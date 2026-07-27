import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/sensor_reading.dart';

/// Displays the verdict from the separate Python Isolation Forest
/// service (see /ai_anomaly_detection in the repo), which runs
/// independently of the ESP32 firmware and writes its result to
/// `/data/ai_anomaly` + `/data/ai_anomaly_score`.
///
/// Shows a neutral "not running yet" state when [reading.hasAiData] is
/// false, so first-time setup doesn't look like a bug.
class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key, required this.reading});

  final SensorReading reading;

  @override
  Widget build(BuildContext context) {
    if (!reading.hasAiData) {
      return _buildContainer(
        color: AppColors.surfaceContainerHigh,
        child: Row(
          children: [
            Icon(Icons.psychology_outlined, color: AppColors.onSurfaceVariant, size: 22),
            const SizedBox(width: AppSpacing.stackSm),
            Expanded(
              child: Text(
                'AI Insight: service not connected yet.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    final isAnomaly = reading.aiAnomaly;
    final color = isAnomaly ? AppColors.warningOrange : AppColors.safeGreen;
    final bgColor = isAnomaly ? AppColors.warningOrangeBg : AppColors.safeGreenBg;

    return _buildContainer(
      color: bgColor,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), shape: BoxShape.circle),
            child: Icon(Icons.psychology_rounded, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.stackSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAnomaly ? 'Unusual pattern detected' : 'Pattern: Normal',
                  style: AppTextStyles.labelMd.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  isAnomaly
                      ? 'Not a hard threshold breach, but statistically unusual for this home.'
                      : 'Readings match this home\'s typical behavior.',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '${reading.aiConfidencePercent}%',
            style: AppTextStyles.headlineMd.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer({required Color color, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: child,
    );
  }
}
