import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state_view.dart';
import 'models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<ProductModel> _cartItems = [mockProducts[0], mockProducts[1]];
  final TextEditingController _couponController = TextEditingController();
  bool _couponApplied = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('السلة', style: AppTypography.headingSmall)),
        body: EmptyStateView(
          icon: Icons.shopping_bag_outlined,
          title: 'سلتك فارغة',
          message: 'اكتشف منتجات وتحف سعودية أصيلة من بازار مُضيف.',
          buttonText: 'تسوّق الآن',
          onButtonPressed: () => context.go('/store'),
        ),
      );
    }

    final subtotal = _cartItems.fold<double>(0, (sum, item) => sum + item.priceNumeric);
    final discount = _couponApplied ? subtotal * 0.1 : 0.0;
    final total = subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text('السلة (${_cartItems.length} منتجات)', style: AppTypography.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => setState(() => _cartItems.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                            const SizedBox(height: 4),
                            Text(item.storeName, style: AppTypography.bodySmall),
                            const SizedBox(height: 4),
                            Text(item.price, style: AppTypography.price.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.textMuted),
                        onPressed: () => setState(() => _cartItems.removeAt(index)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Coupon and Summary Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Coupon Code Row
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: const InputDecoration(
                            hintText: 'أدخل كود الخصم (مثل: SAUDI10)',
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: 'تطبيق',
                        width: 90,
                        height: 48,
                        onPressed: () {
                          if (_couponController.text.isNotEmpty) {
                            setState(() => _couponApplied = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تطبيق كود الخصم بنجاح!'), backgroundColor: AppColors.success),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pricing rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('المجموع الفرعي', style: AppTypography.bodyMedium),
                      Text('${subtotal.toStringAsFixed(0)} ر.س', style: AppTypography.titleSmall),
                    ],
                  ),
                  if (_couponApplied) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('خصم الكوبون (١٠٪)', style: AppTypography.bodyMedium.copyWith(color: AppColors.success)),
                        Text('-${discount.toStringAsFixed(0)} ر.س', style: AppTypography.titleSmall.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الشحن والتوصيل', style: AppTypography.bodyMedium),
                      Text('مجاني', style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold)),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الإجمالي النهائي', style: AppTypography.titleLarge),
                      Text('${total.toStringAsFixed(0)} ر.س', style: AppTypography.price),
                    ],
                  ),
                  const SizedBox(height: 18),

                  CustomButton(
                    text: 'متابعة الدفع (${total.toStringAsFixed(0)} ر.س)',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
                          content: Text(
                            'تم استلام طلبك بنجاح من بازار مُضيف!\nرقم الطلب: #ORD-98431',
                            style: AppTypography.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Center(
                              child: CustomButton(
                                text: 'العودة للرئيسية',
                                width: 180,
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  setState(() => _cartItems.clear());
                                  context.go('/home');
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
          ),
        ],
      ),
    );
  }
}
