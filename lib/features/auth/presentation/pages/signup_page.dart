import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreed = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms of Service first.')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      // Signup succeeded → pop back to the root route so the
      // Splash/AuthProvider tree (which is now "authenticated")
      // shows the RootShell instead of the Login screen.
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Sign up failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8EEF2), Colors.white],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.containerPadding),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildFormCard(),
                      const SizedBox(height: 24),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.shield_outlined,
                color: Color(0xFF344E5F), size: 24),
            const SizedBox(width: 8),
            Text('Sanctuary',
                style: AppTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF344E5F))),
          ]),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Login',
                  style: AppTextStyles.labelMd.copyWith(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFFACCAE3).withOpacity(0.5),
              shape: BoxShape.circle),
          child: const Icon(Icons.lock_open_outlined,
              color: Color(0xFF344E5F), size: 32),
        ),
        const SizedBox(height: 20),
        Text('Begin Your Journey',
            style:
                AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(
          'Secure your sanctuary with ease.\nCreate an account to manage your devices.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _LabeledField(
                label: 'Full Name',
                child: AppTextField(
                    label: '',
                    hint: 'John Doe',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline)),
            const SizedBox(height: 16),
            _LabeledField(
                label: 'Email Address',
                child: AppTextField(
                    label: '',
                    hint: 'name@example.com',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined)),
            const SizedBox(height: 16),
            _LabeledField(
                label: 'Password',
                child: AppTextField(
                    label: '',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: true,
                    prefixIcon: Icons.key_outlined)),
            const SizedBox(height: 16),
            _LabeledField(
                label: 'Confirm',
                child: AppTextField(
                    label: '',
                    hint: '••••••••',
                    controller: _confirmController,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline)),
            const SizedBox(height: 16),
            _LabeledField(
                label: 'Smart Home Location', child: _LocationDropdown()),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v!)),
                Expanded(
                    child: Text(
                        'I agree to the Terms of Service and Privacy Policy.',
                        style: AppTextStyles.labelSm)),
              ],
            ),
            const SizedBox(height: 24),
            PrimaryButton(
                label: 'Create Account',
                icon: Icons.arrow_forward,
                onPressed: _submit),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Wrap(
      // استبدال Row بـ Wrap لمنع الـ Overflow
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'Already have a Sanctuary account? ',
          style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Sign In',
            style: AppTextStyles.bodyMd.copyWith(
              color: const Color(0xFF344E5F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const _LabeledField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelMd
                .copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.location_on_outlined, size: 20)),
      hint: const Text('Select location'),
      items: ['Home', 'Office', 'Villa']
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) {},
    );
  }
}
