class Course {
  const Course({
    required this.id,
    required this.title,
    required this.language,
    required this.modules,
  });

  factory Course.fromJson(Map<String, Object?> json) {
    return Course(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      language: _requiredString(json, 'language'),
      modules: _requiredList(json, 'modules', Module.fromJson),
    );
  }

  final String id;
  final String title;
  final String language;
  final List<Module> modules;
}

class Module {
  const Module({required this.id, required this.title, required this.lessons});

  factory Module.fromJson(Map<String, Object?> json) {
    return Module(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      lessons: _requiredList(json, 'lessons', Lesson.fromJson),
    );
  }

  final String id;
  final String title;
  final List<Lesson> lessons;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.references,
  });

  factory Lesson.fromJson(Map<String, Object?> json) {
    return Lesson(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      references: _requiredList(json, 'references', LessonReference.fromJson),
    );
  }

  final String id;
  final String title;
  final List<LessonReference> references;
}

class LessonReference {
  const LessonReference({required this.type, required this.id});

  factory LessonReference.fromJson(Map<String, Object?> json) {
    return LessonReference(
      type: _requiredString(json, 'type'),
      id: _requiredString(json, 'id'),
    );
  }

  final String type;
  final String id;
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Missing required string field: $key');
}

List<T> _requiredList<T>(
  Map<String, Object?> json,
  String key,
  T Function(Map<String, Object?> json) fromJson,
) {
  final value = json[key];

  if (value is! List) {
    throw FormatException('Missing required list field: $key');
  }

  return value
      .map((item) {
        if (item is Map<String, Object?>) {
          return fromJson(item);
        }

        if (item is Map) {
          return fromJson(Map<String, Object?>.from(item));
        }

        throw FormatException('Invalid item in list field: $key');
      })
      .toList(growable: false);
}
