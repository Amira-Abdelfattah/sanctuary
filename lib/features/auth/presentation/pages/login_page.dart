import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routing/root_shell.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final ok = await auth.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (ok) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) =>  RootShell()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Sign in failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.shield_outlined, color: Color(0xFF344E5F), size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'Sanctuary',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: const Color(0xFF344E5F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your safe haven, simplified and secured.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.asset(
                      'assets/images/onboarding3.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'Email address',
                    hint: 'Email address',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Password',
                    hint: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Login',
                    icon: Icons.arrow_forward,
                    isLoading: auth.isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: Text('Forgot Password?', style: AppTextStyles.labelMd.copyWith(color: Colors.grey)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New to Sanctuary? ', style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
                        child: Text('Sign Up', style: AppTextStyles.bodyMd.copyWith(color: const Color(0xFF344E5F), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}