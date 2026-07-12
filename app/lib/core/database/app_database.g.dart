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
  static const VerificationMeta _attemptPurposeMeta = const VerificationMeta(
    'attemptPurpose',
  );
  @override
  late final GeneratedColumn<String> attemptPurpose = GeneratedColumn<String>(
    'attempt_purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
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
    attemptPurpose,
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
    if (data.containsKey('attempt_purpose')) {
      context.handle(
        _attemptPurposeMeta,
        attemptPurpose.isAcceptableOrUnknown(
          data['attempt_purpose']!,
          _attemptPurposeMeta,
        ),
      );
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
      attemptPurpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_purpose'],
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
  final String attemptPurpose;
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
    required this.attemptPurpose,
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
    map['attempt_purpose'] = Variable<String>(attemptPurpose);
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
      attemptPurpose: Value(attemptPurpose),
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
      attemptPurpose: serializer.fromJson<String>(json['attemptPurpose']),
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
      'attemptPurpose': serializer.toJson<String>(attemptPurpose),
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
    String? attemptPurpose,
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
    attemptPurpose: attemptPurpose ?? this.attemptPurpose,
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
      attemptPurpose: data.attemptPurpose.present
          ? data.attemptPurpose.value
          : this.attemptPurpose,
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
          ..write('attemptPurpose: $attemptPurpose, ')
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
    attemptPurpose,
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
          other.attemptPurpose == this.attemptPurpose &&
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
  final Value<String> attemptPurpose;
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
    this.attemptPurpose = const Value.absent(),
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
    this.attemptPurpose = const Value.absent(),
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
    Expression<String>? attemptPurpose,
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
      if (attemptPurpose != null) 'attempt_purpose': attemptPurpose,
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
    Value<String>? attemptPurpose,
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
      attemptPurpose: attemptPurpose ?? this.attemptPurpose,
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
    if (attemptPurpose.present) {
      map['attempt_purpose'] = Variable<String>(attemptPurpose.value);
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
          ..write('attemptPurpose: $attemptPurpose, ')
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

class $CompetencyAttemptsTable extends CompetencyAttempts
    with TableInfo<$CompetencyAttemptsTable, CompetencyAttemptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetencyAttemptsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _competencyIdMeta = const VerificationMeta(
    'competencyId',
  );
  @override
  late final GeneratedColumn<String> competencyId = GeneratedColumn<String>(
    'competency_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moduleIdMeta = const VerificationMeta(
    'moduleId',
  );
  @override
  late final GeneratedColumn<String> moduleId = GeneratedColumn<String>(
    'module_id',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalOutcomeMeta = const VerificationMeta(
    'finalOutcome',
  );
  @override
  late final GeneratedColumn<String> finalOutcome = GeneratedColumn<String>(
    'final_outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _definitionFingerprintMeta =
      const VerificationMeta('definitionFingerprint');
  @override
  late final GeneratedColumn<String> definitionFingerprint =
      GeneratedColumn<String>(
        'definition_fingerprint',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    attemptId,
    competencyId,
    moduleId,
    startedAt,
    completedAt,
    status,
    finalOutcome,
    definitionFingerprint,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competency_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompetencyAttemptRow> instance, {
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
    if (data.containsKey('competency_id')) {
      context.handle(
        _competencyIdMeta,
        competencyId.isAcceptableOrUnknown(
          data['competency_id']!,
          _competencyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_competencyIdMeta);
    }
    if (data.containsKey('module_id')) {
      context.handle(
        _moduleIdMeta,
        moduleId.isAcceptableOrUnknown(data['module_id']!, _moduleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_moduleIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('final_outcome')) {
      context.handle(
        _finalOutcomeMeta,
        finalOutcome.isAcceptableOrUnknown(
          data['final_outcome']!,
          _finalOutcomeMeta,
        ),
      );
    }
    if (data.containsKey('definition_fingerprint')) {
      context.handle(
        _definitionFingerprintMeta,
        definitionFingerprint.isAcceptableOrUnknown(
          data['definition_fingerprint']!,
          _definitionFingerprintMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_definitionFingerprintMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId};
  @override
  CompetencyAttemptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetencyAttemptRow(
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      competencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}competency_id'],
      )!,
      moduleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}module_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      finalOutcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}final_outcome'],
      ),
      definitionFingerprint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition_fingerprint'],
      )!,
    );
  }

  @override
  $CompetencyAttemptsTable createAlias(String alias) {
    return $CompetencyAttemptsTable(attachedDatabase, alias);
  }
}

class CompetencyAttemptRow extends DataClass
    implements Insertable<CompetencyAttemptRow> {
  final String attemptId;
  final String competencyId;
  final String moduleId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status;
  final String? finalOutcome;
  final String definitionFingerprint;
  const CompetencyAttemptRow({
    required this.attemptId,
    required this.competencyId,
    required this.moduleId,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.finalOutcome,
    required this.definitionFingerprint,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['attempt_id'] = Variable<String>(attemptId);
    map['competency_id'] = Variable<String>(competencyId);
    map['module_id'] = Variable<String>(moduleId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || finalOutcome != null) {
      map['final_outcome'] = Variable<String>(finalOutcome);
    }
    map['definition_fingerprint'] = Variable<String>(definitionFingerprint);
    return map;
  }

  CompetencyAttemptsCompanion toCompanion(bool nullToAbsent) {
    return CompetencyAttemptsCompanion(
      attemptId: Value(attemptId),
      competencyId: Value(competencyId),
      moduleId: Value(moduleId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      status: Value(status),
      finalOutcome: finalOutcome == null && nullToAbsent
          ? const Value.absent()
          : Value(finalOutcome),
      definitionFingerprint: Value(definitionFingerprint),
    );
  }

  factory CompetencyAttemptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetencyAttemptRow(
      attemptId: serializer.fromJson<String>(json['attemptId']),
      competencyId: serializer.fromJson<String>(json['competencyId']),
      moduleId: serializer.fromJson<String>(json['moduleId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
      finalOutcome: serializer.fromJson<String?>(json['finalOutcome']),
      definitionFingerprint: serializer.fromJson<String>(
        json['definitionFingerprint'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'attemptId': serializer.toJson<String>(attemptId),
      'competencyId': serializer.toJson<String>(competencyId),
      'moduleId': serializer.toJson<String>(moduleId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'status': serializer.toJson<String>(status),
      'finalOutcome': serializer.toJson<String?>(finalOutcome),
      'definitionFingerprint': serializer.toJson<String>(definitionFingerprint),
    };
  }

  CompetencyAttemptRow copyWith({
    String? attemptId,
    String? competencyId,
    String? moduleId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    String? status,
    Value<String?> finalOutcome = const Value.absent(),
    String? definitionFingerprint,
  }) => CompetencyAttemptRow(
    attemptId: attemptId ?? this.attemptId,
    competencyId: competencyId ?? this.competencyId,
    moduleId: moduleId ?? this.moduleId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    status: status ?? this.status,
    finalOutcome: finalOutcome.present ? finalOutcome.value : this.finalOutcome,
    definitionFingerprint: definitionFingerprint ?? this.definitionFingerprint,
  );
  CompetencyAttemptRow copyWithCompanion(CompetencyAttemptsCompanion data) {
    return CompetencyAttemptRow(
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      competencyId: data.competencyId.present
          ? data.competencyId.value
          : this.competencyId,
      moduleId: data.moduleId.present ? data.moduleId.value : this.moduleId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
      finalOutcome: data.finalOutcome.present
          ? data.finalOutcome.value
          : this.finalOutcome,
      definitionFingerprint: data.definitionFingerprint.present
          ? data.definitionFingerprint.value
          : this.definitionFingerprint,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyAttemptRow(')
          ..write('attemptId: $attemptId, ')
          ..write('competencyId: $competencyId, ')
          ..write('moduleId: $moduleId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('finalOutcome: $finalOutcome, ')
          ..write('definitionFingerprint: $definitionFingerprint')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    attemptId,
    competencyId,
    moduleId,
    startedAt,
    completedAt,
    status,
    finalOutcome,
    definitionFingerprint,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetencyAttemptRow &&
          other.attemptId == this.attemptId &&
          other.competencyId == this.competencyId &&
          other.moduleId == this.moduleId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.status == this.status &&
          other.finalOutcome == this.finalOutcome &&
          other.definitionFingerprint == this.definitionFingerprint);
}

class CompetencyAttemptsCompanion
    extends UpdateCompanion<CompetencyAttemptRow> {
  final Value<String> attemptId;
  final Value<String> competencyId;
  final Value<String> moduleId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> status;
  final Value<String?> finalOutcome;
  final Value<String> definitionFingerprint;
  final Value<int> rowid;
  const CompetencyAttemptsCompanion({
    this.attemptId = const Value.absent(),
    this.competencyId = const Value.absent(),
    this.moduleId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.finalOutcome = const Value.absent(),
    this.definitionFingerprint = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompetencyAttemptsCompanion.insert({
    required String attemptId,
    required String competencyId,
    required String moduleId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required String status,
    this.finalOutcome = const Value.absent(),
    required String definitionFingerprint,
    this.rowid = const Value.absent(),
  }) : attemptId = Value(attemptId),
       competencyId = Value(competencyId),
       moduleId = Value(moduleId),
       startedAt = Value(startedAt),
       status = Value(status),
       definitionFingerprint = Value(definitionFingerprint);
  static Insertable<CompetencyAttemptRow> custom({
    Expression<String>? attemptId,
    Expression<String>? competencyId,
    Expression<String>? moduleId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? status,
    Expression<String>? finalOutcome,
    Expression<String>? definitionFingerprint,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (attemptId != null) 'attempt_id': attemptId,
      if (competencyId != null) 'competency_id': competencyId,
      if (moduleId != null) 'module_id': moduleId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
      if (finalOutcome != null) 'final_outcome': finalOutcome,
      if (definitionFingerprint != null)
        'definition_fingerprint': definitionFingerprint,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompetencyAttemptsCompanion copyWith({
    Value<String>? attemptId,
    Value<String>? competencyId,
    Value<String>? moduleId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String>? status,
    Value<String?>? finalOutcome,
    Value<String>? definitionFingerprint,
    Value<int>? rowid,
  }) {
    return CompetencyAttemptsCompanion(
      attemptId: attemptId ?? this.attemptId,
      competencyId: competencyId ?? this.competencyId,
      moduleId: moduleId ?? this.moduleId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      finalOutcome: finalOutcome ?? this.finalOutcome,
      definitionFingerprint:
          definitionFingerprint ?? this.definitionFingerprint,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (competencyId.present) {
      map['competency_id'] = Variable<String>(competencyId.value);
    }
    if (moduleId.present) {
      map['module_id'] = Variable<String>(moduleId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (finalOutcome.present) {
      map['final_outcome'] = Variable<String>(finalOutcome.value);
    }
    if (definitionFingerprint.present) {
      map['definition_fingerprint'] = Variable<String>(
        definitionFingerprint.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyAttemptsCompanion(')
          ..write('attemptId: $attemptId, ')
          ..write('competencyId: $competencyId, ')
          ..write('moduleId: $moduleId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('finalOutcome: $finalOutcome, ')
          ..write('definitionFingerprint: $definitionFingerprint, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompetencyTaskResultsTable extends CompetencyTaskResults
    with TableInfo<$CompetencyTaskResultsTable, CompetencyTaskResultRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetencyTaskResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _resultIdMeta = const VerificationMeta(
    'resultId',
  );
  @override
  late final GeneratedColumn<String> resultId = GeneratedColumn<String>(
    'result_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
      'REFERENCES competency_attempts (attempt_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _assessmentTaskIdMeta = const VerificationMeta(
    'assessmentTaskId',
  );
  @override
  late final GeneratedColumn<String> assessmentTaskId = GeneratedColumn<String>(
    'assessment_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _microCompetencyIdsJsonMeta =
      const VerificationMeta('microCompetencyIdsJson');
  @override
  late final GeneratedColumn<String> microCompetencyIdsJson =
      GeneratedColumn<String>(
        'micro_competency_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _attemptSequenceMeta = const VerificationMeta(
    'attemptSequence',
  );
  @override
  late final GeneratedColumn<int> attemptSequence = GeneratedColumn<int>(
    'attempt_sequence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseMeta = const VerificationMeta('phase');
  @override
  late final GeneratedColumn<String> phase = GeneratedColumn<String>(
    'phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityResultStatusMeta =
      const VerificationMeta('activityResultStatus');
  @override
  late final GeneratedColumn<String> activityResultStatus =
      GeneratedColumn<String>(
        'activity_result_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reasonCodeMeta = const VerificationMeta(
    'reasonCode',
  );
  @override
  late final GeneratedColumn<String> reasonCode = GeneratedColumn<String>(
    'reason_code',
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
  @override
  List<GeneratedColumn> get $columns => [
    resultId,
    attemptId,
    assessmentTaskId,
    microCompetencyIdsJson,
    attemptSequence,
    phase,
    activityResultStatus,
    reasonCode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competency_task_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompetencyTaskResultRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('result_id')) {
      context.handle(
        _resultIdMeta,
        resultId.isAcceptableOrUnknown(data['result_id']!, _resultIdMeta),
      );
    } else if (isInserting) {
      context.missing(_resultIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('assessment_task_id')) {
      context.handle(
        _assessmentTaskIdMeta,
        assessmentTaskId.isAcceptableOrUnknown(
          data['assessment_task_id']!,
          _assessmentTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assessmentTaskIdMeta);
    }
    if (data.containsKey('micro_competency_ids_json')) {
      context.handle(
        _microCompetencyIdsJsonMeta,
        microCompetencyIdsJson.isAcceptableOrUnknown(
          data['micro_competency_ids_json']!,
          _microCompetencyIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_microCompetencyIdsJsonMeta);
    }
    if (data.containsKey('attempt_sequence')) {
      context.handle(
        _attemptSequenceMeta,
        attemptSequence.isAcceptableOrUnknown(
          data['attempt_sequence']!,
          _attemptSequenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptSequenceMeta);
    }
    if (data.containsKey('phase')) {
      context.handle(
        _phaseMeta,
        phase.isAcceptableOrUnknown(data['phase']!, _phaseMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseMeta);
    }
    if (data.containsKey('activity_result_status')) {
      context.handle(
        _activityResultStatusMeta,
        activityResultStatus.isAcceptableOrUnknown(
          data['activity_result_status']!,
          _activityResultStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityResultStatusMeta);
    }
    if (data.containsKey('reason_code')) {
      context.handle(
        _reasonCodeMeta,
        reasonCode.isAcceptableOrUnknown(data['reason_code']!, _reasonCodeMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {resultId};
  @override
  CompetencyTaskResultRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetencyTaskResultRow(
      resultId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      assessmentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment_task_id'],
      )!,
      microCompetencyIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}micro_competency_ids_json'],
      )!,
      attemptSequence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempt_sequence'],
      )!,
      phase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase'],
      )!,
      activityResultStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_result_status'],
      )!,
      reasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CompetencyTaskResultsTable createAlias(String alias) {
    return $CompetencyTaskResultsTable(attachedDatabase, alias);
  }
}

class CompetencyTaskResultRow extends DataClass
    implements Insertable<CompetencyTaskResultRow> {
  final String resultId;
  final String attemptId;
  final String assessmentTaskId;
  final String microCompetencyIdsJson;
  final int attemptSequence;
  final String phase;
  final String activityResultStatus;
  final String? reasonCode;
  final DateTime createdAt;
  const CompetencyTaskResultRow({
    required this.resultId,
    required this.attemptId,
    required this.assessmentTaskId,
    required this.microCompetencyIdsJson,
    required this.attemptSequence,
    required this.phase,
    required this.activityResultStatus,
    this.reasonCode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['result_id'] = Variable<String>(resultId);
    map['attempt_id'] = Variable<String>(attemptId);
    map['assessment_task_id'] = Variable<String>(assessmentTaskId);
    map['micro_competency_ids_json'] = Variable<String>(microCompetencyIdsJson);
    map['attempt_sequence'] = Variable<int>(attemptSequence);
    map['phase'] = Variable<String>(phase);
    map['activity_result_status'] = Variable<String>(activityResultStatus);
    if (!nullToAbsent || reasonCode != null) {
      map['reason_code'] = Variable<String>(reasonCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CompetencyTaskResultsCompanion toCompanion(bool nullToAbsent) {
    return CompetencyTaskResultsCompanion(
      resultId: Value(resultId),
      attemptId: Value(attemptId),
      assessmentTaskId: Value(assessmentTaskId),
      microCompetencyIdsJson: Value(microCompetencyIdsJson),
      attemptSequence: Value(attemptSequence),
      phase: Value(phase),
      activityResultStatus: Value(activityResultStatus),
      reasonCode: reasonCode == null && nullToAbsent
          ? const Value.absent()
          : Value(reasonCode),
      createdAt: Value(createdAt),
    );
  }

  factory CompetencyTaskResultRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetencyTaskResultRow(
      resultId: serializer.fromJson<String>(json['resultId']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      assessmentTaskId: serializer.fromJson<String>(json['assessmentTaskId']),
      microCompetencyIdsJson: serializer.fromJson<String>(
        json['microCompetencyIdsJson'],
      ),
      attemptSequence: serializer.fromJson<int>(json['attemptSequence']),
      phase: serializer.fromJson<String>(json['phase']),
      activityResultStatus: serializer.fromJson<String>(
        json['activityResultStatus'],
      ),
      reasonCode: serializer.fromJson<String?>(json['reasonCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'resultId': serializer.toJson<String>(resultId),
      'attemptId': serializer.toJson<String>(attemptId),
      'assessmentTaskId': serializer.toJson<String>(assessmentTaskId),
      'microCompetencyIdsJson': serializer.toJson<String>(
        microCompetencyIdsJson,
      ),
      'attemptSequence': serializer.toJson<int>(attemptSequence),
      'phase': serializer.toJson<String>(phase),
      'activityResultStatus': serializer.toJson<String>(activityResultStatus),
      'reasonCode': serializer.toJson<String?>(reasonCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CompetencyTaskResultRow copyWith({
    String? resultId,
    String? attemptId,
    String? assessmentTaskId,
    String? microCompetencyIdsJson,
    int? attemptSequence,
    String? phase,
    String? activityResultStatus,
    Value<String?> reasonCode = const Value.absent(),
    DateTime? createdAt,
  }) => CompetencyTaskResultRow(
    resultId: resultId ?? this.resultId,
    attemptId: attemptId ?? this.attemptId,
    assessmentTaskId: assessmentTaskId ?? this.assessmentTaskId,
    microCompetencyIdsJson:
        microCompetencyIdsJson ?? this.microCompetencyIdsJson,
    attemptSequence: attemptSequence ?? this.attemptSequence,
    phase: phase ?? this.phase,
    activityResultStatus: activityResultStatus ?? this.activityResultStatus,
    reasonCode: reasonCode.present ? reasonCode.value : this.reasonCode,
    createdAt: createdAt ?? this.createdAt,
  );
  CompetencyTaskResultRow copyWithCompanion(
    CompetencyTaskResultsCompanion data,
  ) {
    return CompetencyTaskResultRow(
      resultId: data.resultId.present ? data.resultId.value : this.resultId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      assessmentTaskId: data.assessmentTaskId.present
          ? data.assessmentTaskId.value
          : this.assessmentTaskId,
      microCompetencyIdsJson: data.microCompetencyIdsJson.present
          ? data.microCompetencyIdsJson.value
          : this.microCompetencyIdsJson,
      attemptSequence: data.attemptSequence.present
          ? data.attemptSequence.value
          : this.attemptSequence,
      phase: data.phase.present ? data.phase.value : this.phase,
      activityResultStatus: data.activityResultStatus.present
          ? data.activityResultStatus.value
          : this.activityResultStatus,
      reasonCode: data.reasonCode.present
          ? data.reasonCode.value
          : this.reasonCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyTaskResultRow(')
          ..write('resultId: $resultId, ')
          ..write('attemptId: $attemptId, ')
          ..write('assessmentTaskId: $assessmentTaskId, ')
          ..write('microCompetencyIdsJson: $microCompetencyIdsJson, ')
          ..write('attemptSequence: $attemptSequence, ')
          ..write('phase: $phase, ')
          ..write('activityResultStatus: $activityResultStatus, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    resultId,
    attemptId,
    assessmentTaskId,
    microCompetencyIdsJson,
    attemptSequence,
    phase,
    activityResultStatus,
    reasonCode,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetencyTaskResultRow &&
          other.resultId == this.resultId &&
          other.attemptId == this.attemptId &&
          other.assessmentTaskId == this.assessmentTaskId &&
          other.microCompetencyIdsJson == this.microCompetencyIdsJson &&
          other.attemptSequence == this.attemptSequence &&
          other.phase == this.phase &&
          other.activityResultStatus == this.activityResultStatus &&
          other.reasonCode == this.reasonCode &&
          other.createdAt == this.createdAt);
}

class CompetencyTaskResultsCompanion
    extends UpdateCompanion<CompetencyTaskResultRow> {
  final Value<String> resultId;
  final Value<String> attemptId;
  final Value<String> assessmentTaskId;
  final Value<String> microCompetencyIdsJson;
  final Value<int> attemptSequence;
  final Value<String> phase;
  final Value<String> activityResultStatus;
  final Value<String?> reasonCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CompetencyTaskResultsCompanion({
    this.resultId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.assessmentTaskId = const Value.absent(),
    this.microCompetencyIdsJson = const Value.absent(),
    this.attemptSequence = const Value.absent(),
    this.phase = const Value.absent(),
    this.activityResultStatus = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompetencyTaskResultsCompanion.insert({
    required String resultId,
    required String attemptId,
    required String assessmentTaskId,
    required String microCompetencyIdsJson,
    required int attemptSequence,
    required String phase,
    required String activityResultStatus,
    this.reasonCode = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : resultId = Value(resultId),
       attemptId = Value(attemptId),
       assessmentTaskId = Value(assessmentTaskId),
       microCompetencyIdsJson = Value(microCompetencyIdsJson),
       attemptSequence = Value(attemptSequence),
       phase = Value(phase),
       activityResultStatus = Value(activityResultStatus),
       createdAt = Value(createdAt);
  static Insertable<CompetencyTaskResultRow> custom({
    Expression<String>? resultId,
    Expression<String>? attemptId,
    Expression<String>? assessmentTaskId,
    Expression<String>? microCompetencyIdsJson,
    Expression<int>? attemptSequence,
    Expression<String>? phase,
    Expression<String>? activityResultStatus,
    Expression<String>? reasonCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (resultId != null) 'result_id': resultId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (assessmentTaskId != null) 'assessment_task_id': assessmentTaskId,
      if (microCompetencyIdsJson != null)
        'micro_competency_ids_json': microCompetencyIdsJson,
      if (attemptSequence != null) 'attempt_sequence': attemptSequence,
      if (phase != null) 'phase': phase,
      if (activityResultStatus != null)
        'activity_result_status': activityResultStatus,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompetencyTaskResultsCompanion copyWith({
    Value<String>? resultId,
    Value<String>? attemptId,
    Value<String>? assessmentTaskId,
    Value<String>? microCompetencyIdsJson,
    Value<int>? attemptSequence,
    Value<String>? phase,
    Value<String>? activityResultStatus,
    Value<String?>? reasonCode,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CompetencyTaskResultsCompanion(
      resultId: resultId ?? this.resultId,
      attemptId: attemptId ?? this.attemptId,
      assessmentTaskId: assessmentTaskId ?? this.assessmentTaskId,
      microCompetencyIdsJson:
          microCompetencyIdsJson ?? this.microCompetencyIdsJson,
      attemptSequence: attemptSequence ?? this.attemptSequence,
      phase: phase ?? this.phase,
      activityResultStatus: activityResultStatus ?? this.activityResultStatus,
      reasonCode: reasonCode ?? this.reasonCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (resultId.present) {
      map['result_id'] = Variable<String>(resultId.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (assessmentTaskId.present) {
      map['assessment_task_id'] = Variable<String>(assessmentTaskId.value);
    }
    if (microCompetencyIdsJson.present) {
      map['micro_competency_ids_json'] = Variable<String>(
        microCompetencyIdsJson.value,
      );
    }
    if (attemptSequence.present) {
      map['attempt_sequence'] = Variable<int>(attemptSequence.value);
    }
    if (phase.present) {
      map['phase'] = Variable<String>(phase.value);
    }
    if (activityResultStatus.present) {
      map['activity_result_status'] = Variable<String>(
        activityResultStatus.value,
      );
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(reasonCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyTaskResultsCompanion(')
          ..write('resultId: $resultId, ')
          ..write('attemptId: $attemptId, ')
          ..write('assessmentTaskId: $assessmentTaskId, ')
          ..write('microCompetencyIdsJson: $microCompetencyIdsJson, ')
          ..write('attemptSequence: $attemptSequence, ')
          ..write('phase: $phase, ')
          ..write('activityResultStatus: $activityResultStatus, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompetencyGapsTable extends CompetencyGaps
    with TableInfo<$CompetencyGapsTable, CompetencyGapRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetencyGapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gapIdMeta = const VerificationMeta('gapId');
  @override
  late final GeneratedColumn<String> gapId = GeneratedColumn<String>(
    'gap_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
      'REFERENCES competency_attempts (attempt_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _assessmentTaskIdMeta = const VerificationMeta(
    'assessmentTaskId',
  );
  @override
  late final GeneratedColumn<String> assessmentTaskId = GeneratedColumn<String>(
    'assessment_task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _microCompetencyIdMeta = const VerificationMeta(
    'microCompetencyId',
  );
  @override
  late final GeneratedColumn<String> microCompetencyId =
      GeneratedColumn<String>(
        'micro_competency_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reasonCodeMeta = const VerificationMeta(
    'reasonCode',
  );
  @override
  late final GeneratedColumn<String> reasonCode = GeneratedColumn<String>(
    'reason_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceModuleIdMeta = const VerificationMeta(
    'sourceModuleId',
  );
  @override
  late final GeneratedColumn<String> sourceModuleId = GeneratedColumn<String>(
    'source_module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLessonIdMeta = const VerificationMeta(
    'sourceLessonId',
  );
  @override
  late final GeneratedColumn<String> sourceLessonId = GeneratedColumn<String>(
    'source_lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStepIdMeta = const VerificationMeta(
    'sourceStepId',
  );
  @override
  late final GeneratedColumn<String> sourceStepId = GeneratedColumn<String>(
    'source_step_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detectedAtMeta = const VerificationMeta(
    'detectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> detectedAt = GeneratedColumn<DateTime>(
    'detected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolutionStatusMeta = const VerificationMeta(
    'resolutionStatus',
  );
  @override
  late final GeneratedColumn<String> resolutionStatus = GeneratedColumn<String>(
    'resolution_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    gapId,
    attemptId,
    assessmentTaskId,
    microCompetencyId,
    reasonCode,
    sourceModuleId,
    sourceLessonId,
    sourceStepId,
    detectedAt,
    resolvedAt,
    resolutionStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competency_gaps';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompetencyGapRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gap_id')) {
      context.handle(
        _gapIdMeta,
        gapId.isAcceptableOrUnknown(data['gap_id']!, _gapIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gapIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('assessment_task_id')) {
      context.handle(
        _assessmentTaskIdMeta,
        assessmentTaskId.isAcceptableOrUnknown(
          data['assessment_task_id']!,
          _assessmentTaskIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assessmentTaskIdMeta);
    }
    if (data.containsKey('micro_competency_id')) {
      context.handle(
        _microCompetencyIdMeta,
        microCompetencyId.isAcceptableOrUnknown(
          data['micro_competency_id']!,
          _microCompetencyIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_microCompetencyIdMeta);
    }
    if (data.containsKey('reason_code')) {
      context.handle(
        _reasonCodeMeta,
        reasonCode.isAcceptableOrUnknown(data['reason_code']!, _reasonCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonCodeMeta);
    }
    if (data.containsKey('source_module_id')) {
      context.handle(
        _sourceModuleIdMeta,
        sourceModuleId.isAcceptableOrUnknown(
          data['source_module_id']!,
          _sourceModuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceModuleIdMeta);
    }
    if (data.containsKey('source_lesson_id')) {
      context.handle(
        _sourceLessonIdMeta,
        sourceLessonId.isAcceptableOrUnknown(
          data['source_lesson_id']!,
          _sourceLessonIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLessonIdMeta);
    }
    if (data.containsKey('source_step_id')) {
      context.handle(
        _sourceStepIdMeta,
        sourceStepId.isAcceptableOrUnknown(
          data['source_step_id']!,
          _sourceStepIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceStepIdMeta);
    }
    if (data.containsKey('detected_at')) {
      context.handle(
        _detectedAtMeta,
        detectedAt.isAcceptableOrUnknown(data['detected_at']!, _detectedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_detectedAtMeta);
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('resolution_status')) {
      context.handle(
        _resolutionStatusMeta,
        resolutionStatus.isAcceptableOrUnknown(
          data['resolution_status']!,
          _resolutionStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_resolutionStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {attemptId, gapId};
  @override
  CompetencyGapRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetencyGapRow(
      gapId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gap_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      assessmentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assessment_task_id'],
      )!,
      microCompetencyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}micro_competency_id'],
      )!,
      reasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_code'],
      )!,
      sourceModuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_module_id'],
      )!,
      sourceLessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lesson_id'],
      )!,
      sourceStepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_step_id'],
      )!,
      detectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}detected_at'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      ),
      resolutionStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}resolution_status'],
      )!,
    );
  }

  @override
  $CompetencyGapsTable createAlias(String alias) {
    return $CompetencyGapsTable(attachedDatabase, alias);
  }
}

class CompetencyGapRow extends DataClass
    implements Insertable<CompetencyGapRow> {
  final String gapId;
  final String attemptId;
  final String assessmentTaskId;
  final String microCompetencyId;
  final String reasonCode;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
  final DateTime detectedAt;
  final DateTime? resolvedAt;
  final String resolutionStatus;
  const CompetencyGapRow({
    required this.gapId,
    required this.attemptId,
    required this.assessmentTaskId,
    required this.microCompetencyId,
    required this.reasonCode,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
    required this.detectedAt,
    this.resolvedAt,
    required this.resolutionStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gap_id'] = Variable<String>(gapId);
    map['attempt_id'] = Variable<String>(attemptId);
    map['assessment_task_id'] = Variable<String>(assessmentTaskId);
    map['micro_competency_id'] = Variable<String>(microCompetencyId);
    map['reason_code'] = Variable<String>(reasonCode);
    map['source_module_id'] = Variable<String>(sourceModuleId);
    map['source_lesson_id'] = Variable<String>(sourceLessonId);
    map['source_step_id'] = Variable<String>(sourceStepId);
    map['detected_at'] = Variable<DateTime>(detectedAt);
    if (!nullToAbsent || resolvedAt != null) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt);
    }
    map['resolution_status'] = Variable<String>(resolutionStatus);
    return map;
  }

  CompetencyGapsCompanion toCompanion(bool nullToAbsent) {
    return CompetencyGapsCompanion(
      gapId: Value(gapId),
      attemptId: Value(attemptId),
      assessmentTaskId: Value(assessmentTaskId),
      microCompetencyId: Value(microCompetencyId),
      reasonCode: Value(reasonCode),
      sourceModuleId: Value(sourceModuleId),
      sourceLessonId: Value(sourceLessonId),
      sourceStepId: Value(sourceStepId),
      detectedAt: Value(detectedAt),
      resolvedAt: resolvedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(resolvedAt),
      resolutionStatus: Value(resolutionStatus),
    );
  }

  factory CompetencyGapRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetencyGapRow(
      gapId: serializer.fromJson<String>(json['gapId']),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      assessmentTaskId: serializer.fromJson<String>(json['assessmentTaskId']),
      microCompetencyId: serializer.fromJson<String>(json['microCompetencyId']),
      reasonCode: serializer.fromJson<String>(json['reasonCode']),
      sourceModuleId: serializer.fromJson<String>(json['sourceModuleId']),
      sourceLessonId: serializer.fromJson<String>(json['sourceLessonId']),
      sourceStepId: serializer.fromJson<String>(json['sourceStepId']),
      detectedAt: serializer.fromJson<DateTime>(json['detectedAt']),
      resolvedAt: serializer.fromJson<DateTime?>(json['resolvedAt']),
      resolutionStatus: serializer.fromJson<String>(json['resolutionStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gapId': serializer.toJson<String>(gapId),
      'attemptId': serializer.toJson<String>(attemptId),
      'assessmentTaskId': serializer.toJson<String>(assessmentTaskId),
      'microCompetencyId': serializer.toJson<String>(microCompetencyId),
      'reasonCode': serializer.toJson<String>(reasonCode),
      'sourceModuleId': serializer.toJson<String>(sourceModuleId),
      'sourceLessonId': serializer.toJson<String>(sourceLessonId),
      'sourceStepId': serializer.toJson<String>(sourceStepId),
      'detectedAt': serializer.toJson<DateTime>(detectedAt),
      'resolvedAt': serializer.toJson<DateTime?>(resolvedAt),
      'resolutionStatus': serializer.toJson<String>(resolutionStatus),
    };
  }

  CompetencyGapRow copyWith({
    String? gapId,
    String? attemptId,
    String? assessmentTaskId,
    String? microCompetencyId,
    String? reasonCode,
    String? sourceModuleId,
    String? sourceLessonId,
    String? sourceStepId,
    DateTime? detectedAt,
    Value<DateTime?> resolvedAt = const Value.absent(),
    String? resolutionStatus,
  }) => CompetencyGapRow(
    gapId: gapId ?? this.gapId,
    attemptId: attemptId ?? this.attemptId,
    assessmentTaskId: assessmentTaskId ?? this.assessmentTaskId,
    microCompetencyId: microCompetencyId ?? this.microCompetencyId,
    reasonCode: reasonCode ?? this.reasonCode,
    sourceModuleId: sourceModuleId ?? this.sourceModuleId,
    sourceLessonId: sourceLessonId ?? this.sourceLessonId,
    sourceStepId: sourceStepId ?? this.sourceStepId,
    detectedAt: detectedAt ?? this.detectedAt,
    resolvedAt: resolvedAt.present ? resolvedAt.value : this.resolvedAt,
    resolutionStatus: resolutionStatus ?? this.resolutionStatus,
  );
  CompetencyGapRow copyWithCompanion(CompetencyGapsCompanion data) {
    return CompetencyGapRow(
      gapId: data.gapId.present ? data.gapId.value : this.gapId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      assessmentTaskId: data.assessmentTaskId.present
          ? data.assessmentTaskId.value
          : this.assessmentTaskId,
      microCompetencyId: data.microCompetencyId.present
          ? data.microCompetencyId.value
          : this.microCompetencyId,
      reasonCode: data.reasonCode.present
          ? data.reasonCode.value
          : this.reasonCode,
      sourceModuleId: data.sourceModuleId.present
          ? data.sourceModuleId.value
          : this.sourceModuleId,
      sourceLessonId: data.sourceLessonId.present
          ? data.sourceLessonId.value
          : this.sourceLessonId,
      sourceStepId: data.sourceStepId.present
          ? data.sourceStepId.value
          : this.sourceStepId,
      detectedAt: data.detectedAt.present
          ? data.detectedAt.value
          : this.detectedAt,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      resolutionStatus: data.resolutionStatus.present
          ? data.resolutionStatus.value
          : this.resolutionStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyGapRow(')
          ..write('gapId: $gapId, ')
          ..write('attemptId: $attemptId, ')
          ..write('assessmentTaskId: $assessmentTaskId, ')
          ..write('microCompetencyId: $microCompetencyId, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('sourceModuleId: $sourceModuleId, ')
          ..write('sourceLessonId: $sourceLessonId, ')
          ..write('sourceStepId: $sourceStepId, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolutionStatus: $resolutionStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    gapId,
    attemptId,
    assessmentTaskId,
    microCompetencyId,
    reasonCode,
    sourceModuleId,
    sourceLessonId,
    sourceStepId,
    detectedAt,
    resolvedAt,
    resolutionStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetencyGapRow &&
          other.gapId == this.gapId &&
          other.attemptId == this.attemptId &&
          other.assessmentTaskId == this.assessmentTaskId &&
          other.microCompetencyId == this.microCompetencyId &&
          other.reasonCode == this.reasonCode &&
          other.sourceModuleId == this.sourceModuleId &&
          other.sourceLessonId == this.sourceLessonId &&
          other.sourceStepId == this.sourceStepId &&
          other.detectedAt == this.detectedAt &&
          other.resolvedAt == this.resolvedAt &&
          other.resolutionStatus == this.resolutionStatus);
}

class CompetencyGapsCompanion extends UpdateCompanion<CompetencyGapRow> {
  final Value<String> gapId;
  final Value<String> attemptId;
  final Value<String> assessmentTaskId;
  final Value<String> microCompetencyId;
  final Value<String> reasonCode;
  final Value<String> sourceModuleId;
  final Value<String> sourceLessonId;
  final Value<String> sourceStepId;
  final Value<DateTime> detectedAt;
  final Value<DateTime?> resolvedAt;
  final Value<String> resolutionStatus;
  final Value<int> rowid;
  const CompetencyGapsCompanion({
    this.gapId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.assessmentTaskId = const Value.absent(),
    this.microCompetencyId = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.sourceModuleId = const Value.absent(),
    this.sourceLessonId = const Value.absent(),
    this.sourceStepId = const Value.absent(),
    this.detectedAt = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.resolutionStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompetencyGapsCompanion.insert({
    required String gapId,
    required String attemptId,
    required String assessmentTaskId,
    required String microCompetencyId,
    required String reasonCode,
    required String sourceModuleId,
    required String sourceLessonId,
    required String sourceStepId,
    required DateTime detectedAt,
    this.resolvedAt = const Value.absent(),
    required String resolutionStatus,
    this.rowid = const Value.absent(),
  }) : gapId = Value(gapId),
       attemptId = Value(attemptId),
       assessmentTaskId = Value(assessmentTaskId),
       microCompetencyId = Value(microCompetencyId),
       reasonCode = Value(reasonCode),
       sourceModuleId = Value(sourceModuleId),
       sourceLessonId = Value(sourceLessonId),
       sourceStepId = Value(sourceStepId),
       detectedAt = Value(detectedAt),
       resolutionStatus = Value(resolutionStatus);
  static Insertable<CompetencyGapRow> custom({
    Expression<String>? gapId,
    Expression<String>? attemptId,
    Expression<String>? assessmentTaskId,
    Expression<String>? microCompetencyId,
    Expression<String>? reasonCode,
    Expression<String>? sourceModuleId,
    Expression<String>? sourceLessonId,
    Expression<String>? sourceStepId,
    Expression<DateTime>? detectedAt,
    Expression<DateTime>? resolvedAt,
    Expression<String>? resolutionStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gapId != null) 'gap_id': gapId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (assessmentTaskId != null) 'assessment_task_id': assessmentTaskId,
      if (microCompetencyId != null) 'micro_competency_id': microCompetencyId,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (sourceModuleId != null) 'source_module_id': sourceModuleId,
      if (sourceLessonId != null) 'source_lesson_id': sourceLessonId,
      if (sourceStepId != null) 'source_step_id': sourceStepId,
      if (detectedAt != null) 'detected_at': detectedAt,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (resolutionStatus != null) 'resolution_status': resolutionStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompetencyGapsCompanion copyWith({
    Value<String>? gapId,
    Value<String>? attemptId,
    Value<String>? assessmentTaskId,
    Value<String>? microCompetencyId,
    Value<String>? reasonCode,
    Value<String>? sourceModuleId,
    Value<String>? sourceLessonId,
    Value<String>? sourceStepId,
    Value<DateTime>? detectedAt,
    Value<DateTime?>? resolvedAt,
    Value<String>? resolutionStatus,
    Value<int>? rowid,
  }) {
    return CompetencyGapsCompanion(
      gapId: gapId ?? this.gapId,
      attemptId: attemptId ?? this.attemptId,
      assessmentTaskId: assessmentTaskId ?? this.assessmentTaskId,
      microCompetencyId: microCompetencyId ?? this.microCompetencyId,
      reasonCode: reasonCode ?? this.reasonCode,
      sourceModuleId: sourceModuleId ?? this.sourceModuleId,
      sourceLessonId: sourceLessonId ?? this.sourceLessonId,
      sourceStepId: sourceStepId ?? this.sourceStepId,
      detectedAt: detectedAt ?? this.detectedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionStatus: resolutionStatus ?? this.resolutionStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gapId.present) {
      map['gap_id'] = Variable<String>(gapId.value);
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (assessmentTaskId.present) {
      map['assessment_task_id'] = Variable<String>(assessmentTaskId.value);
    }
    if (microCompetencyId.present) {
      map['micro_competency_id'] = Variable<String>(microCompetencyId.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(reasonCode.value);
    }
    if (sourceModuleId.present) {
      map['source_module_id'] = Variable<String>(sourceModuleId.value);
    }
    if (sourceLessonId.present) {
      map['source_lesson_id'] = Variable<String>(sourceLessonId.value);
    }
    if (sourceStepId.present) {
      map['source_step_id'] = Variable<String>(sourceStepId.value);
    }
    if (detectedAt.present) {
      map['detected_at'] = Variable<DateTime>(detectedAt.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (resolutionStatus.present) {
      map['resolution_status'] = Variable<String>(resolutionStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyGapsCompanion(')
          ..write('gapId: $gapId, ')
          ..write('attemptId: $attemptId, ')
          ..write('assessmentTaskId: $assessmentTaskId, ')
          ..write('microCompetencyId: $microCompetencyId, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('sourceModuleId: $sourceModuleId, ')
          ..write('sourceLessonId: $sourceLessonId, ')
          ..write('sourceStepId: $sourceStepId, ')
          ..write('detectedAt: $detectedAt, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('resolutionStatus: $resolutionStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompetencyRecoveryExecutionsTable extends CompetencyRecoveryExecutions
    with
        TableInfo<
          $CompetencyRecoveryExecutionsTable,
          CompetencyRecoveryExecutionRow
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompetencyRecoveryExecutionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recoveryExecutionIdMeta =
      const VerificationMeta('recoveryExecutionId');
  @override
  late final GeneratedColumn<String> recoveryExecutionId =
      GeneratedColumn<String>(
        'recovery_execution_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
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
      'REFERENCES competency_attempts (attempt_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _gapIdMeta = const VerificationMeta('gapId');
  @override
  late final GeneratedColumn<String> gapId = GeneratedColumn<String>(
    'gap_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recoveryStepIdMeta = const VerificationMeta(
    'recoveryStepId',
  );
  @override
  late final GeneratedColumn<String> recoveryStepId = GeneratedColumn<String>(
    'recovery_step_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceModuleIdMeta = const VerificationMeta(
    'sourceModuleId',
  );
  @override
  late final GeneratedColumn<String> sourceModuleId = GeneratedColumn<String>(
    'source_module_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceLessonIdMeta = const VerificationMeta(
    'sourceLessonId',
  );
  @override
  late final GeneratedColumn<String> sourceLessonId = GeneratedColumn<String>(
    'source_lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceStepIdMeta = const VerificationMeta(
    'sourceStepId',
  );
  @override
  late final GeneratedColumn<String> sourceStepId = GeneratedColumn<String>(
    'source_step_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _succeededMeta = const VerificationMeta(
    'succeeded',
  );
  @override
  late final GeneratedColumn<bool> succeeded = GeneratedColumn<bool>(
    'succeeded',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("succeeded" IN (0, 1))',
    ),
  );
  static const VerificationMeta _retryOccurredMeta = const VerificationMeta(
    'retryOccurred',
  );
  @override
  late final GeneratedColumn<bool> retryOccurred = GeneratedColumn<bool>(
    'retry_occurred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("retry_occurred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    recoveryExecutionId,
    attemptId,
    gapId,
    recoveryStepId,
    sourceModuleId,
    sourceLessonId,
    sourceStepId,
    status,
    startedAt,
    completedAt,
    succeeded,
    retryOccurred,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'competency_recovery_executions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompetencyRecoveryExecutionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recovery_execution_id')) {
      context.handle(
        _recoveryExecutionIdMeta,
        recoveryExecutionId.isAcceptableOrUnknown(
          data['recovery_execution_id']!,
          _recoveryExecutionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryExecutionIdMeta);
    }
    if (data.containsKey('attempt_id')) {
      context.handle(
        _attemptIdMeta,
        attemptId.isAcceptableOrUnknown(data['attempt_id']!, _attemptIdMeta),
      );
    } else if (isInserting) {
      context.missing(_attemptIdMeta);
    }
    if (data.containsKey('gap_id')) {
      context.handle(
        _gapIdMeta,
        gapId.isAcceptableOrUnknown(data['gap_id']!, _gapIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gapIdMeta);
    }
    if (data.containsKey('recovery_step_id')) {
      context.handle(
        _recoveryStepIdMeta,
        recoveryStepId.isAcceptableOrUnknown(
          data['recovery_step_id']!,
          _recoveryStepIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recoveryStepIdMeta);
    }
    if (data.containsKey('source_module_id')) {
      context.handle(
        _sourceModuleIdMeta,
        sourceModuleId.isAcceptableOrUnknown(
          data['source_module_id']!,
          _sourceModuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceModuleIdMeta);
    }
    if (data.containsKey('source_lesson_id')) {
      context.handle(
        _sourceLessonIdMeta,
        sourceLessonId.isAcceptableOrUnknown(
          data['source_lesson_id']!,
          _sourceLessonIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLessonIdMeta);
    }
    if (data.containsKey('source_step_id')) {
      context.handle(
        _sourceStepIdMeta,
        sourceStepId.isAcceptableOrUnknown(
          data['source_step_id']!,
          _sourceStepIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceStepIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
    }
    if (data.containsKey('succeeded')) {
      context.handle(
        _succeededMeta,
        succeeded.isAcceptableOrUnknown(data['succeeded']!, _succeededMeta),
      );
    }
    if (data.containsKey('retry_occurred')) {
      context.handle(
        _retryOccurredMeta,
        retryOccurred.isAcceptableOrUnknown(
          data['retry_occurred']!,
          _retryOccurredMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recoveryExecutionId};
  @override
  CompetencyRecoveryExecutionRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompetencyRecoveryExecutionRow(
      recoveryExecutionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_execution_id'],
      )!,
      attemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attempt_id'],
      )!,
      gapId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gap_id'],
      )!,
      recoveryStepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recovery_step_id'],
      )!,
      sourceModuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_module_id'],
      )!,
      sourceLessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_lesson_id'],
      )!,
      sourceStepId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_step_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      succeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}succeeded'],
      ),
      retryOccurred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}retry_occurred'],
      )!,
    );
  }

  @override
  $CompetencyRecoveryExecutionsTable createAlias(String alias) {
    return $CompetencyRecoveryExecutionsTable(attachedDatabase, alias);
  }
}

class CompetencyRecoveryExecutionRow extends DataClass
    implements Insertable<CompetencyRecoveryExecutionRow> {
  final String recoveryExecutionId;
  final String attemptId;
  final String gapId;
  final String recoveryStepId;
  final String sourceModuleId;
  final String sourceLessonId;
  final String sourceStepId;
  final String status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final bool? succeeded;
  final bool retryOccurred;
  const CompetencyRecoveryExecutionRow({
    required this.recoveryExecutionId,
    required this.attemptId,
    required this.gapId,
    required this.recoveryStepId,
    required this.sourceModuleId,
    required this.sourceLessonId,
    required this.sourceStepId,
    required this.status,
    this.startedAt,
    this.completedAt,
    this.succeeded,
    required this.retryOccurred,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recovery_execution_id'] = Variable<String>(recoveryExecutionId);
    map['attempt_id'] = Variable<String>(attemptId);
    map['gap_id'] = Variable<String>(gapId);
    map['recovery_step_id'] = Variable<String>(recoveryStepId);
    map['source_module_id'] = Variable<String>(sourceModuleId);
    map['source_lesson_id'] = Variable<String>(sourceLessonId);
    map['source_step_id'] = Variable<String>(sourceStepId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || succeeded != null) {
      map['succeeded'] = Variable<bool>(succeeded);
    }
    map['retry_occurred'] = Variable<bool>(retryOccurred);
    return map;
  }

  CompetencyRecoveryExecutionsCompanion toCompanion(bool nullToAbsent) {
    return CompetencyRecoveryExecutionsCompanion(
      recoveryExecutionId: Value(recoveryExecutionId),
      attemptId: Value(attemptId),
      gapId: Value(gapId),
      recoveryStepId: Value(recoveryStepId),
      sourceModuleId: Value(sourceModuleId),
      sourceLessonId: Value(sourceLessonId),
      sourceStepId: Value(sourceStepId),
      status: Value(status),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      succeeded: succeeded == null && nullToAbsent
          ? const Value.absent()
          : Value(succeeded),
      retryOccurred: Value(retryOccurred),
    );
  }

  factory CompetencyRecoveryExecutionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompetencyRecoveryExecutionRow(
      recoveryExecutionId: serializer.fromJson<String>(
        json['recoveryExecutionId'],
      ),
      attemptId: serializer.fromJson<String>(json['attemptId']),
      gapId: serializer.fromJson<String>(json['gapId']),
      recoveryStepId: serializer.fromJson<String>(json['recoveryStepId']),
      sourceModuleId: serializer.fromJson<String>(json['sourceModuleId']),
      sourceLessonId: serializer.fromJson<String>(json['sourceLessonId']),
      sourceStepId: serializer.fromJson<String>(json['sourceStepId']),
      status: serializer.fromJson<String>(json['status']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      succeeded: serializer.fromJson<bool?>(json['succeeded']),
      retryOccurred: serializer.fromJson<bool>(json['retryOccurred']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recoveryExecutionId': serializer.toJson<String>(recoveryExecutionId),
      'attemptId': serializer.toJson<String>(attemptId),
      'gapId': serializer.toJson<String>(gapId),
      'recoveryStepId': serializer.toJson<String>(recoveryStepId),
      'sourceModuleId': serializer.toJson<String>(sourceModuleId),
      'sourceLessonId': serializer.toJson<String>(sourceLessonId),
      'sourceStepId': serializer.toJson<String>(sourceStepId),
      'status': serializer.toJson<String>(status),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'succeeded': serializer.toJson<bool?>(succeeded),
      'retryOccurred': serializer.toJson<bool>(retryOccurred),
    };
  }

  CompetencyRecoveryExecutionRow copyWith({
    String? recoveryExecutionId,
    String? attemptId,
    String? gapId,
    String? recoveryStepId,
    String? sourceModuleId,
    String? sourceLessonId,
    String? sourceStepId,
    String? status,
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<bool?> succeeded = const Value.absent(),
    bool? retryOccurred,
  }) => CompetencyRecoveryExecutionRow(
    recoveryExecutionId: recoveryExecutionId ?? this.recoveryExecutionId,
    attemptId: attemptId ?? this.attemptId,
    gapId: gapId ?? this.gapId,
    recoveryStepId: recoveryStepId ?? this.recoveryStepId,
    sourceModuleId: sourceModuleId ?? this.sourceModuleId,
    sourceLessonId: sourceLessonId ?? this.sourceLessonId,
    sourceStepId: sourceStepId ?? this.sourceStepId,
    status: status ?? this.status,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    succeeded: succeeded.present ? succeeded.value : this.succeeded,
    retryOccurred: retryOccurred ?? this.retryOccurred,
  );
  CompetencyRecoveryExecutionRow copyWithCompanion(
    CompetencyRecoveryExecutionsCompanion data,
  ) {
    return CompetencyRecoveryExecutionRow(
      recoveryExecutionId: data.recoveryExecutionId.present
          ? data.recoveryExecutionId.value
          : this.recoveryExecutionId,
      attemptId: data.attemptId.present ? data.attemptId.value : this.attemptId,
      gapId: data.gapId.present ? data.gapId.value : this.gapId,
      recoveryStepId: data.recoveryStepId.present
          ? data.recoveryStepId.value
          : this.recoveryStepId,
      sourceModuleId: data.sourceModuleId.present
          ? data.sourceModuleId.value
          : this.sourceModuleId,
      sourceLessonId: data.sourceLessonId.present
          ? data.sourceLessonId.value
          : this.sourceLessonId,
      sourceStepId: data.sourceStepId.present
          ? data.sourceStepId.value
          : this.sourceStepId,
      status: data.status.present ? data.status.value : this.status,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      succeeded: data.succeeded.present ? data.succeeded.value : this.succeeded,
      retryOccurred: data.retryOccurred.present
          ? data.retryOccurred.value
          : this.retryOccurred,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyRecoveryExecutionRow(')
          ..write('recoveryExecutionId: $recoveryExecutionId, ')
          ..write('attemptId: $attemptId, ')
          ..write('gapId: $gapId, ')
          ..write('recoveryStepId: $recoveryStepId, ')
          ..write('sourceModuleId: $sourceModuleId, ')
          ..write('sourceLessonId: $sourceLessonId, ')
          ..write('sourceStepId: $sourceStepId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('succeeded: $succeeded, ')
          ..write('retryOccurred: $retryOccurred')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    recoveryExecutionId,
    attemptId,
    gapId,
    recoveryStepId,
    sourceModuleId,
    sourceLessonId,
    sourceStepId,
    status,
    startedAt,
    completedAt,
    succeeded,
    retryOccurred,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompetencyRecoveryExecutionRow &&
          other.recoveryExecutionId == this.recoveryExecutionId &&
          other.attemptId == this.attemptId &&
          other.gapId == this.gapId &&
          other.recoveryStepId == this.recoveryStepId &&
          other.sourceModuleId == this.sourceModuleId &&
          other.sourceLessonId == this.sourceLessonId &&
          other.sourceStepId == this.sourceStepId &&
          other.status == this.status &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.succeeded == this.succeeded &&
          other.retryOccurred == this.retryOccurred);
}

class CompetencyRecoveryExecutionsCompanion
    extends UpdateCompanion<CompetencyRecoveryExecutionRow> {
  final Value<String> recoveryExecutionId;
  final Value<String> attemptId;
  final Value<String> gapId;
  final Value<String> recoveryStepId;
  final Value<String> sourceModuleId;
  final Value<String> sourceLessonId;
  final Value<String> sourceStepId;
  final Value<String> status;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<bool?> succeeded;
  final Value<bool> retryOccurred;
  final Value<int> rowid;
  const CompetencyRecoveryExecutionsCompanion({
    this.recoveryExecutionId = const Value.absent(),
    this.attemptId = const Value.absent(),
    this.gapId = const Value.absent(),
    this.recoveryStepId = const Value.absent(),
    this.sourceModuleId = const Value.absent(),
    this.sourceLessonId = const Value.absent(),
    this.sourceStepId = const Value.absent(),
    this.status = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.succeeded = const Value.absent(),
    this.retryOccurred = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompetencyRecoveryExecutionsCompanion.insert({
    required String recoveryExecutionId,
    required String attemptId,
    required String gapId,
    required String recoveryStepId,
    required String sourceModuleId,
    required String sourceLessonId,
    required String sourceStepId,
    required String status,
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.succeeded = const Value.absent(),
    this.retryOccurred = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recoveryExecutionId = Value(recoveryExecutionId),
       attemptId = Value(attemptId),
       gapId = Value(gapId),
       recoveryStepId = Value(recoveryStepId),
       sourceModuleId = Value(sourceModuleId),
       sourceLessonId = Value(sourceLessonId),
       sourceStepId = Value(sourceStepId),
       status = Value(status);
  static Insertable<CompetencyRecoveryExecutionRow> custom({
    Expression<String>? recoveryExecutionId,
    Expression<String>? attemptId,
    Expression<String>? gapId,
    Expression<String>? recoveryStepId,
    Expression<String>? sourceModuleId,
    Expression<String>? sourceLessonId,
    Expression<String>? sourceStepId,
    Expression<String>? status,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<bool>? succeeded,
    Expression<bool>? retryOccurred,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recoveryExecutionId != null)
        'recovery_execution_id': recoveryExecutionId,
      if (attemptId != null) 'attempt_id': attemptId,
      if (gapId != null) 'gap_id': gapId,
      if (recoveryStepId != null) 'recovery_step_id': recoveryStepId,
      if (sourceModuleId != null) 'source_module_id': sourceModuleId,
      if (sourceLessonId != null) 'source_lesson_id': sourceLessonId,
      if (sourceStepId != null) 'source_step_id': sourceStepId,
      if (status != null) 'status': status,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (succeeded != null) 'succeeded': succeeded,
      if (retryOccurred != null) 'retry_occurred': retryOccurred,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompetencyRecoveryExecutionsCompanion copyWith({
    Value<String>? recoveryExecutionId,
    Value<String>? attemptId,
    Value<String>? gapId,
    Value<String>? recoveryStepId,
    Value<String>? sourceModuleId,
    Value<String>? sourceLessonId,
    Value<String>? sourceStepId,
    Value<String>? status,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<bool?>? succeeded,
    Value<bool>? retryOccurred,
    Value<int>? rowid,
  }) {
    return CompetencyRecoveryExecutionsCompanion(
      recoveryExecutionId: recoveryExecutionId ?? this.recoveryExecutionId,
      attemptId: attemptId ?? this.attemptId,
      gapId: gapId ?? this.gapId,
      recoveryStepId: recoveryStepId ?? this.recoveryStepId,
      sourceModuleId: sourceModuleId ?? this.sourceModuleId,
      sourceLessonId: sourceLessonId ?? this.sourceLessonId,
      sourceStepId: sourceStepId ?? this.sourceStepId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      succeeded: succeeded ?? this.succeeded,
      retryOccurred: retryOccurred ?? this.retryOccurred,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recoveryExecutionId.present) {
      map['recovery_execution_id'] = Variable<String>(
        recoveryExecutionId.value,
      );
    }
    if (attemptId.present) {
      map['attempt_id'] = Variable<String>(attemptId.value);
    }
    if (gapId.present) {
      map['gap_id'] = Variable<String>(gapId.value);
    }
    if (recoveryStepId.present) {
      map['recovery_step_id'] = Variable<String>(recoveryStepId.value);
    }
    if (sourceModuleId.present) {
      map['source_module_id'] = Variable<String>(sourceModuleId.value);
    }
    if (sourceLessonId.present) {
      map['source_lesson_id'] = Variable<String>(sourceLessonId.value);
    }
    if (sourceStepId.present) {
      map['source_step_id'] = Variable<String>(sourceStepId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (succeeded.present) {
      map['succeeded'] = Variable<bool>(succeeded.value);
    }
    if (retryOccurred.present) {
      map['retry_occurred'] = Variable<bool>(retryOccurred.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompetencyRecoveryExecutionsCompanion(')
          ..write('recoveryExecutionId: $recoveryExecutionId, ')
          ..write('attemptId: $attemptId, ')
          ..write('gapId: $gapId, ')
          ..write('recoveryStepId: $recoveryStepId, ')
          ..write('sourceModuleId: $sourceModuleId, ')
          ..write('sourceLessonId: $sourceLessonId, ')
          ..write('sourceStepId: $sourceStepId, ')
          ..write('status: $status, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('succeeded: $succeeded, ')
          ..write('retryOccurred: $retryOccurred, ')
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
  late final $CompetencyAttemptsTable competencyAttempts =
      $CompetencyAttemptsTable(this);
  late final $CompetencyTaskResultsTable competencyTaskResults =
      $CompetencyTaskResultsTable(this);
  late final $CompetencyGapsTable competencyGaps = $CompetencyGapsTable(this);
  late final $CompetencyRecoveryExecutionsTable competencyRecoveryExecutions =
      $CompetencyRecoveryExecutionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    learnerStates,
    learnerProgressEvents,
    lessonAttempts,
    lessonAttemptStepResults,
    competencyAttempts,
    competencyTaskResults,
    competencyGaps,
    competencyRecoveryExecutions,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'competency_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('competency_task_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'competency_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('competency_gaps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'competency_attempts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('competency_recovery_executions', kind: UpdateKind.delete),
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
      Value<String> attemptPurpose,
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
      Value<String> attemptPurpose,
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

  ColumnFilters<String> get attemptPurpose => $composableBuilder(
    column: $table.attemptPurpose,
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

  ColumnOrderings<String> get attemptPurpose => $composableBuilder(
    column: $table.attemptPurpose,
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

  GeneratedColumn<String> get attemptPurpose => $composableBuilder(
    column: $table.attemptPurpose,
    builder: (column) => column,
  );

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
                Value<String> attemptPurpose = const Value.absent(),
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
                attemptPurpose: attemptPurpose,
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
                Value<String> attemptPurpose = const Value.absent(),
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
                attemptPurpose: attemptPurpose,
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
typedef $$CompetencyAttemptsTableCreateCompanionBuilder =
    CompetencyAttemptsCompanion Function({
      required String attemptId,
      required String competencyId,
      required String moduleId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      required String status,
      Value<String?> finalOutcome,
      required String definitionFingerprint,
      Value<int> rowid,
    });
typedef $$CompetencyAttemptsTableUpdateCompanionBuilder =
    CompetencyAttemptsCompanion Function({
      Value<String> attemptId,
      Value<String> competencyId,
      Value<String> moduleId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<String> status,
      Value<String?> finalOutcome,
      Value<String> definitionFingerprint,
      Value<int> rowid,
    });

final class $$CompetencyAttemptsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompetencyAttemptsTable,
          CompetencyAttemptRow
        > {
  $$CompetencyAttemptsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CompetencyTaskResultsTable,
    List<CompetencyTaskResultRow>
  >
  _competencyTaskResultsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.competencyTaskResults,
    aliasName:
        'competency_attempts__attempt_id__competency_task_results__attempt_id',
  );

  $$CompetencyTaskResultsTableProcessedTableManager
  get competencyTaskResultsRefs {
    final manager =
        $$CompetencyTaskResultsTableTableManager(
          $_db,
          $_db.competencyTaskResults,
        ).filter(
          (f) => f.attemptId.attemptId.sqlEquals(
            $_itemColumn<String>('attempt_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _competencyTaskResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CompetencyGapsTable, List<CompetencyGapRow>>
  _competencyGapsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.competencyGaps,
    aliasName: 'competency_attempts__attempt_id__competency_gaps__attempt_id',
  );

  $$CompetencyGapsTableProcessedTableManager get competencyGapsRefs {
    final manager = $$CompetencyGapsTableTableManager($_db, $_db.competencyGaps)
        .filter(
          (f) => f.attemptId.attemptId.sqlEquals(
            $_itemColumn<String>('attempt_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_competencyGapsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $CompetencyRecoveryExecutionsTable,
    List<CompetencyRecoveryExecutionRow>
  >
  _competencyRecoveryExecutionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.competencyRecoveryExecutions,
    aliasName:
        'competency_attempts__attempt_id__competency_recovery_executions__attempt_id',
  );

  $$CompetencyRecoveryExecutionsTableProcessedTableManager
  get competencyRecoveryExecutionsRefs {
    final manager =
        $$CompetencyRecoveryExecutionsTableTableManager(
          $_db,
          $_db.competencyRecoveryExecutions,
        ).filter(
          (f) => f.attemptId.attemptId.sqlEquals(
            $_itemColumn<String>('attempt_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _competencyRecoveryExecutionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompetencyAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetencyAttemptsTable> {
  $$CompetencyAttemptsTableFilterComposer({
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

  ColumnFilters<String> get competencyId => $composableBuilder(
    column: $table.competencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get finalOutcome => $composableBuilder(
    column: $table.finalOutcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definitionFingerprint => $composableBuilder(
    column: $table.definitionFingerprint,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> competencyTaskResultsRefs(
    Expression<bool> Function($$CompetencyTaskResultsTableFilterComposer f) f,
  ) {
    final $$CompetencyTaskResultsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyTaskResults,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyTaskResultsTableFilterComposer(
                $db: $db,
                $table: $db.competencyTaskResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> competencyGapsRefs(
    Expression<bool> Function($$CompetencyGapsTableFilterComposer f) f,
  ) {
    final $$CompetencyGapsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyGaps,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyGapsTableFilterComposer(
            $db: $db,
            $table: $db.competencyGaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> competencyRecoveryExecutionsRefs(
    Expression<bool> Function(
      $$CompetencyRecoveryExecutionsTableFilterComposer f,
    )
    f,
  ) {
    final $$CompetencyRecoveryExecutionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyRecoveryExecutions,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyRecoveryExecutionsTableFilterComposer(
                $db: $db,
                $table: $db.competencyRecoveryExecutions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CompetencyAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetencyAttemptsTable> {
  $$CompetencyAttemptsTableOrderingComposer({
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

  ColumnOrderings<String> get competencyId => $composableBuilder(
    column: $table.competencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moduleId => $composableBuilder(
    column: $table.moduleId,
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get finalOutcome => $composableBuilder(
    column: $table.finalOutcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definitionFingerprint => $composableBuilder(
    column: $table.definitionFingerprint,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompetencyAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetencyAttemptsTable> {
  $$CompetencyAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get attemptId =>
      $composableBuilder(column: $table.attemptId, builder: (column) => column);

  GeneratedColumn<String> get competencyId => $composableBuilder(
    column: $table.competencyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moduleId =>
      $composableBuilder(column: $table.moduleId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get finalOutcome => $composableBuilder(
    column: $table.finalOutcome,
    builder: (column) => column,
  );

  GeneratedColumn<String> get definitionFingerprint => $composableBuilder(
    column: $table.definitionFingerprint,
    builder: (column) => column,
  );

  Expression<T> competencyTaskResultsRefs<T extends Object>(
    Expression<T> Function($$CompetencyTaskResultsTableAnnotationComposer a) f,
  ) {
    final $$CompetencyTaskResultsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyTaskResults,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyTaskResultsTableAnnotationComposer(
                $db: $db,
                $table: $db.competencyTaskResults,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> competencyGapsRefs<T extends Object>(
    Expression<T> Function($$CompetencyGapsTableAnnotationComposer a) f,
  ) {
    final $$CompetencyGapsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyGaps,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyGapsTableAnnotationComposer(
            $db: $db,
            $table: $db.competencyGaps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> competencyRecoveryExecutionsRefs<T extends Object>(
    Expression<T> Function(
      $$CompetencyRecoveryExecutionsTableAnnotationComposer a,
    )
    f,
  ) {
    final $$CompetencyRecoveryExecutionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyRecoveryExecutions,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyRecoveryExecutionsTableAnnotationComposer(
                $db: $db,
                $table: $db.competencyRecoveryExecutions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CompetencyAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetencyAttemptsTable,
          CompetencyAttemptRow,
          $$CompetencyAttemptsTableFilterComposer,
          $$CompetencyAttemptsTableOrderingComposer,
          $$CompetencyAttemptsTableAnnotationComposer,
          $$CompetencyAttemptsTableCreateCompanionBuilder,
          $$CompetencyAttemptsTableUpdateCompanionBuilder,
          (CompetencyAttemptRow, $$CompetencyAttemptsTableReferences),
          CompetencyAttemptRow,
          PrefetchHooks Function({
            bool competencyTaskResultsRefs,
            bool competencyGapsRefs,
            bool competencyRecoveryExecutionsRefs,
          })
        > {
  $$CompetencyAttemptsTableTableManager(
    _$AppDatabase db,
    $CompetencyAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetencyAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompetencyAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompetencyAttemptsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> attemptId = const Value.absent(),
                Value<String> competencyId = const Value.absent(),
                Value<String> moduleId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> finalOutcome = const Value.absent(),
                Value<String> definitionFingerprint = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompetencyAttemptsCompanion(
                attemptId: attemptId,
                competencyId: competencyId,
                moduleId: moduleId,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                finalOutcome: finalOutcome,
                definitionFingerprint: definitionFingerprint,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String attemptId,
                required String competencyId,
                required String moduleId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                required String status,
                Value<String?> finalOutcome = const Value.absent(),
                required String definitionFingerprint,
                Value<int> rowid = const Value.absent(),
              }) => CompetencyAttemptsCompanion.insert(
                attemptId: attemptId,
                competencyId: competencyId,
                moduleId: moduleId,
                startedAt: startedAt,
                completedAt: completedAt,
                status: status,
                finalOutcome: finalOutcome,
                definitionFingerprint: definitionFingerprint,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompetencyAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                competencyTaskResultsRefs = false,
                competencyGapsRefs = false,
                competencyRecoveryExecutionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (competencyTaskResultsRefs) db.competencyTaskResults,
                    if (competencyGapsRefs) db.competencyGaps,
                    if (competencyRecoveryExecutionsRefs)
                      db.competencyRecoveryExecutions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (competencyTaskResultsRefs)
                        await $_getPrefetchedData<
                          CompetencyAttemptRow,
                          $CompetencyAttemptsTable,
                          CompetencyTaskResultRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetencyAttemptsTableReferences
                              ._competencyTaskResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetencyAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).competencyTaskResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.attemptId,
                              ),
                          typedResults: items,
                        ),
                      if (competencyGapsRefs)
                        await $_getPrefetchedData<
                          CompetencyAttemptRow,
                          $CompetencyAttemptsTable,
                          CompetencyGapRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetencyAttemptsTableReferences
                              ._competencyGapsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetencyAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).competencyGapsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.attemptId == item.attemptId,
                              ),
                          typedResults: items,
                        ),
                      if (competencyRecoveryExecutionsRefs)
                        await $_getPrefetchedData<
                          CompetencyAttemptRow,
                          $CompetencyAttemptsTable,
                          CompetencyRecoveryExecutionRow
                        >(
                          currentTable: table,
                          referencedTable: $$CompetencyAttemptsTableReferences
                              ._competencyRecoveryExecutionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompetencyAttemptsTableReferences(
                                db,
                                table,
                                p0,
                              ).competencyRecoveryExecutionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
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

typedef $$CompetencyAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetencyAttemptsTable,
      CompetencyAttemptRow,
      $$CompetencyAttemptsTableFilterComposer,
      $$CompetencyAttemptsTableOrderingComposer,
      $$CompetencyAttemptsTableAnnotationComposer,
      $$CompetencyAttemptsTableCreateCompanionBuilder,
      $$CompetencyAttemptsTableUpdateCompanionBuilder,
      (CompetencyAttemptRow, $$CompetencyAttemptsTableReferences),
      CompetencyAttemptRow,
      PrefetchHooks Function({
        bool competencyTaskResultsRefs,
        bool competencyGapsRefs,
        bool competencyRecoveryExecutionsRefs,
      })
    >;
typedef $$CompetencyTaskResultsTableCreateCompanionBuilder =
    CompetencyTaskResultsCompanion Function({
      required String resultId,
      required String attemptId,
      required String assessmentTaskId,
      required String microCompetencyIdsJson,
      required int attemptSequence,
      required String phase,
      required String activityResultStatus,
      Value<String?> reasonCode,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CompetencyTaskResultsTableUpdateCompanionBuilder =
    CompetencyTaskResultsCompanion Function({
      Value<String> resultId,
      Value<String> attemptId,
      Value<String> assessmentTaskId,
      Value<String> microCompetencyIdsJson,
      Value<int> attemptSequence,
      Value<String> phase,
      Value<String> activityResultStatus,
      Value<String?> reasonCode,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CompetencyTaskResultsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompetencyTaskResultsTable,
          CompetencyTaskResultRow
        > {
  $$CompetencyTaskResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompetencyAttemptsTable _attemptIdTable(_$AppDatabase db) =>
      db.competencyAttempts.createAlias(
        'competency_task_results__attempt_id__competency_attempts__attempt_id',
      );

  $$CompetencyAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$CompetencyAttemptsTableTableManager(
      $_db,
      $_db.competencyAttempts,
    ).filter((f) => f.attemptId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompetencyTaskResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetencyTaskResultsTable> {
  $$CompetencyTaskResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get microCompetencyIdsJson => $composableBuilder(
    column: $table.microCompetencyIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attemptSequence => $composableBuilder(
    column: $table.attemptSequence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityResultStatus => $composableBuilder(
    column: $table.activityResultStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CompetencyAttemptsTableFilterComposer get attemptId {
    final $$CompetencyAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyTaskResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetencyTaskResultsTable> {
  $$CompetencyTaskResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get resultId => $composableBuilder(
    column: $table.resultId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get microCompetencyIdsJson => $composableBuilder(
    column: $table.microCompetencyIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attemptSequence => $composableBuilder(
    column: $table.attemptSequence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phase => $composableBuilder(
    column: $table.phase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityResultStatus => $composableBuilder(
    column: $table.activityResultStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompetencyAttemptsTableOrderingComposer get attemptId {
    final $$CompetencyAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyTaskResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetencyTaskResultsTable> {
  $$CompetencyTaskResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get resultId =>
      $composableBuilder(column: $table.resultId, builder: (column) => column);

  GeneratedColumn<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get microCompetencyIdsJson => $composableBuilder(
    column: $table.microCompetencyIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attemptSequence => $composableBuilder(
    column: $table.attemptSequence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phase =>
      $composableBuilder(column: $table.phase, builder: (column) => column);

  GeneratedColumn<String> get activityResultStatus => $composableBuilder(
    column: $table.activityResultStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CompetencyAttemptsTableAnnotationComposer get attemptId {
    final $$CompetencyAttemptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyAttempts,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyAttemptsTableAnnotationComposer(
                $db: $db,
                $table: $db.competencyAttempts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompetencyTaskResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetencyTaskResultsTable,
          CompetencyTaskResultRow,
          $$CompetencyTaskResultsTableFilterComposer,
          $$CompetencyTaskResultsTableOrderingComposer,
          $$CompetencyTaskResultsTableAnnotationComposer,
          $$CompetencyTaskResultsTableCreateCompanionBuilder,
          $$CompetencyTaskResultsTableUpdateCompanionBuilder,
          (CompetencyTaskResultRow, $$CompetencyTaskResultsTableReferences),
          CompetencyTaskResultRow,
          PrefetchHooks Function({bool attemptId})
        > {
  $$CompetencyTaskResultsTableTableManager(
    _$AppDatabase db,
    $CompetencyTaskResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetencyTaskResultsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompetencyTaskResultsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompetencyTaskResultsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> resultId = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> assessmentTaskId = const Value.absent(),
                Value<String> microCompetencyIdsJson = const Value.absent(),
                Value<int> attemptSequence = const Value.absent(),
                Value<String> phase = const Value.absent(),
                Value<String> activityResultStatus = const Value.absent(),
                Value<String?> reasonCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompetencyTaskResultsCompanion(
                resultId: resultId,
                attemptId: attemptId,
                assessmentTaskId: assessmentTaskId,
                microCompetencyIdsJson: microCompetencyIdsJson,
                attemptSequence: attemptSequence,
                phase: phase,
                activityResultStatus: activityResultStatus,
                reasonCode: reasonCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String resultId,
                required String attemptId,
                required String assessmentTaskId,
                required String microCompetencyIdsJson,
                required int attemptSequence,
                required String phase,
                required String activityResultStatus,
                Value<String?> reasonCode = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CompetencyTaskResultsCompanion.insert(
                resultId: resultId,
                attemptId: attemptId,
                assessmentTaskId: assessmentTaskId,
                microCompetencyIdsJson: microCompetencyIdsJson,
                attemptSequence: attemptSequence,
                phase: phase,
                activityResultStatus: activityResultStatus,
                reasonCode: reasonCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompetencyTaskResultsTableReferences(db, table, e),
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
                                    $$CompetencyTaskResultsTableReferences
                                        ._attemptIdTable(db),
                                referencedColumn:
                                    $$CompetencyTaskResultsTableReferences
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

typedef $$CompetencyTaskResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetencyTaskResultsTable,
      CompetencyTaskResultRow,
      $$CompetencyTaskResultsTableFilterComposer,
      $$CompetencyTaskResultsTableOrderingComposer,
      $$CompetencyTaskResultsTableAnnotationComposer,
      $$CompetencyTaskResultsTableCreateCompanionBuilder,
      $$CompetencyTaskResultsTableUpdateCompanionBuilder,
      (CompetencyTaskResultRow, $$CompetencyTaskResultsTableReferences),
      CompetencyTaskResultRow,
      PrefetchHooks Function({bool attemptId})
    >;
typedef $$CompetencyGapsTableCreateCompanionBuilder =
    CompetencyGapsCompanion Function({
      required String gapId,
      required String attemptId,
      required String assessmentTaskId,
      required String microCompetencyId,
      required String reasonCode,
      required String sourceModuleId,
      required String sourceLessonId,
      required String sourceStepId,
      required DateTime detectedAt,
      Value<DateTime?> resolvedAt,
      required String resolutionStatus,
      Value<int> rowid,
    });
typedef $$CompetencyGapsTableUpdateCompanionBuilder =
    CompetencyGapsCompanion Function({
      Value<String> gapId,
      Value<String> attemptId,
      Value<String> assessmentTaskId,
      Value<String> microCompetencyId,
      Value<String> reasonCode,
      Value<String> sourceModuleId,
      Value<String> sourceLessonId,
      Value<String> sourceStepId,
      Value<DateTime> detectedAt,
      Value<DateTime?> resolvedAt,
      Value<String> resolutionStatus,
      Value<int> rowid,
    });

final class $$CompetencyGapsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CompetencyGapsTable, CompetencyGapRow> {
  $$CompetencyGapsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompetencyAttemptsTable _attemptIdTable(_$AppDatabase db) =>
      db.competencyAttempts.createAlias(
        'competency_gaps__attempt_id__competency_attempts__attempt_id',
      );

  $$CompetencyAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$CompetencyAttemptsTableTableManager(
      $_db,
      $_db.competencyAttempts,
    ).filter((f) => f.attemptId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompetencyGapsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetencyGapsTable> {
  $$CompetencyGapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gapId => $composableBuilder(
    column: $table.gapId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get microCompetencyId => $composableBuilder(
    column: $table.microCompetencyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => ColumnFilters(column),
  );

  $$CompetencyAttemptsTableFilterComposer get attemptId {
    final $$CompetencyAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyGapsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetencyGapsTable> {
  $$CompetencyGapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gapId => $composableBuilder(
    column: $table.gapId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get microCompetencyId => $composableBuilder(
    column: $table.microCompetencyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompetencyAttemptsTableOrderingComposer get attemptId {
    final $$CompetencyAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyGapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetencyGapsTable> {
  $$CompetencyGapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gapId =>
      $composableBuilder(column: $table.gapId, builder: (column) => column);

  GeneratedColumn<String> get assessmentTaskId => $composableBuilder(
    column: $table.assessmentTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get microCompetencyId => $composableBuilder(
    column: $table.microCompetencyId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get detectedAt => $composableBuilder(
    column: $table.detectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get resolutionStatus => $composableBuilder(
    column: $table.resolutionStatus,
    builder: (column) => column,
  );

  $$CompetencyAttemptsTableAnnotationComposer get attemptId {
    final $$CompetencyAttemptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyAttempts,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyAttemptsTableAnnotationComposer(
                $db: $db,
                $table: $db.competencyAttempts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompetencyGapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetencyGapsTable,
          CompetencyGapRow,
          $$CompetencyGapsTableFilterComposer,
          $$CompetencyGapsTableOrderingComposer,
          $$CompetencyGapsTableAnnotationComposer,
          $$CompetencyGapsTableCreateCompanionBuilder,
          $$CompetencyGapsTableUpdateCompanionBuilder,
          (CompetencyGapRow, $$CompetencyGapsTableReferences),
          CompetencyGapRow,
          PrefetchHooks Function({bool attemptId})
        > {
  $$CompetencyGapsTableTableManager(
    _$AppDatabase db,
    $CompetencyGapsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetencyGapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompetencyGapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompetencyGapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gapId = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> assessmentTaskId = const Value.absent(),
                Value<String> microCompetencyId = const Value.absent(),
                Value<String> reasonCode = const Value.absent(),
                Value<String> sourceModuleId = const Value.absent(),
                Value<String> sourceLessonId = const Value.absent(),
                Value<String> sourceStepId = const Value.absent(),
                Value<DateTime> detectedAt = const Value.absent(),
                Value<DateTime?> resolvedAt = const Value.absent(),
                Value<String> resolutionStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompetencyGapsCompanion(
                gapId: gapId,
                attemptId: attemptId,
                assessmentTaskId: assessmentTaskId,
                microCompetencyId: microCompetencyId,
                reasonCode: reasonCode,
                sourceModuleId: sourceModuleId,
                sourceLessonId: sourceLessonId,
                sourceStepId: sourceStepId,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
                resolutionStatus: resolutionStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gapId,
                required String attemptId,
                required String assessmentTaskId,
                required String microCompetencyId,
                required String reasonCode,
                required String sourceModuleId,
                required String sourceLessonId,
                required String sourceStepId,
                required DateTime detectedAt,
                Value<DateTime?> resolvedAt = const Value.absent(),
                required String resolutionStatus,
                Value<int> rowid = const Value.absent(),
              }) => CompetencyGapsCompanion.insert(
                gapId: gapId,
                attemptId: attemptId,
                assessmentTaskId: assessmentTaskId,
                microCompetencyId: microCompetencyId,
                reasonCode: reasonCode,
                sourceModuleId: sourceModuleId,
                sourceLessonId: sourceLessonId,
                sourceStepId: sourceStepId,
                detectedAt: detectedAt,
                resolvedAt: resolvedAt,
                resolutionStatus: resolutionStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompetencyGapsTableReferences(db, table, e),
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
                                referencedTable: $$CompetencyGapsTableReferences
                                    ._attemptIdTable(db),
                                referencedColumn:
                                    $$CompetencyGapsTableReferences
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

typedef $$CompetencyGapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetencyGapsTable,
      CompetencyGapRow,
      $$CompetencyGapsTableFilterComposer,
      $$CompetencyGapsTableOrderingComposer,
      $$CompetencyGapsTableAnnotationComposer,
      $$CompetencyGapsTableCreateCompanionBuilder,
      $$CompetencyGapsTableUpdateCompanionBuilder,
      (CompetencyGapRow, $$CompetencyGapsTableReferences),
      CompetencyGapRow,
      PrefetchHooks Function({bool attemptId})
    >;
typedef $$CompetencyRecoveryExecutionsTableCreateCompanionBuilder =
    CompetencyRecoveryExecutionsCompanion Function({
      required String recoveryExecutionId,
      required String attemptId,
      required String gapId,
      required String recoveryStepId,
      required String sourceModuleId,
      required String sourceLessonId,
      required String sourceStepId,
      required String status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<bool?> succeeded,
      Value<bool> retryOccurred,
      Value<int> rowid,
    });
typedef $$CompetencyRecoveryExecutionsTableUpdateCompanionBuilder =
    CompetencyRecoveryExecutionsCompanion Function({
      Value<String> recoveryExecutionId,
      Value<String> attemptId,
      Value<String> gapId,
      Value<String> recoveryStepId,
      Value<String> sourceModuleId,
      Value<String> sourceLessonId,
      Value<String> sourceStepId,
      Value<String> status,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<bool?> succeeded,
      Value<bool> retryOccurred,
      Value<int> rowid,
    });

final class $$CompetencyRecoveryExecutionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CompetencyRecoveryExecutionsTable,
          CompetencyRecoveryExecutionRow
        > {
  $$CompetencyRecoveryExecutionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CompetencyAttemptsTable _attemptIdTable(
    _$AppDatabase db,
  ) => db.competencyAttempts.createAlias(
    'competency_recovery_executions__attempt_id__competency_attempts__attempt_id',
  );

  $$CompetencyAttemptsTableProcessedTableManager get attemptId {
    final $_column = $_itemColumn<String>('attempt_id')!;

    final manager = $$CompetencyAttemptsTableTableManager(
      $_db,
      $_db.competencyAttempts,
    ).filter((f) => f.attemptId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_attemptIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompetencyRecoveryExecutionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompetencyRecoveryExecutionsTable> {
  $$CompetencyRecoveryExecutionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get recoveryExecutionId => $composableBuilder(
    column: $table.recoveryExecutionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gapId => $composableBuilder(
    column: $table.gapId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recoveryStepId => $composableBuilder(
    column: $table.recoveryStepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnFilters<bool> get succeeded => $composableBuilder(
    column: $table.succeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get retryOccurred => $composableBuilder(
    column: $table.retryOccurred,
    builder: (column) => ColumnFilters(column),
  );

  $$CompetencyAttemptsTableFilterComposer get attemptId {
    final $$CompetencyAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyRecoveryExecutionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompetencyRecoveryExecutionsTable> {
  $$CompetencyRecoveryExecutionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get recoveryExecutionId => $composableBuilder(
    column: $table.recoveryExecutionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gapId => $composableBuilder(
    column: $table.gapId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recoveryStepId => $composableBuilder(
    column: $table.recoveryStepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
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

  ColumnOrderings<bool> get succeeded => $composableBuilder(
    column: $table.succeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get retryOccurred => $composableBuilder(
    column: $table.retryOccurred,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompetencyAttemptsTableOrderingComposer get attemptId {
    final $$CompetencyAttemptsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.attemptId,
      referencedTable: $db.competencyAttempts,
      getReferencedColumn: (t) => t.attemptId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompetencyAttemptsTableOrderingComposer(
            $db: $db,
            $table: $db.competencyAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompetencyRecoveryExecutionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompetencyRecoveryExecutionsTable> {
  $$CompetencyRecoveryExecutionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get recoveryExecutionId => $composableBuilder(
    column: $table.recoveryExecutionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gapId =>
      $composableBuilder(column: $table.gapId, builder: (column) => column);

  GeneratedColumn<String> get recoveryStepId => $composableBuilder(
    column: $table.recoveryStepId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceModuleId => $composableBuilder(
    column: $table.sourceModuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLessonId => $composableBuilder(
    column: $table.sourceLessonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceStepId => $composableBuilder(
    column: $table.sourceStepId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get succeeded =>
      $composableBuilder(column: $table.succeeded, builder: (column) => column);

  GeneratedColumn<bool> get retryOccurred => $composableBuilder(
    column: $table.retryOccurred,
    builder: (column) => column,
  );

  $$CompetencyAttemptsTableAnnotationComposer get attemptId {
    final $$CompetencyAttemptsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.attemptId,
          referencedTable: $db.competencyAttempts,
          getReferencedColumn: (t) => t.attemptId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CompetencyAttemptsTableAnnotationComposer(
                $db: $db,
                $table: $db.competencyAttempts,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CompetencyRecoveryExecutionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompetencyRecoveryExecutionsTable,
          CompetencyRecoveryExecutionRow,
          $$CompetencyRecoveryExecutionsTableFilterComposer,
          $$CompetencyRecoveryExecutionsTableOrderingComposer,
          $$CompetencyRecoveryExecutionsTableAnnotationComposer,
          $$CompetencyRecoveryExecutionsTableCreateCompanionBuilder,
          $$CompetencyRecoveryExecutionsTableUpdateCompanionBuilder,
          (
            CompetencyRecoveryExecutionRow,
            $$CompetencyRecoveryExecutionsTableReferences,
          ),
          CompetencyRecoveryExecutionRow,
          PrefetchHooks Function({bool attemptId})
        > {
  $$CompetencyRecoveryExecutionsTableTableManager(
    _$AppDatabase db,
    $CompetencyRecoveryExecutionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompetencyRecoveryExecutionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CompetencyRecoveryExecutionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CompetencyRecoveryExecutionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recoveryExecutionId = const Value.absent(),
                Value<String> attemptId = const Value.absent(),
                Value<String> gapId = const Value.absent(),
                Value<String> recoveryStepId = const Value.absent(),
                Value<String> sourceModuleId = const Value.absent(),
                Value<String> sourceLessonId = const Value.absent(),
                Value<String> sourceStepId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool?> succeeded = const Value.absent(),
                Value<bool> retryOccurred = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompetencyRecoveryExecutionsCompanion(
                recoveryExecutionId: recoveryExecutionId,
                attemptId: attemptId,
                gapId: gapId,
                recoveryStepId: recoveryStepId,
                sourceModuleId: sourceModuleId,
                sourceLessonId: sourceLessonId,
                sourceStepId: sourceStepId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                succeeded: succeeded,
                retryOccurred: retryOccurred,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recoveryExecutionId,
                required String attemptId,
                required String gapId,
                required String recoveryStepId,
                required String sourceModuleId,
                required String sourceLessonId,
                required String sourceStepId,
                required String status,
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<bool?> succeeded = const Value.absent(),
                Value<bool> retryOccurred = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompetencyRecoveryExecutionsCompanion.insert(
                recoveryExecutionId: recoveryExecutionId,
                attemptId: attemptId,
                gapId: gapId,
                recoveryStepId: recoveryStepId,
                sourceModuleId: sourceModuleId,
                sourceLessonId: sourceLessonId,
                sourceStepId: sourceStepId,
                status: status,
                startedAt: startedAt,
                completedAt: completedAt,
                succeeded: succeeded,
                retryOccurred: retryOccurred,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CompetencyRecoveryExecutionsTableReferences(db, table, e),
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
                                    $$CompetencyRecoveryExecutionsTableReferences
                                        ._attemptIdTable(db),
                                referencedColumn:
                                    $$CompetencyRecoveryExecutionsTableReferences
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

typedef $$CompetencyRecoveryExecutionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompetencyRecoveryExecutionsTable,
      CompetencyRecoveryExecutionRow,
      $$CompetencyRecoveryExecutionsTableFilterComposer,
      $$CompetencyRecoveryExecutionsTableOrderingComposer,
      $$CompetencyRecoveryExecutionsTableAnnotationComposer,
      $$CompetencyRecoveryExecutionsTableCreateCompanionBuilder,
      $$CompetencyRecoveryExecutionsTableUpdateCompanionBuilder,
      (
        CompetencyRecoveryExecutionRow,
        $$CompetencyRecoveryExecutionsTableReferences,
      ),
      CompetencyRecoveryExecutionRow,
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
  $$CompetencyAttemptsTableTableManager get competencyAttempts =>
      $$CompetencyAttemptsTableTableManager(_db, _db.competencyAttempts);
  $$CompetencyTaskResultsTableTableManager get competencyTaskResults =>
      $$CompetencyTaskResultsTableTableManager(_db, _db.competencyTaskResults);
  $$CompetencyGapsTableTableManager get competencyGaps =>
      $$CompetencyGapsTableTableManager(_db, _db.competencyGaps);
  $$CompetencyRecoveryExecutionsTableTableManager
  get competencyRecoveryExecutions =>
      $$CompetencyRecoveryExecutionsTableTableManager(
        _db,
        _db.competencyRecoveryExecutions,
      );
}
