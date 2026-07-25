import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import 'auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Smart Monitoring',
      description: 'Your home is constantly scanned for potential risks. Experience the peace of mind that comes with invisible protection.',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingData(
      title: 'AI Safety Alerts',
      description: 'Instant notifications the moment a leak or surge is detected.',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingData(
      title: 'Easy Home Protection',
      description: 'Peace of mind for you and your family, simplified.',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, index) => OnboardingContent(data: _pages[index]),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text('Sanctuary', style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF344E5F))),
            ],
          ),
          if (_currentPage < _pages.length - 1)
            TextButton(onPressed: _finishOnboarding, child: Text('Skip', style: AppTextStyles.labelMd.copyWith(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) => _buildDot(index)),
          ),
          const SizedBox(height: 32),
          _OnboardingButton(
            text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
            onPressed: _nextPage,
            showIcon: true,
          ),
          const SizedBox(height: 16),
          _currentPage == 0
              ? TextButton(onPressed: _finishOnboarding, child: Text('Skip for now', style: AppTextStyles.labelMd.copyWith(color: Colors.grey)))
              : const SizedBox(height: 48), // Maintain spacing consistency
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool active = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6, width: active ? 24 : 6,
      decoration: BoxDecoration(color: active ? AppColors.primary : Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final OnboardingData data;
  const OnboardingContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 280), // Responsive height
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))]
                ),
                padding: const EdgeInsets.all(24),
                child: Image.asset(data.image, fit: BoxFit.contain),
              ),
              const SizedBox(height: 40),
              Text(data.title, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(data.description, style: AppTextStyles.bodyMd.copyWith(color: Colors.black54), textAlign: TextAlign.center),
              const SizedBox(height: 20), // Extra space for scroll comfort
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool showIcon;
  const _OnboardingButton({required this.text, required this.onPressed, this.showIcon = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 58,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF456277),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
            elevation: 0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            if (showIcon) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title, description, image;
  OnboardingData({required this.title, required this.description, required this.image});
}