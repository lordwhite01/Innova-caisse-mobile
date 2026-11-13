/// Entités métier pures : aucune dépendance à Drift ou Flutter.

enum ClientType {
  nouveau('N', 'Nouvelle école', 50000),
  ancien('A', 'Ancienne école', 25000);

  const ClientType(this.code, this.label, this.subscriptionPrice);

  final String code;
  final String label;

  /// Montant de l'abonnement proposé automatiquement selon le type.
  final int subscriptionPrice;

  static ClientType fromCode(String code) =>
      values.firstWhere((t) => t.code == code, orElse: () => ancien);
}

enum MovementType { entree, sortie }

class School {
  const School({
    this.id,
    required this.name,
    required this.city,
    required this.contactName,
    required this.clientType,
  });

  final int? id;
  final String name;
  final String city;
  final String contactName;
  final ClientType clientType;
}

class Subscription {
  const Subscription({
    required this.id,
    required this.schoolId,
    required this.kind,
    required this.amount,
    required this.date,
    this.amountPaid = 0,
    this.movementId,
  });

  final int id;
  final int schoolId;
  final String kind; // 'abonnement' | 'réabonnement'
  final int amount;
  final DateTime date;
  final int amountPaid;
  final int? movementId;

  int get remaining => amount - amountPaid;
}

class PhotoSession {
  const PhotoSession({
    required this.id,
    required this.schoolId,
    required this.date,
    required this.studentsRegistered,
    required this.unitPrice,
    this.amountPaid = 0,
    this.movementId,
  });

  final int id;
  final int schoolId;
  final DateTime date;
  final int studentsRegistered;
  final int unitPrice;
  final int amountPaid;
  final int? movementId;

  /// Montant total dû pour la prise de vue.
  int get amountDue => studentsRegistered * unitPrice;

  int get remaining => amountDue - amountPaid;
}

class CashMovement {
  const CashMovement({
    this.id,
    required this.type,
    required this.amount,
    required this.label,
    required this.date,
    this.schoolId,
  });

  final int? id;
  final MovementType type;
  final int amount;
  final String label;
  final DateTime date;
  final int? schoolId;
}

class Receivable {
  const Receivable({
    required this.school,
    required this.due,
    required this.paid,
  });

  final School school;
  final int due;
  final int paid;

  int get remaining => due - paid;
}

class CashSummary {
  const CashSummary({required this.totalIn, required this.totalOut});

  final int totalIn;
  final int totalOut;

  int get balance => totalIn - totalOut;
}