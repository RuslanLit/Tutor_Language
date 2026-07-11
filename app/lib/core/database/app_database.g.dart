// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LearnerStatesTable extends LearnerStates
    with TableInfo<$LearnerStatesTable, LearnerStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnerStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedLanguageMeta = const VerificationMeta(
    'selectedLanguage',
  );
  @override
  late final GeneratedColumn<String> selectedLanguage = GeneratedColumn<String>(
    'selected_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentCourseIdMeta = const VerificationMeta(
    'currentCourseId',
  );
  @override
  late final GeneratedColumn<String> currentCourseId = GeneratedColumn<String>(
    'current_course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentTopicIdMeta = const VerificationMeta(
    'currentTopicId',
  );
  @override
  late final GeneratedColumn<String> currentTopicId = GeneratedColumn<String>(
    'current_topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    selectedLanguage,
    currentCourseId,
    currentTopicId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learner_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnerStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('selected_language')) {
      context.handle(
        _selectedLanguageMeta,
        selectedLanguage.isAcceptableOrUnknown(
          data['selected_language']!,
          _selectedLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedLanguageMeta);
    }
    if (data.containsKey('current_course_id')) {
      context.handle(
        _currentCourseIdMeta,
        currentCourseId.isAcceptableOrUnknown(
          data['current_course_id']!,
          _currentCourseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentCourseIdMeta);
    }
    if (data.containsKey('current_topic_id')) {
      context.handle(
        _currentTopicIdMeta,
        currentTopicId.isAcceptableOrUnknown(
          data['current_topic_id']!,
          _currentTopicIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentTopicIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearnerStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnerStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      selectedLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_language'],
      )!,
      currentCourseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_course_id'],
      )!,
      currentTopicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_topic_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LearnerStatesTable createAlias(String alias) {
    return $LearnerStatesTable(attachedDatabase, alias);
  }
}

class LearnerStateRow extends DataClass implements Insertable<LearnerStateRow> {
  final String id;
  final String selectedLanguage;
  final String currentCourseId;
  final String currentTopicId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LearnerStateRow({
    required this.id,
    required this.selectedLanguage,
    required this.currentCourseId,
    required this.currentTopicId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['selected_language'] = Variable<String>(selectedLanguage);
    map['current_course_id'] = Variable<String>(currentCourseId);
    map['current_topic_id'] = Variable<String>(currentTopicId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LearnerStatesCompanion toCompanion(bool nullToAbsent) {
    return LearnerStatesCompanion(
      id: Value(id),
      selectedLanguage: Value(selectedLanguage),
      currentCourseId: Value(currentCourseId),
      currentTopicId: Value(currentTopicId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory LearnerStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnerStateRow(
      id: serializer.fromJson<String>(json['id']),
      selectedLanguage: serializer.fromJson<String>(json['selectedLanguage']),
      currentCourseId: serializer.fromJson<String>(json['currentCourseId']),
      currentTopicId: serializer.fromJson<String>(json['currentTopicId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'selectedLanguage': serializer.toJson<String>(selectedLanguage),
      'currentCourseId': serializer.toJson<String>(currentCourseId),
      'currentTopicId': serializer.toJson<String>(currentTopicId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LearnerStateRow copyWith({
    String? id,
    String? selectedLanguage,
    String? currentCourseId,
    String? currentTopicId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LearnerStateRow(
    id: id ?? this.id,
    selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    currentCourseId: currentCourseId ?? this.currentCourseId,
    currentTopicId: currentTopicId ?? this.currentTopicId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LearnerStateRow copyWithCompanion(LearnerStatesCompanion data) {
    return LearnerStateRow(
      id: data.id.present ? data.id.value : this.id,
      selectedLanguage: data.selectedLanguage.present
          ? data.selectedLanguage.value
          : this.selectedLanguage,
      currentCourseId: data.currentCourseId.present
          ? data.currentCourseId.value
          : this.currentCourseId,
      currentTopicId: data.currentTopicId.present
          ? data.currentTopicId.value
          : this.currentTopicId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnerStateRow(')
          ..write('id: $id, ')
          ..write('selectedLanguage: $selectedLanguage, ')
          ..write('currentCourseId: $currentCourseId, ')
          ..write('currentTopicId: $currentTopicId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    selectedLanguage,
    currentCourseId,
    currentTopicId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnerStateRow &&
          other.id == this.id &&
          other.selectedLanguage == this.selectedLanguage &&
          other.currentCourseId == this.currentCourseId &&
          other.currentTopicId == this.currentTopicId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LearnerStatesCompanion extends UpdateCompanion<LearnerStateRow> {
  final Value<String> id;
  final Value<String> selectedLanguage;
  final Value<String> currentCourseId;
  final Value<String> currentTopicId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LearnerStatesCompanion({
    this.id = const Value.absent(),
    this.selectedLanguage = const Value.absent(),
    this.currentCourseId = const Value.absent(),
    this.currentTopicId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnerStatesCompanion.insert({
    required String id,
    required String selectedLanguage,
    required String currentCourseId,
    required String currentTopicId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       selectedLanguage = Value(selectedLanguage),
       currentCourseId = Value(currentCourseId),
       currentTopicId = Value(currentTopicId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LearnerStateRow> custom({
    Expression<String>? id,
    Expression<String>? selectedLanguage,
    Expression<String>? currentCourseId,
    Expression<String>? currentTopicId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedLanguage != null) 'selected_language': selectedLanguage,
      if (currentCourseId != null) 'current_course_id': currentCourseId,
      if (currentTopicId != null) 'current_topic_id': currentTopicId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnerStatesCompanion copyWith({
    Value<String>? id,
    Value<String>? selectedLanguage,
    Value<String>? currentCourseId,
    Value<String>? currentTopicId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LearnerStatesCompanion(
      id: id ?? this.id,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentCourseId: currentCourseId ?? this.currentCourseId,
      currentTopicId: currentTopicId ?? this.currentTopicId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (selectedLanguage.present) {
      map['selected_language'] = Variable<String>(selectedLanguage.value);
    }
    if (currentCourseId.present) {
      map['current_course_id'] = Variable<String>(currentCourseId.value);
    }
    if (currentTopicId.present) {
      map['current_topic_id'] = Variable<String>(currentTopicId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnerStatesCompanion(')
          ..write('id: $id, ')
          ..write('selectedLanguage: $selectedLanguage, ')
          ..write('currentCourseId: $currentCourseId, ')
          ..write('currentTopicId: $currentTopicId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LearnerProgressEventsTable extends LearnerProgressEvents
    with TableInfo<$LearnerProgressEventsTable, LearnerProgressEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearnerProgressEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicIdMeta = const VerificationMeta(
    'topicId',
  );
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
    'topic_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentReferenceMeta = const VerificationMeta(
    'contentReference',
  );
  @override
  late final GeneratedColumn<String> contentReference = GeneratedColumn<String>(
    'content_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    topicId,
    sectionId,
    contentReference,
    createdAt,
    metadataJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learner_progress_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearnerProgressEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(
        _topicIdMeta,
        topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    }
    if (data.containsKey('content_reference')) {
      context.handle(
        _contentReferenceMeta,
        contentReference.isAcceptableOrUnknown(
          data['content_reference']!,
          _contentReferenceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearnerProgressEventRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearnerProgressEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      topicId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic_id'],
      )!,
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      ),
      contentReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_reference'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
    );
  }

  @override
  $LearnerProgressEventsTable createAlias(String alias) {
    return $LearnerProgressEventsTable(attachedDatabase, alias);
  }
}

class LearnerProgressEventRow extends DataClass
    implements Insertable<LearnerProgressEventRow> {
  final String id;
  final String eventType;
  final String topicId;
  final String? sectionId;
  final String? contentReference;
  final DateTime createdAt;
  final String? metadataJson;
  const LearnerProgressEventRow({
    required this.id,
    required this.eventType,
    required this.topicId,
    this.sectionId,
    this.contentReference,
    required this.createdAt,
    this.metadataJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['event_type'] = Variable<String>(eventType);
    map['topic_id'] = Variable<String>(topicId);
    if (!nullToAbsent || sectionId != null) {
      map['section_id'] = Variable<String>(sectionId);
    }
    if (!nullToAbsent || contentReference != null) {
      map['content_reference'] = Variable<String>(contentReference);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    return map;
  }

  LearnerProgressEventsCompanion toCompanion(bool nullToAbsent) {
    return LearnerProgressEventsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      topicId: Value(topicId),
      sectionId: sectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sectionId),
      contentReference: contentReference == null && nullToAbsent
          ? const Value.absent()
          : Value(contentReference),
      createdAt: Value(createdAt),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
    );
  }

  factory LearnerProgressEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearnerProgressEventRow(
      id: serializer.fromJson<String>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      topicId: serializer.fromJson<String>(json['topicId']),
      sectionId: serializer.fromJson<String?>(json['sectionId']),
      contentReference: serializer.fromJson<String?>(json['contentReference']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eventType': serializer.toJson<String>(eventType),
      'topicId': serializer.toJson<String>(topicId),
      'sectionId': serializer.toJson<String?>(sectionId),
      'contentReference': serializer.toJson<String?>(contentReference),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'metadataJson': serializer.toJson<String?>(metadataJson),
    };
  }

  LearnerProgressEventRow copyWith({
    String? id,
    String? eventType,
    String? topicId,
    Value<String?> sectionId = const Value.absent(),
    Value<String?> contentReference = const Value.absent(),
    DateTime? createdAt,
    Value<String?> metadataJson = const Value.absent(),
  }) => LearnerProgressEventRow(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    topicId: topicId ?? this.topicId,
    sectionId: sectionId.present ? sectionId.value : this.sectionId,
    contentReference: contentReference.present
        ? contentReference.value
        : this.contentReference,
    createdAt: createdAt ?? this.createdAt,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
  );
  LearnerProgressEventRow copyWithCompanion(
    LearnerProgressEventsCompanion data,
  ) {
    return LearnerProgressEventRow(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      contentReference: data.contentReference.present
          ? data.contentReference.value
          : this.contentReference,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearnerProgressEventRow(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('topicId: $topicId, ')
          ..write('sectionId: $sectionId, ')
          ..write('contentReference: $contentReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('metadataJson: $metadataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventType,
    topicId,
    sectionId,
    contentReference,
    createdAt,
    metadataJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearnerProgressEventRow &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.topicId == this.topicId &&
          other.sectionId == this.sectionId &&
          other.contentReference == this.contentReference &&
          other.createdAt == this.createdAt &&
          other.metadataJson == this.metadataJson);
}

class LearnerProgressEventsCompanion
    extends UpdateCompanion<LearnerProgressEventRow> {
  final Value<String> id;
  final Value<String> eventType;
  final Value<String> topicId;
  final Value<String?> sectionId;
  final Value<String?> contentReference;
  final Value<DateTime> createdAt;
  final Value<String?> metadataJson;
  final Value<int> rowid;
  const LearnerProgressEventsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.topicId = const Value.absent(),
    this.sectionId = const Value.absent(),
    this.contentReference = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnerProgressEventsCompanion.insert({
    required String id,
    required String eventType,
    required String topicId,
    this.sectionId = const Value.absent(),
    this.contentReference = const Value.absent(),
    required DateTime createdAt,
    this.metadataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       eventType = Value(eventType),
       topicId = Value(topicId),
       createdAt = Value(createdAt);
  static Insertable<LearnerProgressEventRow> custom({
    Expression<String>? id,
    Expression<String>? eventType,
    Expression<String>? topicId,
    Expression<String>? sectionId,
    Expression<String>? contentReference,
    Expression<DateTime>? createdAt,
    Expression<String>? metadataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (topicId != null) 'topic_id': topicId,
      if (sectionId != null) 'section_id': sectionId,
      if (contentReference != null) 'content_reference': contentReference,
      if (createdAt != null) 'created_at': createdAt,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnerProgressEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? eventType,
    Value<String>? topicId,
    Value<String?>? sectionId,
    Value<String?>? contentReference,
    Value<DateTime>? createdAt,
    Value<String?>? metadataJson,
    Value<int>? rowid,
  }) {
    return LearnerProgressEventsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      topicId: topicId ?? this.topicId,
      sectionId: sectionId ?? this.sectionId,
      contentReference: contentReference ?? this.contentReference,
      createdAt: createdAt ?? this.createdAt,
      metadataJson: metadataJson ?? this.metadataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (contentReference.present) {
      map['content_reference'] = Variable<String>(contentReference.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearnerProgressEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('topicId: $topicId, ')
          ..write('sectionId: $sectionId, ')
          ..write('contentReference: $contentReference, ')
          ..write('createdAt: $createdAt, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonAttemptsTable extends LessonAttempts
    with TableInfo<$LessonAttemptsTable, LessonAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _courseIdMeta = const VerificationMeta(
    'courseId',
  );
  @override
  late final GeneratedColumn<String> courseId = GeneratedColumn<String>(
    'course_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeStatusMeta = const VerificationMeta(
    'outcomeStatus',
  );
  @override
  late final GeneratedColumn<String> outcomeStatus = GeneratedColumn<String>(
    'outcome_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outcomeReasonCodeMeta = const VerificationMeta(
    'outcomeReasonCode',
  );
  @override
  late final GeneratedColumn<String> outcomeReasonCode =
      GeneratedColumn<String>(
        'outcome_reason_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _assessedStepCountMeta = const VerificationMeta(
    'assessedStepCount',
  );
  @override
  late final GeneratedColumn<int> assessedStepCount = GeneratedColumn<int>(
    'assessed_step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteredStepCountMeta = const VerificationMeta(
    'masteredStepCount',
  );
  @override
  late final GeneratedColumn<int> masteredStepCount = GeneratedColumn<int>(
    'mastered_step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fragileStepCountMeta = const VerificationMeta(
    'fragileStepCount',
  );
  @override
  late final GeneratedColumn<int> fragileStepCount = GeneratedColumn<int>(
    'fragile_step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notMasteredStepCountMeta =
      const VerificationMeta('notMasteredStepCount');
  @override
  late final GeneratedColumn<int> notMasteredStepCount = GeneratedColumn<int>(
    'not_mastered_step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unassessedStepCountMeta =
      const VerificationMeta('unassessedStepCount');
  @override
  late final GeneratedColumn<int> unassessedStepCount = GeneratedColumn<int>(
    'unassessed_step_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _canonicalCheckableStepCountMeta =
      const VerificationMeta('canonicalCheckableStepCount');
  @override
  late final GeneratedColumn<int> canonicalCheckableStepCount =
      GeneratedColumn<int>(
        'canonical_checkable_step_count',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalSubmissionCountMeta =
      const VerificationMeta('totalSubmissionCount');
  @override
  late final GeneratedColumn<int> totalSubmissionCount = GeneratedColumn<int>(
    'total_submission_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _learningPolicyVersionMeta =
      const VerificationMeta('learningPolicyVersion');
  @override
  late final GeneratedColumn<String> learningPolicyVersion =
      GeneratedColumn<String>(
        'learning_policy_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    lessonId,
    courseId,
    startedAt,
    completedAt,
    outcomeStatus,
    outcomeReasonCode,
    assessedStepCount,
    masteredStepCount,
    fragileStepCount,
    notMasteredStepCount,
    unassessedStepCount,
    canonicalCheckableStepCount,
    totalSubmissionCount,
    learningPolicyVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonAttemptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('course_id')) {
      context.handle(
        _courseIdMeta,
        courseId.isAcceptableOrUnknown(data['course_id']!, _courseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_courseIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('outcome_status')) {
      context.handle(
        _outcomeStatusMeta,
        outcomeStatus.isAcceptableOrUnknown(
          data['outcome_status']!,
          _outcomeStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outcomeStatusMeta);
    }
    if (data.containsKey('outcome_reason_code')) {
      context.handle(
        _outcomeReasonCodeMeta,
        outcomeReasonCode.isAcceptableOrUnknown(
          data['outcome_reason_code']!,
          _outcomeReasonCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outcomeReasonCodeMeta);
    }
    if (data.containsKey('assessed_step_count')) {
      context.handle(
        _assessedStepCountMeta,
        assessedStepCount.isAcceptableOrUnknown(
          data['assessed_step_count']!,
          _assessedStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assessedStepCountMeta);
    }
    if (data.containsKey('mastered_step_count')) {
      context.handle(
        _masteredStepCountMeta,
        masteredStepCount.isAcceptableOrUnknown(
          data['mastered_step_count']!,
          _masteredStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteredStepCountMeta);
    }
    if (data.containsKey('fragile_step_count')) {
      context.handle(
        _fragileStepCountMeta,
        fragileStepCount.isAcceptableOrUnknown(
          data['fragile_step_count']!,
          _fragileStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fragileStepCountMeta);
    }
    if (data.containsKey('not_mastered_step_count')) {
      context.handle(
        _notMasteredStepCountMeta,
        notMasteredStepCount.isAcceptableOrUnknown(
          data['not_mastered_step_count']!,
          _notMasteredStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notMasteredStepCountMeta);
    }
    if (data.containsKey('unassessed_step_count')) {
      context.handle(
        _unassessedStepCountMeta,
        unassessedStepCount.isAcceptableOrUnknown(
          data['unassessed_step_count']!,
          _unassessedStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unassessedStepCountMeta);
    }
    if (data.containsKey('canonical_checkable_step_count')) {
      context.handle(
        _canonicalCheckableStepCountMeta,
        canonicalCheckableStepCount.isAcceptableOrUnknown(
          data['canonical_checkable_step_count']!,
          _canonicalCheckableStepCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalCheckableStepCountMeta);
    }
    if (data.containsKey('total_submission_count')) {
      context.handle(
        _totalSubmissionCountMeta,
        totalSubmissionCount.isAcceptableOrUnknown(
          data['total_submission_count']!,
          _totalSubmissionCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalSubmissionCountMeta);
    }
    if (data.containsKey('learning_policy_version')) {
      context.handle(
        _learningPolicyVersionMeta,
        learningPolicyVersion.isAcceptableOrUnknown(
          data['learning_policy_version']!,
          _learningPolicyVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learningPolicyVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  LessonAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonAttemptRow(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      courseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}course_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      outcomeStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome_status'],
      )!,
      outcomeReasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome_reason_code'],
      )!,
      assessedStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assessed_step_count'],
      )!,
      masteredStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mastered_step_count'],
      )!,
      fragileStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fragile_step_count'],
      )!,
      notMasteredStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}not_mastered_step_count'],
      )!,
      unassessedStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unassessed_step_count'],
      )!,
      canonicalCheckableStepCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}canonical_checkable_step_count'],
      )!,
      totalSubmissionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_submission_count'],
      )!,
      learningPolicyVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_policy_version'],
      )!,
    );
  }

  @override
  $LessonAttemptsTable createAlias(String alias) {
    return $LessonAttemptsTable(attachedDatabase, alias);
  }
}

class LessonAttemptRow extends DataClass
    implements Insertable<LessonAttemptRow> {
  final String attemptId;
  final String lessonId;
  final String courseId;
  final DateTime? startedAt;
  final DateTime completedAt;
  final String outcomeStatus;
  final String outcomeReasonCode;
  final int assessedStepCount;
  final int masteredStepCount;
  final int fragileStepCount;
  final int notMasteredStepCount;
  final int unassessedStepCount;
  final int canonicalCheckableStepCount;
  final int totalSubmissionCount;
  final String learningPolicyVersion;
  const LessonAttemptRow({
    required this.attemptId,
    required this.lessonId,
    required this.courseId,
    this.startedAt,
    required this.completedAt,
    required this.outcomeStatus,
    required this.outcomeReasonCode,
    required this.assessedStepCount,
    required this.masteredStepCount,
    required this.fragileStepCount,
    required this.notMasteredStepCount,
    required this.unassessedStepCount,
    required this.canonicalCheckableStepCount,
    required this.totalSubmissionCount,
    required this.learningPolicyVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['course_id'] = Variable<String>(courseId);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    map['completed_at'] = Variable<DateTime>(completedAt);
    map['outcome_status'] = Variable<String>(outcomeStatus);
    map['outcome_reason_code'] = Variable<String>(outcomeReasonCode);
    map['assessed_step_count'] = Variable<int>(assessedStepCount);
    map['mastered_step_count'] = Variable<int>(masteredStepCount);
    map['fragile_step_count'] = Variable<int>(fragileStepCount);
    map['not_mastered_step_count'] = Variable<int>(notMasteredStepCount);
    map['unassessed_step_count'] = Variable<int>(unassessedStepCount);
    map['canonical_checkable_step_count'] = Variable<int>(
      canonicalCheckableStepCount,
    );
    map['total_submission_count'] = Variable<int>(totalSubmissionCount);
    map['learning_policy_version'] = Variable<String>(learningPolicyVersion);
    return map;
  }

  LessonAttemptsCompanion toCompanion(bool nullToAbsent) {
    return LessonAttemptsCompanion(
      attemptId: Value(attemptId),
      lessonId: Value(lessonId),
      courseId: Value(courseId),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: Value(completedAt),
      outcomeStatus: Value(outcomeStatus),
      outcomeReasonCode: Value(outcomeReasonCode),
      assessedStepCount: Value(assessedStepCount),
      masteredStepCount: Value(masteredStepCount),
      fragileStepCount: Value(fragileStepCount),
      notMasteredStepCount: Value(notMasteredStepCount),
      unassessedStepCount: Value(unassessedStepCount),
      canonicalCheckableStepCount: Value(canonicalCheckableStepCount),
      totalSubmissionCount: Value(totalSubmissionCount),
      learningPolicyVersion: Value(learningPolicyVersion),
    );
  }

  factory LessonAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonAttemptRow(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      courseId: serializer.fromJson<String>(json['courseId']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      outcomeStatus: serializer.fromJson<String>(json['outcomeStatus']),
      outcomeReasonCode: serializer.fromJson<String>(json['outcomeReasonCode']),
      assessedStepCount: serializer.fromJson<int>(json['assessedStepCount']),
      masteredStepCount: serializer.fromJson<int>(json['masteredStepCount']),
      fragileStepCount: serializer.fromJson<int>(json['fragileStepCount']),
      notMasteredStepCount: serializer.fromJson<int>(
        json['notMasteredStepCount'],
      ),
      unassessedStepCount: serializer.fromJson<int>(
        json['unassessedStepCount'],
      ),
      canonicalCheckableStepCount: serializer.fromJson<int>(
        json['canonicalCheckableStepCount'],
      ),
      totalSubmissionCount: serializer.fromJson<int>(
        json['totalSubmissionCount'],
      ),
      learningPolicyVersion: serializer.fromJson<String>(
        json['learningPolicyVersion'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'lessonId': serializer.toJson<String>(lessonId),
      'courseId': serializer.toJson<String>(courseId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'outcomeStatus': serializer.toJson<String>(outcomeStatus),
      'outcomeReasonCode': serializer.toJson<String>(outcomeReasonCode),
      'assessedStepCount': serializer.toJson<int>(assessedStepCount),
      'masteredStepCount': serializer.toJson<int>(masteredStepCount),
      'fragileStepCount': serializer.toJson<int>(fragileStepCount),
      'notMasteredStepCount': serializer.toJson<int>(notMasteredStepCount),
      'unassessedStepCount': serializer.toJson<int>(unassessedStepCount),
      'canonicalCheckableStepCount': serializer.toJson<int>(
        canonicalCheckableStepCount,
      ),
      'totalSubmissionCount': serializer.toJson<int>(totalSubmissionCount),
      'learningPolicyVersion': serializer.toJson<String>(learningPolicyVersion),
    };
  }

  LessonAttemptRow copyWith({
    String? attemptId,
    String? lessonId,
    String? courseId,
    Value<DateTime?> startedAt = const Value.absent(),
    DateTime? completedAt,
    String? outcomeStatus,
    String? outcomeReasonCode,
    int? assessedStepCount,
    int? masteredStepCount,
    int? fragileStepCount,
    int? notMasteredStepCount,
    int? unassessedStepCount,
    int? canonicalCheckableStepCount,
    int? totalSubmissionCount,
    String? learningPolicyVersion,
  }) => LessonAttemptRow(
    attemptId: attemptId ?? this.attemptId,
    lessonId: lessonId ?? this.lessonId,
    courseId: courseId ?? this.courseId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt ?? this.completedAt,
    outcomeStatus: outcomeStatus ?? this.outcomeStatus,
    outcomeReasonCode: outcomeReasonCode ?? this.outcomeReasonCode,
    assessedStepCount: assessedStepCount ?? this.assessedStepCount,
    masteredStepCount: masteredStepCount ?? this.masteredStepCount,
    fragileStepCount: fragileStepCount ?? this.fragileStepCount,
    notMasteredStepCount: notMasteredStepCount ?? this.notMasteredStepCount,
    unassessedStepCount: unassessedStepCount ?? this.unassessedStepCount,
    canonicalCheckableStepCount:
        canonicalCheckableStepCount ?? this.canonicalCheckableStepCount,
    totalSubmissionCount: totalSubmissionCount ?? this.totalSubmissionCount,
    learningPolicyVersion: learningPolicyVersion ?? this.learningPolicyVersion,
  );
  LessonAttemptRow copyWithCompanion(LessonAttemptsCompanion data) {
    return LessonAttemptRow(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      courseId: data.courseId.present ? data.courseId.value : this.courseId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      outcomeStatus: data.outcomeStatus.present
          ? data.outcomeStatus.value
          : this.outcomeStatus,
      outcomeReasonCode: data.outcomeReasonCode.present
          ? data.outcomeReasonCode.value
          : this.outcomeReasonCode,
      assessedStepCount: data.assessedStepCount.present
          ? data.assessedStepCount.value
          : this.assessedStepCount,
      masteredStepCount: data.masteredStepCount.present
          ? data.masteredStepCount.value
          : this.masteredStepCount,
      fragileStepCount: data.fragileStepCount.present
          ? data.fragileStepCount.value
          : this.fragileStepCount,
      notMasteredStepCount: data.notMasteredStepCount.present
          ? data.notMasteredStepCount.value
          : this.notMasteredStepCount,
      unassessedStepCount: data.unassessedStepCount.present
          ? data.unassessedStepCount.value
          : this.unassessedStepCount,
      canonicalCheckableStepCount: data.canonicalCheckableStepCount.present
          ? data.canonicalCheckableStepCount.value
          : this.canonicalCheckableStepCount,
      totalSubmissionCount: data.totalSubmissionCount.present
          ? data.totalSubmissionCount.value
          : this.totalSubmissionCount,
      learningPolicyVersion: data.learningPolicyVersion.present
          ? data.learningPolicyVersion.value
          : this.learningPolicyVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttemptRow(')
          ..write('attemptId: $attemptId, ')
          ..write('lessonId: $lessonId, ')
          ..write('courseId: $courseId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('outcomeStatus: $outcomeStatus, ')
          ..write('outcomeReasonCode: $outcomeReasonCode, ')
          ..write('assessedStepCount: $assessedStepCount, ')
          ..write('masteredStepCount: $masteredStepCount, ')
          ..write('fragileStepCount: $fragileStepCount, ')
          ..write('notMasteredStepCount: $notMasteredStepCount, ')
          ..write('unassessedStepCount: $unassessedStepCount, ')
          ..write('canonicalCheckableStepCount: $canonicalCheckableStepCount, ')
          ..write('totalSubmissionCount: $totalSubmissionCount, ')
          ..write('learningPolicyVersion: $learningPolicyVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    lessonId,
    courseId,
    startedAt,
    completedAt,
    outcomeStatus,
    outcomeReasonCode,
    assessedStepCount,
    masteredStepCount,
    fragileStepCount,
    notMasteredStepCount,
    unassessedStepCount,
    canonicalCheckableStepCount,
    totalSubmissionCount,
    learningPolicyVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonAttemptRow &&
          other.attemptId == this.attemptId &&
          other.lessonId == this.lessonId &&
          other.courseId == this.courseId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.outcomeStatus == this.outcomeStatus &&
          other.outcomeReasonCode == this.outcomeReasonCode &&
          other.assessedStepCount == this.assessedStepCount &&
          other.masteredStepCount == this.masteredStepCount &&
          other.fragileStepCount == this.fragileStepCount &&
          other.notMasteredStepCount == this.notMasteredStepCount &&
          other.unassessedStepCount == this.unassessedStepCount &&
          other.canonicalCheckableStepCount ==
              this.canonicalCheckableStepCount &&
          other.totalSubmissionCount == this.totalSubmissionCount &&
          other.learningPolicyVersion == this.learningPolicyVersion);
}

class LessonAttemptsCompanion extends UpdateCompanion<LessonAttemptRow> {
  final Value<String> attemptId;
  final Value<String> lessonId;
  final Value<String> courseId;
  final Value<DateTime?> startedAt;
  final Value<DateTime> completedAt;
  final Value<String> outcomeStatus;
  final Value<String> outcomeReasonCode;
  final Value<int> assessedStepCount;
  final Value<int> masteredStepCount;
  final Value<int> fragileStepCount;
  final Value<int> notMasteredStepCount;
  final Value<int> unassessedStepCount;
  final Value<int> canonicalCheckableStepCount;
  final Value<int> totalSubmissionCount;
  final Value<String> learningPolicyVersion;
  final Value<int> rowid;
  const LessonAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.courseId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.outcomeStatus = const Value.absent(),
    this.outcomeReasonCode = const Value.absent(),
    this.assessedStepCount = const Value.absent(),
    this.masteredStepCount = const Value.absent(),
    this.fragileStepCount = const Value.absent(),
    this.notMasteredStepCount = const Value.absent(),
    this.unassessedStepCount = const Value.absent(),
    this.canonicalCheckableStepCount = const Value.absent(),
    this.totalSubmissionCount = const Value.absent(),
    this.learningPolicyVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonAttemptsCompanion.insert({
    required String attemptId,
    required String lessonId,
    required String courseId,
    this.startedAt = const Value.absent(),
    required DateTime completedAt,
    required String outcomeStatus,
    required String outcomeReasonCode,
    required int assessedStepCount,
    required int masteredStepCount,
    required int fragileStepCount,
    required int notMasteredStepCount,
    required int unassessedStepCount,
    required int canonicalCheckableStepCount,
    required int totalSubmissionCount,
    required String learningPolicyVersion,
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       lessonId = Value(lessonId),
       courseId = Value(courseId),
       completedAt = Value(completedAt),
       outcomeStatus = Value(outcomeStatus),
       outcomeReasonCode = Value(outcomeReasonCode),
       assessedStepCount = Value(assessedStepCount),
       masteredStepCount = Value(masteredStepCount),
       fragileStepCount = Value(fragileStepCount),
       notMasteredStepCount = Value(notMasteredStepCount),
       unassessedStepCount = Value(unassessedStepCount),
       canonicalCheckableStepCount = Value(canonicalCheckableStepCount),
       totalSubmissionCount = Value(totalSubmissionCount),
       learningPolicyVersion = Value(learningPolicyVersion);
  static Insertable<LessonAttemptRow> custom({
    Expression<String>? attemptId,
    Expression<String>? lessonId,
    Expression<String>? courseId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? outcomeStatus,
    Expression<String>? outcomeReasonCode,
    Expression<int>? assessedStepCount,
    Expression<int>? masteredStepCount,
    Expression<int>? fragileStepCount,
    Expression<int>? notMasteredStepCount,
    Expression<int>? unassessedStepCount,
    Expression<int>? canonicalCheckableStepCount,
    Expression<int>? totalSubmissionCount,
    Expression<String>? learningPolicyVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (courseId != null) 'course_id': courseId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (outcomeStatus != null) 'outcome_status': outcomeStatus,
      if (outcomeReasonCode != null) 'outcome_reason_code': outcomeReasonCode,
      if (assessedStepCount != null) 'assessed_step_count': assessedStepCount,
      if (masteredStepCount != null) 'mastered_step_count': masteredStepCount,
      if (fragileStepCount != null) 'fragile_step_count': fragileStepCount,
      if (notMasteredStepCount != null)
        'not_mastered_step_count': notMasteredStepCount,
      if (unassessedStepCount != null)
        'unassessed_step_count': unassessedStepCount,
      if (canonicalCheckableStepCount != null)
        'canonical_checkable_step_count': canonicalCheckableStepCount,
      if (totalSubmissionCount != null)
        'total_submission_count': totalSubmissionCount,
      if (learningPolicyVersion != null)
        'learning_policy_version': learningPolicyVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonAttemptsCompanion copyWith({
    Value<String>? attemptId,
    Value<String>? lessonId,
    Value<String>? courseId,
    Value<DateTime?>? startedAt,
    Value<DateTime>? completedAt,
    Value<String>? outcomeStatus,
    Value<String>? outcomeReasonCode,
    Value<int>? assessedStepCount,
    Value<int>? masteredStepCount,
    Value<int>? fragileStepCount,
    Value<int>? notMasteredStepCount,
    Value<int>? unassessedStepCount,
    Value<int>? canonicalCheckableStepCount,
    Value<int>? totalSubmissionCount,
    Value<String>? learningPolicyVersion,
    Value<int>? rowid,
  }) {
    return LessonAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      lessonId: lessonId ?? this.lessonId,
      courseId: courseId ?? this.courseId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      outcomeStatus: outcomeStatus ?? this.outcomeStatus,
      outcomeReasonCode: outcomeReasonCode ?? this.outcomeReasonCode,
      assessedStepCount: assessedStepCount ?? this.assessedStepCount,
      masteredStepCount: masteredStepCount ?? this.masteredStepCount,
      fragileStepCount: fragileStepCount ?? this.fragileStepCount,
      notMasteredStepCount: notMasteredStepCount ?? this.notMasteredStepCount,
      unassessedStepCount: unassessedStepCount ?? this.unassessedStepCount,
      canonicalCheckableStepCount:
          canonicalCheckableStepCount ?? this.canonicalCheckableStepCount,
      totalSubmissionCount: totalSubmissionCount ?? this.totalSubmissionCount,
      learningPolicyVersion:
          learningPolicyVersion ?? this.learningPolicyVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (courseId.present) {
      map['course_id'] = Variable<String>(courseId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (outcomeStatus.present) {
      map['outcome_status'] = Variable<String>(outcomeStatus.value);
    }
    if (outcomeReasonCode.present) {
      map['outcome_reason_code'] = Variable<String>(outcomeReasonCode.value);
    }
    if (assessedStepCount.present) {
      map['assessed_step_count'] = Variable<int>(assessedStepCount.value);
    }
    if (masteredStepCount.present) {
      map['mastered_step_count'] = Variable<int>(masteredStepCount.value);
    }
    if (fragileStepCount.present) {
      map['fragile_step_count'] = Variable<int>(fragileStepCount.value);
    }
    if (notMasteredStepCount.present) {
      map['not_mastered_step_count'] = Variable<int>(
        notMasteredStepCount.value,
      );
    }
    if (unassessedStepCount.present) {
      map['unassessed_step_count'] = Variable<int>(unassessedStepCount.value);
    }
    if (canonicalCheckableStepCount.present) {
      map['canonical_checkable_step_count'] = Variable<int>(
        canonicalCheckableStepCount.value,
      );
    }
    if (totalSubmissionCount.present) {
      map['total_submission_count'] = Variable<int>(totalSubmissionCount.value);
    }
    if (learningPolicyVersion.present) {
      map['learning_policy_version'] = Variable<String>(
        learningPolicyVersion.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('lessonId: $lessonId, ')
          ..write('courseId: $courseId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('outcomeStatus: $outcomeStatus, ')
          ..write('outcomeReasonCode: $outcomeReasonCode, ')
          ..write('assessedStepCount: $assessedStepCount, ')
          ..write('masteredStepCount: $masteredStepCount, ')
          ..write('fragileStepCount: $fragileStepCount, ')
          ..write('notMasteredStepCount: $notMasteredStepCount, ')
          ..write('unassessedStepCount: $unassessedStepCount, ')
          ..write('canonicalCheckableStepCount: $canonicalCheckableStepCount, ')
          ..write('totalSubmissionCount: $totalSubmissionCount, ')
          ..write('learningPolicyVersion: $learningPolicyVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LessonAttemptStepResultsTable extends LessonAttemptStepResults
    with TableInfo<$LessonAttemptStepResultsTable, LessonAttemptStepResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonAttemptStepResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _attemptIdMeta = const VerificationMeta(
    'attemptId',
  );
  @override
  late final GeneratedColumn<String> attemptId = GeneratedColumn<String>(
    'attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lesson_attempts (attempt_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<String> lessonId = GeneratedColumn<String>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepIdMeta = const VerificationMeta('stepId');
  @override
  late final GeneratedColumn<String> stepId = GeneratedColumn<String>(
    'step_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryStatusMeta = const VerificationMeta(
    'masteryStatus',
  );
  @override
  late final GeneratedColumn<String> masteryStatus = GeneratedColumn<String>(
    'mastery_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _masteryReasonCodeMeta = const VerificationMeta(
    'masteryReasonCode',
  );
  @override
  late final GeneratedColumn<String> masteryReasonCode =
      GeneratedColumn<String>(
        'mastery_reason_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _attemptCountMeta = const VerificationMeta(
    'attemptCount',
  );
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
    'attempt_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successfulSubmissionCountMeta =
      const VerificationMeta('successfulSubmissionCount');
  @override
  late final GeneratedColumn<int> successfulSubmissionCount =
      GeneratedColumn<int>(
        'successful_submission_count',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _latestEvaluationOutcomeMeta =
      const VerificationMeta('latestEvaluationOutcome');
  @override
  late final GeneratedColumn<String> latestEvaluationOutcome =
      GeneratedColumn<String>(
        'latest_evaluation_outcome',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _remediationWasRequiredMeta =
      const VerificationMeta('remediationWasRequired');
  @override
  late final GeneratedColumn<bool> remediationWasRequired =
      GeneratedColumn<bool>(
        'remediation_was_required',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("remediation_was_required" IN (0, 1))',
        ),
      );
  static const VerificationMeta _reviewWasRequiredMeta = const VerificationMeta(
    'reviewWasRequired',
  );
  @override
  late final GeneratedColumn<bool> reviewWasRequired = GeneratedColumn<bool>(
    'review_was_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("review_was_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _confirmationSucceededMeta =
      const VerificationMeta('confirmationSucceeded');
  @override
  late final GeneratedColumn<bool> confirmationSucceeded =
      GeneratedColumn<bool>(
        'confirmation_succeeded',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("confirmation_succeeded" IN (0, 1))',
        ),
      );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    lessonId,
    stepId,
    masteryStatus,
    masteryReasonCode,
    attemptCount,
    successfulSubmissionCount,
    latestEvaluationOutcome,
    remediationWasRequired,
    reviewWasRequired,
    confirmationSucceeded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_attempt_step_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonAttemptStepResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('step_id')) {
      context.handle(
        _stepIdMeta,
        stepId.isAcceptableOrUnknown(data['step_id']!, _stepIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stepIdMeta);
    }
    if (data.containsKey('mastery_status')) {
      context.handle(
        _masteryStatusMeta,
        masteryStatus.isAcceptableOrUnknown(
          data['mastery_status']!,
          _masteryStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteryStatusMeta);
    }
    if (data.containsKey('mastery_reason_code')) {
      context.handle(
        _masteryReasonCodeMeta,
        masteryReasonCode.isAcceptableOrUnknown(
          data['mastery_reason_code']!,
          _masteryReasonCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_masteryReasonCodeMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
        _attemptCountMeta,
        attemptCount.isAcceptableOrUnknown(
          data['attempt_count']!,
          _attemptCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptCountMeta);
    }
    if (data.containsKey('successful_submission_count')) {
      context.handle(
        _successfulSubmissionCountMeta,
        successfulSubmissionCount.isAcceptableOrUnknown(
          data['successful_submission_count']!,
          _successfulSubmissionCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_successfulSubmissionCountMeta);
    }
    if (data.containsKey('latest_evaluation_outcome')) {
      context.handle(
        _latestEvaluationOutcomeMeta,
        latestEvaluationOutcome.isAcceptableOrUnknown(
          data['latest_evaluation_outcome']!,
          _latestEvaluationOutcomeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_latestEvaluationOutcomeMeta);
    }
    if (data.containsKey('remediation_was_required')) {
      context.handle(
        _remediationWasRequiredMeta,
        remediationWasRequired.isAcceptableOrUnknown(
          data['remediation_was_required']!,
          _remediationWasRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remediationWasRequiredMeta);
    }
    if (data.containsKey('review_was_required')) {
      context.handle(
        _reviewWasRequiredMeta,
        reviewWasRequired.isAcceptableOrUnknown(
          data['review_was_required']!,
          _reviewWasRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewWasRequiredMeta);
    }
    if (data.containsKey('confirmation_succeeded')) {
      context.handle(
        _confirmationSucceededMeta,
        confirmationSucceeded.isAcceptableOrUnknown(
          data['confirmation_succeeded']!,
          _confirmationSucceededMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_confirmationSucceededMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId, stepId};
  @override
  LessonAttemptStepResultRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonAttemptStepResultRow(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lesson_id'],
      )!,
      stepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_id'],
      )!,
      masteryStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mastery_status'],
      )!,
      masteryReasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mastery_reason_code'],
      )!,
      attemptCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_count'],
      )!,
      successfulSubmissionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}successful_submission_count'],
      )!,
      latestEvaluationOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latest_evaluation_outcome'],
      )!,
      remediationWasRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remediation_was_required'],
      )!,
      reviewWasRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}review_was_required'],
      )!,
      confirmationSucceeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmation_succeeded'],
      )!,
    );
  }

  @override
  $LessonAttemptStepResultsTable createAlias(String alias) {
    return $LessonAttemptStepResultsTable(attachedDatabase, alias);
  }
}

class LessonAttemptStepResultRow extends DataClass
    implements Insertable<LessonAttemptStepResultRow> {
  final String attemptId;
  final String lessonId;
  final String stepId;
  final String masteryStatus;
  final String masteryReasonCode;
  final int attemptCount;
  final int successfulSubmissionCount;
  final String latestEvaluationOutcome;
  final bool remediationWasRequired;
  final bool reviewWasRequired;
  final bool confirmationSucceeded;
  const LessonAttemptStepResultRow({
    required this.attemptId,
    required this.lessonId,
    required this.stepId,
    required this.masteryStatus,
    required this.masteryReasonCode,
    required this.attemptCount,
    required this.successfulSubmissionCount,
    required this.latestEvaluationOutcome,
    required this.remediationWasRequired,
    required this.reviewWasRequired,
    required this.confirmationSucceeded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    map['lesson_id'] = Variable<String>(lessonId);
    map['step_id'] = Variable<String>(stepId);
    map['mastery_status'] = Variable<String>(masteryStatus);
    map['mastery_reason_code'] = Variable<String>(masteryReasonCode);
    map['attempt_count'] = Variable<int>(attemptCount);
    map['successful_submission_count'] = Variable<int>(
      successfulSubmissionCount,
    );
    map['latest_evaluation_outcome'] = Variable<String>(
      latestEvaluationOutcome,
    );
    map['remediation_was_required'] = Variable<bool>(remediationWasRequired);
    map['review_was_required'] = Variable<bool>(reviewWasRequired);
    map['confirmation_succeeded'] = Variable<bool>(confirmationSucceeded);
    return map;
  }

  LessonAttemptStepResultsCompanion toCompanion(bool nullToAbsent) {
    return LessonAttemptStepResultsCompanion(
      attemptId: Value(attemptId),
      lessonId: Value(lessonId),
      stepId: Value(stepId),
      masteryStatus: Value(masteryStatus),
      masteryReasonCode: Value(masteryReasonCode),
      attemptCount: Value(attemptCount),
      successfulSubmissionCount: Value(successfulSubmissionCount),
      latestEvaluationOutcome: Value(latestEvaluationOutcome),
      remediationWasRequired: Value(remediationWasRequired),
      reviewWasRequired: Value(reviewWasRequired),
      confirmationSucceeded: Value(confirmationSucceeded),
    );
  }

  factory LessonAttemptStepResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonAttemptStepResultRow(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      lessonId: serializer.fromJson<String>(json['lessonId']),
      stepId: serializer.fromJson<String>(json['stepId']),
      masteryStatus: serializer.fromJson<String>(json['masteryStatus']),
      masteryReasonCode: serializer.fromJson<String>(json['masteryReasonCode']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      successfulSubmissionCount: serializer.fromJson<int>(
        json['successfulSubmissionCount'],
      ),
      latestEvaluationOutcome: serializer.fromJson<String>(
        json['latestEvaluationOutcome'],
      ),
      remediationWasRequired: serializer.fromJson<bool>(
        json['remediationWasRequired'],
      ),
      reviewWasRequired: serializer.fromJson<bool>(json['reviewWasRequired']),
      confirmationSucceeded: serializer.fromJson<bool>(
        json['confirmationSucceeded'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'lessonId': serializer.toJson<String>(lessonId),
      'stepId': serializer.toJson<String>(stepId),
      'masteryStatus': serializer.toJson<String>(masteryStatus),
      'masteryReasonCode': serializer.toJson<String>(masteryReasonCode),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'successfulSubmissionCount': serializer.toJson<int>(
        successfulSubmissionCount,
      ),
      'latestEvaluationOutcome': serializer.toJson<String>(
        latestEvaluationOutcome,
      ),
      'remediationWasRequired': serializer.toJson<bool>(remediationWasRequired),
      'reviewWasRequired': serializer.toJson<bool>(reviewWasRequired),
      'confirmationSucceeded': serializer.toJson<bool>(confirmationSucceeded),
    };
  }

  LessonAttemptStepResultRow copyWith({
    String? attemptId,
    String? lessonId,
    String? stepId,
    String? masteryStatus,
    String? masteryReasonCode,
    int? attemptCount,
    int? successfulSubmissionCount,
    String? latestEvaluationOutcome,
    bool? remediationWasRequired,
    bool? reviewWasRequired,
    bool? confirmationSucceeded,
  }) => LessonAttemptStepResultRow(
    attemptId: attemptId ?? this.attemptId,
    lessonId: lessonId ?? this.lessonId,
    stepId: stepId ?? this.stepId,
    masteryStatus: masteryStatus ?? this.masteryStatus,
    masteryReasonCode: masteryReasonCode ?? this.masteryReasonCode,
    attemptCount: attemptCount ?? this.attemptCount,
    successfulSubmissionCount:
        successfulSubmissionCount ?? this.successfulSubmissionCount,
    latestEvaluationOutcome:
        latestEvaluationOutcome ?? this.latestEvaluationOutcome,
    remediationWasRequired:
        remediationWasRequired ?? this.remediationWasRequired,
    reviewWasRequired: reviewWasRequired ?? this.reviewWasRequired,
    confirmationSucceeded: confirmationSucceeded ?? this.confirmationSucceeded,
  );
  LessonAttemptStepResultRow copyWithCompanion(
    LessonAttemptStepResultsCompanion data,
  ) {
    return LessonAttemptStepResultRow(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      stepId: data.stepId.present ? data.stepId.value : this.stepId,
      masteryStatus: data.masteryStatus.present
          ? data.masteryStatus.value
          : this.masteryStatus,
      masteryReasonCode: data.masteryReasonCode.present
          ? data.masteryReasonCode.value
          : this.masteryReasonCode,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      successfulSubmissionCount: data.successfulSubmissionCount.present
          ? data.successfulSubmissionCount.value
          : this.successfulSubmissionCount,
      latestEvaluationOutcome: data.latestEvaluationOutcome.present
          ? data.latestEvaluationOutcome.value
          : this.latestEvaluationOutcome,
      remediationWasRequired: data.remediationWasRequired.present
          ? data.remediationWasRequired.value
          : this.remediationWasRequired,
      reviewWasRequired: data.reviewWasRequired.present
          ? data.reviewWasRequired.value
          : this.reviewWasRequired,
      confirmationSucceeded: data.confirmationSucceeded.present
          ? data.confirmationSucceeded.value
          : this.confirmationSucceeded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttemptStepResultRow(')
          ..write('attemptId: $attemptId, ')
          ..write('lessonId: $lessonId, ')
          ..write('stepId: $stepId, ')
          ..write('masteryStatus: $masteryStatus, ')
          ..write('masteryReasonCode: $masteryReasonCode, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('successfulSubmissionCount: $successfulSubmissionCount, ')
          ..write('latestEvaluationOutcome: $latestEvaluationOutcome, ')
          ..write('remediationWasRequired: $remediationWasRequired, ')
          ..write('reviewWasRequired: $reviewWasRequired, ')
          ..write('confirmationSucceeded: $confirmationSucceeded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    lessonId,
    stepId,
    masteryStatus,
    masteryReasonCode,
    attemptCount,
    successfulSubmissionCount,
    latestEvaluationOutcome,
    remediationWasRequired,
    reviewWasRequired,
    confirmationSucceeded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonAttemptStepResultRow &&
          other.attemptId == this.attemptId &&
          other.lessonId == this.lessonId &&
          other.stepId == this.stepId &&
          other.masteryStatus == this.masteryStatus &&
          other.masteryReasonCode == this.masteryReasonCode &&
          other.attemptCount == this.attemptCount &&
          other.successfulSubmissionCount == this.successfulSubmissionCount &&
          other.latestEvaluationOutcome == this.latestEvaluationOutcome &&
          other.remediationWasRequired == this.remediationWasRequired &&
          other.reviewWasRequired == this.reviewWasRequired &&
          other.confirmationSucceeded == this.confirmationSucceeded);
}

class LessonAttemptStepResultsCompanion
    extends UpdateCompanion<LessonAttemptStepResultRow> {
  final Value<String> attemptId;
  final Value<String> lessonId;
  final Value<String> stepId;
  final Value<String> masteryStatus;
  final Value<String> masteryReasonCode;
  final Value<int> attemptCount;
  final Value<int> successfulSubmissionCount;
  final Value<String> latestEvaluationOutcome;
  final Value<bool> remediationWasRequired;
  final Value<bool> reviewWasRequired;
  final Value<bool> confirmationSucceeded;
  final Value<int> rowid;
  const LessonAttemptStepResultsCompanion({
    this.attemptId = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.stepId = const Value.absent(),
    this.masteryStatus = const Value.absent(),
    this.masteryReasonCode = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.successfulSubmissionCount = const Value.absent(),
    this.latestEvaluationOutcome = const Value.absent(),
    this.remediationWasRequired = const Value.absent(),
    this.reviewWasRequired = const Value.absent(),
    this.confirmationSucceeded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LessonAttemptStepResultsCompanion.insert({
    required String attemptId,
    required String lessonId,
    required String stepId,
    required String masteryStatus,
    required String masteryReasonCode,
    required int attemptCount,
    required int successfulSubmissionCount,
    required String latestEvaluationOutcome,
    required bool remediationWasRequired,
    required bool reviewWasRequired,
    required bool confirmationSucceeded,
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       lessonId = Value(lessonId),
       stepId = Value(stepId),
       masteryStatus = Value(masteryStatus),
       masteryReasonCode = Value(masteryReasonCode),
       attemptCount = Value(attemptCount),
       successfulSubmissionCount = Value(successfulSubmissionCount),
       latestEvaluationOutcome = Value(latestEvaluationOutcome),
       remediationWasRequired = Value(remediationWasRequired),
       reviewWasRequired = Value(reviewWasRequired),
       confirmationSucceeded = Value(confirmationSucceeded);
  static Insertable<LessonAttemptStepResultRow> custom({
    Expression<String>? attemptId,
    Expression<String>? lessonId,
    Expression<String>? stepId,
    Expression<String>? masteryStatus,
    Expression<String>? masteryReasonCode,
    Expression<int>? attemptCount,
    Expression<int>? successfulSubmissionCount,
    Expression<String>? latestEvaluationOutcome,
    Expression<bool>? remediationWasRequired,
    Expression<bool>? reviewWasRequired,
    Expression<bool>? confirmationSucceeded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (lessonId != null) 'lesson_id': lessonId,
      if (stepId != null) 'step_id': stepId,
      if (masteryStatus != null) 'mastery_status': masteryStatus,
      if (masteryReasonCode != null) 'mastery_reason_code': masteryReasonCode,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (successfulSubmissionCount != null)
        'successful_submission_count': successfulSubmissionCount,
      if (latestEvaluationOutcome != null)
        'latest_evaluation_outcome': latestEvaluationOutcome,
      if (remediationWasRequired != null)
        'remediation_was_required': remediationWasRequired,
      if (reviewWasRequired != null) 'review_was_required': reviewWasRequired,
      if (confirmationSucceeded != null)
        'confirmation_succeeded': confirmationSucceeded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LessonAttemptStepResultsCompanion copyWith({
    Value<String>? attemptId,
    Value<String>? lessonId,
    Value<String>? stepId,
    Value<String>? masteryStatus,
    Value<String>? masteryReasonCode,
    Value<int>? attemptCount,
    Value<int>? successfulSubmissionCount,
    Value<String>? latestEvaluationOutcome,
    Value<bool>? remediationWasRequired,
    Value<bool>? reviewWasRequired,
    Value<bool>? confirmationSucceeded,
    Value<int>? rowid,
  }) {
    return LessonAttemptStepResultsCompanion(
      attemptId: attemptId ?? this.attemptId,
      lessonId: lessonId ?? this.lessonId,
      stepId: stepId ?? this.stepId,
      masteryStatus: masteryStatus ?? this.masteryStatus,
      masteryReasonCode: masteryReasonCode ?? this.masteryReasonCode,
      attemptCount: attemptCount ?? this.attemptCount,
      successfulSubmissionCount:
          successfulSubmissionCount ?? this.successfulSubmissionCount,
      latestEvaluationOutcome:
          latestEvaluationOutcome ?? this.latestEvaluationOutcome,
      remediationWasRequired:
          remediationWasRequired ?? this.remediationWasRequired,
      reviewWasRequired: reviewWasRequired ?? this.reviewWasRequired,
      confirmationSucceeded:
          confirmationSucceeded ?? this.confirmationSucceeded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<String>(lessonId.value);
    }
    if (stepId.present) {
      map['step_id'] = Variable<String>(stepId.value);
    }
    if (masteryStatus.present) {
      map['mastery_status'] = Variable<String>(masteryStatus.value);
    }
    if (masteryReasonCode.present) {
      map['mastery_reason_code'] = Variable<String>(masteryReasonCode.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (successfulSubmissionCount.present) {
      map['successful_submission_count'] = Variable<int>(
        successfulSubmissionCount.value,
      );
    }
    if (latestEvaluationOutcome.present) {
      map['latest_evaluation_outcome'] = Variable<String>(
        latestEvaluationOutcome.value,
      );
    }
    if (remediationWasRequired.present) {
      map['remediation_was_required'] = Variable<bool>(
        remediationWasRequired.value,
      );
    }
    if (reviewWasRequired.present) {
      map['review_was_required'] = Variable<bool>(reviewWasRequired.value);
    }
    if (confirmationSucceeded.present) {
      map['confirmation_succeeded'] = Variable<bool>(
        confirmationSucceeded.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonAttemptStepResultsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('lessonId: $lessonId, ')
          ..write('stepId: $stepId, ')
          ..write('masteryStatus: $masteryStatus, ')
          ..write('masteryReasonCode: $masteryReasonCode, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('successfulSubmissionCount: $successfulSubmissionCount, ')
          ..write('latestEvaluationOutcome: $latestEvaluationOutcome, ')
          ..write('remediationWasRequired: $remediationWasRequired, ')
          ..write('reviewWasRequired: $reviewWasRequired, ')
          ..write('confirmationSucceeded: $confirmationSucceeded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LearnerStatesTable learnerStates = $LearnerStatesTable(this);
  late final $LearnerProgressEventsTable learnerProgressEvents =
      $LearnerProgressEventsTable(this);
  late final $LessonAttemptsTable lessonAttempts = $LessonAttemptsTable(this);
  late final $LessonAttemptStepResultsTable lessonAttemptStepResults =
      $LessonAttemptStepResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    learnerStates,
    learnerProgressEvents,
    lessonAttempts,
    lessonAttemptStepResults,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lesson_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('lesson_attempt_step_results', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$LearnerStatesTableCreateCompanionBuilder =
    LearnerStatesCompanion Function({
      required String id,
      required String selectedLanguage,
      required String currentCourseId,
      required String currentTopicId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LearnerStatesTableUpdateCompanionBuilder =
    LearnerStatesCompanion Function({
      Value<String> id,
      Value<String> selectedLanguage,
      Value<String> currentCourseId,
      Value<String> currentTopicId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LearnerStatesTableFilterComposer
    extends Composer<_$AppDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedLanguage => $composableBuilder(
    column: $table.selectedLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentCourseId => $composableBuilder(
    column: $table.currentCourseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currentTopicId => $composableBuilder(
    column: $table.currentTopicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearnerStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedLanguage => $composableBuilder(
    column: $table.selectedLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentCourseId => $composableBuilder(
    column: $table.currentCourseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currentTopicId => $composableBuilder(
    column: $table.currentTopicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearnerStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnerStatesTable> {
  $$LearnerStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get selectedLanguage => $composableBuilder(
    column: $table.selectedLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentCourseId => $composableBuilder(
    column: $table.currentCourseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currentTopicId => $composableBuilder(
    column: $table.currentTopicId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LearnerStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnerStatesTable,
          LearnerStateRow,
          $$LearnerStatesTableFilterComposer,
          $$LearnerStatesTableOrderingComposer,
          $$LearnerStatesTableAnnotationComposer,
          $$LearnerStatesTableCreateCompanionBuilder,
          $$LearnerStatesTableUpdateCompanionBuilder,
          (
            LearnerStateRow,
            BaseReferences<_$AppDatabase, $LearnerStatesTable, LearnerStateRow>,
          ),
          LearnerStateRow,
          PrefetchHooks Function()
        > {
  $$LearnerStatesTableTableManager(_$AppDatabase db, $LearnerStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnerStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearnerStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearnerStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> selectedLanguage = const Value.absent(),
                Value<String> currentCourseId = const Value.absent(),
                Value<String> currentTopicId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion(
                id: id,
                selectedLanguage: selectedLanguage,
                currentCourseId: currentCourseId,
                currentTopicId: currentTopicId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String selectedLanguage,
                required String currentCourseId,
                required String currentTopicId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion.insert(
                id: id,
                selectedLanguage: selectedLanguage,
                currentCourseId: currentCourseId,
                currentTopicId: currentTopicId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearnerStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnerStatesTable,
      LearnerStateRow,
      $$LearnerStatesTableFilterComposer,
      $$LearnerStatesTableOrderingComposer,
      $$LearnerStatesTableAnnotationComposer,
      $$LearnerStatesTableCreateCompanionBuilder,
      $$LearnerStatesTableUpdateCompanionBuilder,
      (
        LearnerStateRow,
        BaseReferences<_$AppDatabase, $LearnerStatesTable, LearnerStateRow>,
      ),
      LearnerStateRow,
      PrefetchHooks Function()
    >;
typedef $$LearnerProgressEventsTableCreateCompanionBuilder =
    LearnerProgressEventsCompanion Function({
      required String id,
      required String eventType,
      required String topicId,
      Value<String?> sectionId,
      Value<String?> contentReference,
      required DateTime createdAt,
      Value<String?> metadataJson,
      Value<int> rowid,
    });
typedef $$LearnerProgressEventsTableUpdateCompanionBuilder =
    LearnerProgressEventsCompanion Function({
      Value<String> id,
      Value<String> eventType,
      Value<String> topicId,
      Value<String?> sectionId,
      Value<String?> contentReference,
      Value<DateTime> createdAt,
      Value<String?> metadataJson,
      Value<int> rowid,
    });

class $$LearnerProgressEventsTableFilterComposer
    extends Composer<_$AppDatabase, $LearnerProgressEventsTable> {
  $$LearnerProgressEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentReference => $composableBuilder(
    column: $table.contentReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearnerProgressEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $LearnerProgressEventsTable> {
  $$LearnerProgressEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicId => $composableBuilder(
    column: $table.topicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentReference => $composableBuilder(
    column: $table.contentReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearnerProgressEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearnerProgressEventsTable> {
  $$LearnerProgressEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get topicId =>
      $composableBuilder(column: $table.topicId, builder: (column) => column);

  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get contentReference => $composableBuilder(
    column: $table.contentReference,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );
}

class $$LearnerProgressEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearnerProgressEventsTable,
          LearnerProgressEventRow,
          $$LearnerProgressEventsTableFilterComposer,
          $$LearnerProgressEventsTableOrderingComposer,
          $$LearnerProgressEventsTableAnnotationComposer,
          $$LearnerProgressEventsTableCreateCompanionBuilder,
          $$LearnerProgressEventsTableUpdateCompanionBuilder,
          (
            LearnerProgressEventRow,
            BaseReferences<
              _$AppDatabase,
              $LearnerProgressEventsTable,
              LearnerProgressEventRow
            >,
          ),
          LearnerProgressEventRow,
          PrefetchHooks Function()
        > {
  $$LearnerProgressEventsTableTableManager(
    _$AppDatabase db,
    $LearnerProgressEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearnerProgressEventsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LearnerProgressEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LearnerProgressEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> topicId = const Value.absent(),
                Value<String?> sectionId = const Value.absent(),
                Value<String?> contentReference = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerProgressEventsCompanion(
                id: id,
                eventType: eventType,
                topicId: topicId,
                sectionId: sectionId,
                contentReference: contentReference,
                createdAt: createdAt,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String eventType,
                required String topicId,
                Value<String?> sectionId = const Value.absent(),
                Value<String?> contentReference = const Value.absent(),
                required DateTime createdAt,
                Value<String?> metadataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerProgressEventsCompanion.insert(
                id: id,
                eventType: eventType,
                topicId: topicId,
                sectionId: sectionId,
                contentReference: contentReference,
                createdAt: createdAt,
                metadataJson: metadataJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearnerProgressEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearnerProgressEventsTable,
      LearnerProgressEventRow,
      $$LearnerProgressEventsTableFilterComposer,
      $$LearnerProgressEventsTableOrderingComposer,
      $$LearnerProgressEventsTableAnnotationComposer,
      $$LearnerProgressEventsTableCreateCompanionBuilder,
      $$LearnerProgressEventsTableUpdateCompanionBuilder,
      (
        LearnerProgressEventRow,
        BaseReferences<
          _$AppDatabase,
          $LearnerProgressEventsTable,
          LearnerProgressEventRow
        >,
      ),
      LearnerProgressEventRow,
      PrefetchHooks Function()
    >;
typedef $$LessonAttemptsTableCreateCompanionBuilder =
    LessonAttemptsCompanion Function({
      required String attemptId,
      required String lessonId,
      required String courseId,
      Value<DateTime?> startedAt,
      required DateTime completedAt,
      required String outcomeStatus,
      required String outcomeReasonCode,
      required int assessedStepCount,
      required int masteredStepCount,
      required int fragileStepCount,
      required int notMasteredStepCount,
      required int unassessedStepCount,
      required int canonicalCheckableStepCount,
      required int totalSubmissionCount,
      required String learningPolicyVersion,
      Value<int> rowid,
    });
typedef $$LessonAttemptsTableUpdateCompanionBuilder =
    LessonAttemptsCompanion Function({
      Value<String> attemptId,
      Value<String> lessonId,
      Value<String> courseId,
      Value<DateTime?> startedAt,
      Value<DateTime> completedAt,
      Value<String> outcomeStatus,
      Value<String> outcomeReasonCode,
      Value<int> assessedStepCount,
      Value<int> masteredStepCount,
      Value<int> fragileStepCount,
      Value<int> notMasteredStepCount,
      Value<int> unassessedStepCount,
      Value<int> canonicalCheckableStepCount,
      Value<int> totalSubmissionCount,
      Value<String> learningPolicyVersion,
      Value<int> rowid,
    });

final class $$LessonAttemptsTableReferences
    extends
        BaseReferences<_$AppDatabase, $LessonAttemptsTable, LessonAttemptRow> {
  $$LessonAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $LessonAttemptStepResultsTable,
    List<LessonAttemptStepResultRow>
  >
  _lessonAttemptStepResultsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.lessonAttemptStepResults,
    aliasName:
        'lesson_attempts__attempt_id__lesson_attempt_step_results__attempt_id',
  );

  $$LessonAttemptStepResultsTableProcessedTableManager
  get lessonAttemptStepResultsRefs {
    final manager =
        $$LessonAttemptStepResultsTableTableManager(
          $_db,
          $_db.lessonAttemptStepResults,
        ).filter(
          (f) => f.attemptId.attemptId.sqlEquals(
            $_itemColumn<String>('attempt_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _lessonAttemptStepResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LessonAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonAttemptsTable> {
  $$LessonAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcomeStatus => $composableBuilder(
    column: $table.outcomeStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcomeReasonCode => $composableBuilder(
    column: $table.outcomeReasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assessedStepCount => $composableBuilder(
    column: $table.assessedStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get masteredStepCount => $composableBuilder(
    column: $table.masteredStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fragileStepCount => $composableBuilder(
    column: $table.fragileStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notMasteredStepCount => $composableBuilder(
    column: $table.notMasteredStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unassessedStepCount => $composableBuilder(
    column: $table.unassessedStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get canonicalCheckableStepCount => $composableBuilder(
    column: $table.canonicalCheckableStepCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSubmissionCount => $composableBuilder(
    column: $table.totalSubmissionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningPolicyVersion => $composableBuilder(
    column: $table.learningPolicyVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> lessonAttemptStepResultsRefs(
    Expression<bool> Function($$LessonAttemptStepResultsTableFilterComposer f)
    f,
  ) {
    final $$LessonAttemptStepResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.lessonAttemptStepResults,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LessonAttemptStepResultsTableFilterComposer(
                $db: $db,
                $table: $db.lessonAttemptStepResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LessonAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonAttemptsTable> {
  $$LessonAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get attemptId => $composableBuilder(
    column: $table.attemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courseId => $composableBuilder(
    column: $table.courseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcomeStatus => $composableBuilder(
    column: $table.outcomeStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcomeReasonCode => $composableBuilder(
    column: $table.outcomeReasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assessedStepCount => $composableBuilder(
    column: $table.assessedStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get masteredStepCount => $composableBuilder(
    column: $table.masteredStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fragileStepCount => $composableBuilder(
    column: $table.fragileStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notMasteredStepCount => $composableBuilder(
    column: $table.notMasteredStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unassessedStepCount => $composableBuilder(
    column: $table.unassessedStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get canonicalCheckableStepCount => $composableBuilder(
    column: $table.canonicalCheckableStepCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSubmissionCount => $composableBuilder(
    column: $table.totalSubmissionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningPolicyVersion => $composableBuilder(
    column: $table.learningPolicyVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonAttemptsTable> {
  $$LessonAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get courseId =>
      $composableBuilder(column: $table.courseId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcomeStatus => $composableBuilder(
    column: $table.outcomeStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get outcomeReasonCode => $composableBuilder(
    column: $table.outcomeReasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assessedStepCount => $composableBuilder(
    column: $table.assessedStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get masteredStepCount => $composableBuilder(
    column: $table.masteredStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fragileStepCount => $composableBuilder(
    column: $table.fragileStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notMasteredStepCount => $composableBuilder(
    column: $table.notMasteredStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unassessedStepCount => $composableBuilder(
    column: $table.unassessedStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get canonicalCheckableStepCount => $composableBuilder(
    column: $table.canonicalCheckableStepCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalSubmissionCount => $composableBuilder(
    column: $table.totalSubmissionCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningPolicyVersion => $composableBuilder(
    column: $table.learningPolicyVersion,
    builder: (column) => column,
  );

  Expression<T> lessonAttemptStepResultsRefs<T extends Object>(
    Expression<T> Function($$LessonAttemptStepResultsTableAnnotationComposer a)
    f,
  ) {
    final $$LessonAttemptStepResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.lessonAttemptStepResults,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$LessonAttemptStepResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.lessonAttemptStepResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$LessonAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonAttemptsTable,
          LessonAttemptRow,
          $$LessonAttemptsTableFilterComposer,
          $$LessonAttemptsTableOrderingComposer,
          $$LessonAttemptsTableAnnotationComposer,
          $$LessonAttemptsTableCreateCompanionBuilder,
          $$LessonAttemptsTableUpdateCompanionBuilder,
          (LessonAttemptRow, $$LessonAttemptsTableReferences),
          LessonAttemptRow,
          PrefetchHooks Function({bool lessonAttemptStepResultsRefs})
        > {
  $$LessonAttemptsTableTableManager(
    _$AppDatabase db,
    $LessonAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> courseId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<String> outcomeStatus = const Value.absent(),
                Value<String> outcomeReasonCode = const Value.absent(),
                Value<int> assessedStepCount = const Value.absent(),
                Value<int> masteredStepCount = const Value.absent(),
                Value<int> fragileStepCount = const Value.absent(),
                Value<int> notMasteredStepCount = const Value.absent(),
                Value<int> unassessedStepCount = const Value.absent(),
                Value<int> canonicalCheckableStepCount = const Value.absent(),
                Value<int> totalSubmissionCount = const Value.absent(),
                Value<String> learningPolicyVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonAttemptsCompanion(
                attemptId: attemptId,
                lessonId: lessonId,
                courseId: courseId,
                startedAt: startedAt,
                completedAt: completedAt,
                outcomeStatus: outcomeStatus,
                outcomeReasonCode: outcomeReasonCode,
                assessedStepCount: assessedStepCount,
                masteredStepCount: masteredStepCount,
                fragileStepCount: fragileStepCount,
                notMasteredStepCount: notMasteredStepCount,
                unassessedStepCount: unassessedStepCount,
                canonicalCheckableStepCount: canonicalCheckableStepCount,
                totalSubmissionCount: totalSubmissionCount,
                learningPolicyVersion: learningPolicyVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                required String lessonId,
                required String courseId,
                Value<DateTime?> startedAt = const Value.absent(),
                required DateTime completedAt,
                required String outcomeStatus,
                required String outcomeReasonCode,
                required int assessedStepCount,
                required int masteredStepCount,
                required int fragileStepCount,
                required int notMasteredStepCount,
                required int unassessedStepCount,
                required int canonicalCheckableStepCount,
                required int totalSubmissionCount,
                required String learningPolicyVersion,
                Value<int> rowid = const Value.absent(),
              }) => LessonAttemptsCompanion.insert(
                attemptId: attemptId,
                lessonId: lessonId,
                courseId: courseId,
                startedAt: startedAt,
                completedAt: completedAt,
                outcomeStatus: outcomeStatus,
                outcomeReasonCode: outcomeReasonCode,
                assessedStepCount: assessedStepCount,
                masteredStepCount: masteredStepCount,
                fragileStepCount: fragileStepCount,
                notMasteredStepCount: notMasteredStepCount,
                unassessedStepCount: unassessedStepCount,
                canonicalCheckableStepCount: canonicalCheckableStepCount,
                totalSubmissionCount: totalSubmissionCount,
                learningPolicyVersion: learningPolicyVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lessonAttemptStepResultsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (lessonAttemptStepResultsRefs) db.lessonAttemptStepResults,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (lessonAttemptStepResultsRefs)
                    await $_getPrefetchedData<
                      LessonAttemptRow,
                      $LessonAttemptsTable,
                      LessonAttemptStepResultRow
                    >(
                      currentTable: table,
                      referencedTable: $$LessonAttemptsTableReferences
                          ._lessonAttemptStepResultsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LessonAttemptsTableReferences(
                            db,
                            table,
                            p0,
                          ).lessonAttemptStepResultsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.attemptId == item.attemptId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LessonAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonAttemptsTable,
      LessonAttemptRow,
      $$LessonAttemptsTableFilterComposer,
      $$LessonAttemptsTableOrderingComposer,
      $$LessonAttemptsTableAnnotationComposer,
      $$LessonAttemptsTableCreateCompanionBuilder,
      $$LessonAttemptsTableUpdateCompanionBuilder,
      (LessonAttemptRow, $$LessonAttemptsTableReferences),
      LessonAttemptRow,
      PrefetchHooks Function({bool lessonAttemptStepResultsRefs})
    >;
typedef $$LessonAttemptStepResultsTableCreateCompanionBuilder =
    LessonAttemptStepResultsCompanion Function({
      required String attemptId,
      required String lessonId,
      required String stepId,
      required String masteryStatus,
      required String masteryReasonCode,
      required int attemptCount,
      required int successfulSubmissionCount,
      required String latestEvaluationOutcome,
      required bool remediationWasRequired,
      required bool reviewWasRequired,
      required bool confirmationSucceeded,
      Value<int> rowid,
    });
typedef $$LessonAttemptStepResultsTableUpdateCompanionBuilder =
    LessonAttemptStepResultsCompanion Function({
      Value<String> attemptId,
      Value<String> lessonId,
      Value<String> stepId,
      Value<String> masteryStatus,
      Value<String> masteryReasonCode,
      Value<int> attemptCount,
      Value<int> successfulSubmissionCount,
      Value<String> latestEvaluationOutcome,
      Value<bool> remediationWasRequired,
      Value<bool> reviewWasRequired,
      Value<bool> confirmationSucceeded,
      Value<int> rowid,
    });

final class $$LessonAttemptStepResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $LessonAttemptStepResultsTable,
          LessonAttemptStepResultRow
        > {
  $$LessonAttemptStepResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LessonAttemptsTable _attemptIdTable(_$AppDatabase db) =>
      db.lessonAttempts.createAlias(
        'lesson_attempt_step_results__attempt_id__lesson_attempts__attempt_id',
      );

  $$LessonAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$LessonAttemptsTableTableManager(
      $_db,
      $_db.lessonAttempts,
    ).filter((f) => f.attemptId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LessonAttemptStepResultsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonAttemptStepResultsTable> {
  $$LessonAttemptStepResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepId => $composableBuilder(
    column: $table.stepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masteryStatus => $composableBuilder(
    column: $table.masteryStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masteryReasonCode => $composableBuilder(
    column: $table.masteryReasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get successfulSubmissionCount => $composableBuilder(
    column: $table.successfulSubmissionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latestEvaluationOutcome => $composableBuilder(
    column: $table.latestEvaluationOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remediationWasRequired => $composableBuilder(
    column: $table.remediationWasRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reviewWasRequired => $composableBuilder(
    column: $table.reviewWasRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmationSucceeded => $composableBuilder(
    column: $table.confirmationSucceeded,
    builder: (column) => ColumnFilters(column),
  );

  $$LessonAttemptsTableFilterComposer get attemptId {
    final $$LessonAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.lessonAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.lessonAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonAttemptStepResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonAttemptStepResultsTable> {
  $$LessonAttemptStepResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepId => $composableBuilder(
    column: $table.stepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masteryStatus => $composableBuilder(
    column: $table.masteryStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masteryReasonCode => $composableBuilder(
    column: $table.masteryReasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get successfulSubmissionCount => $composableBuilder(
    column: $table.successfulSubmissionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latestEvaluationOutcome => $composableBuilder(
    column: $table.latestEvaluationOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remediationWasRequired => $composableBuilder(
    column: $table.remediationWasRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reviewWasRequired => $composableBuilder(
    column: $table.reviewWasRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmationSucceeded => $composableBuilder(
    column: $table.confirmationSucceeded,
    builder: (column) => ColumnOrderings(column),
  );

  $$LessonAttemptsTableOrderingComposer get attemptId {
    final $$LessonAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.lessonAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.lessonAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonAttemptStepResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonAttemptStepResultsTable> {
  $$LessonAttemptStepResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get stepId =>
      $composableBuilder(column: $table.stepId, builder: (column) => column);

  GeneratedColumn<String> get masteryStatus => $composableBuilder(
    column: $table.masteryStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masteryReasonCode => $composableBuilder(
    column: $table.masteryReasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptCount => $composableBuilder(
    column: $table.attemptCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get successfulSubmissionCount => $composableBuilder(
    column: $table.successfulSubmissionCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get latestEvaluationOutcome => $composableBuilder(
    column: $table.latestEvaluationOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remediationWasRequired => $composableBuilder(
    column: $table.remediationWasRequired,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reviewWasRequired => $composableBuilder(
    column: $table.reviewWasRequired,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confirmationSucceeded => $composableBuilder(
    column: $table.confirmationSucceeded,
    builder: (column) => column,
  );

  $$LessonAttemptsTableAnnotationComposer get attemptId {
    final $$LessonAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.lessonAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LessonAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.lessonAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LessonAttemptStepResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonAttemptStepResultsTable,
          LessonAttemptStepResultRow,
          $$LessonAttemptStepResultsTableFilterComposer,
          $$LessonAttemptStepResultsTableOrderingComposer,
          $$LessonAttemptStepResultsTableAnnotationComposer,
          $$LessonAttemptStepResultsTableCreateCompanionBuilder,
          $$LessonAttemptStepResultsTableUpdateCompanionBuilder,
          (
            LessonAttemptStepResultRow,
            $$LessonAttemptStepResultsTableReferences,
          ),
          LessonAttemptStepResultRow,
          PrefetchHooks Function({bool attemptId})
        > {
  $$LessonAttemptStepResultsTableTableManager(
    _$AppDatabase db,
    $LessonAttemptStepResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonAttemptStepResultsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LessonAttemptStepResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LessonAttemptStepResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String> lessonId = const Value.absent(),
                Value<String> stepId = const Value.absent(),
                Value<String> masteryStatus = const Value.absent(),
                Value<String> masteryReasonCode = const Value.absent(),
                Value<int> attemptCount = const Value.absent(),
                Value<int> successfulSubmissionCount = const Value.absent(),
                Value<String> latestEvaluationOutcome = const Value.absent(),
                Value<bool> remediationWasRequired = const Value.absent(),
                Value<bool> reviewWasRequired = const Value.absent(),
                Value<bool> confirmationSucceeded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LessonAttemptStepResultsCompanion(
                attemptId: attemptId,
                lessonId: lessonId,
                stepId: stepId,
                masteryStatus: masteryStatus,
                masteryReasonCode: masteryReasonCode,
                attemptCount: attemptCount,
                successfulSubmissionCount: successfulSubmissionCount,
                latestEvaluationOutcome: latestEvaluationOutcome,
                remediationWasRequired: remediationWasRequired,
                reviewWasRequired: reviewWasRequired,
                confirmationSucceeded: confirmationSucceeded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                required String lessonId,
                required String stepId,
                required String masteryStatus,
                required String masteryReasonCode,
                required int attemptCount,
                required int successfulSubmissionCount,
                required String latestEvaluationOutcome,
                required bool remediationWasRequired,
                required bool reviewWasRequired,
                required bool confirmationSucceeded,
                Value<int> rowid = const Value.absent(),
              }) => LessonAttemptStepResultsCompanion.insert(
                attemptId: attemptId,
                lessonId: lessonId,
                stepId: stepId,
                masteryStatus: masteryStatus,
                masteryReasonCode: masteryReasonCode,
                attemptCount: attemptCount,
                successfulSubmissionCount: successfulSubmissionCount,
                latestEvaluationOutcome: latestEvaluationOutcome,
                remediationWasRequired: remediationWasRequired,
                reviewWasRequired: reviewWasRequired,
                confirmationSucceeded: confirmationSucceeded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LessonAttemptStepResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attemptId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (attemptId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.attemptId,
                                referencedTable:
                                    $$LessonAttemptStepResultsTableReferences
                                        ._attemptIdTable(db),
                                referencedColumn:
                                    $$LessonAttemptStepResultsTableReferences
                                        ._attemptIdTable(db)
                                        .attemptId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LessonAttemptStepResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonAttemptStepResultsTable,
      LessonAttemptStepResultRow,
      $$LessonAttemptStepResultsTableFilterComposer,
      $$LessonAttemptStepResultsTableOrderingComposer,
      $$LessonAttemptStepResultsTableAnnotationComposer,
      $$LessonAttemptStepResultsTableCreateCompanionBuilder,
      $$LessonAttemptStepResultsTableUpdateCompanionBuilder,
      (LessonAttemptStepResultRow, $$LessonAttemptStepResultsTableReferences),
      LessonAttemptStepResultRow,
      PrefetchHooks Function({bool attemptId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LearnerStatesTableTableManager get learnerStates =>
      $$LearnerStatesTableTableManager(_db, _db.learnerStates);
  $$LearnerProgressEventsTableTableManager get learnerProgressEvents =>
      $$LearnerProgressEventsTableTableManager(_db, _db.learnerProgressEvents);
  $$LessonAttemptsTableTableManager get lessonAttempts =>
      $$LessonAttemptsTableTableManager(_db, _db.lessonAttempts);
  $$LessonAttemptStepResultsTableTableManager get lessonAttemptStepResults =>
      $$LessonAttemptStepResultsTableTableManager(
        _db,
        _db.lessonAttemptStepResults,
      );
}
