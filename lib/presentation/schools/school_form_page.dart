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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.school != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifier l’établissement' : 'Nouvel établissement'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _FormSection(
              title: 'Informations',
              children: [
                TextFormField(
                  controller: _name,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l’école',
                    prefixIcon: Icon(Icons.school_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _city,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'Ville',
                    prefixIcon: Icon(Icons.location_city_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _contact,
                  validator: _required,
                  decoration: const InputDecoration(
                    labelText: 'Responsable et contact',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _FormSection(
              title: 'Type de client',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TypeOption(
                        type: ClientType.nouveau,
                        selected: _type == ClientType.nouveau,
                        onTap: () => setState(() => _type = ClientType.nouveau),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeOption(
                        type: ClientType.ancien,
                        selected: _type == ClientType.ancien,
                        onTap: () => setState(() => _type = ClientType.ancien),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton(onPressed: _save, child: const Text('Enregistrer')),
          ],
        ),
      ),
    );
  }
}

/// Bloc de formulaire avec un titre en phrase normale.
class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

/// Carte de choix du type client, avec le montant de l'abonnement.
class _TypeOption extends StatelessWidget {
  const _TypeOption({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ClientType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.ink;
    final sub = selected ? Colors.white70 : AppColors.muted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.navy : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(type.label,
                        style: TextStyle(
                            color: fg,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ),
                  if (selected)
                    const Icon(Icons.check_circle, color: AppColors.orange, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text('${type.subscriptionPrice} FCFA',
                  style: TextStyle(
                      color: fg,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text('Abonnement · ${type.code}',
                  style: TextStyle(color: sub, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
