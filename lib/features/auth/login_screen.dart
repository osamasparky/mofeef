import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'traveler@mudief.sa');
  final _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final success = await ref.read(authProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );
    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / Heritage Emblem
                  Center(
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.goldGlow,
                            blurRadius: 20,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'مُ',
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Welcome Titles from Figma
                  Text(
                    'أهلاً بك في مُضيف',
                    style: AppTypography.headingLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ابدأ رحلتك السعودية الفاخرة واستكشف الأصالة',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  // Login Form Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hintText: 'name@example.com',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'كلمة المرور',
                          hintText: '••••••••',
                          obscureText: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'تسجيل الدخول',
                          isLoading: authState.isLoading,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Guest Action / Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب بعد؟', style: AppTypography.bodyMedium),
                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(
                          'تصفح كزائر',
                          style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold),
                        ),
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
