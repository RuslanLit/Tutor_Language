import '../../core/content/content_loader.dart';
import '../../core/content/educational_content_catalog.dart';
import '../../core/content/educational_content_validator.dart';
import '../../core/content/audio_reference_loader.dart';
import '../../core/content/pronunciation_models.dart';
import '../../core/content/spoken_practice.dart';
import '../../core/content/topic_content.dart';
import '../curriculum/curriculum_loader.dart';
import '../curriculum/curriculum_models.dart';
import 'lesson_content.dart';

class LessonAssemblyService {
  LessonAssemblyService({
    CurriculumLoader? curriculumLoader,
    ContentLoader? contentLoader,
  }) : _curriculumLoader = curriculumLoader ?? CurriculumLoader(),
       _contentLoader = contentLoader ?? ContentLoader();

  final CurriculumLoader _curriculumLoader;
  final ContentLoader _contentLoader;

  Future<LessonContent> assembleLesson(String lessonId) async {
    final course = await _curriculumLoader.loadCourse();
    final lesson = _findLesson(course, lessonId);
    final audioManifest = await AudioReferenceLoader().loadManifest();
    final spokenIssues = [
      ...const SpokenPracticeValidator().validateActivities(lesson.activities),
      ...const SpokenPracticeValidator().validateApprovedAudio(
        lesson.activities,
        audioManifest,
      ),
    ];
    if (spokenIssues.isNotEmpty) {
      throw LessonAssemblyException(spokenIssues.first.message);
    }
    final contentBundle = await _contentLoader.loadLanguagePackContent();
    final catalog = EducationalContentCatalog(contentBundle);

    return assembleLessonDefinition(lesson: lesson, catalog: catalog);
  }

  LessonContent assembleLessonDefinition({
    required LessonDefinition lesson,
    required EducationalContentCatalog catalog,
  }) {
    final spokenIssues = const SpokenPracticeValidator().validateActivities(
      lesson.activities,
    );
    if (spokenIssues.isNotEmpty) {
      throw LessonAssemblyException(spokenIssues.first.message);
    }
    const validator = EducationalContentValidator();
    final issues = validator.validateLessonReferences(
      lesson: lesson,
      catalog: catalog,
    );

    if (issues.isNotEmpty) {
      throw LessonAssemblyException(issues.first.message);
    }

    return LessonContent(
      lesson: lesson,
      sections: List.unmodifiable(_sectionsForLesson(lesson, catalog)),
    );
  }

  LessonDefinition _findLesson(Course course, String lessonId) {
    for (final lesson in course.lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    throw LessonAssemblyException('Lesson not found: $lessonId');
  }

  List<LessonContentSection> _sectionsForLesson(
    LessonDefinition lesson,
    EducationalContentCatalog catalog,
  ) {
    if (lesson.sections.isEmpty) {
      return [
        LessonContentSection(
          section: LessonSection(
            id: '${lesson.id}.section.legacy',
            title: lesson.title,
            order: 1,
            activities: lesson.activities,
          ),
          activities: List.unmodifiable(
            lesson.activities.map((activity) {
              return _activityContent(activity, catalog);
            }),
          ),
        ),
      ];
    }

    return lesson.sections
        .map((section) {
          return LessonContentSection(
            section: section,
            activities: List.unmodifiable(
              section.activities.map((activity) {
                return _activityContent(activity, catalog);
              }),
            ),
          );
        })
        .toList(growable: false);
  }

  LessonContentActivity _activityContent(
    LessonActivity activity,
    EducationalContentCatalog catalog,
  ) {
    return LessonContentActivity(
      activity: activity,
      resolvedContent: List.unmodifiable([
        if (activity.spokenPractice != null)
          SpokenPracticeActivity(
            id: activity.id,
            definition: activity.spokenPractice!,
          ),
        for (final ruleId in activity.introducedReadingRuleIds)
          ReadingRulePresentationReference(ruleId),
        for (final ruleId in activity.reviewedReadingRuleIds)
          ReadingRulePresentationReference(ruleId),
        for (final reference in activity.contentReferences)
          ..._resolveReference(reference, catalog),
      ]),
    );
  }

  List<Object> _resolveReference(
    LessonContentReference reference,
    EducationalContentCatalog catalog,
  ) {
    final content = catalog.contentByAssetPath(reference.assetPath);

    if (content == null) {
      throw LessonAssemblyException(
        'Missing content asset: ${reference.assetPath}',
      );
    }

    if (content.type != reference.type) {
      throw LessonAssemblyException(
        'Content type mismatch for ${reference.assetPath}: '
        'expected ${reference.type}, found ${content.type}',
      );
    }

    final referenceId = reference.referenceId;
    if (referenceId == null) {
      return _allObjects(content);
    }

    final resolved = _objectById(content, referenceId);
    if (resolved == null) {
      throw LessonAssemblyException(
        'Missing content referenceId $referenceId in ${reference.assetPath}',
      );
    }

    return [resolved];
  }

  List<Object> _allObjects(EducationalContent content) {
    return switch (content) {
      VocabularyContent() => content.entries,
      GrammarContent() => content.topics,
      DialogueContent() => content.dialogues,
      ReadingContent() => content.texts,
      ExerciseTemplateContent() => content.templates,
      _ => const [],
    };
  }

  Object? _objectById(EducationalContent content, String id) {
    return switch (content) {
      VocabularyContent() => _firstWhereOrNull<VocabularyItem>(
        content.entries,
        (entry) => entry.id == id,
      ),
      GrammarContent() => _firstWhereOrNull<GrammarTopic>(
        content.topics,
        (topic) => topic.id == id,
      ),
      DialogueContent() => _firstWhereOrNull<Dialogue>(
        content.dialogues,
        (dialogue) => dialogue.id == id,
      ),
      ReadingContent() => _firstWhereOrNull<ReadingText>(
        content.texts,
        (text) => text.id == id,
      ),
      ExerciseTemplateContent() => _firstWhereOrNull<ExerciseTemplate>(
        content.templates,
        (template) => template.id == id,
      ),
      _ => null,
    };
  }

  T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T value) test) {
    for (final value in values) {
      if (test(value)) {
        return value;
      }
    }

    return null;
  }
}

class LessonAssemblyException implements Exception {
  const LessonAssemblyException(this.message);

  final String message;

  @override
  String toString() => 'LessonAssemblyException: $message';
}
