import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database/app_database.dart' show AppDatabase;
import '../data/repositories/drift_finance_repository.dart';
import '../domain/entities/entities.dart';
import '../domain/repositories/finance_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final financeRepositoryProvider = Provider<FinanceRepository>(
  (ref) => DriftFinanceRepository(ref.watch(databaseProvider)),
);

final schoolsProvider = StreamProvider<List<School>>(
  (ref) => ref.watch(financeRepositoryProvider).watchSchools(),
);

final subscriptionsProvider = StreamProvider<List<Subscription>>(
  (ref) => ref.watch(financeRepositoryProvider).watchSubscriptions(),
);

final photoSessionsProvider = StreamProvider<List<PhotoSession>>(
  (ref) => ref.watch(financeRepositoryProvider).watchPhotoSessions(),
);

final movementsProvider = StreamProvider<List<CashMovement>>(
  (ref) => ref.watch(financeRepositoryProvider).watchMovements(),
);

final cashSummaryProvider = StreamProvider<CashSummary>(
  (ref) => ref.watch(financeRepositoryProvider).watchSummary(),
);

final receivablesProvider = StreamProvider<List<Receivable>>(
  (ref) => ref.watch(financeRepositoryProvider).watchReceivables(),
);
