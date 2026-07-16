import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tutor_language/app/router/app_router.dart';
import 'package:tutor_language/core/content/semantic_pilot_scope.dart';
import 'package:tutor_language/debug/semantic_pilot_qa.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_models.dart';
import 'package:tutor_language/features/course_navigation/course_navigation_service.dart';
import 'package:tutor_language/features/curriculum/curriculum_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('QA launcher is absent without SEMANTIC_QA=true', () {
    expect(semanticPilotQaRuntimeConfig.enabledByDefine, isFalse);
    expect(semanticPilotQaRuntimeConfig.isEnabled, isFalse);
    expect(semanticPilotQaPolicy.isEnabled, isFalse);
  });

  test('QA launcher is absent under release-mode policy', () {
    const config = SemanticPilotQaConfig(
      isDebugMode: false,
      enabledByDefine: true,
    );

    expect(config.isEnabled, isFalse);
    expect(SemanticPilotQaPolicy(config).isEnabled, isFalse);
  });

  test('QA launcher contains only the semantic pilot lesson IDs', () {
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );

    expect(policy.lessonIds, semanticPilotLessonIds);
    expect(policy.lessonIds.toSet(), {
      'es.a0.m06.l016',
      'es.a0.m01.l001',
      'es.a0.m06.l017',
      'es.a0.m02.l004',
      'es.a0.m06.l036',
    });
  });

  test('QA launch disables completion persistence', () {
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );

    final launch = policy.launchForLessonId('es.a0.m06.l036');

    expect(launch, isNotNull);
    expect(launch!.lessonId, 'es.a0.m06.l036');
    expect(launch.persistCompletion, isFalse);
  });

  test('QA launch does not mutate learner progress inputs', () {
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );
    final completedLessonIds = {'es.a0.m06.l016', 'es.a0.m01.l001'};

    policy.launchForLessonId('es.a0.m06.l036');

    expect(completedLessonIds, {'es.a0.m06.l016', 'es.a0.m01.l001'});
  });

  test('unknown lesson ID is rejected', () {
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );

    expect(policy.canLaunchLessonId(''), isFalse);
    expect(policy.launchForLessonId(''), isNull);
  });

  test('non-pilot lesson ID is rejected', () {
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );

    expect(policy.canLaunchLessonId('es.a0.m01.l002'), isFalse);
    expect(policy.launchForLessonId('es.a0.m01.l002'), isNull);
  });

  test('QA route is not a production navigation path', () {
    expect(DebugSemanticPilotRoute.path.startsWith('/debug/'), isTrue);
    expect(DebugSemanticPilotLessonRoute.path.startsWith('/debug/'), isTrue);
    expect(DebugSemanticPilotRoute.name, isNot(CourseRoute.name));
    expect(DebugSemanticPilotLessonRoute.name, isNot(LessonRoute.name));
    expect(DebugSemanticPilotLessonRoute.path, isNot(LessonRoute.path));
  });

  test('course navigation still blocks locked Transport lesson', () async {
    final course = await CurriculumLoader(assetBundle: rootBundle).loadCourse();
    const service = CourseNavigationService();

    final state = service.buildNavigationState(
      course: course,
      completedLessonIds: {
        'es.a0.m06.l016',
        'es.a0.m01.l001',
        'es.a0.m06.l017',
        'es.a0.m01.l002',
        'es.a0.m01.l003',
        'es.a0.m01.l004',
        'es.a0.m01.l005',
        'es.a0.m02.l004',
      },
    );
    final transport = state.units
        .expand((unit) => unit.lessons)
        .singleWhere((lesson) => lesson.lessonId == 'es.a0.m06.l036');

    expect(transport.status, LessonNavigationStatus.locked);
    expect(transport.isTappable, isFalse);
  });

  test('QA bypass does not alter availability model', () async {
    final course = await CurriculumLoader(assetBundle: rootBundle).loadCourse();
    const service = CourseNavigationService();
    const policy = SemanticPilotQaPolicy(
      SemanticPilotQaConfig(isDebugMode: true, enabledByDefine: true),
    );
    final completedLessonIds = {'es.a0.m06.l016', 'es.a0.m01.l001'};
    final before = service.buildNavigationState(
      course: course,
      completedLessonIds: completedLessonIds,
    );

    policy.launchForLessonId('es.a0.m06.l036');

    final after = service.buildNavigationState(
      course: course,
      completedLessonIds: completedLessonIds,
    );
    expect(_statuses(after), _statuses(before));
    expect(after.nextLessonId, before.nextLessonId);
  });
}

List<LessonNavigationStatus> _statuses(CourseNavigationState state) {
  return [
    for (final unit in state.units)
      for (final lesson in unit.lessons) lesson.status,
  ];
}
