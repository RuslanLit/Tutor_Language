import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_localization.dart';

void main() {
  group('SemanticLocalizationRepository', () {
    test(
      'loads existing bundles while skipping missing optional assets',
      () async {
        final repository = SemanticLocalizationRepository(
          assetBundle: _MapAssetBundle({
            'assets/languages/spanish/localization/semantic/uk/shared.json': '''
{
  "schemaVersion": 1,
  "targetLanguage": "es",
  "sourceSupportLocale": "uk",
  "supportLocales": ["uk"],
  "units": []
}
''',
          }),
          assetPaths: const [
            'assets/languages/spanish/localization/semantic/uk/shared.json',
            'assets/languages/spanish/localization/semantic/uk/module_01.json',
          ],
        );

        final bundle = await repository.loadBundle();

        expect(bundle.schemaVersion, 1);
        expect(bundle.targetLanguage, 'es');
        expect(bundle.sourceSupportLocale, 'uk');
        expect(bundle.supportLocales, ['uk']);
        expect(bundle.units, isEmpty);
      },
    );

    test('falls back to an empty Ukrainian source bundle', () async {
      final repository = SemanticLocalizationRepository(
        assetBundle: _MapAssetBundle(const {}),
        assetPaths: const [
          'assets/languages/spanish/localization/semantic/uk/module_01.json',
        ],
      );

      final bundle = await repository.loadBundle();

      expect(bundle.schemaVersion, 1);
      expect(bundle.targetLanguage, 'es');
      expect(bundle.sourceSupportLocale, 'uk');
      expect(bundle.supportLocales, ['uk']);
      expect(bundle.units, isEmpty);
    });

    test('still rejects malformed existing bundles', () async {
      final repository = SemanticLocalizationRepository(
        assetBundle: _MapAssetBundle({
          'assets/languages/spanish/localization/semantic/uk/shared.json':
              '{"schemaVersion": 1}',
        }),
        assetPaths: const [
          'assets/languages/spanish/localization/semantic/uk/shared.json',
        ],
      );

      expect(repository.loadBundle(), throwsFormatException);
    });
  });
}

class _MapAssetBundle extends CachingAssetBundle {
  _MapAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) {
      throw FlutterError(
        'Unable to load asset: "$key".\n'
        'The asset does not exist or has empty data.',
      );
    }
    return ByteData.sublistView(Uint8List.fromList(value.codeUnits));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final value = assets[key];
    if (value == null) {
      throw FlutterError(
        'Unable to load asset: "$key".\n'
        'The asset does not exist or has empty data.',
      );
    }
    return value;
  }
}
