import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/custom_button.dart';
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
  String _selectedCity = 'الكل';
  RangeValues _priceRange = const RangeValues(0, 1500);
  double _minRating = 0.0;

  final List<String> _categoriesAr = ['الكل', 'المسارات السياحية', 'المتاحف والتراث', 'المغامرات', 'الفعاليات', 'الأدلاء'];
  final List<String> _categoriesEn = ['All', 'Tourist Trails', 'Museums & Heritage', 'Adventures', 'Events', 'Guides'];

  final List<String> _citiesAr = ['الكل', 'العُلا', 'الرياض', 'جدة التاريخية', 'الدرعية', 'عسير', 'البحر الأحمر'];
  final List<String> _citiesEn = ['All', 'AlUla', 'Riyadh', 'Historic Jeddah', 'Diriyah', 'Asir', 'Red Sea'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet(bool isAr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final categories = isAr ? _categoriesAr : _categoriesEn;
          final cities = isAr ? _citiesAr : _citiesEn;

          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'تصفية النتائج' : 'Filter Results',
                      style: AppTypography.headingSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedCategory = 'الكل';
                          _selectedCity = 'الكل';
                          _priceRange = const RangeValues(0, 1500);
                          _minRating = 0.0;
                        });
                        setState(() {});
                      },
                      child: Text(
                        isAr ? 'إعادة ضبط' : 'Reset All',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
                // Category Filter
                Text(isAr ? 'التصنيف' : 'Category', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSel = (_selectedCategory == cat) || (_selectedCategory == 'الكل' && cat == (isAr ? 'الكل' : 'All'));
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSel,
                      onSelected: (val) {
                        setModalState(() => _selectedCategory = cat);
                        setState(() {});
                      },
                      selectedColor: AppColors.primaryGold,
                      backgroundColor: AppColors.card,
                      labelStyle: TextStyle(
                        color: isSel ? AppColors.textDark : AppColors.textPrimary,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // City Filter
                Text(isAr ? 'المدينة / الوجهة' : 'City / Destination', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: cities.map((city) {
                    final isSel = (_selectedCity == city) || (_selectedCity == 'الكل' && city == (isAr ? 'الكل' : 'All'));
                    return ChoiceChip(
                      label: Text(city),
                      selected: isSel,
                      onSelected: (val) {
                        setModalState(() => _selectedCity = city);
                        setState(() {});
                      },
                      selectedColor: AppColors.primaryGold,
                      backgroundColor: AppColors.card,
                      labelStyle: TextStyle(
                        color: isSel ? AppColors.textDark : AppColors.textPrimary,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Price Range
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAr ? 'نطاق السعر' : 'Price Range', style: AppTypography.titleSmall),
                    Text(
                      '${_priceRange.start.round()} — ${_priceRange.end.round()} ${isAr ? 'ر.س' : 'SAR'}',
                      style: AppTypography.price.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 1500,
                  divisions: 15,
                  activeColor: AppColors.primaryGold,
                  inactiveColor: AppColors.border,
                  onChanged: (val) {
                    setModalState(() => _priceRange = val);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Minimum Rating
                Text(isAr ? 'الحد الأدنى للتقييم' : 'Minimum Rating', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [0.0, 3.0, 4.0, 4.5].map((r) {
                    final isSel = _minRating == r;
                    final label = r == 0.0 ? (isAr ? 'الكل' : 'All') : '$r+ ⭐';
                    return GestureDetector(
                      onTap: () {
                        setModalState(() => _minRating = r);
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.goldGlow : AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? AppColors.primaryGold : AppColors.border),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSel ? AppColors.primaryGold : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                CustomButton(
                  text: isAr ? 'تطبيق الفلاتر' : 'Apply Filters',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final categories = isAr ? _categoriesAr : _categoriesEn;

    final search = _searchController.text.trim();
    final toursAsync = ref.watch(toursListProvider(search.isEmpty ? null : search));

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'اكتشف روائع المملكة' : 'Discover Saudi Wonders', style: AppTypography.headingSmall),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: isAr ? 'ابحث عن وجهة، مسار سياحي، أو معلم...' : 'Search destination, trail, or landmark...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showFilterSheet(isAr),
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: AppColors.goldGlow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGold),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.primaryGold),
                  ),
                ),
              ],
            ),
          ),

          // Filter Category Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = (_selectedCategory == cat) || (_selectedCategory == 'الكل' && index == 0) || (_selectedCategory == 'All' && index == 0);
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
                // Apply In-Memory Filters (Category, City, Price, Rating)
                final filteredTours = tours.where((t) {
                  final price = t.salePrice ?? t.price;
                  if (price < _priceRange.start || price > _priceRange.end) return false;
                  if (t.rating < _minRating) return false;

                  if (_selectedCity != 'الكل' && _selectedCity != 'All') {
                    if (t.locationName != null && !t.locationName!.contains(_selectedCity)) {
                      return false;
                    }
                  }

                  if (_selectedCategory != 'الكل' && _selectedCategory != 'All') {
                    if (t.categoryName != null && !t.categoryName!.contains(_selectedCategory)) {
                      return false;
                    }
                  }

                  return true;
                }).toList();

                if (filteredTours.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.explore_off_outlined, size: 54, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text(isAr ? 'لا توجد نتائج مطابقة لبحثك' : 'No results match your filters', style: AppTypography.titleMedium),
                          const SizedBox(height: 6),
                          Text(
                            isAr ? 'جرب تعديل الفلاتر أو البحث بكلمات أخرى' : 'Try adjusting your filter options or search query',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = 'الكل';
                                _selectedCity = 'الكل';
                                _priceRange = const RangeValues(0, 1500);
                                _minRating = 0.0;
                                _searchController.clear();
                              });
                            },
                            child: Text(isAr ? 'إعادة ضبط الفلاتر' : 'Reset Filters'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTours.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tour = filteredTours[index];
                    return SizedBox(
                      width: double.infinity,
                      child: ExperienceCard(
                        title: tour.title,
                        category: tour.categoryName ?? (isAr ? 'مسار سياحي' : 'Tourist Trail'),
                        location: tour.locationName ?? (isAr ? 'المملكة' : 'KSA'),
                        price: tour.formattedPrice,
                        duration: tour.duration ?? (isAr ? 'ساعتان' : '2 hours'),
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
                    Text(isAr ? 'تعذر تحميل البيانات من الخادم' : 'Failed to load data from server', style: AppTypography.titleMedium),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(toursListProvider(search.isEmpty ? null : search)),
                      child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
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
