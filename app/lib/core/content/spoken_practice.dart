import '../../features/curriculum/curriculum_models.dart';
import 'audio_reference_models.dart';

/// A bounded, non-evaluated oral practice activity for the Lesson Player.
class SpokenPracticeActivity {
  const SpokenPracticeActivity({required this.id, required this.definition});

  final String id;
  final SpokenPracticeDefinition definition;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SpokenPracticeActivity &&
            other.id == id &&
            other.definition == definition;
  }

  @override
  int get hashCode => Object.hash(id, definition);
}

class SpokenPracticeValidationIssue {
  const SpokenPracticeValidationIssue(this.message);

  final String message;
}

class SpokenPracticeValidator {
  const SpokenPracticeValidator();

  List<SpokenPracticeValidationIssue> validateActivities(
    Iterable<LessonActivity> activities,
  ) {
    final issues = <SpokenPracticeValidationIssue>[];
    for (final activity in activities) {
      if (activity.type != 'spoken_practice') continue;
      final definition = activity.spokenPractice;
      if (definition == null) {
        issues.add(
          SpokenPracticeValidationIssue(
            'spoken_practice activity is missing its definition: ${activity.id}',
          ),
        );
        continue;
      }
      if (activity.references.isNotEmpty ||
          activity.contentReferences.isNotEmpty) {
        issues.add(
          SpokenPracticeValidationIssue(
            'spoken_practice must not use content or asset path references: '
            '${activity.id}',
          ),
        );
      }
      if (definition.audioReferenceId.trim().isEmpty ||
          definition.prompt.trim().isEmpty ||
          definition.targetText.trim().isEmpty) {
        issues.add(
          SpokenPracticeValidationIssue(
            'spoken_practice has an empty required field: ${activity.id}',
          ),
        );
      }
    }
    return List.unmodifiable(issues);
  }

  List<SpokenPracticeValidationIssue> validateApprovedAudio(
    Iterable<LessonActivity> activities,
    AudioReferenceManifest manifest,
  ) {
    final byId = {for (final asset in manifest.assets) asset.id: asset};
    final issues = <SpokenPracticeValidationIssue>[];
    for (final activity in activities) {
      final definition = activity.spokenPractice;
      if (activity.type != 'spoken_practice' || definition == null) continue;
      final asset = byId[definition.audioReferenceId];
      if (asset == null) {
        issues.add(
          SpokenPracticeValidationIssue(
            'spoken_practice audio reference is unknown: '
            '${definition.audioReferenceId}',
          ),
        );
      } else if (asset.qaStatus != AudioReferenceQaStatus.approved) {
        issues.add(
          SpokenPracticeValidationIssue(
            'spoken_practice audio reference is not approved: '
            '${definition.audioReferenceId}',
          ),
        );
      }
    }
    return List.unmodifiable(issues);
  }
}
