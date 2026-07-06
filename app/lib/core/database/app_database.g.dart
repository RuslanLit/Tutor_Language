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
  static const VerificationMeta _currentLessonIdMeta = const VerificationMeta(
    'currentLessonId',
  );
  @override
  late final GeneratedColumn<String> currentLessonId = GeneratedColumn<String>(
    'current_lesson_id',
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
    currentLessonId,
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
    if (data.containsKey('current_lesson_id')) {
      context.handle(
        _currentLessonIdMeta,
        currentLessonId.isAcceptableOrUnknown(
          data['current_lesson_id']!,
          _currentLessonIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentLessonIdMeta);
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
      currentLessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_lesson_id'],
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
  final String currentLessonId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const LearnerStateRow({
    required this.id,
    required this.selectedLanguage,
    required this.currentCourseId,
    required this.currentLessonId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['selected_language'] = Variable<String>(selectedLanguage);
    map['current_course_id'] = Variable<String>(currentCourseId);
    map['current_lesson_id'] = Variable<String>(currentLessonId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LearnerStatesCompanion toCompanion(bool nullToAbsent) {
    return LearnerStatesCompanion(
      id: Value(id),
      selectedLanguage: Value(selectedLanguage),
      currentCourseId: Value(currentCourseId),
      currentLessonId: Value(currentLessonId),
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
      currentLessonId: serializer.fromJson<String>(json['currentLessonId']),
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
      'currentLessonId': serializer.toJson<String>(currentLessonId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LearnerStateRow copyWith({
    String? id,
    String? selectedLanguage,
    String? currentCourseId,
    String? currentLessonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LearnerStateRow(
    id: id ?? this.id,
    selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    currentCourseId: currentCourseId ?? this.currentCourseId,
    currentLessonId: currentLessonId ?? this.currentLessonId,
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
      currentLessonId: data.currentLessonId.present
          ? data.currentLessonId.value
          : this.currentLessonId,
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
          ..write('currentLessonId: $currentLessonId, ')
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
    currentLessonId,
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
          other.currentLessonId == this.currentLessonId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LearnerStatesCompanion extends UpdateCompanion<LearnerStateRow> {
  final Value<String> id;
  final Value<String> selectedLanguage;
  final Value<String> currentCourseId;
  final Value<String> currentLessonId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LearnerStatesCompanion({
    this.id = const Value.absent(),
    this.selectedLanguage = const Value.absent(),
    this.currentCourseId = const Value.absent(),
    this.currentLessonId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LearnerStatesCompanion.insert({
    required String id,
    required String selectedLanguage,
    required String currentCourseId,
    required String currentLessonId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       selectedLanguage = Value(selectedLanguage),
       currentCourseId = Value(currentCourseId),
       currentLessonId = Value(currentLessonId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<LearnerStateRow> custom({
    Expression<String>? id,
    Expression<String>? selectedLanguage,
    Expression<String>? currentCourseId,
    Expression<String>? currentLessonId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedLanguage != null) 'selected_language': selectedLanguage,
      if (currentCourseId != null) 'current_course_id': currentCourseId,
      if (currentLessonId != null) 'current_lesson_id': currentLessonId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LearnerStatesCompanion copyWith({
    Value<String>? id,
    Value<String>? selectedLanguage,
    Value<String>? currentCourseId,
    Value<String>? currentLessonId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LearnerStatesCompanion(
      id: id ?? this.id,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentCourseId: currentCourseId ?? this.currentCourseId,
      currentLessonId: currentLessonId ?? this.currentLessonId,
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
    if (currentLessonId.present) {
      map['current_lesson_id'] = Variable<String>(currentLessonId.value);
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
          ..write('currentLessonId: $currentLessonId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LearnerStatesTable learnerStates = $LearnerStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [learnerStates];
}

typedef $$LearnerStatesTableCreateCompanionBuilder =
    LearnerStatesCompanion Function({
      required String id,
      required String selectedLanguage,
      required String currentCourseId,
      required String currentLessonId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$LearnerStatesTableUpdateCompanionBuilder =
    LearnerStatesCompanion Function({
      Value<String> id,
      Value<String> selectedLanguage,
      Value<String> currentCourseId,
      Value<String> currentLessonId,
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

  ColumnFilters<String> get currentLessonId => $composableBuilder(
    column: $table.currentLessonId,
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

  ColumnOrderings<String> get currentLessonId => $composableBuilder(
    column: $table.currentLessonId,
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

  GeneratedColumn<String> get currentLessonId => $composableBuilder(
    column: $table.currentLessonId,
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
                Value<String> currentLessonId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion(
                id: id,
                selectedLanguage: selectedLanguage,
                currentCourseId: currentCourseId,
                currentLessonId: currentLessonId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String selectedLanguage,
                required String currentCourseId,
                required String currentLessonId,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LearnerStatesCompanion.insert(
                id: id,
                selectedLanguage: selectedLanguage,
                currentCourseId: currentCourseId,
                currentLessonId: currentLessonId,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LearnerStatesTableTableManager get learnerStates =>
      $$LearnerStatesTableTableManager(_db, _db.learnerStates);
}
