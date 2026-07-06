import 'content_loader.dart';
import 'course.dart';
import 'curriculum_loader.dart';
import 'topic_content.dart';

class ContentRepository {
  ContentRepository({
    CurriculumLoader? curriculumLoader,
    ContentLoader? contentLoader,
  }) : _curriculumLoader = curriculumLoader ?? CurriculumLoader(),
       _contentLoader = contentLoader ?? ContentLoader();

  final CurriculumLoader _curriculumLoader;
  final ContentLoader _contentLoader;
  final Map<String, TopicContent> _contentCache = {};

  Course? _course;

  Future<Language> loadCurrentLanguage() async {
    final course = await loadCourse();

    return Language(code: course.languageCode, name: _languageName(course));
  }

  Future<Course> loadCourse() async {
    return _course ??= await _curriculumLoader.loadCourse();
  }

  Future<TopicDetails> loadTopicDetails(String topicId) async {
    final course = await loadCourse();
    final topic = _findTopic(course, topicId);
    final sections = <TopicSectionDetails>[];

    for (final section in topic.sections) {
      sections.add(
        TopicSectionDetails(
          section: section,
          content: await loadContent(section.contentReference),
        ),
      );
    }

    return TopicDetails(topic: topic, sections: List.unmodifiable(sections));
  }

  Future<TopicContent> loadContent(ContentReference reference) async {
    final cachedContent = _contentCache[reference.assetPath];

    if (cachedContent != null) {
      return cachedContent;
    }

    final content = await _contentLoader.loadContent(reference.assetPath);
    _contentCache[reference.assetPath] = content;

    return content;
  }

  Topic _findTopic(Course course, String topicId) {
    for (final unit in course.units) {
      for (final topic in unit.topics) {
        if (topic.id == topicId) {
          return topic;
        }
      }
    }

    throw StateError('Topic not found: $topicId');
  }

  String _languageName(Course course) {
    return switch (course.languageCode) {
      'es' => 'Spanish',
      final code => code,
    };
  }
}

class TopicDetails {
  const TopicDetails({required this.topic, required this.sections});

  final Topic topic;
  final List<TopicSectionDetails> sections;
}

class TopicSectionDetails {
  const TopicSectionDetails({required this.section, required this.content});

  final TopicSection section;
  final TopicContent content;
}
