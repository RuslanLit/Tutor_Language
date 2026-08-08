// ignore_for_file: curly_braces_in_flow_control_structures, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const _defaultManifest = 'assets/languages/spanish/audio/reference_audio.json';
const _defaultReport = '../docs/AF4B_AUDIO_TECHNICAL_QA.tsv';
const _defaultMarkdown = '../docs/AF4B_AUDIO_TECHNICAL_QA.md';

Future<void> main(List<String> arguments) async {
  try {
    await _run(arguments);
  } on FormatException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  }
}

Future<void> _run(List<String> arguments) async {
  final options = _parseOptions(arguments);
  if (options.containsKey('help')) {
    _printHelp();
    return;
  }

  final manifestPath = options['manifest'] ?? _defaultManifest;
  final reportPath = options['report'] ?? _defaultReport;
  final markdownPath = options['markdown'] ?? _defaultMarkdown;
  final manifestFile = File(manifestPath);
  if (!manifestFile.existsSync()) {
    throw FormatException('Manifest not found: $manifestPath');
  }
  final decoded = jsonDecode(manifestFile.readAsStringSync());
  if (decoded is! Map) {
    throw const FormatException('Manifest must be a JSON object.');
  }
  final manifest = Map<String, Object?>.from(decoded);

  if (options.containsKey('interactive')) {
    await _interactive(
      reportPath: reportPath,
      mode: options['mode'] ?? 'pending',
    );
    return;
  }

  if (options.containsKey('apply-approved')) {
    _applyApproved(manifestFile, manifest, reportPath);
    return;
  }

  final rows = _scanManifest(manifest, reportPath);
  _writeReport(File(reportPath), rows);
  _writeMarkdown(File(markdownPath), rows);
  stdout.writeln(
    'Scanned ${rows.length} generated audio entries -> $reportPath',
  );
  final counts = <String, int>{};
  for (final row in rows) {
    counts[row.metrics.technicalResult] =
        (counts[row.metrics.technicalResult] ?? 0) + 1;
  }
  stdout.writeln(
    'technical results: ok=${counts['ok'] ?? 0}, '
    'review=${counts['review'] ?? 0}, error=${counts['error'] ?? 0}',
  );
}

Map<String, String> _parseOptions(List<String> arguments) {
  final options = <String, String>{};
  for (var index = 0; index < arguments.length; index++) {
    final argument = arguments[index];
    if (argument == '--help' || argument == '-h') {
      options['help'] = '';
    } else if (argument == '--interactive') {
      options['interactive'] = '';
    } else if (argument == '--apply-approved') {
      options['apply-approved'] = '';
    } else if (argument == '--scan') {
      options['scan'] = '';
    } else if (argument.startsWith('--')) {
      if (index + 1 >= arguments.length) {
        throw FormatException('Missing value for $argument');
      }
      options[argument.substring(2)] = arguments[++index];
    } else {
      throw FormatException('Unknown argument: $argument');
    }
  }
  return options;
}

List<QaRow> _scanManifest(Map<String, Object?> manifest, String reportPath) {
  final assets = manifest['assets'];
  if (assets is! List) {
    throw const FormatException('Manifest assets must be a list.');
  }
  final previous = File(reportPath).existsSync()
      ? _readReport(File(reportPath))
      : <String, QaRow>{};
  final rows = <QaRow>[];
  for (final rawAsset in assets) {
    if (rawAsset is! Map) continue;
    final asset = Map<String, Object?>.from(rawAsset);
    if (asset['qaStatus'] != 'generated') continue;
    final path = asset['assetPath'] as String? ?? '';
    final file = File(path);
    final transcript = asset['transcript'] as String? ?? '';
    final metrics = file.existsSync() && file.lengthSync() > 0
        ? WavTechnicalScanner().scan(file, transcript)
        : WavMetrics.missing(file.existsSync() ? file.lengthSync() : 0);
    rows.add(
      QaRow(
        id: asset['id'] as String? ?? '',
        qaStateBefore: 'generated',
        sourceText: transcript,
        category: asset['purpose'] as String? ?? '',
        wavPath: path,
        metrics: metrics,
        humanResult: previous[asset['id']]?.humanResult ?? 'pending',
        humanNotes: previous[asset['id']]?.humanNotes ?? '',
      ),
    );
  }
  _applyBatchConsistency(rows);
  return rows;
}

