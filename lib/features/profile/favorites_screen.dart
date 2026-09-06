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
    final wishlistState = ref.watch(wishlistProvider);
    final items = wishlistState.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'المفضلات' : 'Wishlist', style: AppTypography.headingSmall),
      ),
      body: wishlistState.isLoading && items.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGold))
          : items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite_border, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          isAr ? 'لا توجد عناصر في المفضلة حتى الآن' : 'No favorites yet',
                          style: AppTypography.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isAr
                              ? 'قم بإضافة كل ما تفضله لتجده بسهولة في أي وقت.'
                              : 'Add your favorite experiences and places to easily find them anytime.',
                          style: AppTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/discover'),
                            icon: const Icon(Icons.explore_outlined),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: AppColors.textDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              textStyle: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            label: Text(isAr ? 'تصفح الآن' : 'Browse Now'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/home'),
                            icon: const Icon(Icons.home_outlined),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              textStyle: AppTypography.titleSmall,
                            ),
                            label: Text(isAr ? 'العودة إلى الرئيسية' : 'Back to Home'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primaryGold,
                  onRefresh: () => ref.read(wishlistProvider.notifier).loadWishlist(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      String categoryLabel;
                      switch (item.objectModel) {
                        case 'museum':
                          categoryLabel = isAr ? 'متحف ومعلم' : 'Museum & Landmark';
                          break;
                        case 'event':
                          categoryLabel = isAr ? 'فعالية وموسم' : 'Event & Season';
                          break;
                        case 'car':
                          categoryLabel = isAr ? 'سيارة وتنقل' : 'Car Rental';
                          break;
                        case 'guide':
                          categoryLabel = isAr ? 'مرشد سياحي' : 'Tour Guide';
                          break;
                        case 'product':
                          categoryLabel = isAr ? 'منتج تراثي' : 'Heritage Shop';
                          break;
                        case 'tour':
                        default:
                          categoryLabel = isAr ? 'مسار سياحي' : 'Tourist Trail';
                      }

                      return SizedBox(
                        width: double.infinity,
                        child: ExperienceCard(
                          title: item.title,
                          category: categoryLabel,
                          location: item.location ?? (isAr ? 'المملكة العربية السعودية' : 'Saudi Arabia'),
                          price: '${item.price.toStringAsFixed(0)} ﷼',
                          duration: isAr ? 'متاح للحجز' : 'Available',
                          rating: 4.9,
                          imageUrl: item.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                          isFavorite: true,
                          onFavoriteTap: () async {
                            await ref.read(wishlistProvider.notifier).toggleFavorite(item);
                          },
                          onTap: () {
                            switch (item.objectModel) {
                              case 'museum':
                                context.push('/museum/${item.objectId}');
                                break;
                              case 'event':
                                context.push('/event/${item.objectId}');
                                break;
                              case 'car':
                                context.push('/car/${item.objectId}');
                                break;
                              case 'guide':
                                context.push('/guide/${item.objectId}');
                                break;
                              case 'product':
                                context.push('/product/${item.objectId}');
                                break;
                              case 'tour':
                              default:
                                context.push('/experience/${item.objectId}');
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
