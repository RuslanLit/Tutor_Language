// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:tutor_language/core/content/audio_reference_models.dart';

const _defaultManifestPath =
    'assets/languages/spanish/audio/reference_audio.json';
const _defaultVoice = 'es_ES-sharvard-medium';

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

  final manifestPath = options['manifest'] ?? _defaultManifestPath;
  final manifestFile = File(manifestPath);
  if (!manifestFile.existsSync()) {
    stderr.writeln('Manifest not found: ' + manifestPath);
    exitCode = 1;
    return;
  }

  final decoded = jsonDecode(manifestFile.readAsStringSync());
  if (decoded is! Map) {
    stderr.writeln('Manifest must be a JSON object.');
    exitCode = 1;
    return;
  }
  final manifest = AudioReferenceManifest.fromJson(
    Map<String, Object?>.from(decoded),
  );
  final appRoot = Directory.current;
  final available = _audioFiles(appRoot, manifest.audioRoot);
  final validationPaths = options.containsKey('generate')
      ? {...available, for (final asset in manifest.assets) asset.assetPath}
      : available;
  final issues = AudioReferenceValidator(
    expectedAudioRoot: manifest.audioRoot,
    availableAssetPaths: validationPaths,
  ).validate(manifest);
  for (final issue in issues) {
    stderr.writeln(issue.code + ': ' + issue.message);
  }
  stdout.writeln(
    'Audio manifest: ' +
        manifest.assets.length.toString() +
        ' entries, ' +
        issues.length.toString() +
        ' validation issue(s).',
  );
  if (issues.isNotEmpty) {
    exitCode = 1;
    return;
  }

  if (options.containsKey('set-qa-id')) {
    final id = options['set-qa-id']!;
    final state = options['set-qa-state']!;
    final updater = AudioReferenceQaStateUpdater(
      expectedAudioRoot: manifest.audioRoot,
      availableAssetPaths: available,
    );
    updater.update(manifest: manifest, id: id, state: state);

    final rawAssets = decoded['assets'];
    if (rawAssets is! List) {
      throw const FormatException('Audio manifest assets must be a list');
    }
    var updatedRawEntry = false;
    for (final rawAsset in rawAssets) {
      if (rawAsset is Map && rawAsset['id'] == id) {
        rawAsset['qaStatus'] = state;
        updatedRawEntry = true;
        break;
      }
    }
    if (!updatedRawEntry) {
      throw FormatException('Unknown audio ID: ' + id);
    }
    final candidate = AudioReferenceManifest.fromJson(
      Map<String, Object?>.from(decoded),
    );
    final candidateIssues = AudioReferenceValidator(
      expectedAudioRoot: candidate.audioRoot,
      availableAssetPaths: available,
    ).validate(candidate);
    if (candidateIssues.isNotEmpty) {
      throw FormatException(
        'Updated manifest is invalid: ' +
            candidateIssues.map((issue) => issue.code).join(', '),
      );
    }
    manifestFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(decoded) + '\n',
    );
    stdout.writeln('updated ' + id + ' qaStatus=' + state);
    return;
  }

  if (!options.containsKey('generate')) {
    stdout.writeln(
      'Validation succeeded. Use --generate to synthesize staging files.',
    );
    return;
  }

  final piper = options['piper-command'] ?? 'piper';
  final voice = options['voice'] ?? _defaultVoice;
  final voiceDir = options['voice-dir'];
  final model = voiceDir == null ? voice : voiceDir + '/' + voice + '.onnx';
  final outputDir = Directory(
    options['output-dir'] ??
        Directory.systemTemp.createTempSync('tutor-audio-').path,
  )..createSync(recursive: true);

  var failures = 0;
  for (final asset in manifest.assets) {
    if (asset.qaStatus == AudioReferenceQaStatus.approved &&
        File(asset.assetPath).existsSync()) {
      stdout.writeln('skip approved ' + asset.id);
      continue;
    }
    final output = File(outputDir.path + '/' + _basename(asset.assetPath));
    Process process;
    try {
      process = await Process.start(piper, [
        '--model',
        model,
        '--output-file',
        output.path,
      ]);
    } on Object catch (error) {
      failures++;
      stderr.writeln(
        'failed ' + asset.id + ': unable to start Piper: ' + error.toString(),
      );
      continue;
    }
    process.stdin.writeln(asset.transcript);
    await process.stdin.close();
    final stdoutText = await process.stdout.transform(utf8.decoder).join();
    final stderrText = await process.stderr.transform(utf8.decoder).join();
    final processExitCode = await process.exitCode;
    if (processExitCode != 0 ||
        !output.existsSync() ||
        output.lengthSync() == 0) {
      failures++;
      stderr.writeln('failed ' + asset.id + ': ' + stderrText.trim());
      continue;
    }
    if (stdoutText.isNotEmpty) {
      stdout.write(stdoutText);
    }
    stdout.writeln('generated ' + asset.id + ' -> ' + output.path);
  }
  if (failures > 0) {
    exitCode = 1;
  }
}

Map<String, String> _parseOptions(List<String> arguments) {
  final options = <String, String>{};
  for (var index = 0; index < arguments.length; index++) {
    final argument = arguments[index];
    if (argument == '--help' || argument == '-h') {
      options['help'] = '';
    } else if (argument == '--generate') {
      options['generate'] = '';
    } else if (argument == '--set-qa') {
      if (index + 2 >= arguments.length) {
        throw const FormatException(
          '--set-qa requires an audio ID and a QA state',
        );
      }
      options['set-qa-id'] = arguments[++index];
      options['set-qa-state'] = arguments[++index];
    } else if (argument.startsWith('--')) {
      if (index + 1 >= arguments.length) {
        throw FormatException('Missing value for ' + argument);
      }
      options[argument.substring(2)] = arguments[++index];
    } else {
      throw FormatException('Unknown argument: ' + argument);
    }
  }
  return options;
}

Set<String> _audioFiles(Directory appRoot, String audioRoot) {
  final root = Directory(appRoot.path + '/' + audioRoot);
  if (!root.existsSync()) return {};
  return {
    for (final file in root.listSync(recursive: true).whereType<File>())
      if (file.path.endsWith('.wav') || file.path.endsWith('.ogg'))
        if (file.lengthSync() > 0) file.path.substring(appRoot.path.length + 1),
  };
}

String _basename(String path) => path.split('/').last;

void _printHelp() {
  stdout.writeln(
    'Validate or generate Spanish reference audio.\n\n'
    'Usage:\n'
    '  dart run tool/audio_reference.dart [options]\n'
    '  dart run tool/audio_reference.dart --generate [options]\n\n'
    'Options:\n'
    '  --manifest PATH       Canonical manifest\n'
    '  --piper-command PATH  Piper executable\n'
    '  --voice NAME          Voice name\n'
    '  --voice-dir PATH      Directory containing NAME.onnx\n'
    '  --output-dir PATH     Controlled staging directory\n'
    '  --generate            Generate WAV files into staging\n'
    '  --set-qa ID STATE     Set one item QA state after human review\n'
    '                        States: generated, reviewed, approved, rejected\n'
    '  -h, --help            Show this help',
  );
}
