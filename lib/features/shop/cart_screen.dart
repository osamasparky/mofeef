import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state_view.dart';
import '../cart/data/cart_repository.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartNotifierProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    if (cartState.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(isAr ? 'السلة' : 'Shopping Cart', style: AppTypography.headingSmall)),
        body: EmptyStateView(
          icon: Icons.shopping_bag_outlined,
          title: isAr ? 'سلتك فارغة' : 'Your cart is empty',
          message: isAr
              ? 'اكتشف منتجات وتحف سعودية أصيلة من بازار مُضيف.'
              : 'Explore authentic Saudi handicrafts and gifts in Modeefe Bazaar.',
          buttonText: isAr ? 'تسوّق الآن' : 'Shop Now',
          onButtonPressed: () => context.go('/store'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isAr ? "السلة" : "Cart"} (${cartState.items.length})', style: AppTypography.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => ref.read(cartNotifierProvider.notifier).clearCart(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartState.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartState.items[index];
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
                        child: Image.network(
                          item.imageUrl.isNotEmpty ? item.imageUrl : 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=800&q=80',
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
                        onPressed: () => ref.read(cartNotifierProvider.notifier).removeItem(index),
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: isAr ? 'أدخل كود الخصم (مثل: MODEEFE)' : 'Enter coupon code (e.g. MODEEFE)',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomButton(
                        text: isAr ? 'تطبيق' : 'Apply',
                        width: 90,
                        height: 48,
                        onPressed: () async {
                          if (_couponController.text.isNotEmpty) {
                            final success = await ref.read(cartNotifierProvider.notifier).applyCoupon(_couponController.text.trim());
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isAr ? 'تم تطبيق كود الخصم بنجاح!' : 'Coupon applied successfully!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAr ? 'المجموع الفرعي' : 'Subtotal', style: AppTypography.bodyMedium),
                      Text('${cartState.subtotal.toStringAsFixed(0)} ${isAr ? "ر.س" : "SAR"}', style: AppTypography.titleSmall),
                    ],
                  ),
                  if (cartState.discount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(isAr ? 'خصم الكوبون' : 'Coupon Discount', style: AppTypography.bodyMedium.copyWith(color: AppColors.success)),
                        Text('-${cartState.discount.toStringAsFixed(0)} ${isAr ? "ر.س" : "SAR"}', style: AppTypography.titleSmall.copyWith(color: AppColors.success)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAr ? 'الشحن والتوصيل' : 'Shipping', style: AppTypography.bodyMedium),
                      Text(isAr ? 'مجاني' : 'Free', style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold)),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAr ? 'الإجمالي النهائي' : 'Total Amount', style: AppTypography.titleLarge),
                      Text('${cartState.total.toStringAsFixed(0)} ${isAr ? "ر.س" : "SAR"}', style: AppTypography.price),
                    ],
                  ),
                  const SizedBox(height: 18),

                  CustomButton(
                    text: '${isAr ? "متابعة الدفع" : "Proceed to Checkout"} (${cartState.total.toStringAsFixed(0)} ${isAr ? "ر.س" : "SAR"})',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: AppColors.surface,
                          title: const Icon(Icons.check_circle, color: AppColors.success, size: 60),
                          content: Text(
                            isAr
                                ? 'تم استلام طلبك بنجاح من بازار مُضيف!\nرقم الطلب: #ORD-98431'
                                : 'Order placed successfully from Modeefe Bazaar!\nOrder Ref: #ORD-98431',
                            style: AppTypography.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Center(
                              child: CustomButton(
                                text: isAr ? 'العودة للرئيسية' : 'Back to Home',
                                width: 180,
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  ref.read(cartNotifierProvider.notifier).clearCart();
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
