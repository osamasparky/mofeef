import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/custom_button.dart';
import 'models/experience_model.dart';

class ExperienceDetailsScreen extends StatelessWidget {
  final String experienceId;

  const ExperienceDetailsScreen({super.key, required this.experienceId});

  @override
  Widget build(BuildContext context) {
    final exp = mockExperiences.firstWhere(
      (e) => e.id == experienceId,
      orElse: () => mockExperiences.first,
    );

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Image Header with Back & Favorite Button
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
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: exp.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Details Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Rating
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
                              exp.category,
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
                                '${exp.rating} (١٢٤ تقييم)',
                                style: AppTypography.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title
                      Text(exp.title, style: AppTypography.headingMedium),
                      const SizedBox(height: 8),

                      // Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(exp.location, style: AppTypography.bodyMedium),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Highlights Row (Working hours & Duration)
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
                            _buildInfoItem(Icons.access_time, 'ساعات العمل', exp.workingHours),
                            Container(width: 1, height: 40, color: AppColors.border),
                            _buildInfoItem(Icons.timelapse, 'المدة', exp.duration),
                            Container(width: 1, height: 40, color: AppColors.border),
                            _buildInfoItem(Icons.confirmation_number_outlined, 'التذكرة', exp.price),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Overview / Description
                      Text('نبذة عن التجربة', style: AppTypography.titleLarge),
                      const SizedBox(height: 8),
                      Text(exp.description, style: AppTypography.bodyLarge),
                      const SizedBox(height: 24),

                      // Location Map Placeholder
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

          // Bottom Fixed Booking Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: const Border(top: BorderSide(color: AppColors.border)),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, -4)),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('السعر يبدأ من', style: AppTypography.bodySmall),
                        Text(exp.price, style: AppTypography.price),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomButton(
                        text: 'حجز التذكرة',
                        onPressed: () => context.push('/checkout/${exp.id}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
