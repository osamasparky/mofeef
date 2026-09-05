import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../experiences/experience_details_screen.dart';
import 'data/booking_repository.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String experienceId;

  const CheckoutScreen({super.key, required this.experienceId});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _ticketCount = 2;
  int _selectedDateIndex = 0;
  String _selectedPaymentMethod = 'apple_pay';
  bool _isSubmitting = false;

  final List<String> _dates = ['اليوم (السبت)', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء'];

  void _handleConfirmBooking(double unitPrice, String title) async {
    setState(() => _isSubmitting = true);
    try {
      final serviceId = int.tryParse(widget.experienceId) ?? 1;
      await ref.read(bookingRepositoryProvider).addToCart(
        serviceId: serviceId,
        serviceType: 'tour',
        startDate: DateTime.now().add(Duration(days: _selectedDateIndex)).toIso8601String().split('T').first,
        guests: _ticketCount,
      );

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
            content: Text(
              'تم تأكيد حجزك بنجاح في $title!\nتم إضافة التذكرة إلى حجوزاتي.',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            actions: [
              Center(
                child: CustomButton(
                  text: 'عرض تذكرتي',
                  width: 180,
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.go('/reservations');
                  },
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الحجز: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tourAsync = ref.watch(tourDetailProvider(widget.experienceId));

    return Scaffold(
      appBar: AppBar(
        title: Text('إتمام الحجز', style: AppTypography.headingSmall),
      ),
      body: tourAsync.when(
        data: (tour) {
          final unitPrice = tour.salePrice ?? tour.price;
          final totalPrice = unitPrice * _ticketCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Summary Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text(tour.locationName ?? 'المملكة', style: AppTypography.bodySmall),
                            const SizedBox(height: 4),
                            Text('${tour.formattedPrice} / للتذكرة', style: AppTypography.price.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Date Picker Section
                Text('اختر موعد الزيارة', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _dates.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedDateIndex;
                      return ChoiceChip(
                        label: Text(_dates[index]),
                        selected: isSelected,
                        onSelected: (val) => setState(() => _selectedDateIndex = index),
                        selectedColor: AppColors.primaryGold,
                        backgroundColor: AppColors.surface,
                        labelStyle: AppTypography.bodySmall.copyWith(
                          color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Tickets Counter
                Text('عدد التذاكر', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('التذاكر (بالغين)', style: AppTypography.titleSmall),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryGold),
                            onPressed: _ticketCount > 1 ? () => setState(() => _ticketCount--) : null,
                          ),
                          Text('$_ticketCount', style: AppTypography.titleMedium),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGold),
                            onPressed: () => setState(() => _ticketCount++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Methods
                Text('طريقة الدفع', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                _buildPaymentOption('apple_pay', 'Apple Pay / Mada', Icons.payment),
                _buildPaymentOption('wallet', 'رصيد المحفظة (١,٢٤٠ ر.س)', Icons.account_balance_wallet_outlined),
                _buildPaymentOption('card', 'بطاقة ائتمانية (Visa / MasterCard)', Icons.credit_card),

                const SizedBox(height: 24),

                // Price Breakdown Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow('التذاكر ($_ticketCount)', '${(unitPrice * _ticketCount).toStringAsFixed(0)} ر.س'),
                      _buildPriceRow('ضريبة القيمة المضافة (١٥٪)', 'مشمولة'),
                      const Divider(color: AppColors.border, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('المجموع الكلي', style: AppTypography.titleMedium),
                          Text('${totalPrice.toStringAsFixed(0)} ر.س', style: AppTypography.price),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Confirm Button
                CustomButton(
                  text: 'تأكيد ودفع ${totalPrice.toStringAsFixed(0)} ر.س',
                  isLoading: _isSubmitting,
                  onPressed: () => _handleConfirmBooking(unitPrice, tour.title),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        error: (_, __) => Center(
          child: Text('تعذر تحميل بيانات التجربة للحجز', style: AppTypography.titleMedium),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.goldGlow : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryGold : AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.primaryGold, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.titleSmall),
        ],
      ),
    );
  }
}
