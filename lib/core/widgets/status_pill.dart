import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

enum SensorStatusLevel { safe, warning, danger }

extension SensorStatusLevelX on SensorStatusLevel {
  Color get dotColor {
    switch (this) {
      case SensorStatusLevel.safe:
        return AppColors.safeGreen;
      case SensorStatusLevel.warning:
        return AppColors.warningOrange;
      case SensorStatusLevel.danger:
        return AppColors.dangerRed;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case SensorStatusLevel.safe:
        return AppColors.safeGreenBg;
      case SensorStatusLevel.warning:
        return AppColors.warningOrangeBg;
      case SensorStatusLevel.danger:
        return AppColors.dangerRedBg;
    }
  }

  String get label {
    switch (this) {
      case SensorStatusLevel.safe:
        return 'Safe';
      case SensorStatusLevel.warning:
        return 'Warning';
      case SensorStatusLevel.danger:
        return 'Danger';
    }
  }
}

/// Small pill used everywhere a sensor's safety state needs to be shown
/// at a glance (dashboard cards, alert rows, history lists).
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.level, this.uppercaseLabel = false});

  final SensorStatusLevel level;
  final bool uppercaseLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: level.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: level.dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            uppercaseLabel ? level.label.toUpperCase() : level.label,
            style: AppTextStyles.labelSm.copyWith(
              color: level.dotColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
