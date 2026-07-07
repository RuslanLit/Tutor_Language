import '../curriculum/curriculum_models.dart';

class LessonGoal {
  const LessonGoal({
    required this.id,
    required this.description,
    this.primaryObjectiveId,
  });

  final String id;
  final String description;
  final String? primaryObjectiveId;
}

class LessonConstraints {
  const LessonConstraints({
    this.maxActivityCount,
    this.requiredActivityTypes = const [],
    this.allowedActivityTypes = const [],
  });

  final int? maxActivityCount;
  final List<String> requiredActivityTypes;
  final List<String> allowedActivityTypes;

  bool allowsActivityType(String activityType) {
    return allowedActivityTypes.isEmpty ||
        allowedActivityTypes.contains(activityType);
  }
}

class LessonGenerationInput {
  const LessonGenerationInput({
    required this.lessonDefinition,
    required this.goal,
    required this.constraints,
  });

  final LessonDefinition lessonDefinition;
  final LessonGoal goal;
  final LessonConstraints constraints;
}

class GeneratedLessonSession {
  const GeneratedLessonSession({
    required this.id,
    required this.lessonDefinitionId,
    required this.goal,
    required this.constraints,
    required this.activities,
    required this.generatedExercises,
  });

  final String id;
  final String lessonDefinitionId;
  final LessonGoal goal;
  final LessonConstraints constraints;
  final List<GeneratedLessonActivity> activities;
  final List<GeneratedExercise> generatedExercises;
}

class GeneratedLessonActivity {
  const GeneratedLessonActivity({
    required this.id,
    required this.sectionId,
    required this.lessonActivityId,
    required this.type,
    required this.order,
    required this.references,
  });

  final String id;
  final String sectionId;
  final String lessonActivityId;
  final String type;
  final int order;
  final List<LessonActivityReference> references;
}

class GeneratedExercise {
  const GeneratedExercise({
    required this.id,
    required this.activityId,
    required this.templateReference,
  });

  final String id;
  final String activityId;
  final LessonActivityReference templateReference;
}

class LessonGenerationException implements Exception {
  const LessonGenerationException(this.message);

  final String message;

  @override
  String toString() => 'LessonGenerationException: $message';
}
