// ignore_for_file: prefer_initializing_formals

import '../../core/content/json_parsing.dart';

class LanguagePackManifest {
  const LanguagePackManifest({
    required this.manifestVersion,
    required this.id,
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.version,
    required this.writingSystem,
    required this.textDirection,
  });

  factory LanguagePackManifest.fromJson(Map<String, Object?> json) {
    return LanguagePackManifest(
      manifestVersion: _requiredInt(json, 'manifestVersion'),
      id: requiredString(json, 'id'),
      code: requiredString(json, 'code'),
      nativeName: requiredString(json, 'nativeName'),
      englishName: requiredString(json, 'englishName'),
      version: requiredString(json, 'version'),
      writingSystem: requiredString(json, 'writingSystem'),
      textDirection: requiredString(json, 'textDirection'),
    );
  }

  final int manifestVersion;
  final String id;
  final String code;
  final String nativeName;
  final String englishName;
  final String version;
  final String writingSystem;
  final String textDirection;
}

class Course {
  const Course({
    required this.id,
    required this.languageId,
    required this.title,
    required this.level,
    required this.version,
    required this.modules,
    required this.lessons,
  });

  factory Course.fromJson(Map<String, Object?> json) {
    return Course(
      id: requiredString(json, 'id'),
      languageId: requiredString(json, 'languageId'),
      title: requiredString(json, 'title'),
      level: requiredString(json, 'level'),
      version: requiredString(json, 'version'),
      modules: requiredList(json, 'modules', Module.fromJson),
      lessons: requiredList(json, 'lessons', Lesson.fromJson),
    );
  }

  final String id;
  final String languageId;
  final String title;
  final String level;
  final String version;
  final List<Module> modules;
  final List<Lesson> lessons;
}

class LanguagePackDisplay {
  const LanguagePackDisplay({required this.id, required this.name});

  final String id;
  final String name;
}

class Module {
  const Module({
    required this.id,
    required this.title,
    required this.lessonIds,
  });

  factory Module.fromJson(Map<String, Object?> json) {
    return Module(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      lessonIds: optionalStringList(json, 'lessonIds'),
    );
  }

  final String id;
  final String title;
  final List<String> lessonIds;
}

class Lesson {
  // A Lesson is an immutable curriculum definition. The future deterministic
  // generator consumes it to create a runtime lesson session; generated
  // exercises and learner interaction state do not belong here.
  // Compatibility fields keep pre-C2 in-memory fixtures working while loaded
  // lesson data uses the canonical metadata/sections schema.
  const Lesson({
    this.metadata,
    this.objectives = const [],
    this.sections = const [],
    this.summary,
    required this.completionCriteria,
    this.references = const [],
    String? id,
    String? moduleId,
    String? title,
    LessonObjective? primaryObjective,
    List<LessonActivity>? activities,
    List<LessonPrerequisite>? prerequisites,
    int? estimatedDurationMinutes,
  }) : _id = id,
       _moduleId = moduleId,
       _title = title,
       _primaryObjective = primaryObjective,
       _activities = activities,
       _prerequisites = prerequisites,
       _estimatedDurationMinutes = estimatedDurationMinutes;

  factory Lesson.fromJson(Map<String, Object?> json) {
    return Lesson(
      metadata: LessonMetadata.fromJson(requiredMap(json, 'metadata')),
      objectives: requiredList(json, 'objectives', LessonObjective.fromJson),
      sections: requiredList(json, 'sections', LessonSection.fromJson),
      summary: LessonSummary.fromJson(requiredMap(json, 'summary')),
      completionCriteria: LessonCompletionCriteria.fromJson(
        requiredMap(json, 'completionCriteria'),
      ),
      references: requiredList(json, 'references', LessonReference.fromJson),
    );
  }

  final LessonMetadata? metadata;
  final List<LessonObjective> objectives;
  final List<LessonSection> sections;
  final LessonSummary? summary;
  final LessonCompletionCriteria completionCriteria;
  final List<LessonReference> references;

