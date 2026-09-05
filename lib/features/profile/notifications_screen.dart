import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../booking/data/booking_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final bookingsAsync = ref.watch(bookingHistoryProvider(''));

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الإشعارات والتحديثات' : 'Notifications & Updates', style: AppTypography.headingSmall),
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_none_outlined, size: 54, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      isAr ? 'لا توجد إشعارات جديدة' : 'No new notifications',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isAr
                          ? 'ستصلك هنا إشعارات تأكيد الحجوزات، العروض الترويجية، والتحديثات المهمة.'
                          : 'Booking confirmations, promotions, and updates will appear here.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final b = bookings[index];
              return _buildNotificationItem(
                title: isAr ? 'تأكيد حجز ${b.serviceTitle}' : 'Booking Confirmed: ${b.serviceTitle}',
                description: isAr
                    ? 'رقم الحجز: ${b.code} • الموعد: ${b.startDate.isNotEmpty ? b.startDate : "مؤكد"}'
                    : 'Booking Ref: ${b.code} • Date: ${b.startDate.isNotEmpty ? b.startDate : "Confirmed"}',
                time: isAr ? 'حديث' : 'Recent',
                icon: Icons.check_circle_outline,
                iconColor: AppColors.success,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        error: (_, __) => Center(
          child: Text(isAr ? 'لا توجد إشعارات' : 'No notifications', style: AppTypography.bodyMedium),
        ),
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
                    Expanded(child: Text(title, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
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
