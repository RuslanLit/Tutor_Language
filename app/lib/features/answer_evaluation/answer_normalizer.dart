import 'answer_evaluation_models.dart';

class AnswerNormalizer {
  const AnswerNormalizer();

  NormalizedAnswer normalize(String value) {
    final normalized = value
        .replaceAll('\u00A0', ' ')
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');

    return NormalizedAnswer(raw: value, value: normalized);
  }

  NormalizedAnswer normalizeMeaningSupport(String value) {
    var normalized = normalize(value).value.replaceAll('’', "'");

    for (final entry in _englishContractionExpansions.entries) {
      normalized = normalized.replaceAll(
        RegExp('\\b${RegExp.escape(entry.key)}\\b'),
        entry.value,
      );
    }

    normalized = normalized
        .replaceAll(',', ' ')
        .replaceAll(RegExp(r'\.+$'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return NormalizedAnswer(raw: value, value: normalized);
  }
}

const _englishContractionExpansions = {
  "i'm": 'i am',
  "you're": 'you are',
  "he's": 'he is',
  "she's": 'she is',
  "it's": 'it is',
  "we're": 'we are',
  "they're": 'they are',
  "don't": 'do not',
  "doesn't": 'does not',
  "isn't": 'is not',
  "aren't": 'are not',
  "can't": 'cannot',
  "won't": 'will not',
};
