import 'activity_result.dart';

const _unset = Object();

class ActivityTemplateState {
  const ActivityTemplateState({
    this.selectedOptionId,
    this.submittedAnswer = '',
    this.matchedPairs = const {},
    this.result,
    this.attemptCount = 0,
  });

  final String? selectedOptionId;
  final String submittedAnswer;
  final Map<String, String> matchedPairs;
  final ActivityResult? result;
  final int attemptCount;

  bool get isCompleted => result != null;

  ActivityTemplateState copyWith({
    Object? selectedOptionId = _unset,
    String? submittedAnswer,
    Map<String, String>? matchedPairs,
    Object? result = _unset,
    int? attemptCount,
  }) {
    return ActivityTemplateState(
      selectedOptionId: selectedOptionId == _unset
          ? this.selectedOptionId
          : selectedOptionId as String?,
      submittedAnswer: submittedAnswer ?? this.submittedAnswer,
      matchedPairs: matchedPairs ?? this.matchedPairs,
      result: result == _unset ? this.result : result as ActivityResult?,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }
}
