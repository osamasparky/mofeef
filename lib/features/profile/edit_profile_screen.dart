import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/auth_provider.dart';
import '../auth/data/models/user_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.displayName ?? 'مسافر مُضيف');
    _emailController = TextEditingController(text: user?.email ?? 'traveler@modeefe.sa');
    _phoneController = TextEditingController(text: user?.phone ?? '0555123456');
    _cityController = TextEditingController(text: 'الرياض');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(bool isAr) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final updatedUser = UserModel(
        id: ref.read(authProvider).user?.id ?? 1,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        avatarUrl: ref.read(authProvider).user?.avatarUrl,
        token: ref.read(authProvider).user?.token,
      );

      ref.read(authProvider.notifier).updateUserState(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'تم حفظ بيانات الملف الشخصي بنجاح' : 'Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'حدث خطأ أثناء الحفظ' : 'Failed to save changes'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'تعديل الملف الشخصي' : 'Edit Profile', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Preview & Change
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.goldGlow,
                        border: Border.all(color: AppColors.primaryGold, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          _nameController.text.isNotEmpty ? _nameController.text.characters.first.toUpperCase() : 'م',
                          style: const TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryGold,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: AppColors.textDark, size: 16),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isAr ? 'تم اختيار الصورة الرمزية' : 'Avatar selected'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Full Name
              Text(isAr ? 'الاسم الكامل' : 'Full Name', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                validator: (v) => (v == null || v.trim().isEmpty) ? (isAr ? 'يرجى إدخال الاسم' : 'Please enter your name') : null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryGold),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 18),

              // Email Address
              Text(isAr ? 'البريد الإلكتروني' : 'Email Address', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => (v == null || !v.contains('@')) ? (isAr ? 'يرجى إدخال بريد إلكتروني صالح' : 'Please enter a valid email') : null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryGold),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 18),

              // Phone Number
              Text(isAr ? 'رقم الجوال' : 'Phone Number', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primaryGold),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 18),

              // City / Region
              Text(isAr ? 'المدينة / المنطقة المفضلة' : 'City / Region', style: AppTypography.titleSmall),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city_outlined, color: AppColors.primaryGold),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: isAr ? 'حفظ التعديلات' : 'Save Changes',
                isLoading: _isSaving,
                onPressed: () => _handleSave(isAr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
