import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/experience_card.dart';
import '../../core/widgets/section_header.dart';
import '../experiences/models/experience_model.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom Luxury App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 110,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.goldGradient,
                        ),
                        child: const Center(
                          child: Text(
                            'م',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('مرحباً بك', style: AppTypography.bodySmall),
                          Text(
                            authState.userName ?? 'مسافر مُضيف',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                        onPressed: () => context.push('/cart'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                        onPressed: () => context.push('/notifications'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () => context.go('/discover'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.primaryGold),
                          const SizedBox(width: 12),
                          Text(
                            'ابحث عن وجهة، تجربة، أو فعالية...',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Hero Banner (تجارب مختارة بعناية)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF273844), Color(0xFF0F1B24)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: 20,
                          top: 24,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'تجارب مختارة بعناية',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.primaryGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('من التراث إلى التجربة', style: AppTypography.headingSmall),
                              const SizedBox(height: 4),
                              Text('اكتشف روائع المملكة الأصيلة', style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: ElevatedButton(
                            onPressed: () => context.go('/discover'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              foregroundColor: AppColors.textDark,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('استكشف الآن'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Quick Category Icons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryIcon(context, 'المتاحف', Icons.museum_outlined, () => context.go('/discover')),
                      _buildCategoryIcon(context, 'الفعاليات', Icons.festival_outlined, () => context.go('/discover')),
                      _buildCategoryIcon(context, 'الجولات', Icons.explore_outlined, () => context.go('/discover')),
                      _buildCategoryIcon(context, 'المتجر', Icons.storefront_outlined, () => context.push('/store')),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Experiences Section
                SectionHeader(
                  title: 'تجارب مميزة',
                  subtitle: 'أبرز المغامرات والأنشطة الثقافية',
                  onActionTap: () => context.go('/discover'),
                ),

                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: mockExperiences.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final exp = mockExperiences[index];
                      return ExperienceCard(
                        title: exp.title,
                        category: exp.category,
                        location: exp.location,
                        price: exp.price,
                        duration: exp.duration,
                        rating: exp.rating,
                        imageUrl: exp.imageUrl,
                        onTap: () => context.push('/experience/${exp.id}'),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Bazaar Promo Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => context.push('/store'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.goldGlow,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.card_giftcard, color: AppColors.primaryGold, size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('بازار مُضيف للمقتنيات', style: AppTypography.titleMedium),
                                const SizedBox(height: 2),
                                Text('تحف سعودية، عطور وبخور، وحرف يدوية', style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: AppColors.primaryGold, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTypography.titleSmall),
        ],
      ),
    );
  }
}
