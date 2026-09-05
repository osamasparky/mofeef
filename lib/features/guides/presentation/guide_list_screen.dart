import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';

class GuideModel {
  final String id;
  final String name;
  final String title;
  final List<String> languages;
  final double rating;
  final int toursCount;
  final String hourlyRate;
  final String imageUrl;

  const GuideModel({
    required this.id,
    required this.name,
    required this.title,
    required this.languages,
    required this.rating,
    required this.toursCount,
    required this.hourlyRate,
    required this.imageUrl,
  });
}

final List<GuideModel> mockGuides = [
  const GuideModel(
    id: 'g_1',
    name: 'عبدالله السبيعي',
    title: 'مرشد سياحي معتمد — آثار العُلا وتاريخ نجد',
    languages: ['العربية', 'الإنجليزية'],
    rating: 4.9,
    toursCount: 142,
    hourlyRate: '١٥٠ ر.س / ساعة',
    imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
  ),
  const GuideModel(
    id: 'g_2',
    name: 'سارة القحطاني',
    title: 'خبيرة التراث الثقافي ومعالم الدرعية',
    languages: ['العربية', 'الفرنسية', 'الإنجليزية'],
    rating: 5.0,
    toursCount: 98,
    hourlyRate: '١٨٠ ر.س / ساعة',
    imageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800&q=80',
  ),
];

class GuideListScreen extends StatelessWidget {
  const GuideListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأدلاء السياحيين المعتمدين', style: AppTypography.headingSmall),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockGuides.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final guide = mockGuides[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: guide.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(guide.name, style: AppTypography.titleMedium),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.primaryGold, size: 14),
                              const SizedBox(width: 4),
                              Text('${guide.rating}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(guide.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(guide.hourlyRate, style: AppTypography.price.copyWith(fontSize: 13)),
                          CustomButton(
                            text: 'طلب إرشاد',
                            width: 100,
                            height: 36,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم إرسال طلب استشارة للمرشد ${guide.name}!'), backgroundColor: AppColors.success),
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
