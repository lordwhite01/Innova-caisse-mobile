// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SchoolsTable extends Schools with TableInfo<$SchoolsTable, School> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchoolsTable(this.attachedDatabase, [this._alias]);
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
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contactNameMeta =
      const VerificationMeta('contactName');
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
      'contact_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _clientTypeMeta =
      const VerificationMeta('clientType');
  @override
  late final GeneratedColumn<String> clientType = GeneratedColumn<String>(
      'client_type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 1),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
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
      [id, name, city, contactName, clientType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schools';
  @override
  VerificationContext validateIntegrity(Insertable<School> instance,
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
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('contact_name')) {
      context.handle(
          _contactNameMeta,
          contactName.isAcceptableOrUnknown(
              data['contact_name']!, _contactNameMeta));
    } else if (isInserting) {
      context.missing(_contactNameMeta);
    }
    if (data.containsKey('client_type')) {
      context.handle(
          _clientTypeMeta,
          clientType.isAcceptableOrUnknown(
              data['client_type']!, _clientTypeMeta));
    } else if (isInserting) {
      context.missing(_clientTypeMeta);
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
  School map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return School(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      contactName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_name'])!,
      clientType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SchoolsTable createAlias(String alias) {
    return $SchoolsTable(attachedDatabase, alias);
  }
}

class School extends DataClass implements Insertable<School> {
  final int id;
  final String name;
  final String city;
  final String contactName;

  /// 'N' = nouvelle école, 'A' = ancienne école.
  final String clientType;
  final DateTime createdAt;
  const School(
      {required this.id,
      required this.name,
      required this.city,
      required this.contactName,
      required this.clientType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['city'] = Variable<String>(city);
    map['contact_name'] = Variable<String>(contactName);
    map['client_type'] = Variable<String>(clientType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SchoolsCompanion toCompanion(bool nullToAbsent) {
    return SchoolsCompanion(
      id: Value(id),
      name: Value(name),
      city: Value(city),
      contactName: Value(contactName),
      clientType: Value(clientType),
      createdAt: Value(createdAt),
    );
  }

  factory School.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return School(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      city: serializer.fromJson<String>(json['city']),
      contactName: serializer.fromJson<String>(json['contactName']),
      clientType: serializer.fromJson<String>(json['clientType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'city': serializer.toJson<String>(city),
      'contactName': serializer.toJson<String>(contactName),
      'clientType': serializer.toJson<String>(clientType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  School copyWith(
          {int? id,
          String? name,
          String? city,
          String? contactName,
          String? clientType,
          DateTime? createdAt}) =>
      School(
        id: id ?? this.id,
        name: name ?? this.name,
        city: city ?? this.city,
        contactName: contactName ?? this.contactName,
        clientType: clientType ?? this.clientType,
        createdAt: createdAt ?? this.createdAt,
      );
  School copyWithCompanion(SchoolsCompanion data) {
    return School(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      city: data.city.present ? data.city.value : this.city,
      contactName:
          data.contactName.present ? data.contactName.value : this.contactName,
      clientType:
          data.clientType.present ? data.clientType.value : this.clientType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('School(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('contactName: $contactName, ')
          ..write('clientType: $clientType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, city, contactName, clientType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is School &&
          other.id == this.id &&
          other.name == this.name &&
          other.city == this.city &&
          other.contactName == this.contactName &&
          other.clientType == this.clientType &&
          other.createdAt == this.createdAt);
}

class SchoolsCompanion extends UpdateCompanion<School> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> city;
  final Value<String> contactName;
  final Value<String> clientType;
  final Value<DateTime> createdAt;
  const SchoolsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.city = const Value.absent(),
    this.contactName = const Value.absent(),
    this.clientType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SchoolsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String city,
    required String contactName,
    required String clientType,
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        city = Value(city),
        contactName = Value(contactName),
        clientType = Value(clientType);
  static Insertable<School> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? city,
    Expression<String>? contactName,
    Expression<String>? clientType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (city != null) 'city': city,
      if (contactName != null) 'contact_name': contactName,
      if (clientType != null) 'client_type': clientType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SchoolsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? city,
      Value<String>? contactName,
      Value<String>? clientType,
      Value<DateTime>? createdAt}) {
    return SchoolsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      contactName: contactName ?? this.contactName,
      clientType: clientType ?? this.clientType,
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
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (clientType.present) {
      map['client_type'] = Variable<String>(clientType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchoolsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('city: $city, ')
          ..write('contactName: $contactName, ')
          ..write('clientType: $clientType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, Subscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _schoolIdMeta =
      const VerificationMeta('schoolId');
  @override
  late final GeneratedColumn<int> schoolId = GeneratedColumn<int>(
      'school_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES schools (id) ON DELETE CASCADE'));
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, schoolId, kind, amount, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<Subscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('school_id')) {
      context.handle(_schoolIdMeta,
          schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta));
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      schoolId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}school_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class Subscription extends DataClass implements Insertable<Subscription> {
  final int id;
  final int schoolId;
  final String kind;
  final int amount;
  final DateTime date;
  const Subscription(
      {required this.id,
      required this.schoolId,
      required this.kind,
      required this.amount,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['school_id'] = Variable<int>(schoolId);
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      kind: Value(kind),
      amount: Value(amount),
      date: Value(date),
    );
  }

  factory Subscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscription(
      id: serializer.fromJson<int>(json['id']),
      schoolId: serializer.fromJson<int>(json['schoolId']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schoolId': serializer.toJson<int>(schoolId),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Subscription copyWith(
          {int? id,
          int? schoolId,
          String? kind,
          int? amount,
          DateTime? date}) =>
      Subscription(
        id: id ?? this.id,
        schoolId: schoolId ?? this.schoolId,
        kind: kind ?? this.kind,
        amount: amount ?? this.amount,
        date: date ?? this.date,
      );
  Subscription copyWithCompanion(SubscriptionsCompanion data) {
    return Subscription(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscription(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, schoolId, kind, amount, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscription &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.date == this.date);
}

class SubscriptionsCompanion extends UpdateCompanion<Subscription> {
  final Value<int> id;
  final Value<int> schoolId;
  final Value<String> kind;
  final Value<int> amount;
  final Value<DateTime> date;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required int schoolId,
    required String kind,
    required int amount,
    required DateTime date,
  })  : schoolId = Value(schoolId),
        kind = Value(kind),
        amount = Value(amount),
        date = Value(date);
  static Insertable<Subscription> custom({
    Expression<int>? id,
    Expression<int>? schoolId,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? schoolId,
      Value<String>? kind,
      Value<int>? amount,
      Value<DateTime>? date}) {
    return SubscriptionsCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<int>(schoolId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $PhotoSessionsTable extends PhotoSessions
    with TableInfo<$PhotoSessionsTable, PhotoSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotoSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _schoolIdMeta =
      const VerificationMeta('schoolId');
  @override
  late final GeneratedColumn<int> schoolId = GeneratedColumn<int>(
      'school_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES schools (id) ON DELETE CASCADE'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _studentsRegisteredMeta =
      const VerificationMeta('studentsRegistered');
  @override
  late final GeneratedColumn<int> studentsRegistered = GeneratedColumn<int>(
      'students_registered', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, schoolId, date, studentsRegistered, unitPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photo_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<PhotoSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('school_id')) {
      context.handle(_schoolIdMeta,
          schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta));
    } else if (isInserting) {
      context.missing(_schoolIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('students_registered')) {
      context.handle(
          _studentsRegisteredMeta,
          studentsRegistered.isAcceptableOrUnknown(
              data['students_registered']!, _studentsRegisteredMeta));
    } else if (isInserting) {
      context.missing(_studentsRegisteredMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PhotoSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PhotoSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      schoolId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}school_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      studentsRegistered: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}students_registered'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_price'])!,
    );
  }

  @override
  $PhotoSessionsTable createAlias(String alias) {
    return $PhotoSessionsTable(attachedDatabase, alias);
  }
}

class PhotoSession extends DataClass implements Insertable<PhotoSession> {
  final int id;
  final int schoolId;
  final DateTime date;
  final int studentsRegistered;
  final int unitPrice;
  const PhotoSession(
      {required this.id,
      required this.schoolId,
      required this.date,
      required this.studentsRegistered,
      required this.unitPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['school_id'] = Variable<int>(schoolId);
    map['date'] = Variable<DateTime>(date);
    map['students_registered'] = Variable<int>(studentsRegistered);
    map['unit_price'] = Variable<int>(unitPrice);
    return map;
  }

  PhotoSessionsCompanion toCompanion(bool nullToAbsent) {
    return PhotoSessionsCompanion(
      id: Value(id),
      schoolId: Value(schoolId),
      date: Value(date),
      studentsRegistered: Value(studentsRegistered),
      unitPrice: Value(unitPrice),
    );
  }

  factory PhotoSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PhotoSession(
      id: serializer.fromJson<int>(json['id']),
      schoolId: serializer.fromJson<int>(json['schoolId']),
      date: serializer.fromJson<DateTime>(json['date']),
      studentsRegistered: serializer.fromJson<int>(json['studentsRegistered']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'schoolId': serializer.toJson<int>(schoolId),
      'date': serializer.toJson<DateTime>(date),
      'studentsRegistered': serializer.toJson<int>(studentsRegistered),
      'unitPrice': serializer.toJson<int>(unitPrice),
    };
  }

  PhotoSession copyWith(
          {int? id,
          int? schoolId,
          DateTime? date,
          int? studentsRegistered,
          int? unitPrice}) =>
      PhotoSession(
        id: id ?? this.id,
        schoolId: schoolId ?? this.schoolId,
        date: date ?? this.date,
        studentsRegistered: studentsRegistered ?? this.studentsRegistered,
        unitPrice: unitPrice ?? this.unitPrice,
      );
  PhotoSession copyWithCompanion(PhotoSessionsCompanion data) {
    return PhotoSession(
      id: data.id.present ? data.id.value : this.id,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
      date: data.date.present ? data.date.value : this.date,
      studentsRegistered: data.studentsRegistered.present
          ? data.studentsRegistered.value
          : this.studentsRegistered,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSession(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('date: $date, ')
          ..write('studentsRegistered: $studentsRegistered, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, schoolId, date, studentsRegistered, unitPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PhotoSession &&
          other.id == this.id &&
          other.schoolId == this.schoolId &&
          other.date == this.date &&
          other.studentsRegistered == this.studentsRegistered &&
          other.unitPrice == this.unitPrice);
}

class PhotoSessionsCompanion extends UpdateCompanion<PhotoSession> {
  final Value<int> id;
  final Value<int> schoolId;
  final Value<DateTime> date;
  final Value<int> studentsRegistered;
  final Value<int> unitPrice;
  const PhotoSessionsCompanion({
    this.id = const Value.absent(),
    this.schoolId = const Value.absent(),
    this.date = const Value.absent(),
    this.studentsRegistered = const Value.absent(),
    this.unitPrice = const Value.absent(),
  });
  PhotoSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
  })  : schoolId = Value(schoolId),
        date = Value(date),
        studentsRegistered = Value(studentsRegistered),
        unitPrice = Value(unitPrice);
  static Insertable<PhotoSession> custom({
    Expression<int>? id,
    Expression<int>? schoolId,
    Expression<DateTime>? date,
    Expression<int>? studentsRegistered,
    Expression<int>? unitPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (schoolId != null) 'school_id': schoolId,
      if (date != null) 'date': date,
      if (studentsRegistered != null) 'students_registered': studentsRegistered,
      if (unitPrice != null) 'unit_price': unitPrice,
    });
  }

  PhotoSessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? schoolId,
      Value<DateTime>? date,
      Value<int>? studentsRegistered,
      Value<int>? unitPrice}) {
    return PhotoSessionsCompanion(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      date: date ?? this.date,
      studentsRegistered: studentsRegistered ?? this.studentsRegistered,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<int>(schoolId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (studentsRegistered.present) {
      map['students_registered'] = Variable<int>(studentsRegistered.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotoSessionsCompanion(')
          ..write('id: $id, ')
          ..write('schoolId: $schoolId, ')
          ..write('date: $date, ')
          ..write('studentsRegistered: $studentsRegistered, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }
}

class $CashMovementsTable extends CashMovements
    with TableInfo<$CashMovementsTable, CashMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _schoolIdMeta =
      const VerificationMeta('schoolId');
  @override
  late final GeneratedColumn<int> schoolId = GeneratedColumn<int>(
      'school_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES schools (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, amount, label, date, schoolId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_movements';
  @override
  VerificationContext validateIntegrity(Insertable<CashMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('school_id')) {
      context.handle(_schoolIdMeta,
          schoolId.isAcceptableOrUnknown(data['school_id']!, _schoolIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      schoolId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}school_id']),
    );
  }

  @override
  $CashMovementsTable createAlias(String alias) {
    return $CashMovementsTable(attachedDatabase, alias);
  }
}

class CashMovement extends DataClass implements Insertable<CashMovement> {
  final int id;

  /// 'entree' ou 'sortie'.
  final String type;
  final int amount;
  final String label;
  final DateTime date;
  final int? schoolId;
  const CashMovement(
      {required this.id,
      required this.type,
      required this.amount,
      required this.label,
      required this.date,
      this.schoolId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['label'] = Variable<String>(label);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || schoolId != null) {
      map['school_id'] = Variable<int>(schoolId);
    }
    return map;
  }

  CashMovementsCompanion toCompanion(bool nullToAbsent) {
    return CashMovementsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      label: Value(label),
      date: Value(date),
      schoolId: schoolId == null && nullToAbsent
          ? const Value.absent()
          : Value(schoolId),
    );
  }

  factory CashMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashMovement(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      label: serializer.fromJson<String>(json['label']),
      date: serializer.fromJson<DateTime>(json['date']),
      schoolId: serializer.fromJson<int?>(json['schoolId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'label': serializer.toJson<String>(label),
      'date': serializer.toJson<DateTime>(date),
      'schoolId': serializer.toJson<int?>(schoolId),
    };
  }

  CashMovement copyWith(
          {int? id,
          String? type,
          int? amount,
          String? label,
          DateTime? date,
          Value<int?> schoolId = const Value.absent()}) =>
      CashMovement(
        id: id ?? this.id,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        label: label ?? this.label,
        date: date ?? this.date,
        schoolId: schoolId.present ? schoolId.value : this.schoolId,
      );
  CashMovement copyWithCompanion(CashMovementsCompanion data) {
    return CashMovement(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      label: data.label.present ? data.label.value : this.label,
      date: data.date.present ? data.date.value : this.date,
      schoolId: data.schoolId.present ? data.schoolId.value : this.schoolId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashMovement(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('label: $label, ')
          ..write('date: $date, ')
          ..write('schoolId: $schoolId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, amount, label, date, schoolId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashMovement &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.label == this.label &&
          other.date == this.date &&
          other.schoolId == this.schoolId);
}

class CashMovementsCompanion extends UpdateCompanion<CashMovement> {
  final Value<int> id;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> label;
  final Value<DateTime> date;
  final Value<int?> schoolId;
  const CashMovementsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.label = const Value.absent(),
    this.date = const Value.absent(),
    this.schoolId = const Value.absent(),
  });
  CashMovementsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required int amount,
    required String label,
    required DateTime date,
    this.schoolId = const Value.absent(),
  })  : type = Value(type),
        amount = Value(amount),
        label = Value(label),
        date = Value(date);
  static Insertable<CashMovement> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? label,
    Expression<DateTime>? date,
    Expression<int>? schoolId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (label != null) 'label': label,
      if (date != null) 'date': date,
      if (schoolId != null) 'school_id': schoolId,
    });
  }

  CashMovementsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<int>? amount,
      Value<String>? label,
      Value<DateTime>? date,
      Value<int?>? schoolId}) {
    return CashMovementsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      label: label ?? this.label,
      date: date ?? this.date,
      schoolId: schoolId ?? this.schoolId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (schoolId.present) {
      map['school_id'] = Variable<int>(schoolId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashMovementsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('label: $label, ')
          ..write('date: $date, ')
          ..write('schoolId: $schoolId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchoolsTable schools = $SchoolsTable(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $PhotoSessionsTable photoSessions = $PhotoSessionsTable(this);
  late final $CashMovementsTable cashMovements = $CashMovementsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [schools, subscriptions, photoSessions, cashMovements];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('schools',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('subscriptions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('schools',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('photo_sessions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('schools',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cash_movements', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$SchoolsTableCreateCompanionBuilder = SchoolsCompanion Function({
  Value<int> id,
  required String name,
  required String city,
  required String contactName,
  required String clientType,
  Value<DateTime> createdAt,
});
typedef $$SchoolsTableUpdateCompanionBuilder = SchoolsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> city,
  Value<String> contactName,
  Value<String> clientType,
  Value<DateTime> createdAt,
});

final class $$SchoolsTableReferences
    extends BaseReferences<_$AppDatabase, $SchoolsTable, School> {
  $$SchoolsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubscriptionsTable, List<Subscription>>
      _subscriptionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.subscriptions,
              aliasName: 'schools__id__subscriptions__school_id');

  $$SubscriptionsTableProcessedTableManager get subscriptionsRefs {
    final manager = $$SubscriptionsTableTableManager($_db, $_db.subscriptions)
        .filter((f) => f.schoolId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_subscriptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PhotoSessionsTable, List<PhotoSession>>
      _photoSessionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.photoSessions,
              aliasName: 'schools__id__photo_sessions__school_id');

  $$PhotoSessionsTableProcessedTableManager get photoSessionsRefs {
    final manager = $$PhotoSessionsTableTableManager($_db, $_db.photoSessions)
        .filter((f) => f.schoolId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photoSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CashMovementsTable, List<CashMovement>>
      _cashMovementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cashMovements,
              aliasName: 'schools__id__cash_movements__school_id');

  $$CashMovementsTableProcessedTableManager get cashMovementsRefs {
    final manager = $$CashMovementsTableTableManager($_db, $_db.cashMovements)
        .filter((f) => f.schoolId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cashMovementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SchoolsTableFilterComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableFilterComposer({
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

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactName => $composableBuilder(
      column: $table.contactName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientType => $composableBuilder(
      column: $table.clientType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> subscriptionsRefs(
      Expression<bool> Function($$SubscriptionsTableFilterComposer f) f) {
    final $$SubscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subscriptions,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.subscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> photoSessionsRefs(
      Expression<bool> Function($$PhotoSessionsTableFilterComposer f) f) {
    final $$PhotoSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.photoSessions,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhotoSessionsTableFilterComposer(
              $db: $db,
              $table: $db.photoSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> cashMovementsRefs(
      Expression<bool> Function($$CashMovementsTableFilterComposer f) f) {
    final $$CashMovementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cashMovements,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashMovementsTableFilterComposer(
              $db: $db,
              $table: $db.cashMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchoolsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableOrderingComposer({
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

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactName => $composableBuilder(
      column: $table.contactName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientType => $composableBuilder(
      column: $table.clientType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SchoolsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchoolsTable> {
  $$SchoolsTableAnnotationComposer({
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

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get contactName => $composableBuilder(
      column: $table.contactName, builder: (column) => column);

  GeneratedColumn<String> get clientType => $composableBuilder(
      column: $table.clientType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> subscriptionsRefs<T extends Object>(
      Expression<T> Function($$SubscriptionsTableAnnotationComposer a) f) {
    final $$SubscriptionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.subscriptions,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SubscriptionsTableAnnotationComposer(
              $db: $db,
              $table: $db.subscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> photoSessionsRefs<T extends Object>(
      Expression<T> Function($$PhotoSessionsTableAnnotationComposer a) f) {
    final $$PhotoSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.photoSessions,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PhotoSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.photoSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> cashMovementsRefs<T extends Object>(
      Expression<T> Function($$CashMovementsTableAnnotationComposer a) f) {
    final $$CashMovementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cashMovements,
        getReferencedColumn: (t) => t.schoolId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CashMovementsTableAnnotationComposer(
              $db: $db,
              $table: $db.cashMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SchoolsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SchoolsTable,
    School,
    $$SchoolsTableFilterComposer,
    $$SchoolsTableOrderingComposer,
    $$SchoolsTableAnnotationComposer,
    $$SchoolsTableCreateCompanionBuilder,
    $$SchoolsTableUpdateCompanionBuilder,
    (School, $$SchoolsTableReferences),
    School,
    PrefetchHooks Function(
        {bool subscriptionsRefs,
        bool photoSessionsRefs,
        bool cashMovementsRefs})> {
  $$SchoolsTableTableManager(_$AppDatabase db, $SchoolsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchoolsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchoolsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchoolsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<String> contactName = const Value.absent(),
            Value<String> clientType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SchoolsCompanion(
            id: id,
            name: name,
            city: city,
            contactName: contactName,
            clientType: clientType,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String city,
            required String contactName,
            required String clientType,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SchoolsCompanion.insert(
            id: id,
            name: name,
            city: city,
            contactName: contactName,
            clientType: clientType,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SchoolsTable, School>(table),
                    $$SchoolsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {subscriptionsRefs = false,
              photoSessionsRefs = false,
              cashMovementsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriptionsRefs) db.subscriptions,
                if (photoSessionsRefs) db.photoSessions,
                if (cashMovementsRefs) db.cashMovements
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriptionsRefs)
                    await $_getPrefetchedDataByColumns<School, $SchoolsTable,
                            Subscription, $SubscriptionsTable>(
                        currentTable: table,
                        referencedTable: $$SchoolsTableReferences
                            ._subscriptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchoolsTableReferences(db, table, p0)
                                .subscriptionsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'school_id',
                        typedResults: items),
                  if (photoSessionsRefs)
                    await $_getPrefetchedDataByColumns<School, $SchoolsTable,
                            PhotoSession, $PhotoSessionsTable>(
                        currentTable: table,
                        referencedTable: $$SchoolsTableReferences
                            ._photoSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchoolsTableReferences(db, table, p0)
                                .photoSessionsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'school_id',
                        typedResults: items),
                  if (cashMovementsRefs)
                    await $_getPrefetchedDataByColumns<School, $SchoolsTable,
                            CashMovement, $CashMovementsTable>(
                        currentTable: table,
                        referencedTable: $$SchoolsTableReferences
                            ._cashMovementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SchoolsTableReferences(db, table, p0)
                                .cashMovementsRefs,
                        currentColumn: 'id',
                        referencedColumn: 'school_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SchoolsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SchoolsTable,
    School,
    $$SchoolsTableFilterComposer,
    $$SchoolsTableOrderingComposer,
    $$SchoolsTableAnnotationComposer,
    $$SchoolsTableCreateCompanionBuilder,
    $$SchoolsTableUpdateCompanionBuilder,
    (School, $$SchoolsTableReferences),
    School,
    PrefetchHooks Function(
        {bool subscriptionsRefs,
        bool photoSessionsRefs,
        bool cashMovementsRefs})>;
typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  required int schoolId,
  required String kind,
  required int amount,
  required DateTime date,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<int> id,
  Value<int> schoolId,
  Value<String> kind,
  Value<int> amount,
  Value<DateTime> date,
});

final class $$SubscriptionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubscriptionsTable, Subscription> {
  $$SubscriptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchoolsTable _schoolIdTable(_$AppDatabase db) =>
      db.schools.createAlias('subscriptions__school_id__schools__id');

  $$SchoolsTableProcessedTableManager get schoolId {
    final $_column = $_itemColumn<int>('school_id')!;

    final manager = $$SchoolsTableTableManager($_db, $_db.schools)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schoolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$SchoolsTableFilterComposer get schoolId {
    final $$SchoolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableFilterComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$SchoolsTableOrderingComposer get schoolId {
    final $$SchoolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableOrderingComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$SchoolsTableAnnotationComposer get schoolId {
    final $$SchoolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableAnnotationComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (Subscription, $$SubscriptionsTableReferences),
    Subscription,
    PrefetchHooks Function({bool schoolId})> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> schoolId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            schoolId: schoolId,
            kind: kind,
            amount: amount,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int schoolId,
            required String kind,
            required int amount,
            required DateTime date,
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            schoolId: schoolId,
            kind: kind,
            amount: amount,
            date: date,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SubscriptionsTable, Subscription>(table),
                    $$SubscriptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({schoolId = false}) {
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
                if (schoolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schoolId,
                    referencedTable:
                        $$SubscriptionsTableReferences._schoolIdTable(db),
                    referencedColumn:
                        $$SubscriptionsTableReferences._schoolIdTable(db).id,
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

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    Subscription,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (Subscription, $$SubscriptionsTableReferences),
    Subscription,
    PrefetchHooks Function({bool schoolId})>;
typedef $$PhotoSessionsTableCreateCompanionBuilder = PhotoSessionsCompanion
    Function({
  Value<int> id,
  required int schoolId,
  required DateTime date,
  required int studentsRegistered,
  required int unitPrice,
});
typedef $$PhotoSessionsTableUpdateCompanionBuilder = PhotoSessionsCompanion
    Function({
  Value<int> id,
  Value<int> schoolId,
  Value<DateTime> date,
  Value<int> studentsRegistered,
  Value<int> unitPrice,
});

final class $$PhotoSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $PhotoSessionsTable, PhotoSession> {
  $$PhotoSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchoolsTable _schoolIdTable(_$AppDatabase db) =>
      db.schools.createAlias('photo_sessions__school_id__schools__id');

  $$SchoolsTableProcessedTableManager get schoolId {
    final $_column = $_itemColumn<int>('school_id')!;

    final manager = $$SchoolsTableTableManager($_db, $_db.schools)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schoolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PhotoSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PhotoSessionsTable> {
  $$PhotoSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get studentsRegistered => $composableBuilder(
      column: $table.studentsRegistered,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  $$SchoolsTableFilterComposer get schoolId {
    final $$SchoolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableFilterComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotoSessionsTable> {
  $$PhotoSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get studentsRegistered => $composableBuilder(
      column: $table.studentsRegistered,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  $$SchoolsTableOrderingComposer get schoolId {
    final $$SchoolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableOrderingComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotoSessionsTable> {
  $$PhotoSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get studentsRegistered => $composableBuilder(
      column: $table.studentsRegistered, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  $$SchoolsTableAnnotationComposer get schoolId {
    final $$SchoolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableAnnotationComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PhotoSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PhotoSessionsTable,
    PhotoSession,
    $$PhotoSessionsTableFilterComposer,
    $$PhotoSessionsTableOrderingComposer,
    $$PhotoSessionsTableAnnotationComposer,
    $$PhotoSessionsTableCreateCompanionBuilder,
    $$PhotoSessionsTableUpdateCompanionBuilder,
    (PhotoSession, $$PhotoSessionsTableReferences),
    PhotoSession,
    PrefetchHooks Function({bool schoolId})> {
  $$PhotoSessionsTableTableManager(_$AppDatabase db, $PhotoSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotoSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotoSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotoSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> schoolId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> studentsRegistered = const Value.absent(),
            Value<int> unitPrice = const Value.absent(),
          }) =>
              PhotoSessionsCompanion(
            id: id,
            schoolId: schoolId,
            date: date,
            studentsRegistered: studentsRegistered,
            unitPrice: unitPrice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int schoolId,
            required DateTime date,
            required int studentsRegistered,
            required int unitPrice,
          }) =>
              PhotoSessionsCompanion.insert(
            id: id,
            schoolId: schoolId,
            date: date,
            studentsRegistered: studentsRegistered,
            unitPrice: unitPrice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PhotoSessionsTable, PhotoSession>(table),
                    $$PhotoSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({schoolId = false}) {
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
                if (schoolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schoolId,
                    referencedTable:
                        $$PhotoSessionsTableReferences._schoolIdTable(db),
                    referencedColumn:
                        $$PhotoSessionsTableReferences._schoolIdTable(db).id,
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

typedef $$PhotoSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PhotoSessionsTable,
    PhotoSession,
    $$PhotoSessionsTableFilterComposer,
    $$PhotoSessionsTableOrderingComposer,
    $$PhotoSessionsTableAnnotationComposer,
    $$PhotoSessionsTableCreateCompanionBuilder,
    $$PhotoSessionsTableUpdateCompanionBuilder,
    (PhotoSession, $$PhotoSessionsTableReferences),
    PhotoSession,
    PrefetchHooks Function({bool schoolId})>;
typedef $$CashMovementsTableCreateCompanionBuilder = CashMovementsCompanion
    Function({
  Value<int> id,
  required String type,
  required int amount,
  required String label,
  required DateTime date,
  Value<int?> schoolId,
});
typedef $$CashMovementsTableUpdateCompanionBuilder = CashMovementsCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<int> amount,
  Value<String> label,
  Value<DateTime> date,
  Value<int?> schoolId,
});

final class $$CashMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $CashMovementsTable, CashMovement> {
  $$CashMovementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SchoolsTable _schoolIdTable(_$AppDatabase db) =>
      db.schools.createAlias('cash_movements__school_id__schools__id');

  $$SchoolsTableProcessedTableManager? get schoolId {
    final $_column = $_itemColumn<int>('school_id');
    if ($_column == null) return null;
    final manager = $$SchoolsTableTableManager($_db, $_db.schools)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_schoolIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CashMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$SchoolsTableFilterComposer get schoolId {
    final $$SchoolsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableFilterComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CashMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$SchoolsTableOrderingComposer get schoolId {
    final $$SchoolsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableOrderingComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CashMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashMovementsTable> {
  $$CashMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$SchoolsTableAnnotationComposer get schoolId {
    final $$SchoolsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.schoolId,
        referencedTable: $db.schools,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SchoolsTableAnnotationComposer(
              $db: $db,
              $table: $db.schools,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CashMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CashMovementsTable,
    CashMovement,
    $$CashMovementsTableFilterComposer,
    $$CashMovementsTableOrderingComposer,
    $$CashMovementsTableAnnotationComposer,
    $$CashMovementsTableCreateCompanionBuilder,
    $$CashMovementsTableUpdateCompanionBuilder,
    (CashMovement, $$CashMovementsTableReferences),
    CashMovement,
    PrefetchHooks Function({bool schoolId})> {
  $$CashMovementsTableTableManager(_$AppDatabase db, $CashMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> schoolId = const Value.absent(),
          }) =>
              CashMovementsCompanion(
            id: id,
            type: type,
            amount: amount,
            label: label,
            date: date,
            schoolId: schoolId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required int amount,
            required String label,
            required DateTime date,
            Value<int?> schoolId = const Value.absent(),
          }) =>
              CashMovementsCompanion.insert(
            id: id,
            type: type,
            amount: amount,
            label: label,
            date: date,
            schoolId: schoolId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CashMovementsTable, CashMovement>(table),
                    $$CashMovementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({schoolId = false}) {
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
                if (schoolId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.schoolId,
                    referencedTable:
                        $$CashMovementsTableReferences._schoolIdTable(db),
                    referencedColumn:
                        $$CashMovementsTableReferences._schoolIdTable(db).id,
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

typedef $$CashMovementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CashMovementsTable,
    CashMovement,
    $$CashMovementsTableFilterComposer,
    $$CashMovementsTableOrderingComposer,
    $$CashMovementsTableAnnotationComposer,
    $$CashMovementsTableCreateCompanionBuilder,
    $$CashMovementsTableUpdateCompanionBuilder,
    (CashMovement, $$CashMovementsTableReferences),
    CashMovement,
    PrefetchHooks Function({bool schoolId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchoolsTableTableManager get schools =>
      $$SchoolsTableTableManager(_db, _db.schools);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$PhotoSessionsTableTableManager get photoSessions =>
      $$PhotoSessionsTableTableManager(_db, _db.photoSessions);
  $$CashMovementsTableTableManager get cashMovements =>
      $$CashMovementsTableTableManager(_db, _db.cashMovements);
}
