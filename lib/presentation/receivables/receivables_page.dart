import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../cash/cash_page.dart';
import '../providers.dart';
import '../widgets/app_search_field.dart';
import '../widgets/app_widgets.dart';
import '../widgets/empty_state.dart';

class ReceivablesPage extends ConsumerStatefulWidget {
  const ReceivablesPage({super.key});

  @override
  ConsumerState<ReceivablesPage> createState() => _ReceivablesPageState();
}

class _ReceivablesPageState extends ConsumerState<ReceivablesPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final receivables = ref.watch(receivablesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Créances')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AppSearchField(
              hint: 'Rechercher une école',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: receivables.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                      icon: Icons.task_alt_outlined,
                      message: 'Aucune créance.\nToutes les écoles sont à jour.');
                }
                final filtered = list
                    .where((r) => matchesQuery(_query, [r.school.name]))
                    .toList();
                final total = filtered.fold<int>(0, (s, r) => s + r.remaining);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: SummaryBanner(
                        label: 'Total restant à percevoir',
                        amount: total,
                      ),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const EmptyState(
                              icon: Icons.search_off,
                              message: 'Aucun résultat pour cette recherche.',
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) =>
                                  _ReceivableItem(receivable: filtered[i]),
                            ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur : $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceivableItem extends StatelessWidget {
  const _ReceivableItem({required this.receivable});

  final Receivable receivable;

  @override
  Widget build(BuildContext context) {
    final r = receivable;
    return PaymentListItem(
      icon: Icons.receipt_long_outlined,
      accent: AppColors.orange,
      title: r.school.name,
      dateText: 'Créance de l’école',
      due: r.due,
      paid: r.paid,
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
    );
  }
}