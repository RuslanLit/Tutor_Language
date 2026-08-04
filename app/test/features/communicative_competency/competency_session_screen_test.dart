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
import 'package:tutor_language/features/communicative_competency/communicative_competency_models.dart';
import 'package:tutor_language/features/communicative_competency/competency_definition_registry.dart';
import 'package:tutor_language/features/communicative_competency/competency_providers.dart';
import 'package:tutor_language/features/communicative_competency/competency_session_screen.dart';
import 'package:tutor_language/features/curriculum/curriculum_models.dart';
import 'package:tutor_language/l10n/generated/app_localizations.dart';

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
          competencyDefinitionRegistryProvider.overrideWith(
            (ref) => _fixtureRegistry,
          ),
          contentRepositoryProvider.overrideWith(
            (ref) => _CompetencyContentRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(useMaterial3: false),
          home: CompetencySessionScreen(
            courseId: 'spanish_a0',
            moduleId: 'es.a0.m03',
            competencyId:
                'competency.es.a0.m03.describe_basic_personal_identity',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Basic personal identity check'), findsOneWidget);
    expect(
      find.text(
        'Competency check: Greet the person and introduce yourself as Marta.',
      ),
      findsOneWidget,
    );

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
    await tester.enterText(find.byType(TextField), 'Hola. Me llamo Marta');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Competency check: Type the Spanish sentence saying that you are from Ukraine.',
      ),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'Soy de Ucrania');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Vivo en Kyiv');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'Hablo ucraniano y un poco de español',
    );
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      '¿De dónde eres? ¿Qué idiomas hablas?',
    );
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      'Me llamo Marta. Soy de Ucrania. Vivo en Kyiv. Hablo ucraniano y un poco de español',
    );
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Competency achieved after review'), findsOneWidget);
    expect(
      find.text('You used review and then completed the communicative task.'),
      findsOneWidget,
    );
  });

  testWidgets('competency session accepts preferred-order correction', (
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
          competencyDefinitionRegistryProvider.overrideWith(
            (ref) => _fixtureRegistry,
          ),
          contentRepositoryProvider.overrideWith(
            (ref) => _CompetencyContentRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(useMaterial3: false),
          home: CompetencySessionScreen(
            courseId: 'spanish_a0',
            moduleId: 'es.a0.m03',
            competencyId:
                'competency.es.a0.m03.describe_basic_personal_identity',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Me llamo Marta. Hola');
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(
      find.text("Let's briefly review one part and try again."),
      findsNothing,
    );
    expect(
      find.text(
        'Competency check: Type the Spanish sentence saying that you are from Ukraine.',
      ),
      findsOneWidget,
    );
  });
}

const _fixtureRegistry = _FixtureCompetencyDefinitionRegistry();

class _FixtureCompetencyDefinitionRegistry
    extends CompetencyDefinitionRegistry {
  const _FixtureCompetencyDefinitionRegistry()
    : super(definitions: const [_fixtureDefinition]);

  @override
  CommunicativeCompetencyCatalog catalogFor(
    RuntimeCompetencyDefinition definition,
  ) {
    return const CommunicativeCompetencyCatalog(
      moduleSequence: ['es.a0.m01', 'es.a0.m02', 'es.a0.m03'],
      competencies: [_fixtureCompetency],
      microCompetencies: _fixtureMicroCompetencies,
      assessmentTasks: _fixtureAssessmentTasks,
      availableRecoveryStepIds: {
        'template.es.a0.m02.l004.name_pattern_choice.v1',
      },
    );
  }
}

const _fixtureCompetency = CommunicativeCompetencyDefinition(
  competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
  moduleId: 'es.a0.m03',
  title: 'Basic personal identity check',
  communicativeGoal:
      'Exchange basic personal identity information using known patterns.',
  requiredMicroCompetencyIds: [
    'micro.es.a0.introduce_self',
    'micro.es.a0.state_origin',
    'micro.es.a0.state_residence',
    'micro.es.a0.state_languages',
    'micro.es.a0.ask_origin',
    'micro.es.a0.ask_languages',
    'micro.es.a0.build_personal_identity_profile',
  ],
  assessmentTaskIds: [
    'task.es.a0.introduce_self',
    'task.es.a0.state_origin',
    'task.es.a0.state_residence',
    'task.es.a0.state_languages',
    'task.es.a0.ask_origin_and_languages',
    'task.es.a0.build_personal_identity_profile',
  ],
);

const _fixtureDefinition = RuntimeCompetencyDefinition(
  competency: _fixtureCompetency,
  diagnosticTaskTemplateIds: {
    'task.es.a0.introduce_self':
        'template.es.a0.m03.competency.type_intro_marta.v1',
    'task.es.a0.state_origin':
        'template.es.a0.m03.competency.type_origin_ucrania.v1',
    'task.es.a0.state_residence':
        'template.es.a0.m03.competency.type_residence_kyiv.v1',
    'task.es.a0.state_languages':
        'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
    'task.es.a0.ask_origin_and_languages':
        'template.es.a0.m03.competency.type_ask_origin_languages.v1',
    'task.es.a0.build_personal_identity_profile':
        'template.es.a0.m03.competency.type_identity_profile.v1',
  },
  recoveryTemplateIds: {
    'micro.es.a0.introduce_self':
        'template.es.a0.m02.l004.name_pattern_choice.v1',
  },
);

const _fixtureMicroCompetencies = [
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.introduce_self',
    description: 'Introduce self.',
    introducedInModuleId: 'es.a0.m02',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_origin',
    description: 'State origin.',
    introducedInModuleId: 'es.a0.m03',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_residence',
    description: 'State residence.',
    introducedInModuleId: 'es.a0.m03',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.state_languages',
    description: 'State languages.',
    introducedInModuleId: 'es.a0.m03',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_origin',
    description: 'Ask origin.',
    introducedInModuleId: 'es.a0.m03',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.ask_languages',
    description: 'Ask languages.',
    introducedInModuleId: 'es.a0.m03',
  ),
  MicroCompetencyDefinition(
    microCompetencyId: 'micro.es.a0.build_personal_identity_profile',
    description: 'Build a profile.',
    introducedInModuleId: 'es.a0.m03',
  ),
];

