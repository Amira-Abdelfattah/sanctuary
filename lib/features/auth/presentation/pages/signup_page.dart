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

  static const routeName = '/signup';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

const _homeLocationOptions = [
  'Apartment',
  'Detached House',
  'Office Space',
  'Condominium',
];

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _homeLocation;
  bool _agreedToTerms = false;
  bool _showTermsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState!.validate();

    // Checkbox has no built-in FormField validator here, so it's
    // checked separately and surfaced as its own inline error.
    setState(() => _showTermsError = !_agreedToTerms);

    if (!formValid || !_agreedToTerms) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim(),
      extraProfileData: {
        'homeLocation': _homeLocation,
      },
    );

    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Sign up failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: AppColors.primary, size: 26),
                    const SizedBox(width: 8),
                    Text('Sanctuary', style: AppTextStyles.headlineMd.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackMd),
                Text('Begin your journey', style: AppTextStyles.headlineLgMobile),
                const SizedBox(height: AppSpacing.stackSm),
                Text(
                  'Secure your sanctuary with ease. Create an account to manage your smart home devices from anywhere.',
                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.stackMd),
                AppTextField(
                  label: 'Full name',
                  hint: 'John Doe',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => Validators.notEmpty(v, field: 'Full name'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.stackSm),
                AppTextField(
                  label: 'Email address',
                  hint: 'name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                  validator: Validators.email,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.stackSm),
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon: Icons.key_outlined,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.stackSm),
                AppTextField(
                  label: 'Confirm password',
                  hint: '••••••••',
                  controller: _confirmController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) => Validators.confirmPassword(v, _passwordController.text),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.stackSm),

                // --- Smart Home Location dropdown -----------------------
                DropdownButtonFormField<String>(
                  initialValue: _homeLocation,
                  decoration: const InputDecoration(
                    labelText: 'Smart home location',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.onSurfaceVariant, size: 20),
                  ),
                  hint: const Text('Select location'),
                  items: _homeLocationOptions
                      .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                  onChanged: (value) => setState(() => _homeLocation = value),
                  validator: (value) => value == null ? 'Please select your home location' : null,
                ),
                const SizedBox(height: AppSpacing.stackSm),

                // --- Terms checkbox --------------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      activeColor: AppColors.primary,
                      onChanged: (value) => setState(() {
                        _agreedToTerms = value ?? false;
                        _showTermsError = false;
                      }),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text.rich(
                          TextSpan(
                            style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant, fontSize: 13),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_showTermsError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text(
                      'Please accept the Terms of Service to continue.',
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.error),
                    ),
                  ),

                const SizedBox(height: AppSpacing.stackMd),
                PrimaryButton(
                  label: 'Create account',
                  isLoading: auth.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.stackMd),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Sign in',
                        style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.stackLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
