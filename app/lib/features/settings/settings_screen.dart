import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/app/app_release_info.dart';
import '../../debug/semantic_pilot_qa.dart';
import '../../l10n/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(l10n.settingsTitle),
        ),
        leading: IconButton(
          tooltip: l10n.backTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(HomeRoute.name),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SettingsSection(
              title: l10n.appTitle,
              children: [
                Text(l10n.releaseScopeLabel),
                const SizedBox(height: 4),
                Text(l10n.releaseStatusLabel),
                const SizedBox(height: 4),
                Text(l10n.versionLabel(AppReleaseInfo.version)),
              ],
            ),
            _SettingsSection(
              title: l10n.privacyTitle,
              children: [
                Text(l10n.privacyOffline),
                Text(l10n.privacyNoAccount),
                Text(l10n.privacyNoTracking),
                Text(l10n.privacyNoAi),
                Text(l10n.privacyLocalProgress),
              ],
            ),
            _SettingsSection(
              title: l10n.feedbackTitle,
              children: [Text(l10n.feedbackBody)],
            ),
            _SettingsSection(
              title: l10n.licensesTitle,
              children: [Text(l10n.licensesBody)],
            ),
            if (semanticPilotQaPolicy.isEnabled)
              _SettingsSection(
                title: 'QA ONLY',
                children: [
                  const Text(
                    'Semantic pilot launcher. Debug build with '
                    'SEMANTIC_QA=true only.',
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () =>
                        context.goNamed(DebugSemanticPilotRoute.name),
                    child: const Text('Open semantic pilot QA'),
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
