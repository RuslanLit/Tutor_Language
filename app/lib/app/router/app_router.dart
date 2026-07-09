import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/lesson_launch/lesson_launch_screen.dart';
import '../../features/lesson_player/lesson_player_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/topic/topic_screen.dart';

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
          return LessonPlayerScreen(
            lessonId: state.pathParameters['lessonId'] ?? '',
          );
        },
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
