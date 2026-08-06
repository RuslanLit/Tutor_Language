import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/learner/learner_progress.dart';
import '../../core/learner/learner_progress_providers.dart';
import '../lesson_launch/lesson_launch_intent.dart';
import '../../l10n/l10n.dart';

const pronunciationPrimerTopicId = 'es.a0.pronunciation_primer';
const pronunciationPrimerAlphabet = <String>[
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'Ñ',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];
const pronunciationPrimerDigraphs = <String>['CH', 'LL'];

enum PronunciationPrimerStatus { notSeen, started, completed, skipped }

class PronunciationPrimerState {
  const PronunciationPrimerState(this.status);

  final PronunciationPrimerStatus status;

  bool get isFinished =>
      status == PronunciationPrimerStatus.completed ||
      status == PronunciationPrimerStatus.skipped;
}

final pronunciationPrimerStateProvider =
    FutureProvider<PronunciationPrimerState>((ref) async {
      final events = await ref.watch(learnerProgressEventsProvider.future);
      return pronunciationPrimerStateFromEvents(events);
    });

PronunciationPrimerState pronunciationPrimerStateFromEvents(
  Iterable<ProgressEvent> events,
) {
  final primerEvents = events
      .where((event) => event.topicId == pronunciationPrimerTopicId)
      .toList();
  if (primerEvents.isEmpty) {
    return const PronunciationPrimerState(PronunciationPrimerStatus.notSeen);
  }
  final latest = primerEvents.last;
  if (latest.eventType == ProgressEventType.topicCompleted) {
    return const PronunciationPrimerState(PronunciationPrimerStatus.completed);
  }
  if (latest.metadataJson != null) {
    final metadata = jsonDecode(latest.metadataJson!);
    if (metadata is Map && metadata['state'] == 'skipped') {
      return const PronunciationPrimerState(PronunciationPrimerStatus.skipped);
    }
  }
  return const PronunciationPrimerState(PronunciationPrimerStatus.started);
}

class PronunciationPrimerScreen extends ConsumerStatefulWidget {
  const PronunciationPrimerScreen({super.key});

  @override
  ConsumerState<PronunciationPrimerScreen> createState() =>
      _PronunciationPrimerScreenState();
}

class _PronunciationPrimerScreenState
    extends ConsumerState<PronunciationPrimerScreen> {
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recordStartIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(pronunciationPrimerStateProvider).asData?.value;
    final alphabetRows = l10n.primerAlphabetRows.split('\n');
    final digraphRows = l10n.primerDigraphRows.split('\n');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.primerTitle),
        actions: [
          TextButton(
            onPressed: _saving ? null : _skip,
            child: Text(l10n.primerSkip),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              children: [
                Text(l10n.primerIntro),
                const SizedBox(height: 16),
                _ReferenceTable(
                  title: l10n.primerAlphabetTitle,
                  rows: alphabetRows,
                ),
                const SizedBox(height: 20),
                _ReferenceTable(
                  title: l10n.primerDigraphTitle,
                  rows: digraphRows,
                ),
                if (state?.isFinished == true) ...[
                  const SizedBox(height: 12),
                  Text(l10n.primerReopenHint),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _continueToLesson,
                child: Text(l10n.primerContinue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _continueToLesson() async {
    await _save(ProgressEventType.topicCompleted, 'completed');
    if (!mounted) return;
    context.goNamed(
      LessonRoute.name,
      pathParameters: {'lessonId': 'es.a0.m01.l001'},
      extra: const LessonLaunchIntent(lessonId: 'es.a0.m01.l001'),
    );
  }

  Future<void> _skip() async {
    await _save(ProgressEventType.topicViewed, 'skipped');
    if (mounted) context.goNamed(CourseRoute.name);
  }

  Future<void> _recordStartIfNeeded() async {
    if (_saving) return;
    final state = await ref.read(pronunciationPrimerStateProvider.future);
    if (!mounted ||
        _saving ||
        state.status != PronunciationPrimerStatus.notSeen) {
      return;
    }
    await _save(ProgressEventType.topicViewed, 'started');
  }

  Future<void> _save(ProgressEventType eventType, String state) async {
    setState(() => _saving = true);
    try {
      await ref
          .read(learnerProgressRepositoryProvider)
          .recordEvent(
            ProgressEvent.create(
              eventType: eventType,
              topicId: pronunciationPrimerTopicId,
              metadataJson: jsonEncode({'state': state}),
            ),
          );
      ref.invalidate(pronunciationPrimerStateProvider);
      ref.invalidate(learnerProgressEventsProvider);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _ReferenceTable extends StatelessWidget {
  const _ReferenceTable({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(row),
            ),
        ],
      ),
    ),
  );
}
