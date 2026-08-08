import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import '../../tool/audio_reference_qa.dart';

void main() {
  test('parses a valid PCM WAV and reports signal metrics', () {
    final file = _writeWav(
      samples: List<double>.generate(
        22050,
        (index) => math.sin(index / 8) * 0.3,
      ),
    );
    addTearDown(() => file.deleteSync());

    final metrics = WavTechnicalScanner().scan(file, 'Hola.');

    expect(metrics.technicalResult, 'ok');
    expect(metrics.sampleRateHz, 22050);
    expect(metrics.channels, 1);
    expect(metrics.bitDepth, 16);
    expect(metrics.durationMs, 1000);
    expect(metrics.peak, greaterThan(0.29));
    expect(metrics.rms, greaterThan(0.1));
  });

  test('detects invalid, missing, and near-silent WAV input', () {
    final invalid = File('${Directory.systemTemp.path}/af4b-invalid.wav')
      ..writeAsBytesSync([1, 2, 3]);
    addTearDown(() => invalid.deleteSync());
    expect(
      WavTechnicalScanner().scan(invalid, 'Hola.').technicalResult,
      'error',
    );
    expect(WavMetrics.missing(0).technicalResult, 'error');

    final silent = _writeWav(samples: List<double>.filled(2205, 0));
    addTearDown(() => silent.deleteSync());
    final metrics = WavTechnicalScanner().scan(silent, 'Hola.');
    expect(metrics.technicalResult, 'error');
    expect(metrics.flags, contains('near-silent signal'));
  });

  test('flags clipping conservatively', () {
    final file = _writeWav(
      samples: [
        ...List<double>.filled(12, 1.0),
        ...List<double>.filled(12, -1.0),
      ],
    );
    addTearDown(() => file.deleteSync());

    final metrics = WavTechnicalScanner().scan(file, 'Ana');

    expect(metrics.technicalResult, 'review');
    expect(metrics.flags, contains('more than 10 samples at/near full scale'));
  });

  test('approval application changes only explicit passes', () {
    final metrics = WavMetrics.missing(1);
    final manifest = <String, Object?>{
      'assets': [
        {'id': 'approved', 'qaStatus': 'approved', 'unrelated': 'keep'},
        {'id': 'pass', 'qaStatus': 'generated', 'unrelated': 'keep'},
        {'id': 'pending', 'qaStatus': 'generated', 'unrelated': 'keep'},
      ],
    };
    final rows = [
      QaRow(
        id: 'pass',
        qaStateBefore: 'generated',
        sourceText: 'Hola.',
        category: 'phrase',
        wavPath: 'pass.wav',
        metrics: metrics,
        humanResult: 'pass',
        humanNotes: 'heard',
      ),
      QaRow(
        id: 'pending',
        qaStateBefore: 'generated',
        sourceText: 'Ana',
        category: 'word',
        wavPath: 'pending.wav',
        metrics: metrics,
        humanResult: 'pending',
        humanNotes: '',
      ),
    ];

    final changed = applyApprovedEntries(manifest, rows);

    expect(changed, ['pass']);
    final assets = manifest['assets']! as List;
    expect((assets[0] as Map)['qaStatus'], 'approved');
    expect((assets[1] as Map)['qaStatus'], 'approved');
    expect((assets[2] as Map)['qaStatus'], 'generated');
    expect((assets[0] as Map)['unrelated'], 'keep');
  });
}

File _writeWav({required List<double> samples}) {
  final file = File(
    '${Directory.systemTemp.path}/af4b-${DateTime.now().microsecondsSinceEpoch}.wav',
  );
  final dataLength = samples.length * 2;
  final bytes = Uint8List(44 + dataLength);
  final view = ByteData.sublistView(bytes);
  void ascii(int offset, String value) {
    for (var index = 0; index < value.length; index++) {
      bytes[offset + index] = value.codeUnitAt(index);
    }
  }

  void u16(int offset, int value) =>
      view.setUint16(offset, value, Endian.little);
  void u32(int offset, int value) =>
      view.setUint32(offset, value, Endian.little);
  ascii(0, 'RIFF');
  u32(4, 36 + dataLength);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  u32(16, 16);
  u16(20, 1);
  u16(22, 1);
  u32(24, 22050);
  u32(28, 44100);
  u16(32, 2);
  u16(34, 16);
  ascii(36, 'data');
  u32(40, dataLength);
  for (var index = 0; index < samples.length; index++) {
    final value = (samples[index].clamp(-1.0, 1.0) * 32767).round();
    view.setInt16(44 + index * 2, value, Endian.little);
  }
  file.writeAsBytesSync(bytes);
  return file;
}
