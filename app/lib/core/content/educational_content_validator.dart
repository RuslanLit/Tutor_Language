import 'content_document.dart';
import 'educational_content_catalog.dart';
import 'topic_content.dart';
import '../../features/curriculum/curriculum_models.dart';

class EducationalContentValidationIssue {
  const EducationalContentValidationIssue(this.message);

  final String message;

  @override
  String toString() => message;
}

class EducationalContentValidator {
  const EducationalContentValidator();

  static const supportedContentTypes = {
    'vocabulary',
    'grammar',
    'dialogue',
    'reading',
    'exercise_template',
  };

  static const supportedExerciseTypes = {
    'multiple_choice',
    'fill_gap',
    'matching',
  };

  List<EducationalContentValidationIssue> validate(
    EducationalContentBundle bundle,
  ) {
    final issues = <EducationalContentValidationIssue>[];
    final idsByType = <String, Set<String>>{
      'vocabulary': {},
      'grammar': {},
      'dialogue': {},
      'reading': {},
      'exercise_template': {},
    };

    for (final content in bundle.contents) {
      if (!supportedContentTypes.contains(content.type)) {
        issues.add(
          EducationalContentValidationIssue(
            'Unsupported content type: ${content.type}',
          ),
        );
        continue;
      }

      switch (content) {
        case VocabularyContent():
          _validateVocabulary(content, idsByType, issues);
        case GrammarContent():
          _validateGrammar(content, idsByType, issues);
        case DialogueContent():
          _validateDialogues(content, idsByType, issues);
        case ReadingContent():
          _validateReadings(content, idsByType, issues);
        case ExerciseTemplateContent():
          _validateExerciseTemplates(content, idsByType, issues);
        default:
          issues.add(
            EducationalContentValidationIssue(
              'Unsupported content type: ${content.type}',
            ),
          );
      }
    }

    _validateGlobalDuplicateIds(idsByType, issues);
    _validateReferences(idsByType, bundle.contents, issues);

    return List.unmodifiable(issues);
  }

  List<EducationalContentValidationIssue> validateLessonReferences({
    required LessonDefinition lesson,
    required EducationalContentCatalog catalog,
  }) {
    final issues = <EducationalContentValidationIssue>[];

    for (final activity in lesson.activities) {
      final seenReferences = <String>{};

      for (final reference in activity.contentReferences) {
        if (reference.type.trim().isEmpty ||
            reference.assetPath.trim().isEmpty) {
          issues.add(
            EducationalContentValidationIssue(
              'Invalid content reference in lesson ${lesson.id}: '
              '${activity.id}',
            ),
          );
          continue;
        }

        final referenceKey =
            '${reference.type}|${reference.assetPath}|${reference.referenceId ?? ''}';
        if (!seenReferences.add(referenceKey)) {
          issues.add(
            EducationalContentValidationIssue(
              'Duplicate content reference in lesson ${lesson.id}: '
              '${activity.id}',
            ),
          );
        }

        if (!catalog.canResolve(reference)) {
          issues.add(
            EducationalContentValidationIssue(
              'Unresolved content reference in lesson ${lesson.id}: '
              '${activity.id}',
            ),
          );
        }
      }
    }

    return List.unmodifiable(issues);
  }

