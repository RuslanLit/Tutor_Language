import '../../core/content/topic_content.dart';
import '../../core/content/spoken_practice.dart';
import '../lesson_assembly/lesson_content.dart';

enum LessonPlayerStepType {
  vocabulary,
  grammar,
  dialogue,
  reading,
  exercise,
  spokenPractice,
  mixed,
}

class LessonPlayerStep {
  const LessonPlayerStep({
    required this.id,
    required this.sourceActivity,
    required this.content,
    required this.stepType,
    this.reviewStepIds = const [],
    this.isInsertedReview = false,
    this.originatingStepId,
    this.authoredSourceStepId,
  });

  final String id;
  final LessonContentActivity sourceActivity;
  final List<Object> content;
  final LessonPlayerStepType stepType;
  final List<String> reviewStepIds;
  final bool isInsertedReview;
  final String? originatingStepId;
  final String? authoredSourceStepId;

  bool get isCheckable {
    return content.whereType<ExerciseTemplate>().any(_requiresCompletion);
  }

  bool get hasRemediation {
    return content.whereType<ExerciseTemplate>().any(
      (template) => template.authoredMisconceptions.isNotEmpty,
    );
  }

  LessonPlayerStep copyWith({
    String? id,
    List<String>? reviewStepIds,
    bool? isInsertedReview,
    String? originatingStepId,
    String? authoredSourceStepId,
  }) {
    return LessonPlayerStep(
      id: id ?? this.id,
      sourceActivity: sourceActivity,
      content: content,
      stepType: stepType,
      reviewStepIds: reviewStepIds ?? this.reviewStepIds,
      isInsertedReview: isInsertedReview ?? this.isInsertedReview,
      originatingStepId: originatingStepId ?? this.originatingStepId,
      authoredSourceStepId: authoredSourceStepId ?? this.authoredSourceStepId,
    );
  }
}

class LessonPlayerStepBuilder {
  const LessonPlayerStepBuilder();

  List<LessonPlayerStep> buildSteps(LessonContent lessonContent) {
    final steps = <LessonPlayerStep>[];

    for (final activity in lessonContent.activities) {
      final pendingInformationalContent = <Object>[];
      var informationalStepCount = 0;
      var templateIndex = 0;

      void flushInformationalContent() {
        if (pendingInformationalContent.isEmpty) {
          return;
        }

        informationalStepCount += 1;
        steps.add(
          LessonPlayerStep(
            id: _stepId(
              lessonId: lessonContent.lesson.id,
              activityId: activity.activity.id,
              contentId: 'info.$informationalStepCount',
            ),
            sourceActivity: activity,
            content: List.unmodifiable(pendingInformationalContent),
            stepType: _informationalStepType(pendingInformationalContent),
          ),
        );
        pendingInformationalContent.clear();
      }

      for (final content in activity.resolvedContent) {
        if (content is ExerciseTemplate) {
          flushInformationalContent();
          templateIndex += 1;
          steps.add(
            LessonPlayerStep(
              id: _stepId(
                lessonId: lessonContent.lesson.id,
                activityId: activity.activity.id,
                contentId: content.id,
                templateIndex: templateIndex,
              ),
              sourceActivity: activity,
              content: [content],
              stepType: LessonPlayerStepType.exercise,
            ),
          );
        } else {
          pendingInformationalContent.add(content);
        }
      }

      flushInformationalContent();
    }

    final stepIdByTemplateId = {
      for (final step in steps)
        for (final template in step.content.whereType<ExerciseTemplate>())
          template.id: step.id,
    };

    return List.unmodifiable(
      steps.map((step) {
        final reviewStepIds = step.content
            .whereType<ExerciseTemplate>()
            .expand((template) => template.reviewTemplateIds)
            .map((templateId) => stepIdByTemplateId[templateId])
            .whereType<String>()
            .toList(growable: false);

        if (reviewStepIds.isEmpty) {
          return step;
        }

        return step.copyWith(reviewStepIds: List.unmodifiable(reviewStepIds));
      }),
    );
  }

  String _stepId({
    required String lessonId,
    required String activityId,
    required String contentId,
    int? templateIndex,
  }) {
    final suffix = templateIndex == null
        ? contentId
        : '$contentId.$templateIndex';
    return '$lessonId::$activityId::$suffix';
  }

  LessonPlayerStepType _informationalStepType(List<Object> content) {
    final types = content.map(_typeForContent).toSet();
    return types.length == 1 ? types.single : LessonPlayerStepType.mixed;
  }

  LessonPlayerStepType _typeForContent(Object content) {
    return switch (content) {
      VocabularyItem() => LessonPlayerStepType.vocabulary,
      GrammarTopic() => LessonPlayerStepType.grammar,
      Dialogue() => LessonPlayerStepType.dialogue,
      ReadingText() => LessonPlayerStepType.reading,
      SpokenPracticeActivity() => LessonPlayerStepType.spokenPractice,
      _ => LessonPlayerStepType.mixed,
    };
  }
}

bool _requiresCompletion(ExerciseTemplate template) {
  return switch (template.exerciseType) {
    'multiple_choice' => template.correctOptionId != null,
    'fill_gap' || 'text_entry' => template.expectedAnswer != null,
    'matching' => template.expectedAnswer != null,
    'guided_dialogue' =>
      template.guidedDialogue != null &&
          template.guidedDialogue!.turns.any((turn) => turn.learner),
    _ => false,
  };
}
