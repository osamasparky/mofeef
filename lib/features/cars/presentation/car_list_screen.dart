import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';

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

final List<CarModel> mockCars = [
  const CarModel(
    id: 'car_1',
    title: 'تويوتا لاندكروزر VXR ٢٠٢٦',
    category: 'دفع رباعي فاخر — رحلات برية',
    pricePerDay: '٨٥٠ ر.س / يوم',
    passengerCount: 7,
    transmission: 'أوتوماتيك',
    imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80',
  ),
  const CarModel(
    id: 'car_2',
    title: 'مرسيدس S-Class ٥٠٠',
    category: 'VIP فاخرة مع سائق خاص',
    pricePerDay: '١,٦٠٠ ر.س / يوم',
    passengerCount: 4,
    transmission: 'أوتوماتيك',
    imageUrl: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800&q=80',
  ),
];

class CarListScreen extends StatelessWidget {
  const CarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تأجير السيارات الفاخرة', style: AppTypography.headingSmall),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockCars.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final car = mockCars[index];
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
      ),
    );
  }
}
