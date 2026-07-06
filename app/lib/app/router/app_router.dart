import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';

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
