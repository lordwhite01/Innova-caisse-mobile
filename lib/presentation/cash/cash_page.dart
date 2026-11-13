import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';
import '../widgets/app_search_field.dart';
import '../widgets/app_widgets.dart';
import '../widgets/empty_state.dart';
import '../widgets/school_picker.dart';

class CashPage extends ConsumerStatefulWidget {
  const CashPage({super.key});

  @override
  ConsumerState<CashPage> createState() => _CashPageState();
}

class _CashPageState extends ConsumerState<CashPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final movements = ref.watch(movementsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    String? schoolName(int? id) => id == null
        ? null
        : schools.where((s) => s.id == id).map((s) => s.name).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Entrées et sorties')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CashFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau mouvement'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AppSearchField(
              hint: 'Rechercher un libellé ou une école',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: movements.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                      icon: Icons.swap_vert_circle_outlined,
                      message: 'Aucun mouvement de caisse.');
                }
                final filtered = list
                    .where((m) =>
                        matchesQuery(_query, [m.label, schoolName(m.schoolId)]))
                    .toList();
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    message: 'Aucun résultat pour cette recherche.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final m = filtered[i];
                    final isIn = m.type == MovementType.entree;
                    final color = isIn ? AppColors.success : AppColors.danger;
                    final name = schoolName(m.schoolId);
                    final subtitle = name == null
                        ? formatDate(m.date)
                        : '${formatDate(m.date)} · $name';
                    return AppListItem(
                      icon: isIn
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      accent: color,
                      title: m.label,
                      subtitle: subtitle,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AmountText(
                            amount: m.amount,
                            color: color,
                            prefix: isIn ? '+ ' : '- ',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.muted),
                            onPressed: () => ref
                                .read(financeRepositoryProvider)
                                .deleteMovement(m.id!),
                          ),
                        ],
                      ),
                    );
                  },
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

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau mouvement')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            SegmentedButton<MovementType>(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.navy,
                selectedForegroundColor: Colors.white,
              ),
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
            const SizedBox(height: 20),
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
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.border),
              ),
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(formatDate(_date)),
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
            FilledButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}