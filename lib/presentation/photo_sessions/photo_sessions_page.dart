import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/school_picker.dart';

/// Tarif fixe d'une prise de vue, par élève.
const photoUnitPrice = 500;

class PhotoSessionsPage extends ConsumerWidget {
  const PhotoSessionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(photoSessionsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Prises de vue')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.orange,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PhotoSessionFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle prise de vue'),
      ),
      body: sessions.when(
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.photo_camera_outlined,
                message: 'Aucune prise de vue.\nAjoutez la première séance.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final p = list[i];
                  final name = schools
                          .where((e) => e.id == p.schoolId)
                          .map((e) => e.name)
                          .firstOrNull ??
                      'École supprimée';
                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top row: school name + date
                          Row(
                            children: [
                              Expanded(
                                child: Text(name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                              Text(formatDate(p.date),
                                  style: TextStyle(
                                      color: AppColors.navy.withOpacity(0.6),
                                      fontSize: 13)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Middle: students badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.orangeSoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '📸 ${p.studentsRegistered} élèves',
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Bottom: total amount
                          Text(
                            formatFcfa(p.amountDue),
                            style: const TextStyle(
                                fontSize: 22,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class PhotoSessionFormPage extends ConsumerStatefulWidget {
  const PhotoSessionFormPage({super.key});

  @override
  ConsumerState<PhotoSessionFormPage> createState() =>
      _PhotoSessionFormPageState();
}

class _PhotoSessionFormPageState extends ConsumerState<PhotoSessionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _students = TextEditingController();
  int? _schoolId;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _students.dispose();
    super.dispose();
  }

  int get _total =>
      (int.tryParse(_students.text) ?? 0) * photoUnitPrice;

  String? _positive(String? v) {
    final n = int.tryParse(v ?? '');
    return (n == null || n <= 0) ? 'Entrez un nombre valide' : null;
  }

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
    await ref.read(financeRepositoryProvider).addPhotoSession(
          schoolId: _schoolId!,
          date: _date,
          studentsRegistered: int.parse(_students.text),
          unitPrice: photoUnitPrice,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle prise de vue')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
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
                labelText: 'Nombre d\u2019élèves inscrits',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
            ),
            const SizedBox(height: 14),
            // Tarif: Card with AppColors.surface background
            Card(
              elevation: 0,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.sell_outlined),
                    const SizedBox(width: 12),
                    Text('Tarif : ${formatFcfa(photoUnitPrice)} par élève'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(formatDate(_date)),
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),
            // AnimatedContainer for total preview
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.orangeSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Montant total à payer'),
                  const SizedBox(height: 4),
                  Text(formatFcfa(_total),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _save,
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Enregistrer la prise de vue'),
            ),
          ],
        ),
      ),
    );
  }
}
