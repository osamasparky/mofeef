import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/html_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/museum_repository.dart';

class MuseumDetailScreen extends ConsumerWidget {
  final dynamic museumId;

  const MuseumDetailScreen({super.key, required this.museumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final museumAsync = ref.watch(museumDetailProvider(museumId));

    return Scaffold(
      body: museumAsync.when(
        data: (museum) {
          final cleanContent = HtmlUtils.stripHtml(museum.content);

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 320,
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: museum.imageUrl ?? 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800&q=80',
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.museum_outlined, color: AppColors.primaryGold, size: 60),
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
                                  'متحف ومعلم ثقافي',
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
                                    '${museum.rating} (${museum.reviewsCount} تقييم)',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(museum.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(museum.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
                              ),
                            ],
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
                                _buildInfoItem(Icons.access_time, 'أوقات العمل', museum.workingHours ?? '٩ص — ٩م'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.confirmation_number_outlined, 'رسوم الدخول', museum.formattedPrice),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('نبذة عن المتحف', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            cleanContent.isNotEmpty ? cleanContent : 'صرح تراثي وثقافي عريق يروي تاريخ وأصالة المملكة العربية السعودية.',
                            style: AppTypography.bodyLarge.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),
                          Text('الموقع الجغرافي', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.map_outlined, color: AppColors.primaryGold, size: 36),
                                  SizedBox(height: 8),
                                  Text('عرض الموقع على الخريطة', style: TextStyle(color: AppColors.textPrimary)),
                                ],
                              ),
                            ),
                          ),
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
                            Text('سعر الدخول', style: AppTypography.bodySmall),
                            Text(museum.formattedPrice, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز تذكرة الدخول',
                            onPressed: () => context.push('/checkout/${museum.id}'),
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
              Text('تعذر تحميل تفاصيل المتحف', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.refresh(museumDetailProvider(museumId)),
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
}
