import '../../features/curriculum/curriculum_loader.dart';
import '../../features/curriculum/curriculum_models.dart';
import '../../features/curriculum/curriculum_repository.dart';
import 'content_loader.dart';
import 'topic_content.dart';

class ContentRepository {
  ContentRepository({
    CurriculumRepository? curriculumRepository,
    ContentLoader? contentLoader,
  }) : _curriculumRepository =
           curriculumRepository ??
           CurriculumRepository(
             loader: CurriculumLoader(
               coursePath: 'assets/languages/spanish/curriculum/course.json',
             ),
           ),
       _contentLoader = contentLoader ?? ContentLoader();

  final CurriculumRepository _curriculumRepository;
  final ContentLoader _contentLoader;
  final Map<String, EducationalContent> _contentCache = {};

  Course? _course;

  Future<LanguagePackDisplay> loadCurrentLanguage() async {
    final manifest = await _curriculumRepository.loadManifest();

    return LanguagePackDisplay(id: manifest.id, name: manifest.englishName);
  }

  Future<Course> loadCourse() async {
    return _course ??= await _curriculumRepository.loadCourse();
  }

  Future<LessonDetails> loadLessonDetails(String lessonId) async {
    final course = await loadCourse();
    final lesson = _findLesson(course, lessonId);
    final activities = <LessonActivityContentDetails>[];

    for (final activity in lesson.activities) {
      for (final reference in activity.contentReferences) {
        activities.add(
          LessonActivityContentDetails(
            activity: activity,
            contentReference: reference,
            content: await loadContent(reference),
          ),
        );
      }
    }

    return LessonDetails(
      lesson: lesson,
      activities: List.unmodifiable(activities),
    );
  }

  Future<EducationalContent> loadContent(
    LessonContentReference reference,
  ) async {
    final cachedContent = _contentCache[reference.assetPath];

    if (cachedContent != null) {
      return cachedContent;
    }

    final content = await _contentLoader.loadContent(reference.assetPath);
    _contentCache[reference.assetPath] = content;

    return content;
  }

  Lesson _findLesson(Course course, String lessonId) {
    for (final lesson in course.lessons) {
      if (lesson.id == lessonId) {
        return lesson;
      }
    }

    throw StateError('Lesson not found: $lessonId');
  }
}

class LessonDetails {
  const LessonDetails({required this.lesson, required this.activities});

  final Lesson lesson;
  final List<LessonActivityContentDetails> activities;
}

class LessonActivityContentDetails {
  const LessonActivityContentDetails({
    required this.activity,
    required this.contentReference,
    required this.content,
  });

  final LessonActivity activity;
  final LessonContentReference contentReference;
  final EducationalContent content;
}
