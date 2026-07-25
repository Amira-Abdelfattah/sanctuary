import 'package:flutter/material.dart';
import '../../shared/widgets/app_bottom_nav_bar.dart';
import '../../features/dashboard/presentation/pages/home_dashboard_page.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/usage/presentation/pages/usage_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

/// Owns the current tab and lays the four main pages + bottom nav bar
/// on top of an [IndexedStack] so switching tabs never rebuilds the
/// other pages' state (e.g. scroll position, chart animation).
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  AppTab _currentTab = AppTab.home;

  void _goTo(AppTab tab) => setState(() => _currentTab = tab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTab.index,
            children: [
              HomeDashboardPage(onViewAlerts: () => _goTo(AppTab.alerts)),
              const AlertsPage(),
              const UsagePage(),
              const ProfilePage(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomNavBar(currentTab: _currentTab, onTabSelected: _goTo),
          ),
        ],
      ),
    );
  }
}
