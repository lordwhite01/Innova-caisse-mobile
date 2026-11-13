import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../providers.dart';
import '../widgets/empty_state.dart';
import '../widgets/school_picker.dart';

// ─────────────────────────────────────────────
// SubscriptionsPage
// ─────────────────────────────────────────────

class SubscriptionsPage extends ConsumerWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subs = ref.watch(subscriptionsProvider);
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Abonnements')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SubscriptionFormPage())),
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nouvel abonnement'),
      ),
      body: subs.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.card_membership_outlined,
              message: 'Aucun abonnement enregistré.',
              hint: 'Appuyez sur + pour ajouter le premier abonnement.',
            );
          }

          final total = list.fold<int>(0, (sum, s) => sum + s.amount);

          return Column(
            children: [
              // ── Sous-total header ──
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bar_chart_rounded,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${list.length} abonnement${list.length > 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      formatFcfa(total),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // ── Liste ──
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final s = list[i];
                    final name = schools
                            .where((e) => e.id == s.schoolId)
                            .map((e) => e.name)
                            .firstOrNull ??
                        'École supprimée';
                    return _SubscriptionCard(
                        subscription: s, schoolName: name);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _SubscriptionCard
// ─────────────────────────────────────────────

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.schoolName,
  });

  final Subscription subscription;
  final String schoolName;

  @override
  Widget build(BuildContext context) {
    final isNew = subscription.kind.toLowerCase().contains('abonn');
    final badgeColor = isNew ? AppColors.success : AppColors.orange;
    final badgeLabel = _cap(subscription.kind);

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── Icône dans cercle orangeSoft ──
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.orangeSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_membership,
                color: AppColors.orange,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            // ── Infos ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          schoolName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Badge type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            color: badgeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${formatDate(subscription.date)} · ${_clientLabel(subscription)}',
                    style: TextStyle(
                      color: AppColors.navy.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // ── Montant ──
            Text(
              formatFcfa(subscription.amount),
              style: const TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  String _clientLabel(Subscription s) {
    // Try to surface a readable client-type label if the entity has one,
    // otherwise fall back to the kind field.
    return _cap(s.kind);
  }
}

// ─────────────────────────────────────────────
// SubscriptionFormPage
// ─────────────────────────────────────────────

class SubscriptionFormPage extends ConsumerStatefulWidget {
  const SubscriptionFormPage({super.key});

  @override
  ConsumerState<SubscriptionFormPage> createState() =>
      _SubscriptionFormPageState();
}

class _SubscriptionFormPageState extends ConsumerState<SubscriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  int? _schoolId;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(financeRepositoryProvider).addSubscription(_schoolId!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolsProvider).valueOrNull ?? [];
    final selected = schools.where((s) => s.id == _schoolId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Nouvel abonnement')),
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
            const SizedBox(height: 20),
            // ── Preview card with animated transition ──
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: selected == null
                  ? const SizedBox.shrink()
                  : _SubscriptionPreview(
                      key: ValueKey(selected.id),
                      school: selected,
                    ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: selected == null ? null : _save,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.navy.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Valider l\'abonnement ✓',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _SubscriptionPreview
// ─────────────────────────────────────────────

class _SubscriptionPreview extends StatelessWidget {
  const _SubscriptionPreview({super.key, required this.school});

  final School school;

  @override
  Widget build(BuildContext context) {
    final isNew = school.clientType == ClientType.nouveau;
    final typeLabel = isNew ? 'Abonnement' : 'Réabonnement';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.card_membership,
              color: AppColors.orange,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      typeLabel,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_outlined,
                      color: AppColors.orange,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatFcfa(school.clientType.subscriptionPrice),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  school.clientType.label,
                  style: TextStyle(
                    color: AppColors.navy.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
