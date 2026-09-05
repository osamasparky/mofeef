import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';

class TermsConditionsScreen extends ConsumerWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الشروط والأحكام' : 'Terms & Conditions', style: AppTypography.headingSmall),
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
                  const Icon(Icons.gavel_outlined, color: AppColors.primaryGold, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isAr
                          ? 'مرحباً بك في منصة "مُضيف". يُعد استخدامك للتطبيق وحجز الخدمات موافقة صريحة على الشروط والأحكام الموضحة أدناه.'
                          : 'Welcome to Modeefe. Your use of the application and bookings signifies your agreement to these terms and conditions.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              title: isAr ? '١. سياسة الحجز وإصدار التذاكر' : '1. Bookings & Ticketing',
              content: isAr
                  ? 'يتم تأكيد الحجز فور إتمام عملية الدفع بنجاح عبر التطبيق، ويحصل المسافر على تذكرة إلكترونية تحتوي على رمز الاستجابة السريعة (QR Code) وكود الحجز المسجل في قائمة "حجوزاتي".'
                  : 'Bookings are confirmed immediately upon successful payment. Electronic tickets with QR codes and reference numbers are stored under "My Bookings".',
            ),
            _buildSection(
              title: isAr ? '٢. الإلغاء والاسترداد المالي' : '2. Cancellation & Refund Policy',
              content: isAr
                  ? 'يمكن إلغاء الحجوزات واسترداد المبالغ إلى المحفظة أو وسيلة الدفع الأصلية وفقاً لسياسة كل مسار أو فعالية، وتتاح إمكانية الإلغاء المجاني قبل موعد الجولة بـ ٢٤ ساعة ما لم يُذكر خلاف ذلك.'
                  : 'Cancellations and refunds are processed according to each trail or event policy. Free cancellation is available up to 24 hours prior to tour time unless specified otherwise.',
            ),
            _buildSection(
              title: isAr ? '٣. التزامات المسافر والامتثال للأنظمة' : '3. Traveler Conduct & Compliance',
              content: isAr
                  ? 'يلتزم المسافر باحترام التعليمات التراثية والبيئية أثناء المسارات، والحضور في الموعد المحدد عند نقطة الالتقاء، والحفاظ على الآثار والمعالم الوطنية وفق أنظمة وزارة السياحة وهيئة التراث.'
                  : 'Travelers are expected to abide by heritage site guidelines, arrive on time at designated trailheads, and respect Saudi Ministry of Tourism and Heritage regulations.',
            ),
            _buildSection(
              title: isAr ? '٤. مسؤولية المرشدين والخدمات' : '4. Certified Guides & Host Responsibility',
              content: isAr
                  ? 'جميع المرشدين السياحيين ومزودي الخدمات في المنصة مرخصون ومعتمدون رسمياً. تبذل المنصة أقصى درجات العناية لضمان جودة وأمان كافة الرحلات والتجارب.'
                  : 'All guides and transportation providers on Modeefe are officially certified. We ensure strict adherence to quality and safety standards for all excursions.',
            ),
            _buildSection(
              title: isAr ? '٥. الملكية الفكرية وحقوق النشر' : '5. Intellectual Property',
              content: isAr
                  ? 'كافة المحتويات، الصور، العلامات التجارية، والمواد التراثية المعروضة في التطبيق هي ملك لمنصة "مُضيف" وشركائها ومحمية بموجب أنظمة حماية الملكية الفكرية في المملكة العربية السعودية.'
                  : 'All branding, heritage media, and content displayed in the app are intellectual property of Modeefe and protected under Saudi IP laws.',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                isAr ? 'منصة مُضيف — الهيئة العامة للسياحة والتراث، المملكة العربية السعودية' : 'Modeefe Platform — Saudi Tourism & Heritage, KSA',
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
