import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'data/shop_repository.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  String _selectedCategory = 'الكل';
  final List<String> _categories = ['الكل', 'مقتنيات وتحف', 'حِرَف يدوية', 'عطور وبخور', 'مأكولات'];

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('بازار مُضيف للمقتنيات', style: AppTypography.headingSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن تحفة، مقتنى، أو منتج أصيل...',
                prefixIcon: Icon(Icons.search, color: AppColors.primaryGold),
              ),
            ),
          ),

          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                  selectedColor: AppColors.primaryGold,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Text('لا توجد منتجات متاحة حالياً', style: AppTypography.bodyMedium),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final prod = products[index];
                    return GestureDetector(
                      onTap: () => context.push('/product/${prod.id}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: prod.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  color: AppColors.surface,
                                  child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(prod.category, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontSize: 10)),
                                  const SizedBox(height: 2),
                                  Text(prod.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(prod.price, style: AppTypography.price.copyWith(fontSize: 13)),
                                      const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.primaryGold),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعذر تحميل منتجات البازار', style: AppTypography.bodyMedium),
                    TextButton(
                      onPressed: () => ref.refresh(productsListProvider),
                      child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.primaryGold)),
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
}
