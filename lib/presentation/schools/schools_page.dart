import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';
import '../widgets/app_search_field.dart';
import '../widgets/app_widgets.dart';
import '../widgets/empty_state.dart';
import 'school_form_page.dart';

class SchoolsPage extends ConsumerStatefulWidget {
  const SchoolsPage({super.key});

  @override
  ConsumerState<SchoolsPage> createState() => _SchoolsPageState();
}

class _SchoolsPageState extends ConsumerState<SchoolsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Établissements')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SchoolFormPage())),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel établissement'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AppSearchField(
              hint: 'Rechercher une école, une ville, un contact',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: schools.when(
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.school_outlined,
                    message:
                        'Aucun établissement.\nAjoutez votre première école.',
                  );
                }
                final filtered = list
                    .where((s) =>
                        matchesQuery(_query, [s.name, s.city, s.contactName]))
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
                  itemBuilder: (context, i) =>
                      _SchoolItem(school: filtered[i]),
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

class _SchoolItem extends ConsumerWidget {
  const _SchoolItem({required this.school});

  final School school;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = school.clientType == ClientType.nouveau;
    return AppListItem(
      icon: Icons.school_outlined,
      accent: isNew ? AppColors.orange : AppColors.navy,
      title: school.name,
      subtitle: '${school.city} · ${school.contactName}\n${school.clientType.label}',
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: AppColors.danger),
        onPressed: () => _confirmDelete(context, ref),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => SchoolFormPage(school: school))),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cet établissement ?'),
        content: const Text(
            'Ses abonnements et prises de vue seront supprimés. '
            'Les mouvements de caisse seront conservés sans établissement.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true && school.id != null) {
      await ref.read(financeRepositoryProvider).deleteSchool(school.id!);
    }
  }
}