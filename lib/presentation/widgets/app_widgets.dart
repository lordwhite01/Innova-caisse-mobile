import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';

/// Ligne de liste unifiée : pastille d'icône, titre, sous-titre et action optionnelle.
class AppListItem extends StatelessWidget {
  const AppListItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.accent = AppColors.navy,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(subtitle!,
                          style: theme.textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Montant formaté en FCFA, chiffres alignés.
class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.amount,
    this.color = AppColors.ink,
    this.prefix = '',
    this.fontSize = 15,
  });

  final int amount;
  final Color color;
  final String prefix;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$prefix${formatFcfa(amount)}',
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

/// Bandeau de synthèse sur fond bleu nuit.
class SummaryBanner extends StatelessWidget {
  const SummaryBanner({super.key, required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          AmountText(
            amount: amount,
            color: Colors.white,
            fontSize: 26,
          ),
        ],
      ),
    );
  }
}

/// Statut de paiement calculé à partir du montant dû et du montant payé.
enum PaymentStatus { paye, partiel, impaye }

PaymentStatus paymentStatusOf(int due, int paid) {
  if (due > 0 && paid >= due) return PaymentStatus.paye;
  if (paid > 0) return PaymentStatus.partiel;
  return PaymentStatus.impaye;
}

/// Pastille colorée indiquant le statut : Payé, Partiel ou Impayé.
class PaymentStatusChip extends StatelessWidget {
  const PaymentStatusChip({super.key, required this.due, required this.paid});

  final int due;
  final int paid;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (paymentStatusOf(due, paid)) {
      PaymentStatus.paye => ('Payé', AppColors.success),
      PaymentStatus.partiel => ('Partiel', AppColors.orange),
      PaymentStatus.impaye => ('Impayé', AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Ligne de liste affichant un élément avec son statut, sa progression de paiement,
/// le montant payé et le reste à payer.
class PaymentListItem extends StatelessWidget {
  const PaymentListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.dateText,
    required this.due,
    required this.paid,
    this.accent = AppColors.navy,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String dateText;
  final int due;
  final int paid;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = due - paid < 0 ? 0 : due - paid;
    final progress = due > 0 ? (paid / due).clamp(0.0, 1.0) : 0.0;
    final isPaid = paymentStatusOf(due, paid) == PaymentStatus.paye;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text(dateText,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AmountText(amount: due, fontSize: 14),
                      const SizedBox(height: 6),
                      PaymentStatusChip(due: due, paid: paid),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  color: isPaid ? AppColors.success : accent,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Payé ${formatFcfa(paid)}', style: theme.textTheme.bodyMedium),
                  const Spacer(),
                  Text(
                    'Reste ${formatFcfa(remaining)}',
                    style: TextStyle(
                      color: remaining > 0 ? AppColors.orange : AppColors.success,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
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