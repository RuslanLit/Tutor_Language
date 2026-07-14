import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/app/app_release_info.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About and Settings'),
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(HomeRoute.name),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _SettingsSection(
              title: AppReleaseInfo.name,
              children: [
                Text(AppReleaseInfo.scope),
                SizedBox(height: 4),
                Text(AppReleaseInfo.status),
                SizedBox(height: 4),
                Text('Version ${AppReleaseInfo.version}'),
              ],
            ),
            _SettingsSection(
              title: 'Privacy',
              children: [
                Text('Works offline.'),
                Text('No account is required.'),
                Text('No ads, tracking, or analytics are used.'),
                Text('No AI service is contacted during lessons.'),
                Text('Learner progress stays on this device.'),
              ],
            ),
            _SettingsSection(
              title: 'Feedback',
              children: [
                Text(
                  'For this early release, report issues through the project '
                  'repository or directly to the project maintainer.',
                ),
              ],
            ),
            _SettingsSection(
              title: 'Licenses and Credits',
              children: [
                Text(
                  'Tutor Language is built with Flutter and includes authored '
                  'Spanish A0 learning content bundled with the app.',
                ),
                SizedBox(height: 4),
                Text(
                  'Full license and third-party credit information will be '
                  'included with the public release package.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}
