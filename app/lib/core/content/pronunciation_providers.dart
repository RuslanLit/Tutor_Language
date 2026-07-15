import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'content_localization_providers.dart';
import 'content_loader.dart';
import 'pronunciation_catalog.dart';
import 'pronunciation_loader.dart';
import 'pronunciation_models.dart';
import 'topic_content.dart';

final pronunciationLoaderProvider = Provider<PronunciationLoader>((ref) {
  return PronunciationLoader();
});

final pronunciationCatalogProvider = FutureProvider<PronunciationCatalog>((
  ref,
) async {
  final contentBundle = await ContentLoader().loadLanguagePackContent();
  final vocabularyContents = contentBundle.byType<VocabularyContent>();

  return ref
      .watch(pronunciationLoaderProvider)
      .loadCatalog(vocabularyContents: vocabularyContents);
});

final resolvedPronunciationProvider =
    FutureProvider.family<ResolvedPronunciationRequest, VocabularyItem>((
      ref,
      item,
    ) async {
      final catalog = await ref.watch(pronunciationCatalogProvider.future);
      final supportLocale = ref.watch(supportLocaleProvider);
      final presentation = catalog.resolveForVocabularyItem(
        item: item,
        supportLocaleCode: supportLocale.code,
      );

      return ResolvedPronunciationRequest(presentation);
    });

class ResolvedPronunciationRequest {
  const ResolvedPronunciationRequest(this.presentation);

  final ResolvedPronunciationPresentation? presentation;
}
