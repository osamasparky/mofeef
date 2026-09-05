import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/car_repository.dart';

class CarDetailScreen extends ConsumerWidget {
  final dynamic carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carAsync = ref.watch(carDetailProvider(carId));

    return Scaffold(
      body: carAsync.when(
        data: (car) {
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: car.imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.directions_car, color: AppColors.primaryGold, size: 80),
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
                                  car.category,
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
                                    '4.9 (ممتاز)',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(car.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 16),
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
                                _buildInfoItem(Icons.people_outline, 'السعة', '${car.passengerCount} ركاب'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.settings_outlined, 'ناقل الحركة', car.transmission),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.local_gas_station_outlined, 'الوقود', 'بنزين 95'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('مواصفات وخدمات السيارة', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          _buildFeatureItem(Icons.verified_outlined, 'تأمين شامل ضد الحوادث'),
                          const SizedBox(height: 8),
                          _buildFeatureItem(Icons.gps_fixed, 'نظام ملاحة GPS حديث'),
                          const SizedBox(height: 8),
                          _buildFeatureItem(Icons.person_pin, 'إمكانية طلب سائق خاص أو قيادة ذاتية'),
                          const SizedBox(height: 8),
                          _buildFeatureItem(Icons.clean_hands_outlined, 'تسليم واستلام معقم بالكامل'),
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
                            Text('سعر الإيجار', style: AppTypography.bodySmall),
                            Text(car.pricePerDay, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز واستئجار السيارة',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('تم استلام طلب استئجار ${car.title} بنجاح!'),
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
              Text('تعذر تحميل تفاصيل السيارة', style: AppTypography.titleLarge),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.refresh(carDetailProvider(carId)),
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

  Widget _buildFeatureItem(IconData icon, String title) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: AppColors.primaryGold, size: 18),
        const SizedBox(width: 10),
        Text(title, style: AppTypography.bodyMedium),
      ],
    );
  }
}
