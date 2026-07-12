import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/core/content/content_providers.dart';
import 'package:tutor_language/core/content/content_repository.dart';
import 'package:tutor_language/core/content/topic_content.dart';
import 'package:tutor_language/core/database/app_database.dart';
import 'package:tutor_language/core/database/database_provider.dart';
import 'package:tutor_language/core/learner/learner_progress.dart';
import 'package:tutor_language/core/learner/learner_progress_repository.dart';
import 'package:tutor_language/features/communicative_competency/competency_session_screen.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';

void main() {
  testWidgets('competency session shows recovery and retry flow', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await LearnerProgressRepository(database).recordEvent(
      ProgressEvent.create(
        eventType: ProgressEventType.lessonCompleted,
        topicId: 'es.a0.m03.l001',
        now: DateTime.utc(2026),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) => database),
          contentRepositoryProvider.overrideWith(
            (ref) => _CompetencyContentRepository(),
          ),
        ],
        child: const MaterialApp(
          home: CompetencySessionScreen(
            courseId: 'spanish_a0',
            moduleId: 'es.a0.m03',
            competencyId: 'competency.es.a0.m03.personal_profile',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Personal identity check'), findsOneWidget);
    expect(find.text('Type the Spanish introduction.'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Soy Marta');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(
      find.text("Let's briefly review one part and try again."),
      findsOneWidget,
    );

    await tester.tap(find.text('Start review'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Me llamo Marta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Try the original task again.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Me llamo Marta');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Type the Spanish origin sentence.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Soy de Valencia');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Competency achieved after review'), findsOneWidget);
    expect(
      find.text('You used review and then completed the communicative task.'),
      findsOneWidget,
    );
  });
}

class _CompetencyContentRepository extends ContentRepository {
  @override
  Future<LanguagePackDisplay> loadCurrentLanguage() async {
    return const LanguagePackDisplay(id: 'spanish', name: 'Spanish');
  }

  @override
  Future<Course> loadCourse() async {
    return _course;
  }

  @override
  Future<EducationalContent> loadContent(
    LessonContentReference reference,
  ) async {
    return const ExerciseTemplateContent(
      assetPath: 'assets/languages/spanish/templates/module_2_names.json',
      templates: [
        ExerciseTemplate(
          id: 'template.es.a0.m02.review.type_me_llamo_marta.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Type the Spanish introduction.',
          expectedAnswer: 'Me llamo Marta',
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m02.review.type_soy_de_valencia.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Type the Spanish origin sentence.',
          expectedAnswer: 'Soy de Valencia',
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m02.l004.name_pattern_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the name introduction pattern.',
          correctOptionId: 'me_llamo',
          answerOptions: [
            ExerciseTemplateOption(id: 'me_llamo', label: 'Me llamo Marta'),
            ExerciseTemplateOption(id: 'soy', label: 'Soy Marta'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m02.l009.origin_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the origin pattern.',
          correctOptionId: 'soy_de',
          answerOptions: [
            ExerciseTemplateOption(id: 'soy_de', label: 'Soy de Valencia'),
            ExerciseTemplateOption(id: 'estoy_de', label: 'Estoy de Valencia'),
          ],
        ),
      ],
    );
  }
}

const _course = Course(
  id: 'spanish_a0',
  languageId: 'spanish',
  title: 'Spanish A0',
  level: 'A0',
  version: '1.0.0',
  modules: [
    Module(id: 'es.a0.m03', title: 'Module 3', lessonIds: ['es.a0.m03.l001']),
  ],
  lessons: [
    Lesson(
      id: 'es.a0.m03.l001',
      moduleId: 'es.a0.m03',
      title: 'Profile',
      activities: [],
      prerequisites: [],
      estimatedDurationMinutes: 5,
      completionCriteria: LessonCompletionCriteria(
        minimumCompletedActivities: 1,
      ),
    ),
  ],
);
