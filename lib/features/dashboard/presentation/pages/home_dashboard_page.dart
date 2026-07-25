import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/sensor_metric_card.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/home_status_hero_card.dart';

/// Home tab — mirrors the "home_dashboard" Stitch design: hero status
/// card, gas level (full width), power + climate bento grid, and a
/// "View alerts" CTA. [onViewAlerts] lets the parent shell switch tabs
/// without this page knowing about routing.
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key, this.onViewAlerts});

  final VoidCallback? onViewAlerts;

  @override
  Widget build(BuildContext context) {
    final sensors = context.watch<SensorProvider>();
    final user = context.watch<AuthProvider>().user;
    final reading = sensors.reading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.containerPadding,
                  AppSpacing.stackSm,
                  AppSpacing.containerPadding,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_rounded, color: AppColors.primary, size: 26),
                        const SizedBox(width: 8),
                        Text('Sanctuary', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(
                        (user?.displayName?.isNotEmpty == true
                                ? user!.displayName![0]
                                : (user?.email?.isNotEmpty == true ? user!.email![0] : '?'))
                            .toUpperCase(),
                        style: AppTextStyles.labelMd.copyWith(color: AppColors.onPrimaryContainer),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                AppSpacing.stackMd,
                AppSpacing.containerPadding,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (!sensors.hasReceivedData)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.stackMd),
                      child: _ConnectingBanner(),
                    ),
                  HomeStatusHeroCard(
                    isSafe: reading.isHomeSafe,
                    subtitle: reading.isHomeSafe
                        ? 'All systems operational. No threats detected.'
                        : reading.statusMessage,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  SensorMetricCard(
                    title: 'Gas level',
                    value: reading.gasLevel.toString(),
                    unit: 'raw',
                    level: reading.gasStatus,
                    icon: Icons.propane_tank_outlined,
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SensorMetricCard(
                          title: 'Voltage',
                          value: reading.voltage.toStringAsFixed(0),
                          unit: 'V',
                          level: reading.voltageAlert ? SensorStatusLevel.danger : SensorStatusLevel.safe,
                          icon: Icons.bolt_outlined,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.gutter),
                      Expanded(
                        child: SensorMetricCard(
                          title: 'Current',
                          value: reading.current.toStringAsFixed(2),
                          unit: 'A',
                          level: reading.currentAlert ? SensorStatusLevel.danger : SensorStatusLevel.safe,
                          icon: Icons.electric_meter_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.gutter),
                  SensorMetricCard(
                    title: 'Relay / power supply',
                    value: reading.relayActive ? 'Power on' : 'Power cut',
                    level: reading.relayActive ? SensorStatusLevel.safe : SensorStatusLevel.danger,
                    icon: reading.relayActive ? Icons.power_outlined : Icons.power_off_outlined,
                    fullWidth: true,
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  PrimaryButton(
                    label: 'View alerts',
                    icon: Icons.notifications_outlined,
                    onPressed: onViewAlerts,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectingBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.stackMd, vertical: AppSpacing.stackSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Connecting to your Sanctuary device...',
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