  void _validateVocabulary(
    VocabularyContent content,
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final item in content.entries) {
      _addIdentifierIssues(
        idsByType['vocabulary']!,
        'vocabulary',
        item.id,
        issues,
      );
      _addEmptyIssues('vocabulary ${item.id}', {
        'spanish': item.spanish,
        'native_translation': item.nativeTranslation,
        'cefr': item.cefr,
        'example': item.example,
      }, issues);
    }
  }

  void _validateGrammar(
    GrammarContent content,
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final topic in content.topics) {
      _addIdentifierIssues(idsByType['grammar']!, 'grammar', topic.id, issues);
      _addEmptyIssues('grammar ${topic.id}', {
        'title': topic.title,
        'explanation': topic.explanation,
      }, issues);
      _addEmptyListIssue(
        'grammar ${topic.id}',
        'examples',
        topic.examples,
        issues,
      );
    }
  }

  void _validateDialogues(
    DialogueContent content,
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final dialogue in content.dialogues) {
      _addIdentifierIssues(
        idsByType['dialogue']!,
        'dialogue',
        dialogue.id,
        issues,
      );
      _addEmptyIssues('dialogue ${dialogue.id}', {
        'title': dialogue.title,
      }, issues);
      _addEmptyListIssue(
        'dialogue ${dialogue.id}',
        'lines',
        dialogue.lines,
        issues,
      );

      for (final line in dialogue.lines) {
        _addEmptyIssues('dialogue line in ${dialogue.id}', {
          'speaker': line.speaker,
          'spanish': line.spanish,
          'native_translation': line.nativeTranslation,
        }, issues);
      }
    }
  }

  void _validateReadings(
    ReadingContent content,
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final text in content.texts) {
      _addIdentifierIssues(idsByType['reading']!, 'reading', text.id, issues);
      _addEmptyIssues('reading ${text.id}', {
        'title': text.title,
        'text': text.text,
        'native_translation': text.nativeTranslation,
      }, issues);
    }
  }

  void _validateExerciseTemplates(
    ExerciseTemplateContent content,
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final template in content.templates) {
      _addIdentifierIssues(
        idsByType['exercise_template']!,
        'exercise_template',
        template.id,
        issues,
      );
      _addEmptyIssues('exercise_template ${template.id}', {
        'exercise_type': template.exerciseType,
        'prompt_template': template.promptTemplate,
      }, issues);
      _addEmptyListIssue(
        'exercise_template ${template.id}',
        'supported_goal_types',
        template.supportedGoalTypes,
        issues,
      );
      _addEmptyListIssue(
        'exercise_template ${template.id}',
        'required_object_types',
        template.requiredObjectTypes,
        issues,
      );

      if (!supportedExerciseTypes.contains(template.exerciseType)) {
        issues.add(
          EducationalContentValidationIssue(
            'Unsupported exercise type in template ${template.id}: '
            '${template.exerciseType}',
          ),
        );
      }
    }
  }

  void _validateReferences(
    Map<String, Set<String>> idsByType,
    Iterable<EducationalContent> contents,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final content in contents) {
      switch (content) {
        case GrammarContent():
          for (final topic in content.topics) {
            _addMissingReferenceIssues(
              owner: 'grammar ${topic.id}',
              referenceType: 'grammar',
              ids: topic.prerequisiteIds,
              knownIds: idsByType['grammar']!,
              issues: issues,
            );
          }
        case DialogueContent():
          for (final dialogue in content.dialogues) {
            _addMissingReferenceIssues(
              owner: 'dialogue ${dialogue.id}',
              referenceType: 'vocabulary',
              ids: dialogue.vocabularyIds,
              knownIds: idsByType['vocabulary']!,
              issues: issues,
            );
            _addMissingReferenceIssues(
              owner: 'dialogue ${dialogue.id}',
              referenceType: 'grammar',
              ids: dialogue.grammarIds,
              knownIds: idsByType['grammar']!,
              issues: issues,
            );
          }
        case ReadingContent():
          for (final text in content.texts) {
            _addMissingReferenceIssues(
              owner: 'reading ${text.id}',
              referenceType: 'vocabulary',
              ids: text.vocabularyIds,
              knownIds: idsByType['vocabulary']!,
              issues: issues,
            );
            _addMissingReferenceIssues(
              owner: 'reading ${text.id}',
              referenceType: 'grammar',
              ids: text.grammarIds,
              knownIds: idsByType['grammar']!,
              issues: issues,
            );
          }
        default:
          break;
      }
    }
  }

  void _validateGlobalDuplicateIds(
    Map<String, Set<String>> idsByType,
    List<EducationalContentValidationIssue> issues,
  ) {
    final seen = <String>{};

    for (final entry in idsByType.entries) {
      for (final id in entry.value) {
        if (!seen.add(id)) {
          issues.add(
            EducationalContentValidationIssue(
              'Duplicate educational content id: $id',
            ),
          );
        }
      }
    }
  }

  void _addIdentifierIssues(
    Set<String> ids,
    String type,
    String id,
    List<EducationalContentValidationIssue> issues,
  ) {
    if (id.trim().isEmpty) {
      issues.add(EducationalContentValidationIssue('Empty $type id'));
      return;
    }

    if (!ids.add(id)) {
      issues.add(EducationalContentValidationIssue('Duplicate $type id: $id'));
    }
  }

  void _addEmptyIssues(
    String owner,
    Map<String, String> fields,
    List<EducationalContentValidationIssue> issues,
  ) {
    for (final entry in fields.entries) {
      if (entry.value.trim().isEmpty) {
        issues.add(
          EducationalContentValidationIssue(
            'Empty ${entry.key} field in $owner',
          ),
        );
      }
    }
  }

  void _addEmptyListIssue(
    String owner,
    String field,
    List<Object> values,
    List<EducationalContentValidationIssue> issues,
  ) {
    if (values.isEmpty) {
      issues.add(
        EducationalContentValidationIssue('Empty $field field in $owner'),
      );
    }
  }

  void _addMissingReferenceIssues({
    required String owner,
    required String referenceType,
    required List<String> ids,
    required Set<String> knownIds,
    required List<EducationalContentValidationIssue> issues,
  }) {
    for (final id in ids) {
      if (!knownIds.contains(id)) {
        issues.add(
          EducationalContentValidationIssue(
            'Invalid $referenceType reference in $owner: $id',
          ),
        );
      }
    }
  }
}
