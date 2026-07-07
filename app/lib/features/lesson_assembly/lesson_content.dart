import '../curriculum/curriculum_models.dart';

class LessonContent {
  const LessonContent({required this.lesson, required this.sections});

  final LessonDefinition lesson;
  final List<LessonContentSection> sections;

  List<LessonContentActivity> get activities {
    return List.unmodifiable(sections.expand((section) => section.activities));
  }
}

class LessonContentSection {
  const LessonContentSection({required this.section, required this.activities});

  final LessonSection section;
  final List<LessonContentActivity> activities;
}

class LessonContentActivity {
  const LessonContentActivity({
    required this.activity,
    required this.resolvedContent,
  });

  final LessonActivity activity;
  final List<Object> resolvedContent;
}
