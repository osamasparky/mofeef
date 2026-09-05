import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../experiences/models/experience_model.dart';

class CheckoutScreen extends StatefulWidget {
  final String experienceId;

  const CheckoutScreen({super.key, required this.experienceId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _ticketCount = 2;
  int _selectedDateIndex = 0;
  String _selectedPaymentMethod = 'apple_pay';

  final List<String> _dates = ['اليوم (السبت)', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء'];

  @override
  Widget build(BuildContext context) {
    final exp = mockExperiences.firstWhere(
      (e) => e.id == widget.experienceId,
      orElse: () => mockExperiences.first,
    );

    final totalPrice = exp.priceNumeric * _ticketCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('إتمام الحجز', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
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
                    child: Image.network(exp.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exp.title, style: AppTypography.titleMedium),
                        const SizedBox(height: 4),
                        Text(exp.location, style: AppTypography.bodySmall),
                        const SizedBox(height: 4),
                        Text('${exp.price} / للتذكرة', style: AppTypography.price.copyWith(fontSize: 14)),
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
                  _buildPriceRow('التذاكر ($_ticketCount)', '${exp.priceNumeric * _ticketCount} ر.س'),
                  _buildPriceRow('ضريبة القيمة المضافة (١٥٪)', 'مشمولة'),
                  const Divider(color: AppColors.border, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المجموع الكلي', style: AppTypography.titleMedium),
                      Text('$totalPrice ر.س', style: AppTypography.price),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            CustomButton(
              text: 'تأكيد ودفع $totalPrice ر.س',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
                    content: Text(
                      'تم تأكيد حجزك بنجاح في ${exp.title}!\nتم إضافة التذكرة إلى حجوزاتي.',
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
              },
            ),
          ],
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
