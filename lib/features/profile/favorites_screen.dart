import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/experience_card.dart';
import '../wishlist/data/wishlist_repository.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلات', style: AppTypography.headingSmall),
      ),
      body: wishlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite_border, size: 54, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text('قائمة المفضلات فارغة', style: AppTypography.titleLarge),
                    const SizedBox(height: 6),
                    Text('استكشف التجارب والوجهات واضغط على علامة القلب لحفظها هنا', style: AppTypography.bodySmall, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.go('/discover'),
                      child: const Text('استكشف التجارب الآن'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: double.infinity,
                child: ExperienceCard(
                  title: item.title,
                  category: item.objectModel == 'tour' ? 'جولة سياحية' : 'معلم سياحي',
                  location: item.location ?? 'المملكة العربية السعودية',
                  price: '${item.price.toStringAsFixed(0)} ر.س',
                  duration: 'ساعتان',
                  rating: 4.9,
                  imageUrl: item.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                  isFavorite: true,
                  onFavoriteTap: () async {
                    await ref.read(wishlistRepositoryProvider).removeFromWishlist(item.objectModel, item.objectId);
                    ref.invalidate(wishlistItemsProvider);
                  },
                  onTap: () => context.push('/experience/${item.objectId}'),
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
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('تعذر تحميل قائمة المفضلات', style: AppTypography.titleMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(wishlistItemsProvider),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
