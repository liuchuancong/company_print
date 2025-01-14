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

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
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
      'name', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _additionalInfoMeta =
      const VerificationMeta('additionalInfo');
  @override
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
      'additional_info', aliasedName, true,
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
      [id, name, phone, address, additionalInfo, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('additional_info')) {
      context.handle(
          _additionalInfoMeta,
          additionalInfo.isAcceptableOrUnknown(
              data['additional_info']!, _additionalInfoMeta));
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
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String? name;
  final String? phone;
  final String? address;
  final String? additionalInfo;
  final DateTime createdAt;
  const Customer(
      {required this.id,
      this.name,
      this.phone,
      this.address,
      this.additionalInfo,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> additionalInfo = const Value.absent(),
          DateTime? createdAt}) =>
      Customer(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        phone: phone.present ? phone.value : this.phone,
        address: address.present ? address.value : this.address,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        createdAt: createdAt ?? this.createdAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, address, additionalInfo, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.additionalInfo == this.additionalInfo &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> additionalInfo;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? additionalInfo,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? phone,
      Value<String?>? address,
      Value<String?>? additionalInfo,
      Value<DateTime>? createdAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      additionalInfo: additionalInfo ?? this.additionalInfo,
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
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (additionalInfo.present) {
      map['additional_info'] = Variable<String>(additionalInfo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomerOrderItemsTable extends CustomerOrderItems
    with TableInfo<$CustomerOrderItemsTable, CustomerOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomerOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES customers (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName =
      GeneratedColumn<String>('item_name', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _itemShortNameMeta =
      const VerificationMeta('itemShortName');
  @override
  late final GeneratedColumn<String> itemShortName = GeneratedColumn<String>(
      'item_short_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseUnitMeta =
      const VerificationMeta('purchaseUnit');
  @override
  late final GeneratedColumn<String> purchaseUnit = GeneratedColumn<String>(
      'purchase_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actualUnitMeta =
      const VerificationMeta('actualUnit');
  @override
  late final GeneratedColumn<String> actualUnit = GeneratedColumn<String>(
      'actual_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseQuantityMeta =
      const VerificationMeta('purchaseQuantity');
  @override
  late final GeneratedColumn<double> purchaseQuantity = GeneratedColumn<double>(
      'purchase_quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actualQuantityMeta =
      const VerificationMeta('actualQuantity');
  @override
  late final GeneratedColumn<double> actualQuantity = GeneratedColumn<double>(
      'actual_quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _presetPriceMeta =
      const VerificationMeta('presetPrice');
  @override
  late final GeneratedColumn<double> presetPrice = GeneratedColumn<double>(
      'preset_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actualPriceMeta =
      const VerificationMeta('actualPrice');
  @override
  late final GeneratedColumn<double> actualPrice = GeneratedColumn<double>(
      'actual_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        itemName,
        itemShortName,
        purchaseUnit,
        actualUnit,
        purchaseQuantity,
        actualQuantity,
        presetPrice,
        actualPrice,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customer_order_items';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerOrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('item_short_name')) {
      context.handle(
          _itemShortNameMeta,
          itemShortName.isAcceptableOrUnknown(
              data['item_short_name']!, _itemShortNameMeta));
    }
    if (data.containsKey('purchase_unit')) {
      context.handle(
          _purchaseUnitMeta,
          purchaseUnit.isAcceptableOrUnknown(
              data['purchase_unit']!, _purchaseUnitMeta));
    }
    if (data.containsKey('actual_unit')) {
      context.handle(
          _actualUnitMeta,
          actualUnit.isAcceptableOrUnknown(
              data['actual_unit']!, _actualUnitMeta));
    }
    if (data.containsKey('purchase_quantity')) {
      context.handle(
          _purchaseQuantityMeta,
          purchaseQuantity.isAcceptableOrUnknown(
              data['purchase_quantity']!, _purchaseQuantityMeta));
    }
    if (data.containsKey('actual_quantity')) {
      context.handle(
          _actualQuantityMeta,
          actualQuantity.isAcceptableOrUnknown(
              data['actual_quantity']!, _actualQuantityMeta));
    }
    if (data.containsKey('preset_price')) {
      context.handle(
          _presetPriceMeta,
          presetPrice.isAcceptableOrUnknown(
              data['preset_price']!, _presetPriceMeta));
    }
    if (data.containsKey('actual_price')) {
      context.handle(
          _actualPriceMeta,
          actualPrice.isAcceptableOrUnknown(
              data['actual_price']!, _actualPriceMeta));
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
  CustomerOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerOrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name'])!,
      itemShortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_short_name']),
      purchaseUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_unit']),
      actualUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actual_unit']),
      purchaseQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}purchase_quantity']),
      actualQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_quantity']),
      presetPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}preset_price']),
      actualPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_price']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomerOrderItemsTable createAlias(String alias) {
    return $CustomerOrderItemsTable(attachedDatabase, alias);
  }
}

class CustomerOrderItem extends DataClass
    implements Insertable<CustomerOrderItem> {
  final int id;
  final int customerId;
  final String itemName;
  final String? itemShortName;
  final String? purchaseUnit;
  final String? actualUnit;
  final double? purchaseQuantity;
  final double? actualQuantity;
  final double? presetPrice;
  final double? actualPrice;
  final DateTime createdAt;
  const CustomerOrderItem(
      {required this.id,
      required this.customerId,
      required this.itemName,
      this.itemShortName,
      this.purchaseUnit,
      this.actualUnit,
      this.purchaseQuantity,
      this.actualQuantity,
      this.presetPrice,
      this.actualPrice,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_id'] = Variable<int>(customerId);
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || itemShortName != null) {
      map['item_short_name'] = Variable<String>(itemShortName);
    }
    if (!nullToAbsent || purchaseUnit != null) {
      map['purchase_unit'] = Variable<String>(purchaseUnit);
    }
    if (!nullToAbsent || actualUnit != null) {
      map['actual_unit'] = Variable<String>(actualUnit);
    }
    if (!nullToAbsent || purchaseQuantity != null) {
      map['purchase_quantity'] = Variable<double>(purchaseQuantity);
    }
    if (!nullToAbsent || actualQuantity != null) {
      map['actual_quantity'] = Variable<double>(actualQuantity);
    }
    if (!nullToAbsent || presetPrice != null) {
      map['preset_price'] = Variable<double>(presetPrice);
    }
    if (!nullToAbsent || actualPrice != null) {
      map['actual_price'] = Variable<double>(actualPrice);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomerOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return CustomerOrderItemsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      itemName: Value(itemName),
      itemShortName: itemShortName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemShortName),
      purchaseUnit: purchaseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUnit),
      actualUnit: actualUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(actualUnit),
      purchaseQuantity: purchaseQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseQuantity),
      actualQuantity: actualQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(actualQuantity),
      presetPrice: presetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(presetPrice),
      actualPrice: actualPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(actualPrice),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerOrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerOrderItem(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int>(json['customerId']),
      itemName: serializer.fromJson<String>(json['itemName']),
      itemShortName: serializer.fromJson<String?>(json['itemShortName']),
      purchaseUnit: serializer.fromJson<String?>(json['purchaseUnit']),
      actualUnit: serializer.fromJson<String?>(json['actualUnit']),
      purchaseQuantity: serializer.fromJson<double?>(json['purchaseQuantity']),
      actualQuantity: serializer.fromJson<double?>(json['actualQuantity']),
      presetPrice: serializer.fromJson<double?>(json['presetPrice']),
      actualPrice: serializer.fromJson<double?>(json['actualPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int>(customerId),
      'itemName': serializer.toJson<String>(itemName),
      'itemShortName': serializer.toJson<String?>(itemShortName),
      'purchaseUnit': serializer.toJson<String?>(purchaseUnit),
      'actualUnit': serializer.toJson<String?>(actualUnit),
      'purchaseQuantity': serializer.toJson<double?>(purchaseQuantity),
      'actualQuantity': serializer.toJson<double?>(actualQuantity),
      'presetPrice': serializer.toJson<double?>(presetPrice),
      'actualPrice': serializer.toJson<double?>(actualPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerOrderItem copyWith(
          {int? id,
          int? customerId,
          String? itemName,
          Value<String?> itemShortName = const Value.absent(),
          Value<String?> purchaseUnit = const Value.absent(),
          Value<String?> actualUnit = const Value.absent(),
          Value<double?> purchaseQuantity = const Value.absent(),
          Value<double?> actualQuantity = const Value.absent(),
          Value<double?> presetPrice = const Value.absent(),
          Value<double?> actualPrice = const Value.absent(),
          DateTime? createdAt}) =>
      CustomerOrderItem(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        itemName: itemName ?? this.itemName,
        itemShortName:
            itemShortName.present ? itemShortName.value : this.itemShortName,
        purchaseUnit:
            purchaseUnit.present ? purchaseUnit.value : this.purchaseUnit,
        actualUnit: actualUnit.present ? actualUnit.value : this.actualUnit,
        purchaseQuantity: purchaseQuantity.present
            ? purchaseQuantity.value
            : this.purchaseQuantity,
        actualQuantity:
            actualQuantity.present ? actualQuantity.value : this.actualQuantity,
        presetPrice: presetPrice.present ? presetPrice.value : this.presetPrice,
        actualPrice: actualPrice.present ? actualPrice.value : this.actualPrice,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomerOrderItem copyWithCompanion(CustomerOrderItemsCompanion data) {
    return CustomerOrderItem(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      itemShortName: data.itemShortName.present
          ? data.itemShortName.value
          : this.itemShortName,
      purchaseUnit: data.purchaseUnit.present
          ? data.purchaseUnit.value
          : this.purchaseUnit,
      actualUnit:
          data.actualUnit.present ? data.actualUnit.value : this.actualUnit,
      purchaseQuantity: data.purchaseQuantity.present
          ? data.purchaseQuantity.value
          : this.purchaseQuantity,
      actualQuantity: data.actualQuantity.present
          ? data.actualQuantity.value
          : this.actualQuantity,
      presetPrice:
          data.presetPrice.present ? data.presetPrice.value : this.presetPrice,
      actualPrice:
          data.actualPrice.present ? data.actualPrice.value : this.actualPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerOrderItem(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('itemName: $itemName, ')
          ..write('itemShortName: $itemShortName, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('actualUnit: $actualUnit, ')
          ..write('purchaseQuantity: $purchaseQuantity, ')
          ..write('actualQuantity: $actualQuantity, ')
          ..write('presetPrice: $presetPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      customerId,
      itemName,
      itemShortName,
      purchaseUnit,
      actualUnit,
      purchaseQuantity,
      actualQuantity,
      presetPrice,
      actualPrice,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerOrderItem &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.itemName == this.itemName &&
          other.itemShortName == this.itemShortName &&
          other.purchaseUnit == this.purchaseUnit &&
          other.actualUnit == this.actualUnit &&
          other.purchaseQuantity == this.purchaseQuantity &&
          other.actualQuantity == this.actualQuantity &&
          other.presetPrice == this.presetPrice &&
          other.actualPrice == this.actualPrice &&
          other.createdAt == this.createdAt);
}

class CustomerOrderItemsCompanion extends UpdateCompanion<CustomerOrderItem> {
  final Value<int> id;
  final Value<int> customerId;
  final Value<String> itemName;
  final Value<String?> itemShortName;
  final Value<String?> purchaseUnit;
  final Value<String?> actualUnit;
  final Value<double?> purchaseQuantity;
  final Value<double?> actualQuantity;
  final Value<double?> presetPrice;
  final Value<double?> actualPrice;
  final Value<DateTime> createdAt;
  const CustomerOrderItemsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.itemShortName = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.actualUnit = const Value.absent(),
    this.purchaseQuantity = const Value.absent(),
    this.actualQuantity = const Value.absent(),
    this.presetPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomerOrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int customerId,
    required String itemName,
    this.itemShortName = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.actualUnit = const Value.absent(),
    this.purchaseQuantity = const Value.absent(),
    this.actualQuantity = const Value.absent(),
    this.presetPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : customerId = Value(customerId),
        itemName = Value(itemName);
  static Insertable<CustomerOrderItem> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? itemName,
    Expression<String>? itemShortName,
    Expression<String>? purchaseUnit,
    Expression<String>? actualUnit,
    Expression<double>? purchaseQuantity,
    Expression<double>? actualQuantity,
    Expression<double>? presetPrice,
    Expression<double>? actualPrice,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (itemName != null) 'item_name': itemName,
      if (itemShortName != null) 'item_short_name': itemShortName,
      if (purchaseUnit != null) 'purchase_unit': purchaseUnit,
      if (actualUnit != null) 'actual_unit': actualUnit,
      if (purchaseQuantity != null) 'purchase_quantity': purchaseQuantity,
      if (actualQuantity != null) 'actual_quantity': actualQuantity,
      if (presetPrice != null) 'preset_price': presetPrice,
      if (actualPrice != null) 'actual_price': actualPrice,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomerOrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? customerId,
      Value<String>? itemName,
      Value<String?>? itemShortName,
      Value<String?>? purchaseUnit,
      Value<String?>? actualUnit,
      Value<double?>? purchaseQuantity,
      Value<double?>? actualQuantity,
      Value<double?>? presetPrice,
      Value<double?>? actualPrice,
      Value<DateTime>? createdAt}) {
    return CustomerOrderItemsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      itemName: itemName ?? this.itemName,
      itemShortName: itemShortName ?? this.itemShortName,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      actualUnit: actualUnit ?? this.actualUnit,
      purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
      actualQuantity: actualQuantity ?? this.actualQuantity,
      presetPrice: presetPrice ?? this.presetPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (itemShortName.present) {
      map['item_short_name'] = Variable<String>(itemShortName.value);
    }
    if (purchaseUnit.present) {
      map['purchase_unit'] = Variable<String>(purchaseUnit.value);
    }
    if (actualUnit.present) {
      map['actual_unit'] = Variable<String>(actualUnit.value);
    }
    if (purchaseQuantity.present) {
      map['purchase_quantity'] = Variable<double>(purchaseQuantity.value);
    }
    if (actualQuantity.present) {
      map['actual_quantity'] = Variable<double>(actualQuantity.value);
    }
    if (presetPrice.present) {
      map['preset_price'] = Variable<double>(presetPrice.value);
    }
    if (actualPrice.present) {
      map['actual_price'] = Variable<double>(actualPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomerOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('itemName: $itemName, ')
          ..write('itemShortName: $itemShortName, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('actualUnit: $actualUnit, ')
          ..write('purchaseQuantity: $purchaseQuantity, ')
          ..write('actualQuantity: $actualQuantity, ')
          ..write('presetPrice: $presetPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderNameMeta =
      const VerificationMeta('orderName');
  @override
  late final GeneratedColumn<String> orderName = GeneratedColumn<String>(
      'order_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _remarkMeta = const VerificationMeta('remark');
  @override
  late final GeneratedColumn<String> remark = GeneratedColumn<String>(
      'remark', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerPhoneMeta =
      const VerificationMeta('customerPhone');
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
      'customer_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customerAddressMeta =
      const VerificationMeta('customerAddress');
  @override
  late final GeneratedColumn<String> customerAddress = GeneratedColumn<String>(
      'customer_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _driverNameMeta =
      const VerificationMeta('driverName');
  @override
  late final GeneratedColumn<String> driverName = GeneratedColumn<String>(
      'driver_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _driverPhoneMeta =
      const VerificationMeta('driverPhone');
  @override
  late final GeneratedColumn<String> driverPhone = GeneratedColumn<String>(
      'driver_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vehiclePlateNumberMeta =
      const VerificationMeta('vehiclePlateNumber');
  @override
  late final GeneratedColumn<String> vehiclePlateNumber =
      GeneratedColumn<String>('vehicle_plate_number', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _advancePaymentMeta =
      const VerificationMeta('advancePayment');
  @override
  late final GeneratedColumn<double> advancePayment = GeneratedColumn<double>(
      'advance_payment', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _itemCountMeta =
      const VerificationMeta('itemCount');
  @override
  late final GeneratedColumn<double> itemCount = GeneratedColumn<double>(
      'item_count', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shippingFeeMeta =
      const VerificationMeta('shippingFee');
  @override
  late final GeneratedColumn<double> shippingFee = GeneratedColumn<double>(
      'shipping_fee', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
      'is_paid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_paid" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderName,
        description,
        remark,
        customerName,
        customerPhone,
        customerAddress,
        driverName,
        driverPhone,
        vehiclePlateNumber,
        advancePayment,
        totalPrice,
        itemCount,
        shippingFee,
        isPaid,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_name')) {
      context.handle(_orderNameMeta,
          orderName.isAcceptableOrUnknown(data['order_name']!, _orderNameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('remark')) {
      context.handle(_remarkMeta,
          remark.isAcceptableOrUnknown(data['remark']!, _remarkMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
          _customerPhoneMeta,
          customerPhone.isAcceptableOrUnknown(
              data['customer_phone']!, _customerPhoneMeta));
    }
    if (data.containsKey('customer_address')) {
      context.handle(
          _customerAddressMeta,
          customerAddress.isAcceptableOrUnknown(
              data['customer_address']!, _customerAddressMeta));
    }
    if (data.containsKey('driver_name')) {
      context.handle(
          _driverNameMeta,
          driverName.isAcceptableOrUnknown(
              data['driver_name']!, _driverNameMeta));
    }
    if (data.containsKey('driver_phone')) {
      context.handle(
          _driverPhoneMeta,
          driverPhone.isAcceptableOrUnknown(
              data['driver_phone']!, _driverPhoneMeta));
    }
    if (data.containsKey('vehicle_plate_number')) {
      context.handle(
          _vehiclePlateNumberMeta,
          vehiclePlateNumber.isAcceptableOrUnknown(
              data['vehicle_plate_number']!, _vehiclePlateNumberMeta));
    }
    if (data.containsKey('advance_payment')) {
      context.handle(
          _advancePaymentMeta,
          advancePayment.isAcceptableOrUnknown(
              data['advance_payment']!, _advancePaymentMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    }
    if (data.containsKey('item_count')) {
      context.handle(_itemCountMeta,
          itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta));
    }
    if (data.containsKey('shipping_fee')) {
      context.handle(
          _shippingFeeMeta,
          shippingFee.isAcceptableOrUnknown(
              data['shipping_fee']!, _shippingFeeMeta));
    }
    if (data.containsKey('is_paid')) {
      context.handle(_isPaidMeta,
          isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta));
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
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      remark: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remark']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      customerPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_phone']),
      customerAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}customer_address']),
      driverName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_name']),
      driverPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_phone']),
      vehiclePlateNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vehicle_plate_number']),
      advancePayment: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}advance_payment']),
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price']),
      itemCount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}item_count']),
      shippingFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shipping_fee']),
      isPaid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_paid'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final int id;
  final String? orderName;
  final String? description;
  final String? remark;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final String? driverName;
  final String? driverPhone;
  final String? vehiclePlateNumber;
  final double? advancePayment;
  final double? totalPrice;
  final double? itemCount;
  final double? shippingFee;
  final bool isPaid;
  final DateTime createdAt;
  const Order(
      {required this.id,
      this.orderName,
      this.description,
      this.remark,
      this.customerName,
      this.customerPhone,
      this.customerAddress,
      this.driverName,
      this.driverPhone,
      this.vehiclePlateNumber,
      this.advancePayment,
      this.totalPrice,
      this.itemCount,
      this.shippingFee,
      required this.isPaid,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || orderName != null) {
      map['order_name'] = Variable<String>(orderName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || remark != null) {
      map['remark'] = Variable<String>(remark);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || customerAddress != null) {
      map['customer_address'] = Variable<String>(customerAddress);
    }
    if (!nullToAbsent || driverName != null) {
      map['driver_name'] = Variable<String>(driverName);
    }
    if (!nullToAbsent || driverPhone != null) {
      map['driver_phone'] = Variable<String>(driverPhone);
    }
    if (!nullToAbsent || vehiclePlateNumber != null) {
      map['vehicle_plate_number'] = Variable<String>(vehiclePlateNumber);
    }
    if (!nullToAbsent || advancePayment != null) {
      map['advance_payment'] = Variable<double>(advancePayment);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['total_price'] = Variable<double>(totalPrice);
    }
    if (!nullToAbsent || itemCount != null) {
      map['item_count'] = Variable<double>(itemCount);
    }
    if (!nullToAbsent || shippingFee != null) {
      map['shipping_fee'] = Variable<double>(shippingFee);
    }
    map['is_paid'] = Variable<bool>(isPaid);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderName: orderName == null && nullToAbsent
          ? const Value.absent()
          : Value(orderName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      remark:
          remark == null && nullToAbsent ? const Value.absent() : Value(remark),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      customerAddress: customerAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAddress),
      driverName: driverName == null && nullToAbsent
          ? const Value.absent()
          : Value(driverName),
      driverPhone: driverPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(driverPhone),
      vehiclePlateNumber: vehiclePlateNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(vehiclePlateNumber),
      advancePayment: advancePayment == null && nullToAbsent
          ? const Value.absent()
          : Value(advancePayment),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      itemCount: itemCount == null && nullToAbsent
          ? const Value.absent()
          : Value(itemCount),
      shippingFee: shippingFee == null && nullToAbsent
          ? const Value.absent()
          : Value(shippingFee),
      isPaid: Value(isPaid),
      createdAt: Value(createdAt),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      orderName: serializer.fromJson<String?>(json['orderName']),
      description: serializer.fromJson<String?>(json['description']),
      remark: serializer.fromJson<String?>(json['remark']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      customerAddress: serializer.fromJson<String?>(json['customerAddress']),
      driverName: serializer.fromJson<String?>(json['driverName']),
      driverPhone: serializer.fromJson<String?>(json['driverPhone']),
      vehiclePlateNumber:
          serializer.fromJson<String?>(json['vehiclePlateNumber']),
      advancePayment: serializer.fromJson<double?>(json['advancePayment']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      itemCount: serializer.fromJson<double?>(json['itemCount']),
      shippingFee: serializer.fromJson<double?>(json['shippingFee']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderName': serializer.toJson<String?>(orderName),
      'description': serializer.toJson<String?>(description),
      'remark': serializer.toJson<String?>(remark),
      'customerName': serializer.toJson<String?>(customerName),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'customerAddress': serializer.toJson<String?>(customerAddress),
      'driverName': serializer.toJson<String?>(driverName),
      'driverPhone': serializer.toJson<String?>(driverPhone),
      'vehiclePlateNumber': serializer.toJson<String?>(vehiclePlateNumber),
      'advancePayment': serializer.toJson<double?>(advancePayment),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'itemCount': serializer.toJson<double?>(itemCount),
      'shippingFee': serializer.toJson<double?>(shippingFee),
      'isPaid': serializer.toJson<bool>(isPaid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Order copyWith(
          {int? id,
          Value<String?> orderName = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> remark = const Value.absent(),
          Value<String?> customerName = const Value.absent(),
          Value<String?> customerPhone = const Value.absent(),
          Value<String?> customerAddress = const Value.absent(),
          Value<String?> driverName = const Value.absent(),
          Value<String?> driverPhone = const Value.absent(),
          Value<String?> vehiclePlateNumber = const Value.absent(),
          Value<double?> advancePayment = const Value.absent(),
          Value<double?> totalPrice = const Value.absent(),
          Value<double?> itemCount = const Value.absent(),
          Value<double?> shippingFee = const Value.absent(),
          bool? isPaid,
          DateTime? createdAt}) =>
      Order(
        id: id ?? this.id,
        orderName: orderName.present ? orderName.value : this.orderName,
        description: description.present ? description.value : this.description,
        remark: remark.present ? remark.value : this.remark,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        customerPhone:
            customerPhone.present ? customerPhone.value : this.customerPhone,
        customerAddress: customerAddress.present
            ? customerAddress.value
            : this.customerAddress,
        driverName: driverName.present ? driverName.value : this.driverName,
        driverPhone: driverPhone.present ? driverPhone.value : this.driverPhone,
        vehiclePlateNumber: vehiclePlateNumber.present
            ? vehiclePlateNumber.value
            : this.vehiclePlateNumber,
        advancePayment:
            advancePayment.present ? advancePayment.value : this.advancePayment,
        totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
        itemCount: itemCount.present ? itemCount.value : this.itemCount,
        shippingFee: shippingFee.present ? shippingFee.value : this.shippingFee,
        isPaid: isPaid ?? this.isPaid,
        createdAt: createdAt ?? this.createdAt,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderName: data.orderName.present ? data.orderName.value : this.orderName,
      description:
          data.description.present ? data.description.value : this.description,
      remark: data.remark.present ? data.remark.value : this.remark,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerAddress: data.customerAddress.present
          ? data.customerAddress.value
          : this.customerAddress,
      driverName:
          data.driverName.present ? data.driverName.value : this.driverName,
      driverPhone:
          data.driverPhone.present ? data.driverPhone.value : this.driverPhone,
      vehiclePlateNumber: data.vehiclePlateNumber.present
          ? data.vehiclePlateNumber.value
          : this.vehiclePlateNumber,
      advancePayment: data.advancePayment.present
          ? data.advancePayment.value
          : this.advancePayment,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      shippingFee:
          data.shippingFee.present ? data.shippingFee.value : this.shippingFee,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderName: $orderName, ')
          ..write('description: $description, ')
          ..write('remark: $remark, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('driverName: $driverName, ')
          ..write('driverPhone: $driverPhone, ')
          ..write('vehiclePlateNumber: $vehiclePlateNumber, ')
          ..write('advancePayment: $advancePayment, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('itemCount: $itemCount, ')
          ..write('shippingFee: $shippingFee, ')
          ..write('isPaid: $isPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderName,
      description,
      remark,
      customerName,
      customerPhone,
      customerAddress,
      driverName,
      driverPhone,
      vehiclePlateNumber,
      advancePayment,
      totalPrice,
      itemCount,
      shippingFee,
      isPaid,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderName == this.orderName &&
          other.description == this.description &&
          other.remark == this.remark &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.customerAddress == this.customerAddress &&
          other.driverName == this.driverName &&
          other.driverPhone == this.driverPhone &&
          other.vehiclePlateNumber == this.vehiclePlateNumber &&
          other.advancePayment == this.advancePayment &&
          other.totalPrice == this.totalPrice &&
          other.itemCount == this.itemCount &&
          other.shippingFee == this.shippingFee &&
          other.isPaid == this.isPaid &&
          other.createdAt == this.createdAt);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String?> orderName;
  final Value<String?> description;
  final Value<String?> remark;
  final Value<String?> customerName;
  final Value<String?> customerPhone;
  final Value<String?> customerAddress;
  final Value<String?> driverName;
  final Value<String?> driverPhone;
  final Value<String?> vehiclePlateNumber;
  final Value<double?> advancePayment;
  final Value<double?> totalPrice;
  final Value<double?> itemCount;
  final Value<double?> shippingFee;
  final Value<bool> isPaid;
  final Value<DateTime> createdAt;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderName = const Value.absent(),
    this.description = const Value.absent(),
    this.remark = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverPhone = const Value.absent(),
    this.vehiclePlateNumber = const Value.absent(),
    this.advancePayment = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.shippingFee = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.orderName = const Value.absent(),
    this.description = const Value.absent(),
    this.remark = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.driverName = const Value.absent(),
    this.driverPhone = const Value.absent(),
    this.vehiclePlateNumber = const Value.absent(),
    this.advancePayment = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.shippingFee = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? orderName,
    Expression<String>? description,
    Expression<String>? remark,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? customerAddress,
    Expression<String>? driverName,
    Expression<String>? driverPhone,
    Expression<String>? vehiclePlateNumber,
    Expression<double>? advancePayment,
    Expression<double>? totalPrice,
    Expression<double>? itemCount,
    Expression<double>? shippingFee,
    Expression<bool>? isPaid,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderName != null) 'order_name': orderName,
      if (description != null) 'description': description,
      if (remark != null) 'remark': remark,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerAddress != null) 'customer_address': customerAddress,
      if (driverName != null) 'driver_name': driverName,
      if (driverPhone != null) 'driver_phone': driverPhone,
      if (vehiclePlateNumber != null)
        'vehicle_plate_number': vehiclePlateNumber,
      if (advancePayment != null) 'advance_payment': advancePayment,
      if (totalPrice != null) 'total_price': totalPrice,
      if (itemCount != null) 'item_count': itemCount,
      if (shippingFee != null) 'shipping_fee': shippingFee,
      if (isPaid != null) 'is_paid': isPaid,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<String?>? orderName,
      Value<String?>? description,
      Value<String?>? remark,
      Value<String?>? customerName,
      Value<String?>? customerPhone,
      Value<String?>? customerAddress,
      Value<String?>? driverName,
      Value<String?>? driverPhone,
      Value<String?>? vehiclePlateNumber,
      Value<double?>? advancePayment,
      Value<double?>? totalPrice,
      Value<double?>? itemCount,
      Value<double?>? shippingFee,
      Value<bool>? isPaid,
      Value<DateTime>? createdAt}) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderName: orderName ?? this.orderName,
      description: description ?? this.description,
      remark: remark ?? this.remark,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehiclePlateNumber: vehiclePlateNumber ?? this.vehiclePlateNumber,
      advancePayment: advancePayment ?? this.advancePayment,
      totalPrice: totalPrice ?? this.totalPrice,
      itemCount: itemCount ?? this.itemCount,
      shippingFee: shippingFee ?? this.shippingFee,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderName.present) {
      map['order_name'] = Variable<String>(orderName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (remark.present) {
      map['remark'] = Variable<String>(remark.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerAddress.present) {
      map['customer_address'] = Variable<String>(customerAddress.value);
    }
    if (driverName.present) {
      map['driver_name'] = Variable<String>(driverName.value);
    }
    if (driverPhone.present) {
      map['driver_phone'] = Variable<String>(driverPhone.value);
    }
    if (vehiclePlateNumber.present) {
      map['vehicle_plate_number'] = Variable<String>(vehiclePlateNumber.value);
    }
    if (advancePayment.present) {
      map['advance_payment'] = Variable<double>(advancePayment.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<double>(itemCount.value);
    }
    if (shippingFee.present) {
      map['shipping_fee'] = Variable<double>(shippingFee.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderName: $orderName, ')
          ..write('description: $description, ')
          ..write('remark: $remark, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('driverName: $driverName, ')
          ..write('driverPhone: $driverPhone, ')
          ..write('vehiclePlateNumber: $vehiclePlateNumber, ')
          ..write('advancePayment: $advancePayment, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('itemCount: $itemCount, ')
          ..write('shippingFee: $shippingFee, ')
          ..write('isPaid: $isPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES orders (id) ON DELETE CASCADE'));
  static const VerificationMeta _itemNameMeta =
      const VerificationMeta('itemName');
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
      'item_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _itemShortNameMeta =
      const VerificationMeta('itemShortName');
  @override
  late final GeneratedColumn<String> itemShortName = GeneratedColumn<String>(
      'item_short_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseUnitMeta =
      const VerificationMeta('purchaseUnit');
  @override
  late final GeneratedColumn<String> purchaseUnit = GeneratedColumn<String>(
      'purchase_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _actualUnitMeta =
      const VerificationMeta('actualUnit');
  @override
  late final GeneratedColumn<String> actualUnit = GeneratedColumn<String>(
      'actual_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _purchaseQuantityMeta =
      const VerificationMeta('purchaseQuantity');
  @override
  late final GeneratedColumn<double> purchaseQuantity = GeneratedColumn<double>(
      'purchase_quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actualQuantityMeta =
      const VerificationMeta('actualQuantity');
  @override
  late final GeneratedColumn<double> actualQuantity = GeneratedColumn<double>(
      'actual_quantity', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _presetPriceMeta =
      const VerificationMeta('presetPrice');
  @override
  late final GeneratedColumn<double> presetPrice = GeneratedColumn<double>(
      'preset_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _actualPriceMeta =
      const VerificationMeta('actualPrice');
  @override
  late final GeneratedColumn<double> actualPrice = GeneratedColumn<double>(
      'actual_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _advancePaymentMeta =
      const VerificationMeta('advancePayment');
  @override
  late final GeneratedColumn<double> advancePayment = GeneratedColumn<double>(
      'advance_payment', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        itemName,
        itemShortName,
        purchaseUnit,
        actualUnit,
        purchaseQuantity,
        actualQuantity,
        presetPrice,
        actualPrice,
        advancePayment,
        totalPrice,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('item_name')) {
      context.handle(_itemNameMeta,
          itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta));
    }
    if (data.containsKey('item_short_name')) {
      context.handle(
          _itemShortNameMeta,
          itemShortName.isAcceptableOrUnknown(
              data['item_short_name']!, _itemShortNameMeta));
    }
    if (data.containsKey('purchase_unit')) {
      context.handle(
          _purchaseUnitMeta,
          purchaseUnit.isAcceptableOrUnknown(
              data['purchase_unit']!, _purchaseUnitMeta));
    }
    if (data.containsKey('actual_unit')) {
      context.handle(
          _actualUnitMeta,
          actualUnit.isAcceptableOrUnknown(
              data['actual_unit']!, _actualUnitMeta));
    }
    if (data.containsKey('purchase_quantity')) {
      context.handle(
          _purchaseQuantityMeta,
          purchaseQuantity.isAcceptableOrUnknown(
              data['purchase_quantity']!, _purchaseQuantityMeta));
    }
    if (data.containsKey('actual_quantity')) {
      context.handle(
          _actualQuantityMeta,
          actualQuantity.isAcceptableOrUnknown(
              data['actual_quantity']!, _actualQuantityMeta));
    }
    if (data.containsKey('preset_price')) {
      context.handle(
          _presetPriceMeta,
          presetPrice.isAcceptableOrUnknown(
              data['preset_price']!, _presetPriceMeta));
    }
    if (data.containsKey('actual_price')) {
      context.handle(
          _actualPriceMeta,
          actualPrice.isAcceptableOrUnknown(
              data['actual_price']!, _actualPriceMeta));
    }
    if (data.containsKey('advance_payment')) {
      context.handle(
          _advancePaymentMeta,
          advancePayment.isAcceptableOrUnknown(
              data['advance_payment']!, _advancePaymentMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
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
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      itemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_name']),
      itemShortName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_short_name']),
      purchaseUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_unit']),
      actualUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actual_unit']),
      purchaseQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}purchase_quantity']),
      actualQuantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_quantity']),
      presetPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}preset_price']),
      actualPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}actual_price']),
      advancePayment: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}advance_payment']),
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final String? itemName;
  final String? itemShortName;
  final String? purchaseUnit;
  final String? actualUnit;
  final double? purchaseQuantity;
  final double? actualQuantity;
  final double? presetPrice;
  final double? actualPrice;
  final double? advancePayment;
  final double? totalPrice;
  final DateTime createdAt;
  const OrderItem(
      {required this.id,
      required this.orderId,
      this.itemName,
      this.itemShortName,
      this.purchaseUnit,
      this.actualUnit,
      this.purchaseQuantity,
      this.actualQuantity,
      this.presetPrice,
      this.actualPrice,
      this.advancePayment,
      this.totalPrice,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    if (!nullToAbsent || itemName != null) {
      map['item_name'] = Variable<String>(itemName);
    }
    if (!nullToAbsent || itemShortName != null) {
      map['item_short_name'] = Variable<String>(itemShortName);
    }
    if (!nullToAbsent || purchaseUnit != null) {
      map['purchase_unit'] = Variable<String>(purchaseUnit);
    }
    if (!nullToAbsent || actualUnit != null) {
      map['actual_unit'] = Variable<String>(actualUnit);
    }
    if (!nullToAbsent || purchaseQuantity != null) {
      map['purchase_quantity'] = Variable<double>(purchaseQuantity);
    }
    if (!nullToAbsent || actualQuantity != null) {
      map['actual_quantity'] = Variable<double>(actualQuantity);
    }
    if (!nullToAbsent || presetPrice != null) {
      map['preset_price'] = Variable<double>(presetPrice);
    }
    if (!nullToAbsent || actualPrice != null) {
      map['actual_price'] = Variable<double>(actualPrice);
    }
    if (!nullToAbsent || advancePayment != null) {
      map['advance_payment'] = Variable<double>(advancePayment);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['total_price'] = Variable<double>(totalPrice);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      itemName: itemName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemName),
      itemShortName: itemShortName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemShortName),
      purchaseUnit: purchaseUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseUnit),
      actualUnit: actualUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(actualUnit),
      purchaseQuantity: purchaseQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseQuantity),
      actualQuantity: actualQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(actualQuantity),
      presetPrice: presetPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(presetPrice),
      actualPrice: actualPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(actualPrice),
      advancePayment: advancePayment == null && nullToAbsent
          ? const Value.absent()
          : Value(advancePayment),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      createdAt: Value(createdAt),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      itemName: serializer.fromJson<String?>(json['itemName']),
      itemShortName: serializer.fromJson<String?>(json['itemShortName']),
      purchaseUnit: serializer.fromJson<String?>(json['purchaseUnit']),
      actualUnit: serializer.fromJson<String?>(json['actualUnit']),
      purchaseQuantity: serializer.fromJson<double?>(json['purchaseQuantity']),
      actualQuantity: serializer.fromJson<double?>(json['actualQuantity']),
      presetPrice: serializer.fromJson<double?>(json['presetPrice']),
      actualPrice: serializer.fromJson<double?>(json['actualPrice']),
      advancePayment: serializer.fromJson<double?>(json['advancePayment']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'itemName': serializer.toJson<String?>(itemName),
      'itemShortName': serializer.toJson<String?>(itemShortName),
      'purchaseUnit': serializer.toJson<String?>(purchaseUnit),
      'actualUnit': serializer.toJson<String?>(actualUnit),
      'purchaseQuantity': serializer.toJson<double?>(purchaseQuantity),
      'actualQuantity': serializer.toJson<double?>(actualQuantity),
      'presetPrice': serializer.toJson<double?>(presetPrice),
      'actualPrice': serializer.toJson<double?>(actualPrice),
      'advancePayment': serializer.toJson<double?>(advancePayment),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          Value<String?> itemName = const Value.absent(),
          Value<String?> itemShortName = const Value.absent(),
          Value<String?> purchaseUnit = const Value.absent(),
          Value<String?> actualUnit = const Value.absent(),
          Value<double?> purchaseQuantity = const Value.absent(),
          Value<double?> actualQuantity = const Value.absent(),
          Value<double?> presetPrice = const Value.absent(),
          Value<double?> actualPrice = const Value.absent(),
          Value<double?> advancePayment = const Value.absent(),
          Value<double?> totalPrice = const Value.absent(),
          DateTime? createdAt}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        itemName: itemName.present ? itemName.value : this.itemName,
        itemShortName:
            itemShortName.present ? itemShortName.value : this.itemShortName,
        purchaseUnit:
            purchaseUnit.present ? purchaseUnit.value : this.purchaseUnit,
        actualUnit: actualUnit.present ? actualUnit.value : this.actualUnit,
        purchaseQuantity: purchaseQuantity.present
            ? purchaseQuantity.value
            : this.purchaseQuantity,
        actualQuantity:
            actualQuantity.present ? actualQuantity.value : this.actualQuantity,
        presetPrice: presetPrice.present ? presetPrice.value : this.presetPrice,
        actualPrice: actualPrice.present ? actualPrice.value : this.actualPrice,
        advancePayment:
            advancePayment.present ? advancePayment.value : this.advancePayment,
        totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
        createdAt: createdAt ?? this.createdAt,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      itemShortName: data.itemShortName.present
          ? data.itemShortName.value
          : this.itemShortName,
      purchaseUnit: data.purchaseUnit.present
          ? data.purchaseUnit.value
          : this.purchaseUnit,
      actualUnit:
          data.actualUnit.present ? data.actualUnit.value : this.actualUnit,
      purchaseQuantity: data.purchaseQuantity.present
          ? data.purchaseQuantity.value
          : this.purchaseQuantity,
      actualQuantity: data.actualQuantity.present
          ? data.actualQuantity.value
          : this.actualQuantity,
      presetPrice:
          data.presetPrice.present ? data.presetPrice.value : this.presetPrice,
      actualPrice:
          data.actualPrice.present ? data.actualPrice.value : this.actualPrice,
      advancePayment: data.advancePayment.present
          ? data.advancePayment.value
          : this.advancePayment,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemName: $itemName, ')
          ..write('itemShortName: $itemShortName, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('actualUnit: $actualUnit, ')
          ..write('purchaseQuantity: $purchaseQuantity, ')
          ..write('actualQuantity: $actualQuantity, ')
          ..write('presetPrice: $presetPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('advancePayment: $advancePayment, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderId,
      itemName,
      itemShortName,
      purchaseUnit,
      actualUnit,
      purchaseQuantity,
      actualQuantity,
      presetPrice,
      actualPrice,
      advancePayment,
      totalPrice,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.itemName == this.itemName &&
          other.itemShortName == this.itemShortName &&
          other.purchaseUnit == this.purchaseUnit &&
          other.actualUnit == this.actualUnit &&
          other.purchaseQuantity == this.purchaseQuantity &&
          other.actualQuantity == this.actualQuantity &&
          other.presetPrice == this.presetPrice &&
          other.actualPrice == this.actualPrice &&
          other.advancePayment == this.advancePayment &&
          other.totalPrice == this.totalPrice &&
          other.createdAt == this.createdAt);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<String?> itemName;
  final Value<String?> itemShortName;
  final Value<String?> purchaseUnit;
  final Value<String?> actualUnit;
  final Value<double?> purchaseQuantity;
  final Value<double?> actualQuantity;
  final Value<double?> presetPrice;
  final Value<double?> actualPrice;
  final Value<double?> advancePayment;
  final Value<double?> totalPrice;
  final Value<DateTime> createdAt;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.itemName = const Value.absent(),
    this.itemShortName = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.actualUnit = const Value.absent(),
    this.purchaseQuantity = const Value.absent(),
    this.actualQuantity = const Value.absent(),
    this.presetPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.advancePayment = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    this.itemName = const Value.absent(),
    this.itemShortName = const Value.absent(),
    this.purchaseUnit = const Value.absent(),
    this.actualUnit = const Value.absent(),
    this.purchaseQuantity = const Value.absent(),
    this.actualQuantity = const Value.absent(),
    this.presetPrice = const Value.absent(),
    this.actualPrice = const Value.absent(),
    this.advancePayment = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : orderId = Value(orderId);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<String>? itemName,
    Expression<String>? itemShortName,
    Expression<String>? purchaseUnit,
    Expression<String>? actualUnit,
    Expression<double>? purchaseQuantity,
    Expression<double>? actualQuantity,
    Expression<double>? presetPrice,
    Expression<double>? actualPrice,
    Expression<double>? advancePayment,
    Expression<double>? totalPrice,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (itemName != null) 'item_name': itemName,
      if (itemShortName != null) 'item_short_name': itemShortName,
      if (purchaseUnit != null) 'purchase_unit': purchaseUnit,
      if (actualUnit != null) 'actual_unit': actualUnit,
      if (purchaseQuantity != null) 'purchase_quantity': purchaseQuantity,
      if (actualQuantity != null) 'actual_quantity': actualQuantity,
      if (presetPrice != null) 'preset_price': presetPrice,
      if (actualPrice != null) 'actual_price': actualPrice,
      if (advancePayment != null) 'advance_payment': advancePayment,
      if (totalPrice != null) 'total_price': totalPrice,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<String?>? itemName,
      Value<String?>? itemShortName,
      Value<String?>? purchaseUnit,
      Value<String?>? actualUnit,
      Value<double?>? purchaseQuantity,
      Value<double?>? actualQuantity,
      Value<double?>? presetPrice,
      Value<double?>? actualPrice,
      Value<double?>? advancePayment,
      Value<double?>? totalPrice,
      Value<DateTime>? createdAt}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      itemName: itemName ?? this.itemName,
      itemShortName: itemShortName ?? this.itemShortName,
      purchaseUnit: purchaseUnit ?? this.purchaseUnit,
      actualUnit: actualUnit ?? this.actualUnit,
      purchaseQuantity: purchaseQuantity ?? this.purchaseQuantity,
      actualQuantity: actualQuantity ?? this.actualQuantity,
      presetPrice: presetPrice ?? this.presetPrice,
      actualPrice: actualPrice ?? this.actualPrice,
      advancePayment: advancePayment ?? this.advancePayment,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (itemShortName.present) {
      map['item_short_name'] = Variable<String>(itemShortName.value);
    }
    if (purchaseUnit.present) {
      map['purchase_unit'] = Variable<String>(purchaseUnit.value);
    }
    if (actualUnit.present) {
      map['actual_unit'] = Variable<String>(actualUnit.value);
    }
    if (purchaseQuantity.present) {
      map['purchase_quantity'] = Variable<double>(purchaseQuantity.value);
    }
    if (actualQuantity.present) {
      map['actual_quantity'] = Variable<double>(actualQuantity.value);
    }
    if (presetPrice.present) {
      map['preset_price'] = Variable<double>(presetPrice.value);
    }
    if (actualPrice.present) {
      map['actual_price'] = Variable<double>(actualPrice.value);
    }
    if (advancePayment.present) {
      map['advance_payment'] = Variable<double>(advancePayment.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('itemName: $itemName, ')
          ..write('itemShortName: $itemShortName, ')
          ..write('purchaseUnit: $purchaseUnit, ')
          ..write('actualUnit: $actualUnit, ')
          ..write('purchaseQuantity: $purchaseQuantity, ')
          ..write('actualQuantity: $actualQuantity, ')
          ..write('presetPrice: $presetPrice, ')
          ..write('actualPrice: $actualPrice, ')
          ..write('advancePayment: $advancePayment, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _driverNameMeta =
      const VerificationMeta('driverName');
  @override
  late final GeneratedColumn<String> driverName = GeneratedColumn<String>(
      'driver_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _plateNumberMeta =
      const VerificationMeta('plateNumber');
  @override
  late final GeneratedColumn<String> plateNumber = GeneratedColumn<String>(
      'plate_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _driverPhoneMeta =
      const VerificationMeta('driverPhone');
  @override
  late final GeneratedColumn<String> driverPhone = GeneratedColumn<String>(
      'driver_phone', aliasedName, true,
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
      [id, driverName, plateNumber, driverPhone, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('driver_name')) {
      context.handle(
          _driverNameMeta,
          driverName.isAcceptableOrUnknown(
              data['driver_name']!, _driverNameMeta));
    }
    if (data.containsKey('plate_number')) {
      context.handle(
          _plateNumberMeta,
          plateNumber.isAcceptableOrUnknown(
              data['plate_number']!, _plateNumberMeta));
    }
    if (data.containsKey('driver_phone')) {
      context.handle(
          _driverPhoneMeta,
          driverPhone.isAcceptableOrUnknown(
              data['driver_phone']!, _driverPhoneMeta));
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
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      driverName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_name']),
      plateNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plate_number']),
      driverPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}driver_phone']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String? driverName;
  final String? plateNumber;
  final String? driverPhone;
  final DateTime createdAt;
  const Vehicle(
      {required this.id,
      this.driverName,
      this.plateNumber,
      this.driverPhone,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || driverName != null) {
      map['driver_name'] = Variable<String>(driverName);
    }
    if (!nullToAbsent || plateNumber != null) {
      map['plate_number'] = Variable<String>(plateNumber);
    }
    if (!nullToAbsent || driverPhone != null) {
      map['driver_phone'] = Variable<String>(driverPhone);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      driverName: driverName == null && nullToAbsent
          ? const Value.absent()
          : Value(driverName),
      plateNumber: plateNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(plateNumber),
      driverPhone: driverPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(driverPhone),
      createdAt: Value(createdAt),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      driverName: serializer.fromJson<String?>(json['driverName']),
      plateNumber: serializer.fromJson<String?>(json['plateNumber']),
      driverPhone: serializer.fromJson<String?>(json['driverPhone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'driverName': serializer.toJson<String?>(driverName),
      'plateNumber': serializer.toJson<String?>(plateNumber),
      'driverPhone': serializer.toJson<String?>(driverPhone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Vehicle copyWith(
          {int? id,
          Value<String?> driverName = const Value.absent(),
          Value<String?> plateNumber = const Value.absent(),
          Value<String?> driverPhone = const Value.absent(),
          DateTime? createdAt}) =>
      Vehicle(
        id: id ?? this.id,
        driverName: driverName.present ? driverName.value : this.driverName,
        plateNumber: plateNumber.present ? plateNumber.value : this.plateNumber,
        driverPhone: driverPhone.present ? driverPhone.value : this.driverPhone,
        createdAt: createdAt ?? this.createdAt,
      );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      driverName:
          data.driverName.present ? data.driverName.value : this.driverName,
      plateNumber:
          data.plateNumber.present ? data.plateNumber.value : this.plateNumber,
      driverPhone:
          data.driverPhone.present ? data.driverPhone.value : this.driverPhone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('driverName: $driverName, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('driverPhone: $driverPhone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, driverName, plateNumber, driverPhone, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.driverName == this.driverName &&
          other.plateNumber == this.plateNumber &&
          other.driverPhone == this.driverPhone &&
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String?> driverName;
  final Value<String?> plateNumber;
  final Value<String?> driverPhone;
  final Value<DateTime> createdAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.driverName = const Value.absent(),
    this.plateNumber = const Value.absent(),
    this.driverPhone = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    this.driverName = const Value.absent(),
    this.plateNumber = const Value.absent(),
    this.driverPhone = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? driverName,
    Expression<String>? plateNumber,
    Expression<String>? driverPhone,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (driverName != null) 'driver_name': driverName,
      if (plateNumber != null) 'plate_number': plateNumber,
      if (driverPhone != null) 'driver_phone': driverPhone,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VehiclesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? driverName,
      Value<String?>? plateNumber,
      Value<String?>? driverPhone,
      Value<DateTime>? createdAt}) {
    return VehiclesCompanion(
      id: id ?? this.id,
      driverName: driverName ?? this.driverName,
      plateNumber: plateNumber ?? this.plateNumber,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (driverName.present) {
      map['driver_name'] = Variable<String>(driverName.value);
    }
    if (plateNumber.present) {
      map['plate_number'] = Variable<String>(plateNumber.value);
    }
    if (driverPhone.present) {
      map['driver_phone'] = Variable<String>(driverPhone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('driverName: $driverName, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('driverPhone: $driverPhone, ')
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
  late final $CustomersTable customers = $CustomersTable(this);
  late final $CustomerOrderItemsTable customerOrderItems =
      $CustomerOrderItemsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final DishUnitsDao dishUnitsDao = DishUnitsDao(this as AppDatabase);
  late final DishesCategoryDao dishesCategoryDao =
      DishesCategoryDao(this as AppDatabase);
  late final CustomerDao customerDao = CustomerDao(this as AppDatabase);
  late final CustomerOrderItemsDao customerOrderItemsDao =
      CustomerOrderItemsDao(this as AppDatabase);
  late final OrderItemsDao orderItemsDao = OrderItemsDao(this as AppDatabase);
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final VehicleDao vehicleDao = VehicleDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        dishUnits,
        dishesCategory,
        customers,
        customerOrderItems,
        orders,
        orderItems,
        vehicles
      ];
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
          WritePropagation(
            on: TableUpdateQuery.onTableName('customers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('customer_order_items', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('orders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('order_items', kind: UpdateKind.delete),
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
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> additionalInfo,
  Value<DateTime> createdAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String?> name,
  Value<String?> phone,
  Value<String?> address,
  Value<String?> additionalInfo,
  Value<DateTime> createdAt,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomerOrderItemsTable, List<CustomerOrderItem>>
      _customerOrderItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.customerOrderItems,
              aliasName: $_aliasNameGenerator(
                  db.customers.id, db.customerOrderItems.customerId));

  $$CustomerOrderItemsTableProcessedTableManager get customerOrderItemsRefs {
    final manager =
        $$CustomerOrderItemsTableTableManager($_db, $_db.customerOrderItems)
            .filter((f) => f.customerId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_customerOrderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
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

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> customerOrderItemsRefs(
      Expression<bool> Function($$CustomerOrderItemsTableFilterComposer f) f) {
    final $$CustomerOrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.customerOrderItems,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomerOrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.customerOrderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
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

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
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

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customerOrderItemsRefs<T extends Object>(
      Expression<T> Function($$CustomerOrderItemsTableAnnotationComposer a) f) {
    final $$CustomerOrderItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.customerOrderItems,
            getReferencedColumn: (t) => t.customerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CustomerOrderItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.customerOrderItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool customerOrderItemsRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            address: address,
            additionalInfo: additionalInfo,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            address: address,
            additionalInfo: additionalInfo,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerOrderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (customerOrderItemsRefs) db.customerOrderItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customerOrderItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._customerOrderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .customerOrderItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool customerOrderItemsRefs})>;
typedef $$CustomerOrderItemsTableCreateCompanionBuilder
    = CustomerOrderItemsCompanion Function({
  Value<int> id,
  required int customerId,
  required String itemName,
  Value<String?> itemShortName,
  Value<String?> purchaseUnit,
  Value<String?> actualUnit,
  Value<double?> purchaseQuantity,
  Value<double?> actualQuantity,
  Value<double?> presetPrice,
  Value<double?> actualPrice,
  Value<DateTime> createdAt,
});
typedef $$CustomerOrderItemsTableUpdateCompanionBuilder
    = CustomerOrderItemsCompanion Function({
  Value<int> id,
  Value<int> customerId,
  Value<String> itemName,
  Value<String?> itemShortName,
  Value<String?> purchaseUnit,
  Value<String?> actualUnit,
  Value<double?> purchaseQuantity,
  Value<double?> actualQuantity,
  Value<double?> presetPrice,
  Value<double?> actualPrice,
  Value<DateTime> createdAt,
});

final class $$CustomerOrderItemsTableReferences extends BaseReferences<
    _$AppDatabase, $CustomerOrderItemsTable, CustomerOrderItem> {
  $$CustomerOrderItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias($_aliasNameGenerator(
          db.customerOrderItems.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager get customerId {
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id($_item.customerId));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CustomerOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomerOrderItemsTable> {
  $$CustomerOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomerOrderItemsTable> {
  $$CustomerOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomerOrderItemsTable> {
  $$CustomerOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName, builder: (column) => column);

  GeneratedColumn<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => column);

  GeneratedColumn<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => column);

  GeneratedColumn<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity, builder: (column) => column);

  GeneratedColumn<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity, builder: (column) => column);

  GeneratedColumn<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => column);

  GeneratedColumn<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CustomerOrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomerOrderItemsTable,
    CustomerOrderItem,
    $$CustomerOrderItemsTableFilterComposer,
    $$CustomerOrderItemsTableOrderingComposer,
    $$CustomerOrderItemsTableAnnotationComposer,
    $$CustomerOrderItemsTableCreateCompanionBuilder,
    $$CustomerOrderItemsTableUpdateCompanionBuilder,
    (CustomerOrderItem, $$CustomerOrderItemsTableReferences),
    CustomerOrderItem,
    PrefetchHooks Function({bool customerId})> {
  $$CustomerOrderItemsTableTableManager(
      _$AppDatabase db, $CustomerOrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomerOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomerOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomerOrderItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> customerId = const Value.absent(),
            Value<String> itemName = const Value.absent(),
            Value<String?> itemShortName = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<String?> actualUnit = const Value.absent(),
            Value<double?> purchaseQuantity = const Value.absent(),
            Value<double?> actualQuantity = const Value.absent(),
            Value<double?> presetPrice = const Value.absent(),
            Value<double?> actualPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerOrderItemsCompanion(
            id: id,
            customerId: customerId,
            itemName: itemName,
            itemShortName: itemShortName,
            purchaseUnit: purchaseUnit,
            actualUnit: actualUnit,
            purchaseQuantity: purchaseQuantity,
            actualQuantity: actualQuantity,
            presetPrice: presetPrice,
            actualPrice: actualPrice,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int customerId,
            required String itemName,
            Value<String?> itemShortName = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<String?> actualUnit = const Value.absent(),
            Value<double?> purchaseQuantity = const Value.absent(),
            Value<double?> actualQuantity = const Value.absent(),
            Value<double?> presetPrice = const Value.absent(),
            Value<double?> actualPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              CustomerOrderItemsCompanion.insert(
            id: id,
            customerId: customerId,
            itemName: itemName,
            itemShortName: itemShortName,
            purchaseUnit: purchaseUnit,
            actualUnit: actualUnit,
            purchaseQuantity: purchaseQuantity,
            actualQuantity: actualQuantity,
            presetPrice: presetPrice,
            actualPrice: actualPrice,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomerOrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({customerId = false}) {
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
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable: $$CustomerOrderItemsTableReferences
                        ._customerIdTable(db),
                    referencedColumn: $$CustomerOrderItemsTableReferences
                        ._customerIdTable(db)
                        .id,
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

typedef $$CustomerOrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomerOrderItemsTable,
    CustomerOrderItem,
    $$CustomerOrderItemsTableFilterComposer,
    $$CustomerOrderItemsTableOrderingComposer,
    $$CustomerOrderItemsTableAnnotationComposer,
    $$CustomerOrderItemsTableCreateCompanionBuilder,
    $$CustomerOrderItemsTableUpdateCompanionBuilder,
    (CustomerOrderItem, $$CustomerOrderItemsTableReferences),
    CustomerOrderItem,
    PrefetchHooks Function({bool customerId})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String?> orderName,
  Value<String?> description,
  Value<String?> remark,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<String?> customerAddress,
  Value<String?> driverName,
  Value<String?> driverPhone,
  Value<String?> vehiclePlateNumber,
  Value<double?> advancePayment,
  Value<double?> totalPrice,
  Value<double?> itemCount,
  Value<double?> shippingFee,
  Value<bool> isPaid,
  Value<DateTime> createdAt,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String?> orderName,
  Value<String?> description,
  Value<String?> remark,
  Value<String?> customerName,
  Value<String?> customerPhone,
  Value<String?> customerAddress,
  Value<String?> driverName,
  Value<String?> driverPhone,
  Value<String?> vehiclePlateNumber,
  Value<double?> advancePayment,
  Value<double?> totalPrice,
  Value<double?> itemCount,
  Value<double?> shippingFee,
  Value<bool> isPaid,
  Value<DateTime> createdAt,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderName => $composableBuilder(
      column: $table.orderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remark => $composableBuilder(
      column: $table.remark, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vehiclePlateNumber => $composableBuilder(
      column: $table.vehiclePlateNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get shippingFee => $composableBuilder(
      column: $table.shippingFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderName => $composableBuilder(
      column: $table.orderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remark => $composableBuilder(
      column: $table.remark, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vehiclePlateNumber => $composableBuilder(
      column: $table.vehiclePlateNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get itemCount => $composableBuilder(
      column: $table.itemCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get shippingFee => $composableBuilder(
      column: $table.shippingFee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPaid => $composableBuilder(
      column: $table.isPaid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderName =>
      $composableBuilder(column: $table.orderName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get remark =>
      $composableBuilder(column: $table.remark, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get customerPhone => $composableBuilder(
      column: $table.customerPhone, builder: (column) => column);

  GeneratedColumn<String> get customerAddress => $composableBuilder(
      column: $table.customerAddress, builder: (column) => column);

  GeneratedColumn<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => column);

  GeneratedColumn<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => column);

  GeneratedColumn<String> get vehiclePlateNumber => $composableBuilder(
      column: $table.vehiclePlateNumber, builder: (column) => column);

  GeneratedColumn<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<double> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<double> get shippingFee => $composableBuilder(
      column: $table.shippingFee, builder: (column) => column);

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool orderItemsRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> orderName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> remark = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> customerAddress = const Value.absent(),
            Value<String?> driverName = const Value.absent(),
            Value<String?> driverPhone = const Value.absent(),
            Value<String?> vehiclePlateNumber = const Value.absent(),
            Value<double?> advancePayment = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<double?> itemCount = const Value.absent(),
            Value<double?> shippingFee = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            orderName: orderName,
            description: description,
            remark: remark,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            driverName: driverName,
            driverPhone: driverPhone,
            vehiclePlateNumber: vehiclePlateNumber,
            advancePayment: advancePayment,
            totalPrice: totalPrice,
            itemCount: itemCount,
            shippingFee: shippingFee,
            isPaid: isPaid,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> orderName = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> remark = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> customerPhone = const Value.absent(),
            Value<String?> customerAddress = const Value.absent(),
            Value<String?> driverName = const Value.absent(),
            Value<String?> driverPhone = const Value.absent(),
            Value<String?> vehiclePlateNumber = const Value.absent(),
            Value<double?> advancePayment = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<double?> itemCount = const Value.absent(),
            Value<double?> shippingFee = const Value.absent(),
            Value<bool> isPaid = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            orderName: orderName,
            description: description,
            remark: remark,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            driverName: driverName,
            driverPhone: driverPhone,
            vehiclePlateNumber: vehiclePlateNumber,
            advancePayment: advancePayment,
            totalPrice: totalPrice,
            itemCount: itemCount,
            shippingFee: shippingFee,
            isPaid: isPaid,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool orderItemsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  Value<String?> itemName,
  Value<String?> itemShortName,
  Value<String?> purchaseUnit,
  Value<String?> actualUnit,
  Value<double?> purchaseQuantity,
  Value<double?> actualQuantity,
  Value<double?> presetPrice,
  Value<double?> actualPrice,
  Value<double?> advancePayment,
  Value<double?> totalPrice,
  Value<DateTime> createdAt,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<String?> itemName,
  Value<String?> itemShortName,
  Value<String?> purchaseUnit,
  Value<String?> actualUnit,
  Value<double?> purchaseQuantity,
  Value<double?> actualQuantity,
  Value<double?> presetPrice,
  Value<double?> actualPrice,
  Value<double?> advancePayment,
  Value<double?> totalPrice,
  Value<DateTime> createdAt,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id($_item.orderId));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemName => $composableBuilder(
      column: $table.itemName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get itemShortName => $composableBuilder(
      column: $table.itemShortName, builder: (column) => column);

  GeneratedColumn<String> get purchaseUnit => $composableBuilder(
      column: $table.purchaseUnit, builder: (column) => column);

  GeneratedColumn<String> get actualUnit => $composableBuilder(
      column: $table.actualUnit, builder: (column) => column);

  GeneratedColumn<double> get purchaseQuantity => $composableBuilder(
      column: $table.purchaseQuantity, builder: (column) => column);

  GeneratedColumn<double> get actualQuantity => $composableBuilder(
      column: $table.actualQuantity, builder: (column) => column);

  GeneratedColumn<double> get presetPrice => $composableBuilder(
      column: $table.presetPrice, builder: (column) => column);

  GeneratedColumn<double> get actualPrice => $composableBuilder(
      column: $table.actualPrice, builder: (column) => column);

  GeneratedColumn<double> get advancePayment => $composableBuilder(
      column: $table.advancePayment, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<String?> itemName = const Value.absent(),
            Value<String?> itemShortName = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<String?> actualUnit = const Value.absent(),
            Value<double?> purchaseQuantity = const Value.absent(),
            Value<double?> actualQuantity = const Value.absent(),
            Value<double?> presetPrice = const Value.absent(),
            Value<double?> actualPrice = const Value.absent(),
            Value<double?> advancePayment = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            itemName: itemName,
            itemShortName: itemShortName,
            purchaseUnit: purchaseUnit,
            actualUnit: actualUnit,
            purchaseQuantity: purchaseQuantity,
            actualQuantity: actualQuantity,
            presetPrice: presetPrice,
            actualPrice: actualPrice,
            advancePayment: advancePayment,
            totalPrice: totalPrice,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            Value<String?> itemName = const Value.absent(),
            Value<String?> itemShortName = const Value.absent(),
            Value<String?> purchaseUnit = const Value.absent(),
            Value<String?> actualUnit = const Value.absent(),
            Value<double?> purchaseQuantity = const Value.absent(),
            Value<double?> actualQuantity = const Value.absent(),
            Value<double?> presetPrice = const Value.absent(),
            Value<double?> actualPrice = const Value.absent(),
            Value<double?> advancePayment = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            itemName: itemName,
            itemShortName: itemShortName,
            purchaseUnit: purchaseUnit,
            actualUnit: actualUnit,
            purchaseQuantity: purchaseQuantity,
            actualQuantity: actualQuantity,
            presetPrice: presetPrice,
            actualPrice: actualPrice,
            advancePayment: advancePayment,
            totalPrice: totalPrice,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
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
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
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

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId})>;
typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String?> driverName,
  Value<String?> plateNumber,
  Value<String?> driverPhone,
  Value<DateTime> createdAt,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String?> driverName,
  Value<String?> plateNumber,
  Value<String?> driverPhone,
  Value<DateTime> createdAt,
});

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get driverName => $composableBuilder(
      column: $table.driverName, builder: (column) => column);

  GeneratedColumn<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => column);

  GeneratedColumn<String> get driverPhone => $composableBuilder(
      column: $table.driverPhone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$VehiclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
    Vehicle,
    PrefetchHooks Function()> {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> driverName = const Value.absent(),
            Value<String?> plateNumber = const Value.absent(),
            Value<String?> driverPhone = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VehiclesCompanion(
            id: id,
            driverName: driverName,
            plateNumber: plateNumber,
            driverPhone: driverPhone,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> driverName = const Value.absent(),
            Value<String?> plateNumber = const Value.absent(),
            Value<String?> driverPhone = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VehiclesCompanion.insert(
            id: id,
            driverName: driverName,
            plateNumber: plateNumber,
            driverPhone: driverPhone,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VehiclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle>),
    Vehicle,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DishUnitsTableTableManager get dishUnits =>
      $$DishUnitsTableTableManager(_db, _db.dishUnits);
  $$DishesCategoryTableTableManager get dishesCategory =>
      $$DishesCategoryTableTableManager(_db, _db.dishesCategory);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$CustomerOrderItemsTableTableManager get customerOrderItems =>
      $$CustomerOrderItemsTableTableManager(_db, _db.customerOrderItems);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
}
