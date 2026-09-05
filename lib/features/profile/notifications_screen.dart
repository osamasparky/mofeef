import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات', style: AppTypography.headingSmall),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            title: 'تم تأكيد حجزك بنجاح',
            description: 'تم تأكيد حجز المتحف الوطني السعودي ليوم السبت القادم.',
            time: 'قبل ساعة',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
          ),
          _buildNotificationItem(
            title: 'عرض خاص ٢٠٪ على التجارب',
            description: 'خصم ٢٠٪ على جولات درب زبيدة هذا الأسبوع باستخدام كود SAUDI20.',
            time: 'أمس',
            icon: Icons.local_offer_outlined,
            iconColor: AppColors.primaryGold,
          ),
          _buildNotificationItem(
            title: 'تجربة جديدة في العُلا',
            description: 'أضفنا تجربة صحراوية فاخرة في العُلا — استكشفها الآن واحجز مبكراً.',
            time: 'قبل يومين',
            icon: Icons.explore_outlined,
            iconColor: AppColors.accentTeal,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: AppTypography.titleSmall),
                    Text(time, style: AppTypography.bodySmall),
                  ],
                ),
                const SizedBox(height: 4),
                Text(description, style: AppTypography.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