void _applyBatchConsistency(List<QaRow> rows) {
  final signatures = <String, int>{};
  for (final row in rows) {
    final signature = row.metrics.formatSignature;
    if (signature != null)
      signatures[signature] = (signatures[signature] ?? 0) + 1;
  }
  if (signatures.isEmpty) return;
  final common = signatures.entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key;
  for (final row in rows) {
    if (row.metrics.formatSignature != null &&
        row.metrics.formatSignature != common) {
      row.metrics.flags.add('format differs from batch majority (heuristic)');
      row.metrics.technicalResult = _maxResult(
        row.metrics.technicalResult,
        'review',
      );
    }
  }
}

String _maxResult(String left, String right) {
  const rank = {'ok': 0, 'review': 1, 'error': 2};
  return (rank[left] ?? 0) >= (rank[right] ?? 0) ? left : right;
}

class WavMetrics {
  WavMetrics({
    required this.fileSizeBytes,
    required this.durationMs,
    required this.sampleRateHz,
    required this.channels,
    required this.bitDepth,
    required this.audioFormat,
    required this.peak,
    required this.rms,
    required this.leadingSilenceMs,
    required this.trailingSilenceMs,
    required this.maxInternalSilenceMs,
    required this.technicalResult,
    required this.flags,
    required this.characterCount,
    required this.wordCount,
  });

  factory WavMetrics.missing(int size) => WavMetrics(
    fileSizeBytes: size,
    durationMs: null,
    sampleRateHz: null,
    channels: null,
    bitDepth: null,
    audioFormat: null,
    peak: null,
    rms: null,
    leadingSilenceMs: null,
    trailingSilenceMs: null,
    maxInternalSilenceMs: null,
    technicalResult: 'error',
    flags: ['missing or zero-byte file'],
    characterCount: 0,
    wordCount: 0,
  );

  final int fileSizeBytes;
  final int? durationMs;
  final int? sampleRateHz;
  final int? channels;
  final int? bitDepth;
  final int? audioFormat;
  final double? peak;
  final double? rms;
  final int? leadingSilenceMs;
  final int? trailingSilenceMs;
  final int? maxInternalSilenceMs;
  String technicalResult;
  final List<String> flags;
  final int characterCount;
  final int wordCount;

  String? get formatSignature => sampleRateHz == null
      ? null
      : '$sampleRateHz/$channels/$bitDepth/$audioFormat';
}

