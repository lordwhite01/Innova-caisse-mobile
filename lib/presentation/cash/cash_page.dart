import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/school_picker.dart';

class CashPage extends ConsumerWidget {
  const CashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movements = ref.watch(movementsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Entrées et sorties')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CashFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau mouvement'),
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
      ),
      body: movements.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
                icon: Icons.swap_vert_circle_outlined,
                message: 'Aucun mouvement de caisse.');
          }

          // Calcul des totaux du mois en cours
          final now = DateTime.now();
          double totalEntrees = 0;
          double totalSorties = 0;
          for (final m in list) {
            if (m.date.year == now.year && m.date.month == now.month) {
              if (m.type == MovementType.entree) {
                totalEntrees += m.amount;
              } else {
                totalSorties += m.amount;
              }
            }
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: list.length + 1, // +1 pour l'en-tête
            separatorBuilder: (_, i) =>
                i == 0 ? const SizedBox(height: 16) : const SizedBox(height: 10),
            itemBuilder: (context, i) {
              // En-tête résumé mois en cours
              if (i == 0) {
                return _MonthSummaryHeader(
                  totalEntrees: totalEntrees,
                  totalSorties: totalSorties,
                );
              }

              final m = list[i - 1];
              final isIn = m.type == MovementType.entree;
              final color = isIn ? AppColors.success : AppColors.danger;
              final schoolName = m.schoolId == null
                  ? null
                  : schools
                      .where((s) => s.id == m.schoolId)
                      .map((s) => s.name)
                      .firstOrNull;
              final subtitle = schoolName == null
                  ? formatDate(m.date)
                  : '${formatDate(m.date)} · $schoolName';

              return Dismissible(
                key: ValueKey(m.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white, size: 28),
                ),
                onDismissed: (_) =>
                    ref.read(financeRepositoryProvider).deleteMovement(m.id!),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Barre colorée verticale gauche (3px)
                          Container(width: 3, color: color),
                          // Contenu
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              leading: CircleAvatar(
                                backgroundColor: color.withValues(alpha: 0.12),
                                child: Icon(
                                  isIn
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  color: color,
                                ),
                              ),
                              title: Text(m.label,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(subtitle),
                              trailing: Text(
                                '${isIn ? '+' : '-'} ${formatFcfa(m.amount)}',
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

/// En-tête résumé des totaux entrées/sorties du mois en cours.
class _MonthSummaryHeader extends StatelessWidget {
  const _MonthSummaryHeader({
    required this.totalEntrees,
    required this.totalSorties,
  });

  final double totalEntrees;
  final double totalSorties;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryChip(
            label: 'Entrées',
            amount: totalEntrees,
            color: AppColors.success,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryChip(
            label: 'Sorties',
            amount: totalSorties,
            color: AppColors.danger,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                Text(
                  formatFcfa(amount.toInt()),
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Formulaire de mouvement. Pré-remplissable (ex. encaissement depuis les créances).
class CashFormPage extends ConsumerStatefulWidget {
  const CashFormPage({
    super.key,
    this.initialType = MovementType.entree,
    this.initialSchoolId,
    this.initialAmount,
    this.initialLabel,
  });

  final MovementType initialType;
  final int? initialSchoolId;
  final int? initialAmount;
  final String? initialLabel;

  @override
  ConsumerState<CashFormPage> createState() => _CashFormPageState();
}

class _CashFormPageState extends ConsumerState<CashFormPage> {
  final _formKey = GlobalKey<FormState>();
  late MovementType _type;
  late final TextEditingController _amount;
  late final TextEditingController _label;
  int? _schoolId;
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _schoolId = widget.initialSchoolId;
    _amount = TextEditingController(text: widget.initialAmount?.toString());
    _label = TextEditingController(text: widget.initialLabel);
  }

  @override
  void dispose() {
    _amount.dispose();
    _label.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(financeRepositoryProvider).addMovement(CashMovement(
          type: _type,
          amount: int.parse(_amount.text),
          label: _label.text.trim(),
          date: _date,
          schoolId: _schoolId,
        ));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];
    final isEntree = _type == MovementType.entree;
    final segmentColor = isEntree ? AppColors.success : AppColors.danger;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau mouvement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // SegmentedButton stylisé avec couleurs personnalisées
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      secondaryContainer: segmentColor.withValues(alpha: 0.15),
                      onSecondaryContainer: segmentColor,
                      outline: segmentColor.withValues(alpha: 0.4),
                    ),
              ),
              child: SegmentedButton<MovementType>(
                segments: const [
                  ButtonSegment(
                      value: MovementType.entree,
                      label: Text('Entrée'),
                      icon: Icon(Icons.arrow_downward_rounded)),
                  ButtonSegment(
                      value: MovementType.sortie,
                      label: Text('Sortie'),
                      icon: Icon(Icons.arrow_upward_rounded)),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amount,
              keyboardType: TextInputType.number,
              validator: (v) =>
                  (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Montant invalide' : null,
              decoration: const InputDecoration(
                labelText: 'Montant (FCFA)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _label,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Libellé obligatoire' : null,
              decoration: const InputDecoration(
                labelText: 'Libellé',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
            ),
            const SizedBox(height: 14),
            SchoolPicker(
              schools: schools,
              value: _schoolId,
              required: false,
              onChanged: (v) => setState(() => _schoolId = v),
            ),
            const SizedBox(height: 14),
            // Date picker tile embelli
            ListTile(
              tileColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              leading: Icon(Icons.calendar_today_outlined,
                  color: AppColors.navy, size: 22),
              title: Text(
                formatDate(_date),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right,
                  color: AppColors.navy.withValues(alpha: 0.4)),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            const SizedBox(height: 28),
            // Bouton Enregistrer avec gradient navy → #1A237E
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF1A237E)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Enregistrer',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