const _fixtureAssessmentTasks = [
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.introduce_self',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.introduce_self'],
    lessonStepReference: 'template.es.a0.m03.competency.type_intro_marta.v1',
    recoveryMappings: [
      CompetencyRecoveryMapping(
        microCompetencyId: 'micro.es.a0.introduce_self',
        reasonCode: CompetencyGapReasonCode.prerequisiteNotRetained,
        recoveryStepReferences: [
          CompetencyRecoveryStepReference(
            stepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
            sourceModuleId: 'es.a0.m02',
            sourceLessonId: 'es.a0.m02.l004',
            sourceStepId: 'template.es.a0.m02.l004.name_pattern_choice.v1',
          ),
        ],
        retryTaskId: 'task.es.a0.introduce_self',
      ),
    ],
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_origin',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_origin'],
    lessonStepReference: 'template.es.a0.m03.competency.type_origin_ucrania.v1',
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_residence',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_residence'],
    lessonStepReference: 'template.es.a0.m03.competency.type_residence_kyiv.v1',
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.state_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.state_languages'],
    lessonStepReference:
        'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.ask_origin_and_languages',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: [
      'micro.es.a0.ask_origin',
      'micro.es.a0.ask_languages',
    ],
    lessonStepReference:
        'template.es.a0.m03.competency.type_ask_origin_languages.v1',
  ),
  CompetencyAssessmentTask(
    taskId: 'task.es.a0.build_personal_identity_profile',
    competencyId: 'competency.es.a0.m03.describe_basic_personal_identity',
    assessedMicroCompetencyIds: ['micro.es.a0.build_personal_identity_profile'],
    lessonStepReference:
        'template.es.a0.m03.competency.type_identity_profile.v1',
    isCentralTask: true,
  ),
];

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
          id: 'template.es.a0.m03.competency.type_intro_marta.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Greet the person and introduce yourself as Marta.',
          expectedAnswer: 'Hola. Me llamo Marta',
          acceptedAnswers: ['Hola\nMe llamo Marta'],
          acceptedWithFeedbackAnswers: [
            AcceptedWithFeedbackAnswer(
              answer: 'Me llamo Marta. Hola',
              feedbackKey: 'answer.preferred_order',
              canonicalAnswer: 'Hola. Me llamo Marta',
            ),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.competency.type_origin_ucrania.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Type the Spanish sentence saying that you are from Ukraine.',
          expectedAnswer: 'Soy de Ucrania',
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.competency.type_residence_kyiv.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Type the Spanish sentence saying that you live in Kyiv.',
          expectedAnswer: 'Vivo en Kyiv',
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.competency.type_languages_ucranian_spanish.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Type the Spanish sentence saying that you speak Ukrainian and a little Spanish.',
          expectedAnswer: 'Hablo ucraniano y un poco de español',
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.competency.type_ask_origin_languages.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Ask where the other person is from and which languages they speak.',
          expectedAnswer: '¿De dónde eres? ¿Qué idiomas hablas?',
          acceptedWithFeedbackAnswers: [
            AcceptedWithFeedbackAnswer(
              answer: '¿Qué idiomas hablas? ¿De dónde eres?',
              feedbackKey: 'answer.preferred_order',
              canonicalAnswer: '¿De dónde eres? ¿Qué idiomas hablas?',
            ),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.competency.type_identity_profile.v1',
          exerciseType: 'text_entry',
          supportedGoalTypes: ['recall'],
          requiredObjectTypes: ['phrase'],
          promptTemplate:
              'Competency check: Type the Spanish sentence sequence in this order for this profile: "My name is Marta. I am from Ukraine. I live in Kyiv. I speak Ukrainian and a little Spanish."',
          expectedAnswer:
              'Me llamo Marta. Soy de Ucrania. Vivo en Kyiv. Hablo ucraniano y un poco de español',
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
        ExerciseTemplate(
          id: 'template.es.a0.m03.l013.origin_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the origin pattern.',
          correctOptionId: 'soy_de',
          answerOptions: [
            ExerciseTemplateOption(id: 'soy_de', label: 'Soy de Ucrania'),
            ExerciseTemplateOption(id: 'vivo_en', label: 'Vivo en Ucrania'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.l015.residence_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the residence pattern.',
          correctOptionId: 'vivo_en',
          answerOptions: [
            ExerciseTemplateOption(id: 'vivo_en', label: 'Vivo en Kyiv'),
            ExerciseTemplateOption(id: 'soy_de', label: 'Soy de Kyiv'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.l016.language_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the language pattern.',
          correctOptionId: 'hablo',
          answerOptions: [
            ExerciseTemplateOption(id: 'hablo', label: 'Hablo español'),
            ExerciseTemplateOption(id: 'vivo', label: 'Vivo español'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.l014.origin_question_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the origin question.',
          correctOptionId: 'de_donde',
          answerOptions: [
            ExerciseTemplateOption(id: 'de_donde', label: '¿De dónde eres?'),
            ExerciseTemplateOption(id: 'donde', label: '¿Dónde vives?'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.l017.exchange_question_choice.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the language question.',
          correctOptionId: 'idiomas',
          answerOptions: [
            ExerciseTemplateOption(
              id: 'idiomas',
              label: '¿Qué idiomas hablas?',
            ),
            ExerciseTemplateOption(id: 'origin', label: '¿De dónde eres?'),
          ],
        ),
        ExerciseTemplate(
          id: 'template.es.a0.m03.l015.origin_residence_contrast.v1',
          exerciseType: 'multiple_choice',
          supportedGoalTypes: ['recognition'],
          requiredObjectTypes: ['phrase'],
          promptTemplate: 'Choose the residence answer.',
          correctOptionId: 'residence',
          answerOptions: [
            ExerciseTemplateOption(id: 'residence', label: 'Vivo en Kyiv.'),
            ExerciseTemplateOption(id: 'origin', label: 'Soy de Kyiv.'),
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