class WavTechnicalScanner {
  WavMetrics scan(File file, String sourceText) {
    final bytes = file.readAsBytesSync();
    final flags = <String>[];
    final characterCount = sourceText.runes.length;
    final wordCount = sourceText.trim().isEmpty
        ? 0
        : sourceText.trim().split(RegExp(r'\s+')).length;
    if (bytes.length < 44 ||
        _ascii(bytes, 0, 4) != 'RIFF' ||
        _ascii(bytes, 8, 4) != 'WAVE') {
      return WavMetrics(
        fileSizeBytes: bytes.length,
        durationMs: null,
        sampleRateHz: null,
        channels: null,
        bitDepth: null,
        audioFormat: null,
        peak: null,
        rms: null,
        leadingSilenceMs: null,
        trailingSilenceMs: null,
        maxInternalSilenceMs: null,
        technicalResult: 'error',
        flags: ['invalid WAV RIFF/WAVE header'],
        characterCount: characterCount,
        wordCount: wordCount,
      );
    }

    int? format;
    int? channels;
    int? sampleRate;
    int? bits;
    int? blockAlign;
    int dataOffset = -1;
    int dataLength = 0;
    var offset = 12;
    while (offset + 8 <= bytes.length) {
      final id = _ascii(bytes, offset, 4);
      final length = _u32(bytes, offset + 4);
      final body = offset + 8;
      if (body + length > bytes.length) break;
      if (id == 'fmt ' && length >= 16) {
        format = _u16(bytes, body);
        channels = _u16(bytes, body + 2);
        sampleRate = _u32(bytes, body + 4);
        blockAlign = _u16(bytes, body + 12);
        bits = _u16(bytes, body + 14);
      } else if (id == 'data') {
        dataOffset = body;
        dataLength = length;
      }
      offset = body + length + (length.isOdd ? 1 : 0);
    }
    if (format == null ||
        channels == null ||
        sampleRate == null ||
        bits == null ||
        blockAlign == null ||
        dataOffset < 0) {
      return WavMetrics(
        fileSizeBytes: bytes.length,
        durationMs: null,
        sampleRateHz: sampleRate,
        channels: channels,
        bitDepth: bits,
        audioFormat: format,
        peak: null,
        rms: null,
        leadingSilenceMs: null,
        trailingSilenceMs: null,
        maxInternalSilenceMs: null,
        technicalResult: 'error',
        flags: ['missing or incomplete fmt/data chunk'],
        characterCount: characterCount,
        wordCount: wordCount,
      );
    }
    if (format != 1) flags.add('non-PCM format $format');
    if (channels < 1 || sampleRate < 8000 || bits < 8 || bits > 32) {
      flags.add('unusual audio format');
    }
    if (dataOffset + dataLength > bytes.length) {
      flags.add('data chunk exceeds file');
      return WavMetrics(
        fileSizeBytes: bytes.length,
        durationMs: null,
        sampleRateHz: sampleRate,
        channels: channels,
        bitDepth: bits,
        audioFormat: format,
        peak: null,
        rms: null,
        leadingSilenceMs: null,
        trailingSilenceMs: null,
        maxInternalSilenceMs: null,
        technicalResult: 'error',
        flags: flags,
        characterCount: characterCount,
        wordCount: wordCount,
      );
    }

    final bytesPerSample = (bits + 7) ~/ 8;
    final frameBytes = blockAlign;
    final frameCount = dataLength ~/ frameBytes;
    final samples = <double>[];
    var sumSquares = 0.0;
    var peak = 0.0;
    var nearFullScaleSamples = 0;
    for (var frame = 0; frame < frameCount; frame++) {
      var framePeak = 0.0;
      for (var channel = 0; channel < channels; channel++) {
        final position =
            dataOffset + frame * frameBytes + channel * bytesPerSample;
        final value = _sample(bytes, position, bits);
        framePeak = math.max(framePeak, value.abs());
        peak = math.max(peak, value.abs());
        if (value.abs() >= 0.999) nearFullScaleSamples++;
        sumSquares += value * value;
      }
      samples.add(framePeak);
    }
    final rms = samples.isEmpty
        ? 0.0
        : math.sqrt(sumSquares / (samples.length * channels));
    final threshold = 0.01;
    var leading = 0;
    while (leading < samples.length && samples[leading] < threshold) leading++;
    var trailing = 0;
    while (trailing < samples.length - leading &&
        samples[samples.length - 1 - trailing] < threshold)
      trailing++;
    var maxInternal = 0;
    var currentInternal = 0;
    for (var index = leading; index < samples.length - trailing; index++) {
      if (samples[index] < threshold) {
        currentInternal++;
        maxInternal = math.max(maxInternal, currentInternal);
      } else {
        currentInternal = 0;
      }
    }
    final durationMs = sampleRate == 0
        ? null
        : (frameCount * 1000 / sampleRate).round();
    final leadingMs = (leading * 1000 / sampleRate).round();
    final trailingMs = (trailing * 1000 / sampleRate).round();
    final internalMs = (maxInternal * 1000 / sampleRate).round();
    var result = 'ok';
    if (rms < 0.001 || peak < 0.005) {
      flags.add('near-silent signal');
      result = 'error';
    }
    if (nearFullScaleSamples > 10) {
      flags.add('more than 10 samples at/near full scale');
      result = _maxResult(result, 'review');
    }
    if (leadingMs > 1500) {
      flags.add('leading silence >1500ms (heuristic)');
      result = _maxResult(result, 'review');
    }
    if (trailingMs > 1500) {
      flags.add('trailing silence >1500ms (heuristic)');
      result = _maxResult(result, 'review');
    }
    if (internalMs > 1500) {
      flags.add('internal silence >1500ms (heuristic)');
      result = _maxResult(result, 'review');
    }
    final shortest = math.max(200, wordCount * 80);
    final longest = math.max(10000, characterCount * 450);
    if (durationMs != null && durationMs < shortest) {
      flags.add('duration shorter than text heuristic');
      result = _maxResult(result, 'review');
    }
    if (durationMs != null && durationMs > longest) {
      flags.add('duration longer than text heuristic');
      result = _maxResult(result, 'review');
    }
    return WavMetrics(
      fileSizeBytes: bytes.length,
      durationMs: durationMs,
      sampleRateHz: sampleRate,
      channels: channels,
      bitDepth: bits,
      audioFormat: format,
      peak: peak,
      rms: rms,
      leadingSilenceMs: leadingMs,
      trailingSilenceMs: trailingMs,
      maxInternalSilenceMs: internalMs,
      technicalResult: result,
      flags: flags,
      characterCount: characterCount,
      wordCount: wordCount,
    );
  }
}

