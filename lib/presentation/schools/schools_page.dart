import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import 'school_form_page.dart';

class SchoolsPage extends ConsumerWidget {
  const SchoolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schools = ref.watch(schoolsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Établissements'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: schools.maybeWhen(
            data: (list) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${list.length} établissement${list.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.navy.withOpacity(0.55),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SchoolFormPage())),
        backgroundColor: AppColors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nouvel établissement',
            style: TextStyle(color: Colors.white)),
      ),
      body: schools.when(
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.school_outlined,
                message: 'Aucun établissement.\nAjoutez votre première école.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _SchoolTile(school: list[i]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

class _SchoolTile extends ConsumerWidget {
  const _SchoolTile({required this.school});

  final School school;

  Color get _badgeBg {
    switch (school.clientType) {
      case ClientType.nouveau:
        return const Color(0xFFE6F4EE);
      case ClientType.ancien:
        return const Color(0xFFE3EEFF);
    }
  }

  Color get _badgeText {
    switch (school.clientType) {
      case ClientType.nouveau:
        return AppColors.success;
      case ClientType.ancien:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => SchoolFormPage(school: school))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Leading avatar
              const CircleAvatar(
                backgroundColor: AppColors.orangeSoft,
                child: Icon(Icons.school_outlined, color: AppColors.navy),
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            school.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _badgeBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            school.clientType.code,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Contact name
                    Text(
                      school.contactName,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // City indicator
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 3),
                        Text(
                          school.city,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Delete button with hover effect
              _DeleteButton(
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
        ),
      ),
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

/// Delete button: grey by default, red on hover/press
class _DeleteButton extends StatefulWidget {
  const _DeleteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: IconButton(
        icon: Icon(
          Icons.delete_outline,
          color: _hovering ? AppColors.danger : Colors.grey[400],
        ),
        onPressed: widget.onPressed,
        splashColor: AppColors.danger.withOpacity(0.12),
        highlightColor: AppColors.danger.withOpacity(0.08),
      ),
    );
  }
}
