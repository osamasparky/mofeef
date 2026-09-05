import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'سياسة الخصوصية' : 'Privacy Policy', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.goldGlow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security, color: AppColors.primaryGold, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isAr
                          ? 'نلتزم في منصة "مُضيف" بحماية بياناتكم وخصوصيتكم وفقاً لنظام حماية البيانات الشخصية في المملكة العربية السعودية.'
                          : 'Modeefe is committed to protecting your data and privacy in full compliance with Saudi PDPL regulations.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: isAr ? '١. جمع واستخدام البيانات الشخصية' : '1. Data Collection & Use',
              content: isAr
                  ? 'نقوم بجمع البيانات الضرورية لتقديم الخدمات السياحية وحجوزات المسارات والفعاليات، وتشمل: الاسم، رقم الجوال، البريد الإلكتروني، وبيانات الحجز، وذلك لغرض إصدار التذاكر وتأكيد العمليات والتواصل معكم.'
                  : 'We collect essential information to facilitate tourist bookings, tickets, and seasonal experiences including your name, email, phone number, and booking preferences.',
            ),
            _buildSection(
              title: isAr ? '٢. أمان وسرية المعاملات المالية' : '2. Payment & Transaction Security',
              content: isAr
                  ? 'تتم جميع العمليات المالية وعمليات الدفع عبر بوابات دفع إلكترونية معتمدة من البنك المركزي السعودي (ساما) وتخضع لأعلى معايير التشفير والأمان العالمية (PCI-DSS).'
                  : 'All electronic payments are processed through secure gateways certified by the Saudi Central Bank (SAMA) with top-tier PCI-DSS encryption standards.',
            ),
            _buildSection(
              title: isAr ? '٣. الموقع الجغرافي والخرائط' : '3. Location & Navigation Services',
              content: isAr
                  ? 'يتم استخدام إحداثيات الموقع الجغرافي فقط عند طلب المسافر للوصول إلى محطات المسارات السياحية والمتاحف والفعاليات عبر تطبيقات الخرائط المعتمدة.'
                  : 'Location data is only accessed when requesting navigation directions to trail stages, museums, or live event venues.',
            ),
            _buildSection(
              title: isAr ? '٤. مشاركة البيانات مع الشركاء' : '4. Third-Party Sharing',
              content: isAr
                  ? 'لا نقوم ببيع أو تأجير بياناتكم لأي طرف ثالث. تتم مشاركة بيانات الحجز الأساسية فقط مع مزودي التجارب والمرشدين السياحيين المعتمدين لضمان تنفيذ خدمتكم بنجاح.'
                  : 'We do not sell or rent user data. Necessary booking details are shared exclusively with certified guides and experience hosts to execute your tour.',
            ),
            _buildSection(
              title: isAr ? '٥. حقوق المستخدم والتحكم بالبيانات' : '5. User Rights & Data Control',
              content: isAr
                  ? 'يحق لكم في أي وقت مراجعة بياناتكم الشخصية، تحديثها من خلال صفحة تعديل الملف الشخصي، أو طلب حذف الحساب والتواصل مع فريق الخصوصية عبر: privacy@modeefe.sa'
                  : 'You maintain the right to review, update, or request deletion of your personal data at any time by contacting privacy@modeefe.sa.',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                isAr ? 'آخر تحديث: سبتمبر ٢٠٢٦ — منصة مُضيف للسياحة والتراث' : 'Last updated: September 2026 — Modeefe Platform',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.primaryGold)),
          const SizedBox(height: 8),
          Text(content, style: AppTypography.bodyMedium.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}