  final String? _id;
  final String? _moduleId;
  final String? _title;
  final LessonObjective? _primaryObjective;
  final List<LessonActivity>? _activities;
  final List<LessonPrerequisite>? _prerequisites;
  final int? _estimatedDurationMinutes;

  String get id => metadata?.id ?? _id!;
  String get moduleId => metadata?.moduleId ?? _moduleId!;
  String get courseId => metadata?.courseId ?? '';
  String get title => metadata?.title ?? _title!;
  int get estimatedDurationMinutes =>
      metadata?.estimatedDurationMinutes ?? _estimatedDurationMinutes!;
  String get difficulty => metadata?.difficulty ?? '';
  List<LessonPrerequisite> get prerequisites =>
      metadata?.prerequisites ?? _prerequisites ?? const [];
  LessonObjective? get primaryObjective =>
      objectives.isEmpty ? _primaryObjective : objectives.first;
  List<LessonObjective> get secondaryObjectives =>
      objectives.length <= 1 ? const [] : objectives.skip(1).toList();
  List<LessonActivity> get activities => sections.isEmpty
      ? _activities ?? const []
      : List.unmodifiable(sections.expand((section) => section.activities));
}

typedef LessonDefinition = Lesson;

class LessonMetadata {
  const LessonMetadata({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.courseId,
    required this.estimatedDurationMinutes,
    required this.difficulty,
    required this.tags,
    required this.version,
    required this.prerequisites,
  });

  factory LessonMetadata.fromJson(Map<String, Object?> json) {
    return LessonMetadata(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      moduleId: requiredString(json, 'moduleId'),
      courseId: requiredString(json, 'courseId'),
      estimatedDurationMinutes: _requiredInt(json, 'estimatedDurationMinutes'),
      difficulty: requiredString(json, 'difficulty'),
      tags: optionalStringList(json, 'tags'),
      version: requiredString(json, 'version'),
      prerequisites: requiredList(
        json,
        'prerequisites',
        LessonPrerequisite.fromJson,
      ),
    );
  }

  final String id;
  final String title;
  final String moduleId;
  final String courseId;
  final int estimatedDurationMinutes;
  final String difficulty;
  final List<String> tags;
  final String version;
  final List<LessonPrerequisite> prerequisites;
}

class LessonObjective {
  const LessonObjective({required this.id, required this.description});

  factory LessonObjective.fromJson(Map<String, Object?> json) {
    return LessonObjective(
      id: requiredString(json, 'id'),
      description: requiredString(json, 'description'),
    );
  }

  final String id;
  final String description;
}

class LessonSection {
  const LessonSection({
    required this.id,
    required this.title,
    required this.order,
    required this.activities,
  });

  factory LessonSection.fromJson(Map<String, Object?> json) {
    return LessonSection(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      order: _requiredInt(json, 'order'),
      activities: requiredList(json, 'activities', LessonActivity.fromJson),
    );
  }

  final String id;
  final String title;
  final int order;
  final List<LessonActivity> activities;
}

class LessonActivity {
  const LessonActivity({
    required this.id,
    required this.title,
    required this.type,
    this.order = 1,
    this.references = const [],
    List<LessonContentReference> contentReferences = const [],
  }) : _legacyContentReferences = contentReferences;

  factory LessonActivity.fromJson(Map<String, Object?> json) {
    return LessonActivity(
      id: requiredString(json, 'id'),
      title: requiredString(json, 'title'),
      type: requiredString(json, 'type'),
      order: _requiredInt(json, 'order'),
      references: _optionalActivityReferenceList(json, 'references'),
    );
  }

  final String id;
  final String title;
  final String type;
  final int order;
  final List<LessonActivityReference> references;
  final List<LessonContentReference> _legacyContentReferences;