double _sample(Uint8List bytes, int offset, int bits) {
  if (bits == 8) return (bytes[offset] - 128) / 128.0;
  var value = 0;
  final byteCount = (bits + 7) ~/ 8;
  for (var index = 0; index < byteCount; index++) {
    value |= bytes[offset + index] << (8 * index);
  }
  final signBit = 1 << (bits - 1);
  final fullScale = 1 << bits;
  if (value & signBit != 0) value -= fullScale;
  return value / signBit;
}

int _u16(Uint8List bytes, int offset) =>
    bytes[offset] | (bytes[offset + 1] << 8);
int _u32(Uint8List bytes, int offset) =>
    bytes[offset] |
    (bytes[offset + 1] << 8) |
    (bytes[offset + 2] << 16) |
    (bytes[offset + 3] << 24);
String _ascii(Uint8List bytes, int offset, int length) =>
    String.fromCharCodes(bytes.sublist(offset, offset + length));

class QaRow {
  QaRow({
    required this.id,
    required this.qaStateBefore,
    required this.sourceText,
    required this.category,
    required this.wavPath,
    required this.metrics,
    required this.humanResult,
    required this.humanNotes,
  });
  final String id;
  final String qaStateBefore;
  final String sourceText;
  final String category;
  final String wavPath;
  final WavMetrics metrics;
  String humanResult;
  String humanNotes;
}

Map<String, QaRow> _readReport(File file) {
  final rows = <String, QaRow>{};
  if (!file.existsSync()) return rows;
  final lines = file.readAsLinesSync();
  for (final line in lines.skip(1)) {
    final fields = line.split('\t');
    if (fields.length < 18) continue;
    rows[fields[0]] = QaRow(
      id: fields[0],
      qaStateBefore: fields[1],
      sourceText: fields[2],
      category: fields[3],
      wavPath: fields[4],
      metrics: WavMetrics(
        fileSizeBytes: int.tryParse(fields[5]) ?? 0,
        durationMs: int.tryParse(fields[6]),
        sampleRateHz: int.tryParse(fields[7]),
        channels: int.tryParse(fields[8]),
        bitDepth: int.tryParse(fields[9]),
        audioFormat: null,
        peak: double.tryParse(fields[10]),
        rms: double.tryParse(fields[11]),
        leadingSilenceMs: int.tryParse(fields[12]),
        trailingSilenceMs: int.tryParse(fields[13]),
        maxInternalSilenceMs: int.tryParse(fields[14]),
        technicalResult: fields[15],
        flags: fields[16].isEmpty ? [] : fields[16].split('; '),
        characterCount: 0,
        wordCount: 0,
      ),
      humanResult: fields[17],
      humanNotes: fields.length > 18 ? fields[18] : '',
    );
  }
  return rows;
}

void _writeReport(File file, List<QaRow> rows) {
  file.parent.createSync(recursive: true);
  final output = StringBuffer(
    'id\tqa_state_before\tsource_text\tcategory\twav_path\tfile_size_bytes\t'
    'duration_ms\tsample_rate_hz\tchannels\tbit_depth\tpeak\trms\t'
    'leading_silence_ms\ttrailing_silence_ms\tmax_internal_silence_ms\t'
    'technical_result\ttechnical_flags\thuman_result\thuman_notes\n',
  );
  for (final row in rows) {
    final m = row.metrics;
    output.writeln(
      [
        row.id,
        row.qaStateBefore,
        row.sourceText,
        row.category,
        row.wavPath,
        m.fileSizeBytes,
        m.durationMs ?? '',
        m.sampleRateHz ?? '',
        m.channels ?? '',
        m.bitDepth ?? '',
        m.peak?.toStringAsFixed(6) ?? '',
        m.rms?.toStringAsFixed(6) ?? '',
        m.leadingSilenceMs ?? '',
        m.trailingSilenceMs ?? '',
        m.maxInternalSilenceMs ?? '',
        m.technicalResult,
        m.flags.join('; '),
        row.humanResult,
        row.humanNotes.replaceAll('\t', ' '),
      ].join('\t'),
    );
  }
  file.writeAsStringSync(output.toString());
}

