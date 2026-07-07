import '../curriculum/curriculum_models.dart';
import 'lesson_generation_models.dart';

class DeterministicLessonGenerator {
  const DeterministicLessonGenerator();

  GeneratedLessonSession generate(LessonGenerationInput input) {
    final lesson = input.lessonDefinition;
    final constraints = input.constraints;
    final orderedActivities = _orderedActivities(lesson, constraints);

    _validateConstraints(
      lessonDefinition: lesson,
      constraints: constraints,
      activities: orderedActivities,
    );

    return GeneratedLessonSession(
      id: _sessionId(lesson, input.goal),
      lessonDefinitionId: lesson.id,
      goal: input.goal,
      constraints: constraints,
      activities: orderedActivities,
      generatedExercises: _generatedExercises(orderedActivities),
    );
  }

  List<GeneratedLessonActivity> _orderedActivities(
    LessonDefinition lesson,
    LessonConstraints constraints,
  ) {
    final sections = [...lesson.sections]
      ..sort((left, right) => left.order.compareTo(right.order));
    final generated = <GeneratedLessonActivity>[];

    for (final section in sections) {
      final activities = [...section.activities]
        ..sort((left, right) => left.order.compareTo(right.order));

      for (final activity in activities) {
        if (!constraints.allowsActivityType(activity.type)) {
          continue;
        }

        generated.add(
          GeneratedLessonActivity(
            id: '${section.id}.${activity.id}',
            sectionId: section.id,
            lessonActivityId: activity.id,
            type: activity.type,
            order: generated.length + 1,
            references: activity.references,
          ),
        );
      }
    }

    return List.unmodifiable(generated);
  }

  void _validateConstraints({
    required LessonDefinition lessonDefinition,
    required LessonConstraints constraints,
    required List<GeneratedLessonActivity> activities,
  }) {
    final maxActivityCount = constraints.maxActivityCount;
    if (maxActivityCount != null && activities.length > maxActivityCount) {
      throw LessonGenerationException(
        'Lesson definition ${lessonDefinition.id} exceeds max activity count',
      );
    }

    final activityTypes = activities.map((activity) => activity.type).toSet();
    for (final requiredType in constraints.requiredActivityTypes) {
      if (!activityTypes.contains(requiredType)) {
        throw LessonGenerationException(
          'Lesson definition ${lessonDefinition.id} does not contain '
          'required activity type: $requiredType',
        );
      }
    }
  }

  List<GeneratedExercise> _generatedExercises(
    List<GeneratedLessonActivity> activities,
  ) {
    final generatedExercises = <GeneratedExercise>[];

    for (final activity in activities) {
      for (final reference in activity.references) {
        if (reference.type != 'exercise_template') {
          continue;
        }

        generatedExercises.add(
          GeneratedExercise(
            id: '${activity.id}.exercise.${generatedExercises.length + 1}',
            activityId: activity.id,
            templateReference: reference,
          ),
        );
      }
    }

    return List.unmodifiable(generatedExercises);
  }

  String _sessionId(LessonDefinition lesson, LessonGoal goal) {
    return 'generated.${lesson.id}.${goal.id}';
  }
}
