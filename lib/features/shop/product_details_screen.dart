import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import 'models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final prod = mockProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => mockProducts.first,
    );

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                        onPressed: () => context.push('/cart'),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: prod.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prod.storeName, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                      const SizedBox(height: 6),
                      Text(prod.title, style: AppTypography.headingSmall),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(prod.price, style: AppTypography.price.copyWith(fontSize: 22)),
                          const SizedBox(width: 12),
                          Text(
                            prod.originalPrice,
                            style: AppTypography.bodyMedium.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                              const SizedBox(width: 4),
                              Text('${prod.rating} (${prod.reviewsCount})', style: AppTypography.bodySmall),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 16),
                      Text('تفاصيل المنتج', style: AppTypography.titleLarge),
                      const SizedBox(height: 8),
                      Text(prod.description, style: AppTypography.bodyLarge),
                      const SizedBox(height: 20),

                      // Guarantee badges
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBadge(Icons.verified_outlined, 'أصلي ١٠٠٪'),
                            _buildBadge(Icons.local_shipping_outlined, 'شحن سريع ومجاني'),
                            _buildBadge(Icons.assignment_return_outlined, 'استرجاع ميسر'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          ),
                          Text('$_quantity', style: AppTypography.titleMedium),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'إضافة إلى السلة',
                        icon: Icons.shopping_bag_outlined,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تمت إضافة المنتج إلى السلة بنجاح!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                          context.push('/cart');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 20),
        const SizedBox(height: 4),
        Text(text, style: AppTypography.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }
}