void _writeMarkdown(File file, List<QaRow> rows) {
  file.parent.createSync(recursive: true);
  final counts = <String, int>{};
  for (final row in rows)
    counts[row.metrics.technicalResult] =
        (counts[row.metrics.technicalResult] ?? 0) + 1;
  final formats = <String, int>{};
  final durations =
      rows.map((row) => row.metrics.durationMs).whereType<int>().toList()
        ..sort();
  for (final row in rows) {
    final format = row.metrics.formatSignature ?? 'invalid';
    formats[format] = (formats[format] ?? 0) + 1;
  }
  final suspicious = rows
      .where((row) => row.metrics.technicalResult != 'ok')
      .toList();
  final out = StringBuffer('''# AF4B Production Audio Technical QA

Scope: the 114 current AF4A entries with manifest QA state `generated`.
The 3 original AF1 `approved` entries were not scanned for promotion and were
not modified.

The scanner parses RIFF/WAVE headers and PCM samples directly; it does not use
ASR and cannot judge pronunciation, stress, cadence, naturalness, or
pedagogical suitability. Human listening remains mandatory.

## Summary

- scanned: ${rows.length}
- technical `ok`: ${counts['ok'] ?? 0}
- technical `review`: ${counts['review'] ?? 0}
- technical `error`: ${counts['error'] ?? 0}
- duration min/median/max: ${durations.isEmpty ? 'n/a' : '${durations.first} / ${durations[durations.length ~/ 2]} / ${durations.last} ms'}

## Format distribution

''');
  for (final entry in formats.entries)
    out.writeln('- `${entry.key}`: ${entry.value}');
  out.write('''
## Conservative rules

- `error`: missing/zero-byte file, invalid RIFF/WAVE structure, missing chunks,
  unreadable data, or effectively silent signal (`rms < 0.001` or peak `< 0.005`).
- `review`: more than 10 samples at/near full scale (`abs(sample) >= 0.999`), leading/trailing or
  internal silence over 1500 ms, unusual format, or an extreme duration/text
  mismatch. These are conservative heuristics, not pronunciation judgments.
- silence uses a per-frame peak below `0.01` as the silence heuristic.
- duration heuristic is only a broad outlier check: shorter than
  `max(200 ms, words * 80 ms)` or longer than `max(10000 ms, characters * 450 ms)`.

## Suspicious files

''');
  if (suspicious.isEmpty) {
    out.writeln('None. This does not constitute human approval.');
  } else {
    for (final row in suspicious)
      out.writeln('- `${row.id}` — ${row.metrics.flags.join('; ')}');
  }
  out.write('''
## Human QA

All report rows start with `human_result=pending`. A technical `ok` never
promotes an entry. Human PASS requires understandable intended Spanish,
acceptable stress, no truncation/repetition/extra speech, usable pauses and
question intonation, appropriate A0/A1 speed, reasonable batch volume, and no
severe artifact. FAIL covers defects that could teach incorrect pronunciation
or materially degrade learning. Minor synthetic character alone is not fail.

The interactive reviewer uses the already-installed external `ffplay` command
and saves each result immediately, so quitting resumes from the remaining
pending rows:

```bash
cd ~/Tutor_Language/app
dart run tool/audio_reference_qa.dart --interactive --mode suspicious-first
dart run tool/audio_reference_qa.dart --interactive --mode all
```

After human review only, apply explicit passes with:

```bash
dart run tool/audio_reference_qa.dart --apply-approved
```

This promotion command changes only generated manifest entries whose report
row is `human_result=pass`; it does not alter the three original approved
entries.
''');
  file.writeAsStringSync(out.toString());
}

