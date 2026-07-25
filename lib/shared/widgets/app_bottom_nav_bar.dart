import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// The four primary destinations of the app, in tab order.
enum AppTab { home, alerts, usage, profile }

/// Glassmorphism-style bottom navigation shared by Home / Alerts / Usage /
/// Profile. Pass [currentTab] + [onTabSelected] from a parent that owns
/// an [IndexedStack] (or router) so the tab bar stays a dumb, reusable
/// widget with no navigation logic of its own.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  static const _items = [
    (tab: AppTab.home, icon: Icons.home_rounded, outlineIcon: Icons.home_outlined, label: 'Home'),
    (tab: AppTab.alerts, icon: Icons.notifications_rounded, outlineIcon: Icons.notifications_outlined, label: 'Alerts'),
    (tab: AppTab.usage, icon: Icons.analytics_rounded, outlineIcon: Icons.analytics_outlined, label: 'Usage'),
    (tab: AppTab.profile, icon: Icons.person_rounded, outlineIcon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((item) {
          final isActive = item.tab == currentTab;
          return _NavItem(
            icon: isActive ? item.icon : item.outlineIcon,
            label: item.label,
            isActive: isActive,
            onTap: () => onTabSelected(item.tab),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.labelSm.copyWith(
                color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
