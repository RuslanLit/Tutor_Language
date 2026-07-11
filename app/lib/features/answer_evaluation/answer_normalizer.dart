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
}
