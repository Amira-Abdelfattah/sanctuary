import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../dashboard/presentation/providers/sensor_provider.dart';
import '../providers/alerts_builder.dart';
import '../widgets/alert_card.dart';

enum _AlertFilter { all, critical, warning }

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  _AlertFilter _filter = _AlertFilter.all;

  @override
  Widget build(BuildContext context) {
    final reading = context.watch<SensorProvider>().reading;
    final allAlerts = AlertsBuilder.build(reading);

    final filtered = allAlerts.where((a) {
      switch (_filter) {
        case _AlertFilter.all:
          return true;
        case _AlertFilter.critical:
          return a.level == SensorStatusLevel.danger;
        case _AlertFilter.warning:
          return a.level == SensorStatusLevel.warning;
      }
    }).toList();

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
                  Text('Recent activity', style: AppTextStyles.headlineLgMobile),
                  const SizedBox(height: 4),
                  Text(
                    "Stay updated with your home's security status.",
                    style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  Row(
                    children: [
                      _FilterChip(
                        label: 'All alerts',
                        selected: _filter == _AlertFilter.all,
                        onTap: () => setState(() => _filter = _AlertFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Critical',
                        selected: _filter == _AlertFilter.critical,
                        onTap: () => setState(() => _filter = _AlertFilter.critical),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Warning',
                        selected: _filter == _AlertFilter.warning,
                        onTap: () => setState(() => _filter = _AlertFilter.warning),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  if (filtered.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.stackLg),
                      child: Center(
                        child: Text(
                          'No alerts in this category.',
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ),
                    )
                  else
                    ...filtered.map((alert) => AlertCard(alert: alert)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
