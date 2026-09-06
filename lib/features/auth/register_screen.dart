import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/locale_provider.dart';
import 'auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).register({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'password': _passwordController.text,
      'password_confirmation': _passwordController.text,
      'term': 1,
      'term_conditions': 1,
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مرحباً بك في مُضيف! تم إنشاء حسابك بنجاح.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/home');
    } else if (mounted) {
      final error = ref.read(authProvider).errorMessage;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF071018),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with AlUla Background & Header
            Stack(
              children: [
                SizedBox(
                  height: 230,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/home_hero_bg.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0F1B26)),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1B4E4A).withOpacity(0.70),
                          const Color(0xFF09141D).withOpacity(0.60),
                          const Color(0xFF071018).withOpacity(0.98),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => context.pop(),
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                            ),
                            const Spacer(),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF131D26).withOpacity(0.85),
                                border: Border.all(
                                  color: const Color(0xFFF5A623).withOpacity(0.35),
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isAr ? 'إنشاء حساب جديد' : 'Create New Account',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Tajawal',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAr ? 'انضم إلى مجتمع مسافري مُضيف' : 'Join Modeefe Travelers Community',
                          style: const TextStyle(fontSize: 12.5, color: Color(0xFFCBD5E1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Form Card
            Transform.translate(
              offset: const Offset(0, -15),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B141E),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFF1E3246), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Segmented Switch [تسجيل الدخول | إنشاء حساب]
                      Container(
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF070D14),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: const Color(0xFF162534)),
                        ),
                        child: Row(
                          children: [
                            // Active: إنشاء حساب
                            Expanded(
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5A623),
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x55F5A623),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    isAr ? 'إنشاء حساب' : 'Sign Up',
                                    style: const TextStyle(
                                      color: Color(0xFF0B141E),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Inactive: تسجيل الدخول
                            Expanded(
                              child: GestureDetector(
                                onTap: () => context.go('/login'),
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: Text(
                                    isAr ? 'تسجيل الدخول' : 'Sign In',
                                    style: const TextStyle(
                                      color: Color(0xFF8A9BB0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // First & Last Name
                      Row(
                        children: [
                          Expanded(
                            child: _buildPillField(
                              controller: _firstNameController,
                              hint: isAr ? 'الاسم الأول' : 'First Name',
                              icon: Icons.person_outline,
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildPillField(
                              controller: _lastNameController,
                              hint: isAr ? 'اسم العائلة' : 'Last Name',
                              icon: Icons.person_outline,
                              validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Email
                      _buildPillField(
                        controller: _emailController,
                        hint: isAr ? 'البريد الإلكتروني' : 'Email Address',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@') ? 'بريد غير صحيح' : null,
                      ),
                      const SizedBox(height: 12),

                      // Phone
                      _buildPillField(
                        controller: _phoneController,
                        hint: isAr ? 'رقم الجوال' : 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),

                      // Password
                      _buildPillField(
                        controller: _passwordController,
                        hint: isAr ? 'كلمة المرور' : 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: _obscurePassword,
                        onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                        validator: (v) => v == null || v.length < 6 ? '٦ خانات على الأقل' : null,
                      ),
                      const SizedBox(height: 22),

                      // Submit Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: authState.isLoading ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF5A623),
                            foregroundColor: const Color(0xFF0B141E),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Color(0xFF0B141E),
                                  ),
                                )
                              : Text(
                                  isAr ? 'إنشاء الحساب' : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isAr ? 'لديك حساب بالفعل؟' : 'Already have an account?',
                            style: const TextStyle(color: Color(0xFF8A9BB0), fontSize: 13),
                          ),
                          TextButton(
                            onPressed: () => context.go('/login'),
                            child: Text(
                              isAr ? 'تسجيل الدخول' : 'Sign In',
                              style: const TextStyle(
                                color: Color(0xFFF5A623),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A26),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFF1E3246), width: 1.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          if (isPassword)
            IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF64748B),
                size: 18,
              ),
              onPressed: onToggleVisibility,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword && obscureText,
              keyboardType: keyboardType,
              validator: validator,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              ),
            ),
          ),
          Icon(icon, color: const Color(0xFFF5A623), size: 19),
        ],
      ),
    );
  }
}
