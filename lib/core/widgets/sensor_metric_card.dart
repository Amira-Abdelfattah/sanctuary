import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'status_pill.dart';

/// Compact metric card used in the dashboard's bento grid
/// (Power, Climate, ...). For the full-width gas card use
/// [SensorMetricCard.fullWidth].
class SensorMetricCard extends StatelessWidget {
  const SensorMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.level,
    this.unit,
    this.icon,
    this.fullWidth = false,
  });

  final String title;
  final String value;
  final String? unit;
  final SensorStatusLevel level;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: fullWidth ? _buildFullWidthContent() : _buildSquareContent(),
    );

    return content;
  }

  Widget _buildFullWidthContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: AppTextStyles.labelSm.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: AppTextStyles.headlineLg),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(unit!, style: AppTextStyles.labelMd.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ],
            ),
            const SizedBox(height: 8),
            StatusPill(level: level),
          ],
        ),
        if (icon != null)
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: level.backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: level.dotColor, size: 28),
          ),
      ],
    );
  }

  Widget _buildSquareContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toUpperCase(), style: AppTextStyles.labelSm.copyWith(letterSpacing: 1.2)),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.headlineMd),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StatusPill(level: level),
            if (icon != null) Icon(icon, color: level.dotColor, size: 22),
          ],
        ),
      ],
    );
  }
}
