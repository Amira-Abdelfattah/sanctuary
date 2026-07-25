import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The big "Your Home is Safe" / "Attention Needed" hero card at the
/// top of the dashboard, with a soft pulsing status indicator.
class HomeStatusHeroCard extends StatefulWidget {
  const HomeStatusHeroCard({super.key, required this.isSafe, required this.subtitle});

  final bool isSafe;
  final String subtitle;

  @override
  State<HomeStatusHeroCard> createState() => _HomeStatusHeroCardState();
}

class _HomeStatusHeroCardState extends State<HomeStatusHeroCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSafe ? AppColors.safeGreen : AppColors.dangerRed;
    final bgColor = widget.isSafe ? AppColors.safeGreenBg : AppColors.dangerRedBg;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final scale = 0.95 + (_controller.value * 0.1);
                final opacity = 0.8 - (_controller.value * 0.4);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: opacity * 0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                      child: Icon(
                        widget.isSafe ? Icons.verified_user_rounded : Icons.warning_rounded,
                        color: color,
                        size: 32,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Text(
            widget.isSafe ? 'Your home is safe' : 'Attention needed',
            style: AppTextStyles.headlineLgMobile,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            widget.subtitle,
            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.stackMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.isSafe ? 'SECURED' : 'ALERT',
                  style: AppTextStyles.labelSm.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
