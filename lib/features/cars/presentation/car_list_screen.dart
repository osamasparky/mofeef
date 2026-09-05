import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/car_repository.dart';

class CarModel {
  final String id;
  final String title;
  final String category;
  final String pricePerDay;
  final int passengerCount;
  final String transmission;
  final String imageUrl;

  const CarModel({
    required this.id,
    required this.title,
    required this.category,
    required this.pricePerDay,
    required this.passengerCount,
    required this.transmission,
    required this.imageUrl,
  });
}

class CarListScreen extends ConsumerWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carsAsync = ref.watch(carsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('تأجير السيارات الفاخرة', style: AppTypography.headingSmall),
      ),
      body: carsAsync.when(
        data: (cars) {
          if (cars.isEmpty) {
            return Center(
              child: Text('لا توجد سيارات متاحة حالياً', style: AppTypography.bodyMedium),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cars.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final car = cars[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: car.imageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 160,
                        color: AppColors.surface,
                        child: const Icon(Icons.directions_car, size: 48, color: AppColors.textMuted),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.category, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                          const SizedBox(height: 4),
                          Text(car.title, style: AppTypography.titleLarge),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text('${car.passengerCount} ركاب', style: AppTypography.bodySmall),
                              const SizedBox(width: 16),
                              const Icon(Icons.settings_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(car.transmission, style: AppTypography.bodySmall),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(car.pricePerDay, style: AppTypography.price),
                              CustomButton(
                                text: 'حجز السيارة',
                                width: 130,
                                height: 42,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('تم فتح طلب حجز السيارة بنجاح!'), backgroundColor: AppColors.success),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
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
              Text('تعذر تحميل بيانات السيارات', style: AppTypography.bodyMedium),
              TextButton(
                onPressed: () => ref.refresh(carsListProvider),
                child: const Text('إعادة المحاولة', style: TextStyle(color: AppColors.primaryGold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
