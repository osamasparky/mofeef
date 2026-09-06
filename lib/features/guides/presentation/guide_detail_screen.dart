import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/utils/share_helper.dart';
import '../../wishlist/data/wishlist_repository.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/guide_repository.dart';

class GuideDetailScreen extends ConsumerWidget {
  final dynamic guideId;

  const GuideDetailScreen({super.key, required this.guideId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final guideAsync = ref.watch(guideDetailProvider(guideId));

    return Scaffold(
      body: guideAsync.when(
        data: (guide) {
          final cleanBio = HtmlUtils.stripHtml(guide.title);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
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
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: Icon(
                              ref.watch(wishlistProvider).isFavorite(guideId, 'guide')
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ref.watch(wishlistProvider).isFavorite(guideId, 'guide')
                                  ? AppColors.error
                                  : AppColors.primaryGold,
                            ),
                            onPressed: () async {
                              final added = await ref.read(wishlistProvider.notifier).toggleFavorite(
                                WishlistItemModel(
                                  id: int.tryParse(guideId.toString()) ?? 0,
                                  objectId: int.tryParse(guideId.toString()) ?? 0,
                                  objectModel: 'guide',
                                  title: guide.name,
                                  imageUrl: guide.imageUrl,
                                  price: double.tryParse(guide.hourlyRate.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
                                  location: guide.languages.join(' • '),
                                ),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(added
                                        ? (isAr ? 'تمت إضافة المرشد إلى المفضلة ❤️' : 'Added guide to favorites ❤️')
                                        : (isAr ? 'تمت إزالة المرشد من المفضلة' : 'Removed from favorites')),
                                    backgroundColor: added ? AppColors.primaryGold : AppColors.card,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () => ShareHelper.shareItem(
                              context: context,
                              title: guide.name,
                              category: 'مرشد سياحي معتمد',
                              id: guideId.toString(),
                              price: guide.hourlyRate,
                              location: guide.languages.join(' • '),
                              type: 'guide',
                            ),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: guide.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.person, color: AppColors.primaryGold, size: 80),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'مرشد سياحي معتمد',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.primaryGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: AppColors.primaryGold, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${guide.rating}',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(guide.name, style: AppTypography.headingMedium),
                          const SizedBox(height: 8),
                          Text(
                            cleanBio.isNotEmpty ? cleanBio : 'مرشد سياحي مرخص معتمد يقدم جولات واستشارات ثقافية غنية.',
                            style: AppTypography.bodyLarge.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 20),
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
                                _buildInfoItem(Icons.translate, 'اللغات', guide.languages.join('، ')),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.tour_outlined, 'الجولات', '${guide.toursCount} جولة'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.payments_outlined, 'سعر الساعة', guide.hourlyRate),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('خدمات الإرشاد السياحي', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          _buildServiceTile(Icons.directions_walk, 'جولات ميدانية خاصة', 'مرافقة حية للمواقع الأثرية وشرح تاريخي موثق.'),
                          const SizedBox(height: 10),
                          _buildServiceTile(Icons.support_agent, 'استشارات تخطيط المسارات', 'مساعدتك في تصميم جدول سياحي متكامل في المملكة.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('التكلفة التقريبية', style: AppTypography.bodySmall),
                            Text(guide.hourlyRate, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز واستشارة المرشد',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم إرسال طلب الحجز للمرشد ${guide.name} بنجاح!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('تعذر تحميل تفاصيل المرشد', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.refresh(guideDetailProvider(guideId)),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 20),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.bodySmall),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.titleSmall),
      ],
    );
  }

  Widget _buildServiceTile(IconData icon, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.goldGlow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                const SizedBox(height: 2),
                Text(desc, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
