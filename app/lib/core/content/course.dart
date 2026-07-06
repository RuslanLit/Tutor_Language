import 'json_parsing.dart';

class Language {
  const Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, Object?> json) {
    return Language(
      code: _requiredString(json, 'code'),
      name: _requiredString(json, 'name'),
    );
  }

  final String code;
  final String name;

  Map<String, Object?> toJson() {
    return {'code': code, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Language && other.code == code && other.name == name;
  }

  @override
  int get hashCode => Object.hash(code, name);
}

class Course {
  const Course({
    required this.id,
    required this.languageCode,
    required this.title,
    required this.units,
  });

  factory Course.fromJson(Map<String, Object?> json) {
    return Course(
      id: _requiredString(json, 'id'),
      languageCode: _requiredString(json, 'languageCode'),
      title: _requiredString(json, 'title'),
      units: requiredList(json, 'units', Unit.fromJson),
    );
  }

  final String id;
  final String languageCode;
  final String title;
  final List<Unit> units;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'languageCode': languageCode,
      'title': title,
      'units': units.map((unit) => unit.toJson()).toList(growable: false),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Course &&
            other.id == id &&
            other.languageCode == languageCode &&
            other.title == title &&
            listEquals(other.units, units);
  }

  @override
  int get hashCode =>
      Object.hash(id, languageCode, title, Object.hashAll(units));
}

class Unit {
  const Unit({required this.id, required this.title, required this.topics});

  factory Unit.fromJson(Map<String, Object?> json) {
    return Unit(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      topics: requiredList(json, 'topics', Topic.fromJson),
    );
  }

  final String id;
  final String title;
  final List<Topic> topics;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'topics': topics.map((topic) => topic.toJson()).toList(growable: false),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Unit &&
            other.id == id &&
            other.title == title &&
            listEquals(other.topics, topics);
  }

  @override
  int get hashCode => Object.hash(id, title, Object.hashAll(topics));
}

class Topic {
  const Topic({required this.id, required this.title, required this.sections});

  factory Topic.fromJson(Map<String, Object?> json) {
    return Topic(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      sections: requiredList(json, 'sections', TopicSection.fromJson),
    );
  }

  final String id;
  final String title;
  final List<TopicSection> sections;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'sections': sections
          .map((section) => section.toJson())
          .toList(growable: false),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Topic &&
            other.id == id &&
            other.title == title &&
            listEquals(other.sections, sections);
  }

  @override
  int get hashCode => Object.hash(id, title, Object.hashAll(sections));
}

class TopicSection {
  const TopicSection({
    required this.id,
    required this.title,
    required this.contentReference,
  });

  factory TopicSection.fromJson(Map<String, Object?> json) {
    return TopicSection(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      contentReference: ContentReference.fromJson(
        requiredMap(json, 'contentReference'),
      ),
    );
  }

  final String id;
  final String title;
  final ContentReference contentReference;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'contentReference': contentReference.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TopicSection &&
            other.id == id &&
            other.title == title &&
            other.contentReference == contentReference;
  }

  @override
  int get hashCode => Object.hash(id, title, contentReference);
}

class ContentReference {
  const ContentReference({
    required this.type,
    required this.assetPath,
    this.referenceId,
  });

  factory ContentReference.fromJson(Map<String, Object?> json) {
    return ContentReference(
      type: _requiredString(json, 'type'),
      assetPath: _requiredString(json, 'assetPath'),
      referenceId: _optionalString(json, 'referenceId'),
    );
  }

  final String type;
  final String assetPath;
  final String? referenceId;

  Map<String, Object?> toJson() {
    return {
      'type': type,
      'assetPath': assetPath,
      if (referenceId != null) 'referenceId': referenceId,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ContentReference &&
            other.type == type &&
            other.assetPath == assetPath &&
            other.referenceId == referenceId;
  }

  @override
  int get hashCode => Object.hash(type, assetPath, referenceId);
}

String _requiredString(Map<String, Object?> json, String key) {
  return requiredString(json, key);
}

String? _optionalString(Map<String, Object?> json, String key) {
  return optionalString(json, key);
}