  List<LessonContentReference> get contentReferences =>
      _legacyContentReferences.isNotEmpty
      ? _legacyContentReferences
      : references
            .map(
              (reference) => LessonContentReference(
                type: reference.type,
                assetPath: reference.assetPath,
                referenceId: reference.referenceId,
              ),
            )
            .toList(growable: false);
}

typedef LessonActivityDefinition = LessonActivity;

class LessonActivityReference {
  const LessonActivityReference({
    required this.type,
    required this.assetPath,
    this.referenceId,
  });

  factory LessonActivityReference.fromJson(Map<String, Object?> json) {
    return LessonActivityReference(
      type: requiredString(json, 'type'),
      assetPath: requiredString(json, 'assetPath'),
      referenceId: optionalString(json, 'referenceId'),
    );
  }

  final String type;
  final String assetPath;
  final String? referenceId;
}

class LessonContentReference extends LessonActivityReference {
  const LessonContentReference({
    required super.type,
    required super.assetPath,
    super.referenceId,
  });

  factory LessonContentReference.fromJson(Map<String, Object?> json) {
    return LessonContentReference(
      type: requiredString(json, 'type'),
      assetPath: requiredString(json, 'assetPath'),
      referenceId: optionalString(json, 'referenceId'),
    );
  }
}

class LessonReference {
  const LessonReference({required this.type, required this.id, this.note});

  factory LessonReference.fromJson(Map<String, Object?> json) {
    return LessonReference(
      type: requiredString(json, 'type'),
      id: requiredString(json, 'id'),
      note: optionalString(json, 'note'),
    );
  }

  final String type;
  final String id;
  final String? note;
}

class LessonPrerequisite {
  const LessonPrerequisite({required this.lessonId});

  factory LessonPrerequisite.fromJson(Map<String, Object?> json) {
    return LessonPrerequisite(lessonId: requiredString(json, 'lessonId'));
  }

  final String lessonId;
}

class LessonCompletionCriteria {
  const LessonCompletionCriteria({
    this.requiredActivities = const [],
    int? minimumCompletedActivities,
    this.mandatorySections = const [],
    String? type,
    int? minimumCheckedAnswers,
    bool? requiresAllCheckedAnswersCorrect,
  }) : minimumCompletedActivities =
           minimumCompletedActivities ?? minimumCheckedAnswers ?? 0;

  factory LessonCompletionCriteria.fromJson(Map<String, Object?> json) {
    return LessonCompletionCriteria(
      requiredActivities: optionalStringList(json, 'requiredActivities'),
      minimumCompletedActivities: _requiredInt(
        json,
        'minimumCompletedActivities',
      ),
      mandatorySections: optionalStringList(json, 'mandatorySections'),
    );
  }

  final List<String> requiredActivities;
  final int minimumCompletedActivities;
  final List<String> mandatorySections;
}

class LessonSummary {
  const LessonSummary({
    required this.id,
    required this.reviewPrompt,
    required this.referenceIds,
  });

  factory LessonSummary.fromJson(Map<String, Object?> json) {
    return LessonSummary(
      id: requiredString(json, 'id'),
      reviewPrompt: requiredString(json, 'reviewPrompt'),
      referenceIds: optionalStringList(json, 'referenceIds'),
    );
  }

  final String id;
  final String reviewPrompt;
  final List<String> referenceIds;
}

int _requiredInt(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value is int) {
    return value;
  }

  throw FormatException('Missing required int field: $key');
}

List<LessonActivityReference> _optionalActivityReferenceList(
  Map<String, Object?> json,
  String key,
) {
  final value = json[key];

  if (value == null) {
    return const [];
  }

  if (value is! List) {
    throw FormatException('Expected list field: $key');
  }

  return List.unmodifiable(
    value.map((item) {
      if (item is Map<String, Object?>) {
        return LessonActivityReference.fromJson(item);
      }

      if (item is Map) {
        return LessonActivityReference.fromJson(
          Map<String, Object?>.from(item),
        );
      }

      throw FormatException('Expected object item in list field: $key');
    }),
  );
}
