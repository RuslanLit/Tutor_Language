import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../debug/semantic_pilot_qa.dart';
import '../../debug/semantic_pilot_qa_screen.dart';
import '../../debug/recording_qa.dart';
import '../../debug/recording_qa_screen.dart';
import '../../debug/qa_navigator.dart';
import '../../debug/qa_navigator_screen.dart';
import '../../core/learner/lesson_attempt.dart';
import '../../features/communicative_competency/competency_session_screen.dart';
import '../../features/course_navigation/course_navigation_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/lesson_launch/lesson_launch_screen.dart';
import '../../features/lesson_launch/lesson_launch_intent.dart';
import '../../features/lesson_player/lesson_player_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/topic/topic_screen.dart';
import '../../features/pronunciation_primer/pronunciation_primer.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: HomeRoute.path,
    routes: [
      GoRoute(
        path: HomeRoute.path,
        name: HomeRoute.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: SettingsRoute.path,
        name: SettingsRoute.name,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: CourseRoute.path,
        name: CourseRoute.name,
        builder: (context, state) => const CourseNavigationScreen(),
      ),
      GoRoute(
        path: PronunciationPrimerRoute.path,
        name: PronunciationPrimerRoute.name,
        builder: (context, state) => const PronunciationPrimerScreen(),
      ),
      GoRoute(
        path: TopicRoute.path,
        name: TopicRoute.name,
        builder: (context, state) {
          return TopicScreen(topicId: state.pathParameters['topicId'] ?? '');
        },
      ),
      GoRoute(
        path: LessonLaunchRoute.path,
        name: LessonLaunchRoute.name,
        builder: (context, state) => const LessonLaunchScreen(),
      ),
      GoRoute(
        path: LessonRoute.path,
        name: LessonRoute.name,
        builder: (context, state) {
          final extra = state.extra;
          final intent = extra is LessonLaunchIntent ? extra : null;
          return LessonPlayerScreen(
            lessonId:
                intent?.lessonId ?? state.pathParameters['lessonId'] ?? '',
            attemptPurpose:
                intent?.attemptPurpose ?? LessonAttemptPurpose.normal,
            reviewMode: intent?.mode == LessonLaunchMode.review,
            qaMode: intent?.mode == LessonLaunchMode.qa,
            initialStepId: intent?.initialStepId,
            persistCompletion: intent?.mode != LessonLaunchMode.qa,
          );
        },
      ),
      GoRoute(
        path: CompetencyRoute.path,
        name: CompetencyRoute.name,
        builder: (context, state) {
          return CompetencySessionScreen(
            courseId: state.pathParameters['courseId'] ?? '',
            moduleId: state.pathParameters['moduleId'] ?? '',
            competencyId: state.pathParameters['competencyId'] ?? '',
            forceNewAttempt: state.uri.queryParameters['retry'] == 'true',
          );
        },
      ),
      if (semanticPilotQaPolicy.isEnabled) ...[
        GoRoute(
          path: DebugSemanticPilotRoute.path,
          name: DebugSemanticPilotRoute.name,
          builder: (context, state) => const SemanticPilotQaScreen(),
        ),
        GoRoute(
          path: DebugSemanticPilotLessonRoute.path,
          name: DebugSemanticPilotLessonRoute.name,
          builder: (context, state) {
            return SemanticPilotQaLessonScreen(
              lessonId: state.pathParameters['lessonId'] ?? '',
            );
          },
        ),
      ],
      if (recordingQaEnabled)
        GoRoute(
          path: RecordingQaRoute.path,
          name: RecordingQaRoute.name,
          builder: (context, state) => const RecordingQaScreen(),
        ),
      if (qaNavigatorEnabled)
        GoRoute(
          path: QaNavigatorRoute.path,
          name: QaNavigatorRoute.name,
          builder: (context, state) => const QaNavigatorScreen(),
        ),
    ],
  );
});

abstract final class HomeRoute {
  static const name = 'home';
  static const path = '/';
}

abstract final class SettingsRoute {
  static const name = 'settings';
  static const path = '/settings';
}

abstract final class CourseRoute {
  static const name = 'course';
  static const path = '/course';
}

abstract final class PronunciationPrimerRoute {
  static const name = 'pronunciationPrimer';
  static const path = '/course/pronunciation-primer';
}

abstract final class TopicRoute {
  static const name = 'topic';
  static const path = '/topic/:topicId';
}

abstract final class LessonLaunchRoute {
  static const name = 'lessonLaunch';
  static const path = '/lesson/launch';
}

abstract final class LessonRoute {
  static const name = 'lesson';
  static const path = '/lesson/:lessonId';
}

abstract final class CompetencyRoute {
  static const name = 'competency';
  static const path =
      '/course/:courseId/module/:moduleId/competency/:competencyId';
}

abstract final class DebugSemanticPilotRoute {
  static const name = 'debugSemanticPilot';
  static const path = '/debug/semantic-pilot';
}

abstract final class DebugSemanticPilotLessonRoute {
  static const name = 'debugSemanticPilotLesson';
  static const path = '/debug/semantic-pilot/lesson/:lessonId';
}

abstract final class RecordingQaRoute {
  static const name = 'recordingQa';
  static const path = '/debug/recording';
}

abstract final class QaNavigatorRoute {
  static const name = 'debugQaNavigator';
  static const path = '/debug/qa-navigator';
}
