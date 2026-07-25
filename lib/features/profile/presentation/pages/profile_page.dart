import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final initial = (user?.displayName?.isNotEmpty == true
            ? user!.displayName![0]
            : (user?.email?.isNotEmpty == true ? user!.email![0] : '?'))
        .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerPadding,
                AppSpacing.stackMd,
                AppSpacing.containerPadding,
                120,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            initial,
                            style: AppTextStyles.headlineLg.copyWith(color: AppColors.onPrimaryContainer),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.stackSm),
                        Text(
                          user?.displayName?.isNotEmpty == true ? user!.displayName! : 'Sanctuary user',
                          style: AppTextStyles.headlineMd,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackLg),
                  _ProfileTile(icon: Icons.person_outline_rounded, label: 'Edit profile', onTap: () {}),
                  _ProfileToggleTile(icon: Icons.notifications_outlined, label: 'Push notifications'),
                  _ProfileTile(icon: Icons.contact_emergency_outlined, label: 'Emergency contact', onTap: () {}),
                  _ProfileTile(icon: Icons.help_outline_rounded, label: 'Help & support', onTap: () {}),
                  const SizedBox(height: AppSpacing.stackLg),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context, auth),
                      icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                      label: Text('Log out', style: AppTextStyles.labelMd.copyWith(color: AppColors.error)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.stackMd),
                  Center(
                    child: Text(
                      'Sanctuary · v1.0.0',
                      style: AppTextStyles.labelSm,
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

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to view your home status.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              auth.signOut();
            },
            child: Text('Log out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.stackSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(label, style: AppTextStyles.bodyMd),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      ),
    );
  }
}

class _ProfileToggleTile extends StatefulWidget {
  const _ProfileToggleTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  State<_ProfileToggleTile> createState() => _ProfileToggleTileState();
}

class _ProfileToggleTileState extends State<_ProfileToggleTile> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.stackSm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Icon(widget.icon, color: AppColors.primary, size: 20),
        ),
        title: Text(widget.label, style: AppTextStyles.bodyMd),
        trailing: Switch(
          value: _enabled,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => _enabled = v),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      ),
    );
  }
}
