import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_text_styles.dart';
import 'onboarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // We show the Splash view directly as per your request for no auth logic here
    return const _SplashView();
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EEF2), Colors.white],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
            child: Column(
              children: [
                const Spacer(flex: 3),
                const _LogoCard(),
                const SizedBox(height: AppSpacing.stackLg),
                const _BrandHeader(),
                const SizedBox(height: 60),
                const _StatusIndicator(),
                const Spacer(flex: 4),
                _BeginButton(),
                const SizedBox(height: AppSpacing.stackSm),
                const _FooterText(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoCard extends StatelessWidget {
  const _LogoCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sanctuary',
          style: AppTextStyles.headlineLg.copyWith(
            color: const Color(0xFF344E5F),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Home Safety Companion',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF456277), shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Text(
          'INITIALIZING SECURITY',
          style: AppTextStyles.labelSm.copyWith(letterSpacing: 2.0, fontWeight: FontWeight.bold, color: const Color(0xFF344E5F)),
        ),
      ],
    );
  }
}

class _BeginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  OnboardingPage())),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF456277),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          elevation: 0,
        ),
        child: const Text('Begin Journey', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText();
  @override
  Widget build(BuildContext context) {
    return Text(
      'Establishing encrypted connection...',
      style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.4), fontSize: 11),
    );
  }
}