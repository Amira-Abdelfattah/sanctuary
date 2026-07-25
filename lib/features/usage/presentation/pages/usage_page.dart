import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../dashboard/presentation/providers/sensor_provider.dart';

/// Usage tab. Shows the electrical readings the ESP32 is actually
/// publishing (voltage, current, instantaneous power) plus a live
/// trend line built from the readings received during this session.
/// There is deliberately no fabricated "weekly trend" — the firmware
/// doesn't store history, so we only chart what we've really seen.
class UsagePage extends StatelessWidget {
  const UsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sensors = context.watch<SensorProvider>();
    final reading = sensors.reading;
    final power = sensors.instantaneousPowerWatts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                AppSpacing.stackSm,
                AppSpacing.containerPadding,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text('Consumption', style: AppTextStyles.headlineLgMobile),
                  const SizedBox(height: 4),
                  Text(
                    "Live readings from your home's power sensors.",
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          icon: Icons.bolt_rounded,
                          label: 'Voltage',
                          value: '${reading.voltage.toStringAsFixed(0)} V',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.gutter),
                      Expanded(
                        child: _StatTile(
                          icon: Icons.electric_meter_rounded,
                          label: 'Current',
                          value: '${reading.current.toStringAsFixed(2)} A',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  _StatTile(
                    icon: Icons.power_rounded,
                    label: 'Instantaneous power',
                    value: '${power.toStringAsFixed(1)} W',
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  Text('Live session trend', style: AppTextStyles.headlineMd),
                  const SizedBox(height: 4),
                  Text(
                    'Power (W) over the readings received since you opened the app.',
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.stackSm),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(AppSpacing.stackMd),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: sensors.powerHistory.length < 2
                        ? Center(
                            child: Text(
                              'Collecting live data...',
                              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          )
                        : LineChart(_buildChartData(sensors.powerHistory)),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.stackMd),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.eco_outlined, color: AppColors.tertiary),
                        const SizedBox(width: AppSpacing.stackSm),
                        Expanded(
                          child: Text(
                            reading.relayActive
                                ? 'Power supply is stable and within safe limits.'
                                : 'Power was cut by the safety relay — resolve the active alert to restore it.',
                            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onTertiaryContainer, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildChartData(List<double> history) {
    final spots = <FlSpot>[
      for (int i = 0; i < history.length; i++) FlSpot(i.toDouble(), history[i]),
    ];
    final maxY = (history.reduce((a, b) => a > b ? a : b) * 1.3).clamp(1, double.infinity);

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minY: 0,
      maxY: maxY.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.25),
                AppColors.primary.withValues(alpha: 0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(AppSpacing.stackMd),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSm),
              Text(value, style: AppTextStyles.headlineMd),
            ],
          ),
        ],
      ),
    );
  }
}
