import 'package:drift/drift.dart';

class Schools extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 120)();
  TextColumn get city => text().withLength(min: 2, max: 80)();
  TextColumn get contactName => text().withLength(min: 2, max: 120)();
  /// 'N' = nouvelle école, 'A' = ancienne école.
  TextColumn get clientType => text().withLength(min: 1, max: 1)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Subscriptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schoolId =>
      integer().references(Schools, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get date => dateTime()();
}

class PhotoSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get schoolId =>
      integer().references(Schools, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get studentsRegistered => integer()();
  IntColumn get unitPrice => integer()();
}

class CashMovements extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 'entree' ou 'sortie'.
  TextColumn get type => text()();
  IntColumn get amount => integer()();
  TextColumn get label => text().withLength(min: 1, max: 200)();
  DateTimeColumn get date => dateTime()();
  IntColumn get schoolId => integer()
      .nullable()
      .references(Schools, #id, onDelete: KeyAction.setNull)();
}
