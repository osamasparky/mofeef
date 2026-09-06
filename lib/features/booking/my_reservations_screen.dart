import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/custom_button.dart';
import 'data/booking_repository.dart';

class MyReservationsScreen extends ConsumerWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final upcomingBookingsAsync = ref.watch(bookingHistoryProvider(''));
    final ticketsAsync = ref.watch(myTicketsProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isAr ? 'حجوزاتي' : 'My Reservations', style: AppTypography.headingSmall),
          bottom: TabBar(
            indicatorColor: AppColors.primaryGold,
            indicatorWeight: 3,
            labelColor: AppColors.primaryGold,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTypography.titleSmall,
            tabs: [
              Tab(text: isAr ? 'القادمة' : 'Upcoming'),
              Tab(text: isAr ? 'المكتملة' : 'Completed'),
              Tab(text: isAr ? 'الملغاة' : 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Tab with Real API
            upcomingBookingsAsync.when(
              data: (bookings) {
                if (bookings.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_number_outlined, size: 54, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            isAr ? 'لا توجد حجوزات قادمة' : 'No upcoming bookings',
                            style: AppTypography.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isAr
                                ? 'استكشف التجارب والمتاحف واحجز رحلتك القادمة بكل سهولة.'
                                : 'Explore tours and museums and book your next trip easily.',
                            style: AppTypography.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.go('/discover'),
                            child: Text(isAr ? 'استكشف التجارب الآن' : 'Explore Now'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final b = bookings[index];
                    return _buildTicketCard(
                      context,
                      isAr: isAr,
                      title: b.serviceTitle,
                      category: b.serviceType == 'tour' ? (isAr ? 'مسار سياحي' : 'Tourist Trail') : (isAr ? 'تذكرة معلم' : 'Ticket'),
                      bookingCode: b.code,
                      date: b.startDate.isNotEmpty ? b.startDate : (isAr ? 'موعد الزيارة' : 'Visit Date'),
                      time: isAr ? 'تاريخ الحجز' : 'Booking Date',
                      ticketsCount: b.totalGuests,
                      price: '${b.total.toStringAsFixed(0)} ﷼',
                      status: b.status == 'confirmed' ? (isAr ? 'مؤكد' : 'Confirmed') : b.status,
                      statusColor: AppColors.success,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text(isAr ? 'تعذر تحميل سجل الحجوزات' : 'Failed to load bookings', style: AppTypography.titleMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(bookingHistoryProvider('')),
                      child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
                    ),
                  ],
                ),
              ),
            ),

            // Completed Tab
            ticketsAsync.when(
              data: (tickets) {
                if (tickets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_outlined, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(isAr ? 'لا توجد حجوزات سابقة مكتملة' : 'No completed bookings', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  itemCount: tickets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final t = tickets[index];
                    return _buildTicketCard(
                      context,
                      isAr: isAr,
                      title: t.title,
                      category: isAr ? 'رحلة مكتملة' : 'Completed Trip',
                      bookingCode: t.bookingCode,
                      date: t.date,
                      time: '',
                      ticketsCount: 1,
                      price: isAr ? 'مكتملة' : 'Completed',
                      status: isAr ? 'مكتملة' : 'Completed',
                      statusColor: AppColors.textSecondary,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (_, __) => Center(child: Text(isAr ? 'لا توجد حجوزات مكتملة' : 'No completed bookings', style: AppTypography.bodyMedium)),
            ),

            // Cancelled Tab
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel_outlined, size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    Text(isAr ? 'لا توجد حجوزات ملغاة' : 'No cancelled bookings', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
    required bool isAr,
    required String title,
    required String category,
    required String bookingCode,
    required String date,
    required String time,
    required int ticketsCount,
    required String price,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: AppTypography.bodySmall.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(bookingCode, style: AppTypography.bodySmall),
                  ],
                ),
                const SizedBox(height: 10),
                Text(title, style: AppTypography.titleLarge),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primaryGold),
                    const SizedBox(width: 6),
                    Text(date, style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          Row(
            children: [
              Container(
                width: 14,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (constraints.constrainWidth() / 12).floor(),
                        (_) => const SizedBox(
                          width: 6,
                          height: 1.5,
                          child: DecoratedBox(decoration: BoxDecoration(color: AppColors.border)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                width: 14,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isAr ? 'عدد التذاكر: $ticketsCount' : 'Tickets: $ticketsCount', style: AppTypography.bodyMedium),
                    const SizedBox(height: 4),
                    Text(price, style: AppTypography.price),
                  ],
                ),
                CustomButton(
                  text: isAr ? 'عرض التذكرة والـ QR' : 'Show Ticket & QR',
                  width: 170,
                  height: 42,
                  onPressed: () => _showQrModal(context, isAr, title, bookingCode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQrModal(BuildContext context, bool isAr, String title, String code) {
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
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(title, style: AppTypography.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(isAr ? 'رمز الحجز: $code' : 'Booking Reference: $code', style: AppTypography.bodySmall),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.qr_code_2, size: 160, color: Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              isAr ? 'امسح الرمز عند بوابة الدخول للتحقق السريع' : 'Scan code at the entrance for verification',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
