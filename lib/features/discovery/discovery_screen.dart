import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/experience_card.dart';
import '../tours/data/repositories/tour_repository.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  final List<String> _categories = ['الكل', 'المتاحف', 'المغامرات', 'التراث والآثار', 'الفعاليات', 'الأدلاء'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = _searchController.text.trim();
    final toursAsync = ref.watch(toursListProvider(search.isEmpty ? null : search));

    return Scaffold(
      appBar: AppBar(
        title: Text('اكتشف روائع المملكة', style: AppTypography.headingSmall),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ابحث عن وجهة، مدينة، أو معلم...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),

          // Filter Category Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedCategory = cat);
                  },
                  selectedColor: AppColors.primaryGold,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.primaryGold : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Grid / List of Experiences from Real API
          Expanded(
            child: toursAsync.when(
              data: (tours) {
                if (tours.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.explore_off_outlined, size: 54, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text('لا توجد نتائج مطابقة لبحثك', style: AppTypography.titleMedium),
                          const SizedBox(height: 6),
                          Text('جرب البحث بكلمات أخرى أو اختر تصنيفاً مختلفاً', style: AppTypography.bodySmall),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: tours.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tour = tours[index];
                    return SizedBox(
                      width: double.infinity,
                      child: ExperienceCard(
                        title: tour.title,
                        category: tour.categoryName ?? 'تجربة سياحية',
                        location: tour.locationName ?? 'المملكة',
                        price: tour.formattedPrice,
                        duration: tour.duration ?? 'ساعتان',
                        rating: tour.rating,
                        imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                        onTap: () => context.push('/experience/${tour.id}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGold),
              ),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text('تعذر تحميل البيانات من الخادم', style: AppTypography.titleMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(toursListProvider(search.isEmpty ? null : search)),
                      child: const Text('إعادة المحاولة'),
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
}
