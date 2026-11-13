import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../cash/cash_page.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';

class ReceivablesPage extends ConsumerWidget {
  const ReceivablesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivables = ref.watch(receivablesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Créances')),
      body: receivables.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
                icon: Icons.task_alt_outlined,
                message: 'Aucune créance.\nToutes les écoles sont à jour.');
          }
          final total = list.fold<int>(0, (s, r) => s + r.remaining);
          return Column(
            children: [
              // Header with gradient + wallet icon
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.navy, Color(0xFF283593)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total restant à percevoir',
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text(formatFcfa(total),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) =>
                      _ReceivableTile(receivable: list[i]),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _ReceivableTile extends StatelessWidget {
  const _ReceivableTile({required this.receivable});

  final Receivable receivable;

  @override
  Widget build(BuildContext context) {
    final r = receivable;

    // Calculate paid ratio (0.0 to 1.0)
    final ratio = r.due > 0 ? (r.paid / r.due).clamp(0.0, 1.0) : 0.0;
    final paidPercent = (ratio * 100).round();

    // Color based on ratio
    final Color progressColor;
    if (ratio > 0.70) {
      progressColor = AppColors.success;
    } else if (ratio >= 0.30) {
      progressColor = AppColors.orange;
    } else {
      progressColor = AppColors.danger;
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CashFormPage(
              initialType: MovementType.entree,
              initialSchoolId: r.school.id,
              initialAmount: r.remaining,
              initialLabel: 'Paiement ${r.school.name}',
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.school.name,
                        style:
                            const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                        'Dû : ${formatFcfa(r.due)} · Payé : ${formatFcfa(r.paid)}',
                        style: TextStyle(
                            color: AppColors.navy.withOpacity(0.6),
                            fontSize: 13)),
                    const SizedBox(height: 6),
                    Text('Reste : ${formatFcfa(r.remaining)}',
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    // Progress bar row
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 7,
                              backgroundColor:
                                  AppColors.navy.withOpacity(0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  progressColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$paidPercent%',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: progressColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
