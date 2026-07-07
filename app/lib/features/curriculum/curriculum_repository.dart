import 'curriculum_loader.dart';
import 'curriculum_models.dart';

class CurriculumRepository {
  CurriculumRepository({CurriculumLoader? loader})
    : _loader = loader ?? CurriculumLoader();

  final CurriculumLoader _loader;

  LanguagePackManifest? _manifest;
  Course? _course;

  Future<LanguagePackManifest> loadManifest() async {
    return _manifest ??= await _loader.loadManifest();
  }

  Future<Course> loadCourse() async {
    return _course ??= await _loader.loadCourse();
  }

  Future<Lesson> loadLesson(String path) async {
    return _loader.loadLesson(path: path);
  }
}
