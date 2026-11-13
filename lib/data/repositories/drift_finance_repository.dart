import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/entities.dart' as d;
import '../../domain/repositories/finance_repository.dart';
import '../database/app_database.dart';
import '../database/tables.dart';

class DriftFinanceRepository implements FinanceRepository {
  DriftFinanceRepository(this._db);

  final AppDatabase _db;

  // ---------- Établissements ----------

  @override
  Stream<List<d.School>> watchSchools() {
    final query = _db.select(_db.schools)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map((rows) => rows.map(_toSchool).toList());
  }

  @override
  Future<void> saveSchool(d.School school) async {
    final data = SchoolsCompanion(
      name: Value(school.name),
      city: Value(school.city),
      contactName: Value(school.contactName),
      clientType: Value(school.clientType.code),
    );
    if (school.id == null) {
      await _db.into(_db.schools).insert(data);
    } else {
      await (_db.update(_db.schools)..where((t) => t.id.equals(school.id!)))
          .write(data);
    }
  }

  @override
  Future<void> deleteSchool(int id) async {
    await (_db.delete(_db.schools)..where((t) => t.id.equals(id))).go();
  }

  // ---------- Abonnements ----------

  @override
  Stream<List<d.Subscription>> watchSubscriptions() {
    final query = _db.select(_db.subscriptions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch().map((rows) => rows.map(_toSubscription).toList());
  }

  @override
  Future<void> addSubscription(int schoolId) async {
    await _db.transaction(() async {
      final school = await (_db.select(_db.schools)
            ..where((t) => t.id.equals(schoolId)))
          .getSingle();
      final type = d.ClientType.fromCode(school.clientType);
      final isNew = type == d.ClientType.nouveau;

      await _db.into(_db.subscriptions).insert(
            SubscriptionsCompanion.insert(
              schoolId: schoolId,
              kind: isNew ? 'abonnement' : 'réabonnement',
              amount: type.subscriptionPrice,
              date: DateTime.now(),
            ),
          );

      // Hypothèse métier : après son premier abonnement, une nouvelle école
      // devient une ancienne école (réabonnement au tarif réduit).
      if (isNew) {
        await (_db.update(_db.schools)..where((t) => t.id.equals(schoolId)))
            .write(SchoolsCompanion(clientType: Value('A')));
      }
    });
  }

  // ---------- Prises de vue ----------

  @override
  Stream<List<d.PhotoSession>> watchPhotoSessions() {
    final query = _db.select(_db.photoSessions)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch().map((rows) => rows.map(_toPhoto).toList());
  }

  @override
  Future<void> addPhotoSession({
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
  }) async {
    await _db.into(_db.photoSessions).insert(
          PhotoSessionsCompanion.insert(
            schoolId: schoolId,
            date: date,
            studentsRegistered: studentsRegistered,
            unitPrice: unitPrice,
          ),
        );
  }

  // ---------- Caisse ----------

  @override
  Stream<List<d.CashMovement>> watchMovements() {
    final query = _db.select(_db.cashMovements)
      ..orderBy([(t) => OrderingTerm.desc(t.date)]);
    return query.watch().map((rows) => rows.map(_toMovement).toList());
  }

  @override
  Future<void> addMovement(d.CashMovement movement) async {
    await _db.into(_db.cashMovements).insert(
          CashMovementsCompanion.insert(
            type: movement.type.name,
            amount: movement.amount,
            label: movement.label,
            date: movement.date,
            schoolId: Value(movement.schoolId),
          ),
        );
  }

  @override
  Future<void> deleteMovement(int id) async {
    await (_db.delete(_db.cashMovements)..where((t) => t.id.equals(id))).go();
  }

  // ---------- Vues dérivées ----------

  @override
  Stream<d.CashSummary> watchSummary() {
    return watchMovements().map((moves) {
      var totalIn = 0;
      var totalOut = 0;
      for (final m in moves) {
        if (m.type == d.MovementType.entree) {
          totalIn += m.amount;
        } else {
          totalOut += m.amount;
        }
      }
      return d.CashSummary(totalIn: totalIn, totalOut: totalOut);
    });
  }

  /// Créance = total dû (abonnements + prises de vue) - encaissements liés à l'école.
  /// Les élèves qui paient en plusieurs fois sont pris en compte grâce aux
  /// encaissements partiels rattachés à l'école.
  @override
  Stream<List<d.Receivable>> watchReceivables() {
    return CombineLatestStream.combine4<List<d.School>, List<d.Subscription>,
        List<d.PhotoSession>, List<d.CashMovement>, List<d.Receivable>>(
      watchSchools(),
      watchSubscriptions(),
      watchPhotoSessions(),
      watchMovements(),
      (schools, subs, photos, moves) {
        final result = <d.Receivable>[];
        for (final school in schools) {
          final due = subs
                  .where((s) => s.schoolId == school.id)
                  .fold<int>(0, (sum, s) => sum + s.amount) +
              photos
                  .where((p) => p.schoolId == school.id)
                  .fold<int>(0, (sum, p) => sum + p.amountDue);
          final paid = moves
              .where((m) =>
                  m.type == d.MovementType.entree && m.schoolId == school.id)
              .fold<int>(0, (sum, m) => sum + m.amount);
          if (due - paid > 0) {
            result.add(d.Receivable(school: school, due: due, paid: paid));
          }
        }
        result.sort((a, b) => b.remaining.compareTo(a.remaining));
        return result;
      },
    );
  }

  // ---------- Mappers ----------

  d.School _toSchool(School r) => d.School(
        id: r.id,
        name: r.name,
        city: r.city,
        contactName: r.contactName,
        clientType: d.ClientType.fromCode(r.clientType),
      );

  d.Subscription _toSubscription(Subscription r) => d.Subscription(
        id: r.id,
        schoolId: r.schoolId,
        kind: r.kind,
        amount: r.amount,
        date: r.date,
      );

  d.PhotoSession _toPhoto(PhotoSession r) => d.PhotoSession(
        id: r.id,
        schoolId: r.schoolId,
        date: r.date,
        studentsRegistered: r.studentsRegistered,
        unitPrice: r.unitPrice,
      );

  d.CashMovement _toMovement(CashMovement r) => d.CashMovement(
        id: r.id,
        type: d.MovementType.values.byName(r.type),
        amount: r.amount,
        label: r.label,
        date: r.date,
        schoolId: r.schoolId,
      );
}
