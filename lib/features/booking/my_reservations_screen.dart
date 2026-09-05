import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حجوزاتي', style: AppTypography.headingSmall),
          bottom: TabBar(
            indicatorColor: AppColors.primaryGold,
            indicatorWeight: 3,
            labelColor: AppColors.primaryGold,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTypography.titleSmall,
            tabs: const [
              Tab(text: 'القادمة'),
              Tab(text: 'المكتملة'),
              Tab(text: 'الملغاة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Tab
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTicketCard(
                  context,
                  title: 'مناطيد فوق سماء العُلا',
                  category: 'مغامرة',
                  bookingCode: 'MDF-89931',
                  date: 'السبت، ١٢ أكتوبر ٢٠٢٦',
                  time: '٠٥:٣٠ صباحاً',
                  ticketsCount: 2,
                  price: '١,٢٠٠ ر.س',
                  status: 'مؤكد',
                  statusColor: AppColors.success,
                ),
                const SizedBox(height: 16),
                _buildTicketCard(
                  context,
                  title: 'المتحف الوطني السعودي',
                  category: 'متحف',
                  bookingCode: 'MDF-77210',
                  date: 'الجمعة، ٢٥ أكتوبر ٢٠٢٦',
                  time: '٠٤:٠٠ مساءً',
                  ticketsCount: 3,
                  price: '١٥٠ ر.س',
                  status: 'مؤكد',
                  statusColor: AppColors.success,
                ),
              ],
            ),

            // Completed Tab
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTicketCard(
                  context,
                  title: 'ليالي السوق التراثي بالدرعية',
                  category: 'ثقافة',
                  bookingCode: 'MDF-55109',
                  date: '١٥ سبتمبر ٢٠٢٦',
                  time: '٠٨:٠٠ مساءً',
                  ticketsCount: 2,
                  price: '٢٥٠ ر.س',
                  status: 'مكتملة',
                  statusColor: AppColors.textSecondary,
                ),
              ],
            ),

            // Cancelled Tab
            Center(
              child: Text('لا توجد حجوزات ملغاة', style: AppTypography.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(
    BuildContext context, {
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
          // Ticket Header
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
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: AppColors.primaryGold),
                    const SizedBox(width: 6),
                    Text(time, style: AppTypography.bodySmall),
                  ],
                ),
              ],
            ),
          ),

          // Dashed Divider & Cutouts
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

          // Ticket Bottom with QR & Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('عدد التذاكر: $ticketsCount', style: AppTypography.bodyMedium),
                    const SizedBox(height: 4),
                    Text(price, style: AppTypography.price),
                  ],
                ),
                CustomButton(
                  text: 'عرض التذكرة والـ QR',
                  width: 160,
                  height: 42,
                  onPressed: () => _showQrModal(context, title, bookingCode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQrModal(BuildContext context, String title, String code) {
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
            Text('رمز الحجز: $code', style: AppTypography.bodySmall),
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
            Text('امسح الرمز عند بوابة الدخول للتحقق السريع', style: AppTypography.bodySmall),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
