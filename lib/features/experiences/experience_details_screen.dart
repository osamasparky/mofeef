import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import '../tours/data/models/tour_model.dart';
import '../tours/data/repositories/tour_repository.dart';

final tourDetailProvider = FutureProvider.family<TourModel, String>((ref, id) async {
  return ref.watch(tourRepositoryProvider).getTourDetail(id);
});

class ExperienceDetailsScreen extends ConsumerWidget {
  final String experienceId;

  const ExperienceDetailsScreen({super.key, required this.experienceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourAsync = ref.watch(tourDetailProvider(experienceId));

    return Scaffold(
      body: tourAsync.when(
        data: (tour) {
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
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت الإضافة إلى المفضلة!'), backgroundColor: AppColors.success),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
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
                                  tour.categoryName ?? 'تجربة سياحية',
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
                                    '${tour.rating} (${tour.reviewsCount} تقييم)',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Text(tour.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(tour.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
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
                                _buildInfoItem(Icons.access_time, 'ساعات العمل', '٩ص — ٩م'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.timelapse, 'المدة', tour.duration ?? 'ساعتان'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.confirmation_number_outlined, 'التذكرة', tour.formattedPrice),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Text('نبذة عن التجربة', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Text(tour.content ?? 'استمتع بتجربة سياحية وثقافية فريدة من نوعها.', style: AppTypography.bodyLarge),
                          const SizedBox(height: 24),

                          Text('الموقع على الخريطة', style: AppTypography.titleLarge),
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
                                  Text('عرض على خرائط Google', style: TextStyle(color: AppColors.textPrimary)),
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
                            Text('السعر يبدأ من', style: AppTypography.bodySmall),
                            Text(tour.formattedPrice, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز التذكرة',
                            onPressed: () => context.push('/checkout/${tour.id}'),
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
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 54, color: AppColors.error),
                const SizedBox(height: 16),
                Text('تعذر تحميل تفاصيل التجربة', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(tourDetailProvider(experienceId)),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
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
