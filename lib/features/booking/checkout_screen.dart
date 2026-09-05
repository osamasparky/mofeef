import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../auth/auth_provider.dart';
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
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedPaymentMethod = 'apple_pay';
  bool _isSubmitting = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();

  double _discountAmount = 0.0;
  String? _appliedCoupon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider);
      if (auth.userName != null) _nameController.text = auth.userName!;
      if (auth.userEmail != null) _emailController.text = auth.userEmail!;
      _phoneController.text = '0555123456';
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'MODEEFE' || code == 'KSA2030' || code == 'GOLD') {
      setState(() {
        _discountAmount = 50.0;
        _appliedCoupon = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تطبيق خصم بقيمة ٥٠ ر.س بنجاح! 🎉'), backgroundColor: AppColors.success),
      );
    } else if (code.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رمز الكوبون غير صالح'), backgroundColor: AppColors.error),
      );
    }
  }

  void _handleConfirmBooking(double unitPrice, String title) async {
    setState(() => _isSubmitting = true);
    try {
      final serviceId = int.tryParse(widget.experienceId) ?? 1;
      final dateStr = '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

      final bookingCode = 'MDF-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      await ref.read(bookingRepositoryProvider).addToCart(
        serviceId: serviceId,
        serviceType: 'tour',
        startDate: dateStr,
        guests: _ticketCount,
      );

      // Invalidate booking history so the new booking immediately appears
      ref.invalidate(bookingHistoryProvider(''));
      ref.invalidate(myTicketsProvider);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Column(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 64),
                SizedBox(height: 12),
                Text('تم تأكيد الحجز بنجاح!', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('رقم الحجز:', style: AppTypography.bodySmall),
                          Text(bookingCode, style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('الموعد:', style: AppTypography.bodySmall),
                          Text(dateStr, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('التذاكر:', style: AppTypography.bodySmall),
                          Text('$_ticketCount تذاكر', style: AppTypography.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.qr_code_2, size: 100, color: Colors.black),
                ),
              ],
            ),
            actions: [
              Center(
                child: CustomButton(
                  text: 'عرض التذكرة في حجوزاتي',
                  width: 220,
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
        title: Text('إتمام الحجز والدفع', style: AppTypography.headingSmall),
      ),
      body: tourAsync.when(
        data: (tour) {
          final unitPrice = tour.salePrice ?? tour.price;
          final subtotal = unitPrice * _ticketCount;
          final total = (subtotal - _discountAmount).clamp(0.0, double.infinity);

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
                Text('موعد الزيارة', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppColors.primaryGold,
                              surface: AppColors.card,
                              onSurface: AppColors.textPrimary,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: AppColors.primaryGold, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: AppTypography.titleSmall,
                            ),
                          ],
                        ),
                        const Text('تغيير الموعد', style: TextStyle(color: AppColors.primaryGold, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tickets Counter
                Text('عدد التذاكر', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                // Guest Details
                Text('بيانات المسافر الرئيسي', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryGold),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني لتأكيد الحجز',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primaryGold),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),

                // Coupon Section
                Text('كوبون الخصم', style: AppTypography.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'أدخل الرمز (مثال: MODEEFE)',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: AppColors.textDark,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _applyCoupon,
                      child: const Text('تطبيق', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
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
                      _buildPriceRow('التذاكر ($_ticketCount)', '${subtotal.toStringAsFixed(0)} ر.س'),
                      if (_discountAmount > 0)
                        _buildPriceRow('خصم الكوبون ($_appliedCoupon)', '-${_discountAmount.toStringAsFixed(0)} ر.س'),
                      _buildPriceRow('ضريبة القيمة المضافة (١٥٪)', 'مشمولة'),
                      const Divider(color: AppColors.border, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('المجموع الكلي', style: AppTypography.titleMedium),
                          Text('${total.toStringAsFixed(0)} ر.س', style: AppTypography.price),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Confirm Button
                CustomButton(
                  text: 'تأكيد ودفع ${total.toStringAsFixed(0)} ر.س',
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
