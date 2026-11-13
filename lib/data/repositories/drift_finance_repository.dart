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
  Future<void> addSubscription(
    int schoolId, {
    int amountPaid = 0,
    DateTime? date,
  }) async {
    final when = date ?? DateTime.now();
    await _db.transaction(() async {
      final school = await _schoolById(schoolId);
      final type = d.ClientType.fromCode(school.clientType);
      final isNew = type == d.ClientType.nouveau;

      final id = await _db.into(_db.subscriptions).insert(
            SubscriptionsCompanion.insert(
              schoolId: schoolId,
              kind: isNew ? 'abonnement' : 'réabonnement',
              amount: type.subscriptionPrice,
              date: when,
              amountPaid: Value(amountPaid),
            ),
          );

      final movementId = await _syncPayment(
        movementId: null,
        amount: amountPaid,
        label: 'Abonnement · ${school.name}',
        date: when,
        schoolId: schoolId,
      );
      await (_db.update(_db.subscriptions)..where((t) => t.id.equals(id)))
          .write(SubscriptionsCompanion(movementId: Value(movementId)));

      // Hypothèse métier : après son premier abonnement, une nouvelle école
      // devient une ancienne école (réabonnement au tarif réduit).
      if (isNew) {
        await (_db.update(_db.schools)..where((t) => t.id.equals(schoolId)))
            .write(SchoolsCompanion(clientType: Value('A')));
      }
    });
  }

  @override
  Future<void> updateSubscription(
    d.Subscription subscription, {
    required int schoolId,
    required DateTime date,
    required int amountPaid,
  }) async {
    await _db.transaction(() async {
      final school = await _schoolById(schoolId);
      final movementId = await _syncPayment(
        movementId: subscription.movementId,
        amount: amountPaid,
        label: 'Abonnement · ${school.name}',
        date: date,
        schoolId: schoolId,
      );
      await (_db.update(_db.subscriptions)
            ..where((t) => t.id.equals(subscription.id)))
          .write(SubscriptionsCompanion(
        schoolId: Value(schoolId),
        date: Value(date),
        amountPaid: Value(amountPaid),
        movementId: Value(movementId),
      ));
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
    int amountPaid = 0,
  }) async {
    await _db.transaction(() async {
      final school = await _schoolById(schoolId);
      final id = await _db.into(_db.photoSessions).insert(
            PhotoSessionsCompanion.insert(
              schoolId: schoolId,
              date: date,
              studentsRegistered: studentsRegistered,
              unitPrice: unitPrice,
              amountPaid: Value(amountPaid),
            ),
          );
      final movementId = await _syncPayment(
        movementId: null,
        amount: amountPaid,
        label: 'Prise de vue · ${school.name}',
        date: date,
        schoolId: schoolId,
      );
      await (_db.update(_db.photoSessions)..where((t) => t.id.equals(id)))
          .write(PhotoSessionsCompanion(movementId: Value(movementId)));
    });
  }

  @override
  Future<void> updatePhotoSession(
    d.PhotoSession session, {
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
    required int amountPaid,
  }) async {
    await _db.transaction(() async {
      final school = await _schoolById(schoolId);
      final movementId = await _syncPayment(
        movementId: session.movementId,
        amount: amountPaid,
        label: 'Prise de vue · ${school.name}',
        date: date,
        schoolId: schoolId,
      );
      await (_db.update(_db.photoSessions)
            ..where((t) => t.id.equals(session.id)))
          .write(PhotoSessionsCompanion(
        schoolId: Value(schoolId),
        date: Value(date),
        studentsRegistered: Value(studentsRegistered),
        unitPrice: Value(unitPrice),
        amountPaid: Value(amountPaid),
        movementId: Value(movementId),
      ));
    });
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
  /// Les paiements saisis dans les abonnements et prises de vue sont des
  /// encaissements rattachés à l'école, donc comptés automatiquement.
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

  // ---------- Outils internes ----------

  Future<School> _schoolById(int id) =>
      (_db.select(_db.schools)..where((t) => t.id.equals(id))).getSingle();

  /// Crée, met à jour ou supprime l'encaissement lié à un abonnement ou une prise de vue.
  /// Retourne l'identifiant de l'encaissement, ou null s'il n'y en a plus.
  Future<int?> _syncPayment({
    required int? movementId,
    required int amount,
    required String label,
    required DateTime date,
    required int schoolId,
  }) async {
    if (amount <= 0) {
      if (movementId != null) {
        await (_db.delete(_db.cashMovements)
              ..where((t) => t.id.equals(movementId)))
            .go();
      }
      return null;
    }

    final companion = CashMovementsCompanion(
      type: Value('entree'),
      amount: Value(amount),
      label: Value(label),
      date: Value(date),
      schoolId: Value(schoolId),
    );

    if (movementId != null) {
      final updated = await (_db.update(_db.cashMovements)
            ..where((t) => t.id.equals(movementId)))
          .write(companion);
      // Si l'encaissement a été supprimé depuis la caisse, on le recrée.
      if (updated > 0) return movementId;
    }
    return _db.into(_db.cashMovements).insert(companion);
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
        amountPaid: r.amountPaid,
        movementId: r.movementId,
      );

  d.PhotoSession _toPhoto(PhotoSession r) => d.PhotoSession(
        id: r.id,
        schoolId: r.schoolId,
        date: r.date,
        studentsRegistered: r.studentsRegistered,
        unitPrice: r.unitPrice,
        amountPaid: r.amountPaid,
        movementId: r.movementId,
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