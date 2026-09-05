import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../auth/auth_provider.dart';
import '../booking/data/booking_repository.dart';
import '../wishlist/data/wishlist_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final wishlistAsync = ref.watch(wishlistItemsProvider);
    final bookingsAsync = ref.watch(bookingHistoryProvider(''));

    final favCount = wishlistAsync.asData?.value.length.toString() ?? '0';
    final bookCount = bookingsAsync.asData?.value.length.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الملف الشخصي والإعدادات' : 'Profile & Settings', style: AppTypography.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primaryGold),
            tooltip: isAr ? 'تعديل الملف الشخصي' : 'Edit Profile',
            onPressed: () => context.push('/edit-profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card matching Figma
            GestureDetector(
              onTap: () => context.push('/edit-profile'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.goldGlow,
                            border: Border.all(color: AppColors.primaryGold, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              authState.userName != null && authState.userName!.isNotEmpty
                                  ? authState.userName!.characters.first.toUpperCase()
                                  : 'م',
                              style: const TextStyle(
                                color: AppColors.primaryGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isAr ? 'ذهبـي' : 'VIP Gold',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          authState.userName ?? (isAr ? 'مسافر مُضيف' : 'Modeefe Traveler'),
                          style: AppTypography.titleLarge,
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.edit_outlined, size: 16, color: AppColors.primaryGold),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authState.userEmail ?? 'traveler@modeefe.sa',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 18),

                    // Real Dynamic Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('١', isAr ? 'وجهات زرتها' : 'Visited'),
                        Container(width: 1, height: 35, color: AppColors.border),
                        _buildStatItem(favCount, isAr ? 'تجارب مفضلة' : 'Wishlist'),
                        Container(width: 1, height: 35, color: AppColors.border),
                        _buildStatItem(bookCount, isAr ? 'حجوزات نشطة' : 'Bookings'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Quick Links
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: isAr ? 'تعديل الملف الشخصي' : 'Edit Profile Information',
              subtitle: isAr ? 'الاسم، البريد، رقم الجوال' : 'Name, Email, Phone',
              onTap: () => context.push('/edit-profile'),
            ),
            _buildSettingsTile(
              icon: Icons.account_balance_wallet_outlined,
              title: isAr ? 'المحفظة والرصيد' : 'Wallet & Balance',
              subtitle: isAr ? '١,٢٥٠ ر.س متاح' : '1,250 SAR Available',
              onTap: () => context.push('/wallet'),
            ),
            _buildSettingsTile(
              icon: Icons.notifications_outlined,
              title: isAr ? 'الإشعارات والتحديثات' : 'Notifications',
              onTap: () => context.push('/notifications'),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: isAr ? 'اللغة / Language' : 'Language / اللغة',
              subtitle: isAr ? 'العربية (السعودية)' : 'English (US)',
              onTap: () => _showLanguageDialog(context, ref, isAr),
            ),
            _buildSettingsTile(
              icon: Icons.gavel_outlined,
              title: isAr ? 'الشروط والأحكام' : 'Terms & Conditions',
              subtitle: isAr ? 'سياسات الحجز، الإلغاء، واستخدام المنصة' : 'Booking, cancellation, and usage terms',
              onTap: () => context.push('/terms-conditions'),
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: isAr ? 'سياسة الخصوصية' : 'Privacy Policy',
              subtitle: isAr ? 'حماية البيانات وأمان المعاملات وفق الأنظمة' : 'Data protection and PDPL compliance',
              onTap: () => context.push('/privacy-policy'),
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: isAr ? 'مركز المساعدة والدعم' : 'Help & Support Center',
              subtitle: isAr ? 'خدمة العملاء ٢٤/٧' : '24/7 Customer Support',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isAr ? 'خدمة العملاء متاحة على مدار الساعة: support@modeefe.sa' : 'Support available 24/7: support@modeefe.sa'),
                    backgroundColor: AppColors.primaryGold,
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: isAr ? 'تسجيل الخروج' : 'Logout',
              iconColor: AppColors.error,
              textColor: AppColors.error,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, bool isAr) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isAr ? 'اختر لغة التطبيق' : 'Select App Language',
              style: AppTypography.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Text('🇸🇦', style: TextStyle(fontSize: 24)),
              title: const Text('العربية (Arabic)', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: isAr ? const Icon(Icons.check_circle, color: AppColors.primaryGold) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('ar');
                Navigator.pop(ctx);
              },
            ),
            const Divider(color: AppColors.border),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: const Text('English (الإنجليزية)', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: !isAr ? const Icon(Icons.check_circle, color: AppColors.primaryGold) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('en');
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: AppTypography.headingSmall.copyWith(color: AppColors.primaryGold)),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? AppColors.primaryGold),
        title: Text(title, style: AppTypography.titleSmall.copyWith(color: textColor ?? AppColors.textPrimary)),
        subtitle: subtitle != null ? Text(subtitle, style: AppTypography.bodySmall) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
      ),
    );
  }
}
