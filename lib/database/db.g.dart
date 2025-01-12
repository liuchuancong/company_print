// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $DishUnitsTable extends DishUnits
    with TableInfo<$DishUnitsTable, DishUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DishUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _abbreviationMeta =
      const VerificationMeta('abbreviation');
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
      'abbreviation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, abbreviation, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dish_units';
  @override
  VerificationContext validateIntegrity(Insertable<DishUnit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
          _abbreviationMeta,
          abbreviation.isAcceptableOrUnknown(
              data['abbreviation']!, _abbreviationMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DishUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DishUnit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      abbreviation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}abbreviation']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DishUnitsTable createAlias(String alias) {
    return $DishUnitsTable(attachedDatabase, alias);
  }
}

class DishUnit extends DataClass implements Insertable<DishUnit> {
  final int id;
  final String name;
  final String? abbreviation;
  final String? description;
  final DateTime createdAt;
  const DishUnit(
      {required this.id,
      required this.name,
      this.abbreviation,
      this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || abbreviation != null) {
      map['abbreviation'] = Variable<String>(abbreviation);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DishUnitsCompanion toCompanion(bool nullToAbsent) {
    return DishUnitsCompanion(
      id: Value(id),
      name: Value(name),
      abbreviation: abbreviation == null && nullToAbsent
          ? const Value.absent()
          : Value(abbreviation),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory DishUnit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DishUnit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      abbreviation: serializer.fromJson<String?>(json['abbreviation']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'abbreviation': serializer.toJson<String?>(abbreviation),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DishUnit copyWith(
          {int? id,
          String? name,
          Value<String?> abbreviation = const Value.absent(),
          Value<String?> description = const Value.absent(),
          DateTime? createdAt}) =>
      DishUnit(
        id: id ?? this.id,
        name: name ?? this.name,
        abbreviation:
            abbreviation.present ? abbreviation.value : this.abbreviation,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  DishUnit copyWithCompanion(DishUnitsCompanion data) {
    return DishUnit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DishUnit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, abbreviation, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DishUnit &&
          other.id == this.id &&
          other.name == this.name &&
          other.abbreviation == this.abbreviation &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class DishUnitsCompanion extends UpdateCompanion<DishUnit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> abbreviation;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  const DishUnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DishUnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.abbreviation = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<DishUnit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? abbreviation,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DishUnitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? abbreviation,
      Value<String?>? description,
      Value<DateTime>? createdAt}) {
    return DishUnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DishUnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DishesCategoryTable extends DishesCategory
    with TableInfo<$DishesCategoryTable, DishesCategoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DishesCategoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES dishes_category (id) ON DELETE CASCADE'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      '无描述', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentId, description, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dishes_category';
  @override
  VerificationContext validateIntegrity(Insertable<DishesCategoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('无描述')) {
      context.handle(_descriptionMeta,
          description.isAcceptableOrUnknown(data['无描述']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DishesCategoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DishesCategoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}无描述'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DishesCategoryTable createAlias(String alias) {
    return $DishesCategoryTable(attachedDatabase, alias);
  }
}

class DishesCategoryData extends DataClass
    implements Insertable<DishesCategoryData> {
  final int id;
  final String name;
  final int? parentId;
  final String description;
  final DateTime createdAt;
  const DishesCategoryData(
      {required this.id,
      required this.name,
      this.parentId,
      required this.description,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['无描述'] = Variable<String>(description);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DishesCategoryCompanion toCompanion(bool nullToAbsent) {
    return DishesCategoryCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      description: Value(description),
      createdAt: Value(createdAt),
    );
  }

  factory DishesCategoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DishesCategoryData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      description: serializer.fromJson<String>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'description': serializer.toJson<String>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DishesCategoryData copyWith(
          {int? id,
          String? name,
          Value<int?> parentId = const Value.absent(),
          String? description,
          DateTime? createdAt}) =>
      DishesCategoryData(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
      );
  DishesCategoryData copyWithCompanion(DishesCategoryCompanion data) {
    return DishesCategoryData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DishesCategoryData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, description, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DishesCategoryData &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.description == this.description &&
          other.createdAt == this.createdAt);
}

class DishesCategoryCompanion extends UpdateCompanion<DishesCategoryData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<String> description;
  final Value<DateTime> createdAt;
  const DishesCategoryCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DishesCategoryCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required String description,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        description = Value(description);
  static Insertable<DishesCategoryData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (description != null) '无描述': description,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DishesCategoryCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? parentId,
      Value<String>? description,
      Value<DateTime>? createdAt}) {
    return DishesCategoryCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (description.present) {
      map['无描述'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DishesCategoryCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DishUnitsTable dishUnits = $DishUnitsTable(this);
  late final $DishesCategoryTable dishesCategory = $DishesCategoryTable(this);
  late final DishUnitsDao dishUnitsDao = DishUnitsDao(this as AppDatabase);
  late final DishesCategoryDao dishesCategoryDao =
      DishesCategoryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [dishUnits, dishesCategory];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('dishes_category',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('dishes_category', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$DishUnitsTableCreateCompanionBuilder = DishUnitsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> abbreviation,
  Value<String?> description,
  Value<DateTime> createdAt,
});
typedef $$DishUnitsTableUpdateCompanionBuilder = DishUnitsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> abbreviation,
  Value<String?> description,
  Value<DateTime> createdAt,
});

class $$DishUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $DishUnitsTable> {
  $$DishUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$DishUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $DishUnitsTable> {
  $$DishUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DishUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DishUnitsTable> {
  $$DishUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
      column: $table.abbreviation, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DishUnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DishUnitsTable,
    DishUnit,
    $$DishUnitsTableFilterComposer,
    $$DishUnitsTableOrderingComposer,
    $$DishUnitsTableAnnotationComposer,
    $$DishUnitsTableCreateCompanionBuilder,
    $$DishUnitsTableUpdateCompanionBuilder,
    (DishUnit, BaseReferences<_$AppDatabase, $DishUnitsTable, DishUnit>),
    DishUnit,
    PrefetchHooks Function()> {
  $$DishUnitsTableTableManager(_$AppDatabase db, $DishUnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DishUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DishUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DishUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> abbreviation = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DishUnitsCompanion(
            id: id,
            name: name,
            abbreviation: abbreviation,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> abbreviation = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DishUnitsCompanion.insert(
            id: id,
            name: name,
            abbreviation: abbreviation,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DishUnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DishUnitsTable,
    DishUnit,
    $$DishUnitsTableFilterComposer,
    $$DishUnitsTableOrderingComposer,
    $$DishUnitsTableAnnotationComposer,
    $$DishUnitsTableCreateCompanionBuilder,
    $$DishUnitsTableUpdateCompanionBuilder,
    (DishUnit, BaseReferences<_$AppDatabase, $DishUnitsTable, DishUnit>),
    DishUnit,
    PrefetchHooks Function()>;
typedef $$DishesCategoryTableCreateCompanionBuilder = DishesCategoryCompanion
    Function({
  Value<int> id,
  required String name,
  Value<int?> parentId,
  required String description,
  Value<DateTime> createdAt,
});
typedef $$DishesCategoryTableUpdateCompanionBuilder = DishesCategoryCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int?> parentId,
  Value<String> description,
  Value<DateTime> createdAt,
});

final class $$DishesCategoryTableReferences extends BaseReferences<
    _$AppDatabase, $DishesCategoryTable, DishesCategoryData> {
  $$DishesCategoryTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $DishesCategoryTable _parentIdTable(_$AppDatabase db) =>
      db.dishesCategory.createAlias($_aliasNameGenerator(
          db.dishesCategory.parentId, db.dishesCategory.id));

  $$DishesCategoryTableProcessedTableManager? get parentId {
    if ($_item.parentId == null) return null;
    final manager = $$DishesCategoryTableTableManager($_db, $_db.dishesCategory)
        .filter((f) => f.id($_item.parentId!));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DishesCategoryTableFilterComposer
    extends Composer<_$AppDatabase, $DishesCategoryTable> {
  $$DishesCategoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$DishesCategoryTableFilterComposer get parentId {
    final $$DishesCategoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.dishesCategory,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DishesCategoryTableFilterComposer(
              $db: $db,
              $table: $db.dishesCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DishesCategoryTableOrderingComposer
    extends Composer<_$AppDatabase, $DishesCategoryTable> {
  $$DishesCategoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$DishesCategoryTableOrderingComposer get parentId {
    final $$DishesCategoryTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.dishesCategory,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DishesCategoryTableOrderingComposer(
              $db: $db,
              $table: $db.dishesCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DishesCategoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $DishesCategoryTable> {
  $$DishesCategoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DishesCategoryTableAnnotationComposer get parentId {
    final $$DishesCategoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.dishesCategory,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DishesCategoryTableAnnotationComposer(
              $db: $db,
              $table: $db.dishesCategory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DishesCategoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DishesCategoryTable,
    DishesCategoryData,
    $$DishesCategoryTableFilterComposer,
    $$DishesCategoryTableOrderingComposer,
    $$DishesCategoryTableAnnotationComposer,
    $$DishesCategoryTableCreateCompanionBuilder,
    $$DishesCategoryTableUpdateCompanionBuilder,
    (DishesCategoryData, $$DishesCategoryTableReferences),
    DishesCategoryData,
    PrefetchHooks Function({bool parentId})> {
  $$DishesCategoryTableTableManager(
      _$AppDatabase db, $DishesCategoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DishesCategoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DishesCategoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DishesCategoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DishesCategoryCompanion(
            id: id,
            name: name,
            parentId: parentId,
            description: description,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int?> parentId = const Value.absent(),
            required String description,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DishesCategoryCompanion.insert(
            id: id,
            name: name,
            parentId: parentId,
            description: description,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DishesCategoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$DishesCategoryTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$DishesCategoryTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$DishesCategoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DishesCategoryTable,
    DishesCategoryData,
    $$DishesCategoryTableFilterComposer,
    $$DishesCategoryTableOrderingComposer,
    $$DishesCategoryTableAnnotationComposer,
    $$DishesCategoryTableCreateCompanionBuilder,
    $$DishesCategoryTableUpdateCompanionBuilder,
    (DishesCategoryData, $$DishesCategoryTableReferences),
    DishesCategoryData,
    PrefetchHooks Function({bool parentId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DishUnitsTableTableManager get dishUnits =>
      $$DishUnitsTableTableManager(_db, _db.dishUnits);
  $$DishesCategoryTableTableManager get dishesCategory =>
      $$DishesCategoryTableTableManager(_db, _db.dishesCategory);
}
