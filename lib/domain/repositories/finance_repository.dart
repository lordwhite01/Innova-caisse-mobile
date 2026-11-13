import '../entities/entities.dart';

/// Contrat de la couche domaine. L'implémentation locale vit dans la couche data.
abstract class FinanceRepository {
  // Établissements
  Stream<List<School>> watchSchools();
  Future<void> saveSchool(School school);
  Future<void> deleteSchool(int id);

  // Abonnements : le montant est calculé automatiquement selon le type client.
  Stream<List<Subscription>> watchSubscriptions();
  Future<void> addSubscription(int schoolId);

  // Prises de vue
  Stream<List<PhotoSession>> watchPhotoSessions();
  Future<void> addPhotoSession({
    required int schoolId,
    required DateTime date,
    required int studentsRegistered,
    required int unitPrice,
  });

  // Entrées et sorties de caisse
  Stream<List<CashMovement>> watchMovements();
  Future<void> addMovement(CashMovement movement);
  Future<void> deleteMovement(int id);

  // Tableaux dérivés
  Stream<CashSummary> watchSummary();
  Stream<List<Receivable>> watchReceivables();
}