Future<void> _interactive({
  required String reportPath,
  required String mode,
}) async {
  final reportFile = File(reportPath);
  final rows = _readReport(reportFile).values.toList();
  final selected = rows.where((row) {
    if (mode == 'all') return true;
    if (mode == 'suspicious-first') return row.humanResult == 'pending';
    if (mode == 'failed-only') return row.humanResult == 'fail';
    return row.humanResult == 'pending';
  }).toList();
  if (mode == 'suspicious-first') {
    selected.sort((a, b) {
      final aSuspicious = a.metrics.technicalResult == 'ok' ? 1 : 0;
      final bSuspicious = b.metrics.technicalResult == 'ok' ? 1 : 0;
      return aSuspicious.compareTo(bSuspicious);
    });
  }
  for (var index = 0; index < selected.length; index++) {
    final row = selected[index];
    while (true) {
      stdout.writeln('\n${index + 1}/${selected.length} ${row.id}');
      stdout.writeln('${row.sourceText}');
      stdout.writeln(
        'category=${row.category} technical=${row.metrics.technicalResult} flags=${row.metrics.flags.join('; ')}',
      );
      if (row.humanNotes.isNotEmpty) stdout.writeln('notes=${row.humanNotes}');
      await Process.run('ffplay', [
        '-nodisp',
        '-autoexit',
        '-loglevel',
        'error',
        row.wavPath,
      ]);
      stdout.write('[p]ass [r]eplay [f]ail [s]kip [n]ote [q]uit: ');
      final command = stdin.readLineSync()?.trim().toLowerCase() ?? 'q';
      if (command == 'r') continue;
      if (command == 'q') {
        _writeReport(reportFile, rows);
        stdout.writeln('saved progress to $reportPath');
        return;
      }
      if (command == 'n') {
        stdout.write('note: ');
        row.humanNotes = stdin.readLineSync()?.trim() ?? '';
        _writeReport(reportFile, rows);
        continue;
      }
      if (command == 'p') row.humanResult = 'pass';
      if (command == 'f') row.humanResult = 'fail';
      if (command == 's') row.humanResult = 'pending';
      if (command == 'p' || command == 'f' || command == 's') {
        _writeReport(reportFile, rows);
        break;
      }
    }
  }
  _writeReport(reportFile, rows);
  stdout.writeln('review complete; approvals are not applied automatically');
}

void _applyApproved(
  File manifestFile,
  Map<String, Object?> manifest,
  String reportPath,
) {
  final report = _readReport(File(reportPath));
  final assets = manifest['assets'];
  if (assets is! List)
    throw const FormatException('Manifest assets must be a list.');
  final changed = applyApprovedEntries(manifest, report.values);
  if (changed.isNotEmpty) {
    manifestFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(manifest) + '\n',
    );
  }
  stdout.writeln('approved ${changed.length} entries');
  for (final id in changed) stdout.writeln(id);
}

List<String> applyApprovedEntries(
  Map<String, Object?> manifest,
  Iterable<QaRow> reportRows,
) {
  final report = {for (final row in reportRows) row.id: row};
  final assets = manifest['assets'];
  if (assets is! List)
    throw const FormatException('Manifest assets must be a list.');
  final changed = <String>[];
  for (final rawAsset in assets) {
    if (rawAsset is! Map) continue;
    final asset = Map<String, Object?>.from(rawAsset);
    final id = asset['id'];
    final row = id is String ? report[id] : null;
    if (asset['qaStatus'] == 'generated' && row?.humanResult == 'pass') {
      asset['qaStatus'] = 'approved';
      rawAsset['qaStatus'] = 'approved';
      changed.add(id as String);
    }
  }
  return changed;
}

void _printHelp() {
  stdout.writeln('''Inspect generated reference WAVs and manage human QA.

Usage:
  dart run tool/audio_reference_qa.dart [--scan] [options]
  dart run tool/audio_reference_qa.dart --interactive --mode pending [options]
  dart run tool/audio_reference_qa.dart --apply-approved [options]

Options:
  --manifest PATH       Manifest (default: $_defaultManifest)
  --report PATH         QA TSV report (default: $_defaultReport)
  --markdown PATH       QA Markdown report (default: $_defaultMarkdown)
  --interactive         Resume-friendly human listening workflow
  --mode MODE           pending, all, suspicious-first, or failed-only
  --apply-approved      Promote only report rows with human_result=pass
  --scan                Scan generated entries (default operation)
  -h, --help            Show help
''');
}
