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

class SubscriptionsPage extends ConsumerStatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  ConsumerState<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends ConsumerState<SubscriptionsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final subs = ref.watch(subscriptionsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    String schoolName(int id) =>
        schools.where((e) => e.id == id).map((e) => e.name).firstOrNull ??
        'École supprimée';

    return Scaffold(
      appBar: AppBar(title: const Text('Abonnements')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SubscriptionFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel abonnement'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AppSearchField(
              hint: 'Rechercher une école ou un type',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: subs.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                      icon: Icons.card_membership_outlined,
                      message: 'Aucun abonnement enregistré.');
                }
                final filtered = list
                    .where((s) => matchesQuery(
                        _query, [schoolName(s.schoolId), s.kind]))
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
                  itemBuilder: (_, i) {
                    final s = filtered[i];
                    return PaymentListItem(
                      icon: Icons.card_membership_outlined,
                      title: schoolName(s.schoolId),
                      dateText: '${_cap(s.kind)} · ${formatDate(s.date)}',
                      due: s.amount,
                      paid: s.amountPaid,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubscriptionFormPage(subscription: s),
                        ),
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

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// Création ou modification d'un abonnement. Le montant dû est fixé par le type
/// client ; le montant payé est optionnel et le reste se calcule automatiquement.
class SubscriptionFormPage extends ConsumerStatefulWidget {
  const SubscriptionFormPage({super.key, this.subscription});

  final Subscription? subscription;

  @override
  ConsumerState<SubscriptionFormPage> createState() =>
      _SubscriptionFormPageState();
}

class _SubscriptionFormPageState extends ConsumerState<SubscriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _paid;
  late int? _schoolId;
  late DateTime _date;

  bool get _isEdit => widget.subscription != null;

  @override
  void initState() {
    super.initState();
    final s = widget.subscription;
    _schoolId = s?.schoolId;
    _date = s?.date ?? DateTime.now();
    _paid = TextEditingController(
        text: (s != null && s.amountPaid > 0) ? '${s.amountPaid}' : '');
  }

  @override
  void dispose() {
    _paid.dispose();
    super.dispose();
  }

  int get _paidValue => int.tryParse(_paid.text.trim()) ?? 0;

  /// Montant dû : fixé à la création selon le type client, puis conservé.
  int _dueFor(List<School> schools) {
    if (_isEdit) return widget.subscription!.amount;
    final s = schools.where((e) => e.id == _schoolId).firstOrNull;
    return s?.clientType.subscriptionPrice ?? 0;
  }

  String? Function(String?) _paidValidator(int due) => (v) {
        if (v == null || v.trim().isEmpty) return null;
        final n = int.tryParse(v.trim());
        if (n == null || n < 0) return 'Montant invalide';
        if (n > due) return 'Supérieur au montant dû';
        return null;
      };

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(financeRepositoryProvider);
    if (_isEdit) {
      await repo.updateSubscription(
        widget.subscription!,
        schoolId: _schoolId!,
        date: _date,
        amountPaid: _paidValue,
      );
    } else {
      await repo.addSubscription(
        _schoolId!,
        amountPaid: _paidValue,
        date: _date,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];
    final selected = schools.where((s) => s.id == _schoolId).firstOrNull;
    final due = _dueFor(schools);
    final remaining = due - _paidValue;
    final kindLabel = _isEdit
        ? _cap(widget.subscription!.kind)
        : (selected?.clientType == ClientType.nouveau
            ? 'Abonnement'
            : 'Réabonnement');

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Modifier l’abonnement' : 'Nouvel abonnement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            SchoolPicker(
              schools: schools,
              value: _schoolId,
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
              onTap: _pickDate,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _paid,
              keyboardType: TextInputType.number,
              validator: _paidValidator(due),
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Montant payé par l’école (optionnel)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: 20),
            if (_schoolId != null) ...[
              SummaryBanner(label: '$kindLabel · montant dû', amount: due),
              const SizedBox(height: 12),
              _RemainingCard(remaining: remaining),
            ],
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _schoolId == null ? null : _save,
              child: Text(_isEdit
                  ? 'Enregistrer les modifications'
                  : 'Valider l’abonnement'),
            ),
          ],
        ),
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

/// Affiche le reste à payer, calculé automatiquement.
class _RemainingCard extends StatelessWidget {
  const _RemainingCard({required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Expanded(child: Text('Reste à payer')),
          AmountText(
            amount: remaining < 0 ? 0 : remaining,
            color: remaining > 0 ? AppColors.orange : AppColors.success,
          ),
        ],
      ),
    );
  }
}