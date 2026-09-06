import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/experience_card.dart';
import '../wishlist/data/wishlist_repository.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final wishlistAsync = ref.watch(wishlistItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'المفضلات' : 'Wishlist', style: AppTypography.headingSmall),
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
                    Text(
                      isAr ? 'لا يوجد مفضلة' : 'No Favorites',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isAr
                          ? 'استكشف التجارب والوجهات واضغط على علامة القلب لحفظها هنا'
                          : 'Explore tours and destinations and tap the heart icon to save them here.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.home_outlined),
                      label: Text(isAr ? 'العودة إلى الرئيسية' : 'Back to Home'),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: double.infinity,
                child: ExperienceCard(
                  title: item.title,
                  category: item.objectModel == 'tour' ? (isAr ? 'مسار سياحي' : 'Tourist Trail') : (isAr ? 'معلم سياحي' : 'Landmark'),
                  location: item.location ?? (isAr ? 'المملكة العربية السعودية' : 'Saudi Arabia'),
                  price: '${item.price.toStringAsFixed(0)} ﷼',
                  duration: isAr ? 'ساعتان' : '2 hours',
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
              Text(isAr ? 'تعذر تحميل قائمة المفضلات' : 'Failed to load wishlist', style: AppTypography.titleMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(wishlistItemsProvider),
                child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
