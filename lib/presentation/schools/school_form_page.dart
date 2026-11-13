import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';

class SchoolFormPage extends ConsumerStatefulWidget {
  const SchoolFormPage({super.key, this.school});

  final School? school;

  @override
  ConsumerState<SchoolFormPage> createState() => _SchoolFormPageState();
}

class _SchoolFormPageState extends ConsumerState<SchoolFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _city;
  late final TextEditingController _contact;
  late ClientType _type;

  @override
  void initState() {
    super.initState();
    final s = widget.school;
    _name = TextEditingController(text: s?.name);
    _city = TextEditingController(text: s?.city);
    _contact = TextEditingController(text: s?.contactName);
    _type = s?.clientType ?? ClientType.nouveau;
  }

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _contact.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().length < 2) ? 'Champ obligatoire' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(financeRepositoryProvider).saveSchool(School(
          id: widget.school?.id,
          name: _name.text.trim(),
          city: _city.text.trim(),
          contactName: _contact.text.trim(),
          clientType: _type,
        ));
    if (mounted) Navigator.pop(context);
  }

  Color get _typeColor {
    switch (_type) {
      case ClientType.nouveau:
        return AppColors.success;
      case ClientType.ancien:
        return const Color(0xFF2563EB);
    }
  }

  Color get _typeBgColor {
    switch (_type) {
      case ClientType.nouveau:
        return const Color(0xFFE6F4EE);
      case ClientType.ancien:
        return const Color(0xFFE3EEFF);
    }
  }

  static const _subtleBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color(0xFFDDE3F0), width: 1.5),
  );

  static const _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: AppColors.navy, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.school != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier l'établissement' : 'Nouvel établissement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ── Visual header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school,
                        size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isEdit ? 'Modifier l'établissement' : 'Nouvel établissement',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // ── Form fields ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _name,
                    validator: _required,
                    decoration: InputDecoration(
                      labelText: 'Nom de l'école',
                      prefixIcon: const Icon(Icons.school_outlined),
                      enabledBorder: _subtleBorder,
                      focusedBorder: _focusedBorder,
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _city,
                    validator: _required,
                    decoration: InputDecoration(
                      labelText: 'Ville',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      enabledBorder: _subtleBorder,
                      focusedBorder: _focusedBorder,
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _contact,
                    validator: _required,
                    decoration: InputDecoration(
                      labelText: 'Responsable et contact',
                      prefixIcon: const Icon(Icons.person_outline),
                      enabledBorder: _subtleBorder,
                      focusedBorder: _focusedBorder,
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide:
                            BorderSide(color: AppColors.danger, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Type de client ───────────────────────────────────
                  const Text('Type de client',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SegmentedButton<ClientType>(
                            segments: [
                              for (final t in ClientType.values)
                                ButtonSegment(
                                    value: t,
                                    label: Text('${t.label} (${t.code})')),
                            ],
                            selected: {_type},
                            onSelectionChanged: (s) =>
                                setState(() => _type = s.first),
                          ),
                          const SizedBox(height: 12),
                          // Tariff description badge
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _typeBgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Abonnement : ${_type.subscriptionPrice} FCFA',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _typeColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Save button ──────────────────────────────────────
                  FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52)),
                    child: Text(
                      isEdit ? 'Modifier' : 'Créer l'établissement',
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
