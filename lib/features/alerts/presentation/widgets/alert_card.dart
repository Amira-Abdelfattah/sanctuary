import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../domain/entities/alert_item.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key, required this.alert});

  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.stackSm),
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: alert.level.backgroundColor, shape: BoxShape.circle),
                child: Icon(alert.icon, color: alert.level.dotColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.stackSm),
              Expanded(
                child: Text(alert.title, style: AppTextStyles.labelMd.copyWith(fontSize: 15)),
              ),
              StatusPill(level: alert.level, uppercaseLabel: true),
            ],
          ),
          const SizedBox(height: AppSpacing.stackSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: alert.level.backgroundColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border(left: BorderSide(color: alert.level.dotColor, width: 3)),
            ),
            child: Text(
              'Action: ${alert.actionHint}',
              style: AppTextStyles.bodyMd.copyWith(color: alert.level.dotColor, fontSize: 14),
            ),
          ),
          const SizedBox(height: 6),
          Text(alert.message, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 14)),
        ],
      ),
    );
  }
}
