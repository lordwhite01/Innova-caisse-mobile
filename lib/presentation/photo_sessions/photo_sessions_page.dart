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

/// Tarif fixe d'une prise de vue, par élève.
const photoUnitPrice = 500;

class PhotoSessionsPage extends ConsumerStatefulWidget {
  const PhotoSessionsPage({super.key});

  @override
  ConsumerState<PhotoSessionsPage> createState() => _PhotoSessionsPageState();
}

class _PhotoSessionsPageState extends ConsumerState<PhotoSessionsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(photoSessionsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    String schoolName(int id) =>
        schools.where((e) => e.id == id).map((e) => e.name).firstOrNull ??
        'École supprimée';

    return Scaffold(
      appBar: AppBar(title: const Text('Prises de vue')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PhotoSessionFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle prise de vue'),
      ),
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
            child: sessions.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                      icon: Icons.photo_camera_outlined,
                      message:
                          'Aucune prise de vue.\nAjoutez la première séance.');
                }
                final filtered = list
                    .where((p) => matchesQuery(_query, [schoolName(p.schoolId)]))
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
                    final p = filtered[i];
                    return PaymentListItem(
                      icon: Icons.photo_camera_outlined,
                      accent: AppColors.orange,
                      title: schoolName(p.schoolId),
                      dateText: '${p.studentsRegistered} élèves · ${formatDate(p.date)}',
                      due: p.amountDue,
                      paid: p.amountPaid,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PhotoSessionFormPage(session: p),
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
}

/// Création ou modification d'une prise de vue. Le montant total = élèves × tarif.
/// Le montant payé est optionnel et le reste se calcule automatiquement.
class PhotoSessionFormPage extends ConsumerStatefulWidget {
  const PhotoSessionFormPage({super.key, this.session});

  final PhotoSession? session;

  @override
  ConsumerState<PhotoSessionFormPage> createState() =>
      _PhotoSessionFormPageState();
}

class _PhotoSessionFormPageState extends ConsumerState<PhotoSessionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _students;
  late final TextEditingController _paid;
  late int? _schoolId;
  late DateTime _date;

  bool get _isEdit => widget.session != null;

  @override
  void initState() {
    super.initState();
    final p = widget.session;
    _schoolId = p?.schoolId;
    _date = p?.date ?? DateTime.now();
    _students = TextEditingController(
        text: p != null ? '${p.studentsRegistered}' : '');
    _paid = TextEditingController(
        text: (p != null && p.amountPaid > 0) ? '${p.amountPaid}' : '');
  }

  @override
  void dispose() {
    _students.dispose();
    _paid.dispose();
    super.dispose();
  }

  int get _students0 => int.tryParse(_students.text.trim()) ?? 0;
  int get _paidValue => int.tryParse(_paid.text.trim()) ?? 0;
  int get _total => _students0 * photoUnitPrice;

  String? _positive(String? v) {
    final n = int.tryParse(v?.trim() ?? '');
    return (n == null || n <= 0) ? 'Entrez un nombre valide' : null;
  }

  String? Function(String?) _paidValidator(int total) => (v) {
        if (v == null || v.trim().isEmpty) return null;
        final n = int.tryParse(v.trim());
        if (n == null || n < 0) return 'Montant invalide';
        if (n > total) return 'Supérieur au montant total';
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
      await repo.updatePhotoSession(
        widget.session!,
        schoolId: _schoolId!,
        date: _date,
        studentsRegistered: _students0,
        unitPrice: photoUnitPrice,
        amountPaid: _paidValue,
      );
    } else {
      await repo.addPhotoSession(
        schoolId: _schoolId!,
        date: _date,
        studentsRegistered: _students0,
        unitPrice: photoUnitPrice,
        amountPaid: _paidValue,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];
    final remaining = _total - _paidValue;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Modifier la prise de vue' : 'Nouvelle prise de vue'),
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
            TextFormField(
              controller: _students,
              keyboardType: TextInputType.number,
              validator: _positive,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Nombre d’élèves inscrits',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sell_outlined, color: AppColors.muted),
                  const SizedBox(width: 12),
                  Text('Tarif : ${formatFcfa(photoUnitPrice)} par élève',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
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
              validator: _paidValidator(_total),
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Montant payé par l’école (optionnel)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: 20),
            SummaryBanner(label: 'Montant total à payer', amount: _total),
            const SizedBox(height: 12),
            Container(
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
                    color:
                        remaining > 0 ? AppColors.orange : AppColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _save,
              child: Text(_isEdit
                  ? 'Enregistrer les modifications'
                  : 'Enregistrer la prise de vue'),
            ),
          ],
        ),
      ),
    );
  }
}