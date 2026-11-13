import '../entities/entities.dart';

/// Contrat de la couche domaine. L'implémentation locale vit dans la couche data.
abstract class FinanceRepository {
  // Établissements
  Stream<List<School>> watchSchools();
  Future<void> saveSchool(School school);
  Future<void> deleteSchool(int id);

  // Abonnements : le montant dû est calculé selon le type client.
  Stream<List<Subscription>> watchSubscriptions();
  Future<void> addSubscription(int schoolId, {int amountPaid = 0, DateTime? date});
  Future<void> updateSubscription(
    Subscription subscription, {
    required int schoolId,
    required DateTime date,
    required int amountPaid,
  });

  // Prises de vue
  Stream<List<PhotoSession>> watchPhotoSessions();
  Future<void> addPhotoSession({
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
    int amountPaid = 0,
  });
  Future<void> updatePhotoSession(
    PhotoSession session, {
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
    required int amountPaid,
  });

  // Entrées et sorties de caisse
  Stream<List<CashMovement>> watchMovements();
  Future<void> addMovement(CashMovement movement);
  Future<void> deleteMovement(int id);

  // Tableaux dérivés
  Stream<CashSummary> watchSummary();
  Stream<List<Receivable>> watchReceivables();
}