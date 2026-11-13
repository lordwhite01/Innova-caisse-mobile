import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/entities.dart';
import '../cash/cash_page.dart';
import '../photo_sessions/photo_sessions_page.dart';
import '../providers.dart';
import '../receivables/receivables_page.dart';
import '../schools/schools_page.dart';
import '../subscriptions/subscriptions_page.dart';
import 'widgets/home_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(cashSummaryProvider);

    final items = <_NavItem>[
      _NavItem('ÉTABLISSEMENT', Icons.school_outlined, const SchoolsPage()),
      _NavItem('ABONNEMENT', Icons.card_membership_outlined,
          const SubscriptionsPage()),
      _NavItem('PRISE DE VUE', Icons.photo_camera_outlined,
          const PhotoSessionsPage()),
      _NavItem('ENTRÉE ET SORTIE', Icons.swap_vert_circle_outlined,
          const CashPage()),
      _NavItem('CRÉANCES', Icons.receipt_long_outlined,
          const ReceivablesPage()),
    ];

    return Scaffold(
      body: Column(
        children: [
          _Header(
            summary: summary.valueOrNull,
            showBalance: _showBalance,
            onToggle: () => setState(() => _showBalance = !_showBalance),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                for (final item in items)
                  HomeCard(
                    label: item.label,
                    icon: item.icon,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item.page),
                    ),
                  ),
              ],
            ),
          ),
          // Footer (item 6)
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 4),
            child: Text(
              'Innova School · Caisse v1.0',
              style: TextStyle(
                color: AppColors.navy.withOpacity(0.4),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.page);
  final String label;
  final IconData icon;
  final Widget page;
}

// ─── Helpers for date & greeting ──────────────────────────────────────────────

String _formatDate(DateTime d) {
  const jours = [
    'lundi', 'mardi', 'mercredi', 'jeudi',
    'vendredi', 'samedi', 'dimanche'
  ];
  const mois = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
  ];
  // DateTime.weekday: 1=lundi … 7=dimanche
  final jour = jours[d.weekday - 1];
  final m = mois[d.month - 1];
  return '$jour ${d.day} $m ${d.year}';
}

String _greeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Bonjour ☀️';
  if (h < 18) return 'Bon après-midi 🌤';
  return 'Bonsoir 🌙';
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.summary,
    required this.showBalance,
    required this.onToggle,
  });

  final CashSummary? summary;
  final bool showBalance;
  final VoidCallback onToggle;

  String _amount(int? value) {
    if (value == null) return '—';
    return showBalance ? formatFcfa(value) : '•••••••';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        // Item 1 — gradient
        gradient: LinearGradient(
          colors: [AppColors.navy, Color(0xFF1A237E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(90)),
        // Item 5 — box shadow
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: logo + title / date (item 2)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/owl.jpeg',
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'INNOVA SCHOOL CAISSE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                  ),
                  // Item 2 — date du jour
                  Text(
                    _formatDate(now),
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Item 3 — greeting
              Text(
                _greeting(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text('Solde de caisse',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _amount(summary?.balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onToggle,
                    tooltip: showBalance ? 'Masquer' : 'Afficher',
                    icon: Icon(
                      showBalance
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: 'Total encaissé',
                      value: _amount(summary?.totalIn),
                      icon: Icons.arrow_downward_rounded,
                      color: const Color(0xFF6FD3A0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: 'Total décaissé',
                      value: _amount(summary?.totalOut),
                      icon: Icons.arrow_upward_rounded,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── StatTile ─────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Item 4 — left border + slightly lighter background
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: color, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
        ],
      ),
    );
  }
}
