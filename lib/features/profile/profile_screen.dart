import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../auth/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card matching Figma
            Container(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
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
                          child: const Text('ذهبـي', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(authState.userName ?? 'مسافر مُضيف', style: AppTypography.titleLarge),
                  const SizedBox(height: 4),
                  Text(authState.userEmail ?? 'traveler@mudief.sa', style: AppTypography.bodySmall),
                  const SizedBox(height: 18),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('٣', 'وجهات زرتها'),
                      Container(width: 1, height: 35, color: AppColors.border),
                      _buildStatItem('١٢', 'تجارب مفضلة'),
                      Container(width: 1, height: 35, color: AppColors.border),
                      _buildStatItem('٤', 'حجوزات نشطة'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Settings & Quick Links
            _buildSettingsTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'المحفظة والرصيد',
              subtitle: '١,٢٤٠ ر.س متاح',
              onTap: () => context.push('/wallet'),
            ),
            _buildSettingsTile(
              icon: Icons.storefront_outlined,
              title: 'بازار مُضيف للمقتنيات',
              subtitle: 'تحف ومنتجات تراثية',
              onTap: () => context.push('/store'),
            ),
            _buildSettingsTile(
              icon: Icons.notifications_outlined,
              title: 'الإشعارات والتحديثات',
              onTap: () => context.push('/notifications'),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: 'اللغة',
              subtitle: 'العربية (السعودية)',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'مركز المساعدة والدعم',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'تسجيل الخروج',
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
