import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/utils/html_utils.dart';
import '../data/models/tour_model.dart';
import '../data/repositories/tour_repository.dart';

// Provider specifically for tourist trails (category 1)
final touristTrailsProvider = FutureProvider.family<List<TourModel>, String?>((ref, search) async {
  return ref.watch(tourRepositoryProvider).searchTours(
    search: search,
    categoryId: 1, // Tourist routes
  );
});

class TouristTrailsScreen extends ConsumerStatefulWidget {
  const TouristTrailsScreen({super.key});

  @override
  ConsumerState<TouristTrailsScreen> createState() => _TouristTrailsScreenState();
}

class _TouristTrailsScreenState extends ConsumerState<TouristTrailsScreen> {
  final _searchController = TextEditingController();
  String _selectedRouteType = 'الكل';
  String _selectedStyle = 'الكل';
  RangeValues _priceRange = const RangeValues(100, 500);
  double _minRating = 0.0;

  final List<String> _routeTypesAr = ['الكل', 'المسارات السياحية', 'السياحة البيئية', 'جولات برفقة مرشد', 'مسارات تاريخية'];
  final List<String> _routeTypesEn = ['All', 'Tourist Routes', 'Ecotourism', 'Escorted Tour', 'Historical Trails'];

  final List<String> _stylesAr = ['الكل', 'ثقافي', 'تاريخي', 'إسلامي', 'تراث شعبي', 'مغامرات'];
  final List<String> _stylesEn = ['All', 'Cultural', 'Historical', 'Islamic', 'Folk Heritage', 'Adventures'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal(BuildContext context, bool isAr) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final routeTypes = isAr ? _routeTypesAr : _routeTypesEn;
          final styles = isAr ? _stylesAr : _stylesEn;

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
                      isAr ? 'تصفية المسارات السياحية' : 'Filter Tourist Trails',
                      style: AppTypography.headingSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedRouteType = 'الكل';
                          _selectedStyle = 'الكل';
                          _priceRange = const RangeValues(100, 500);
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
                const SizedBox(height: 16),

                // Route Type Filter
                Text(isAr ? 'نوع المسار' : 'Route Type', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: routeTypes.map((rt) {
                    final isSel = (_selectedRouteType == rt) || (_selectedRouteType == 'الكل' && rt == (isAr ? 'الكل' : 'All'));
                    return ChoiceChip(
                      label: Text(rt),
                      selected: isSel,
                      onSelected: (val) {
                        setModalState(() => _selectedRouteType = rt);
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

                // Style Filter
                Text(isAr ? 'نمط الرحلة' : 'Travel Style', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: styles.map((st) {
                    final isSel = (_selectedStyle == st) || (_selectedStyle == 'الكل' && st == (isAr ? 'الكل' : 'All'));
                    return ChoiceChip(
                      label: Text(st),
                      selected: isSel,
                      onSelected: (val) {
                        setModalState(() => _selectedStyle = st);
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

                // Price Range
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAr ? 'نطاق السعر' : 'Price Range', style: AppTypography.titleSmall),
                    Text(
                      '${_priceRange.start.round()} — ${_priceRange.end.round()} ﷼',
                      style: AppTypography.price.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  activeColor: AppColors.primaryGold,
                  inactiveColor: AppColors.border,
                  onChanged: (val) {
                    setModalState(() => _priceRange = val);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Rating Filter
                Text(isAr ? 'التقييم الأدنى' : 'Minimum Rating', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [0.0, 4.0, 4.5, 4.8].map((rate) {
                    final isSel = _minRating == rate;
                    final label = rate == 0.0 ? (isAr ? 'الكل' : 'All') : '★ $rate+';
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(label),
                        selected: isSel,
                        onSelected: (val) {
                          setModalState(() => _minRating = rate);
                          setState(() {});
                        },
                        selectedColor: AppColors.primaryGold,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.textDark : AppColors.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Apply button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: AppColors.textDark,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      isAr ? 'تطبيق الفلاتر' : 'Apply Filters',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
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
    final trailsAsync = ref.watch(touristTrailsProvider(_searchController.text));
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'المسارات السياحية' : 'Tourist Trails & Routes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: isAr ? 'ابحث عن مسار سياحي (مثل صلح الحديبية)...' : 'Search trail (e.g. Al-Hudaybiyyah)...',
                        hintStyle: AppTypography.bodySmall,
                        prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _openFilterModal(context, isAr),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.filter_list, color: AppColors.primaryGold),
                  ),
                ),
              ],
            ),
          ),

          // Trails List
          Expanded(
            child: trailsAsync.when(
              data: (trails) {
                // Apply in-memory price, rating, and search filter
                final filtered = trails.where((t) {
                  final matchesPrice = t.priceNumeric >= _priceRange.start && t.priceNumeric <= _priceRange.end;
                  final matchesRating = t.rating >= _minRating;
                  final matchesSearch = _searchController.text.isEmpty ||
                      t.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      t.description.toLowerCase().contains(_searchController.text.toLowerCase());
                  return matchesPrice && matchesRating && matchesSearch;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.alt_route, color: AppColors.textMuted, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          isAr ? 'لا توجد مسارات مطابقة لمعايير البحث' : 'No trails found matching criteria',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _priceRange = const RangeValues(100, 500);
                              _selectedRouteType = 'الكل';
                            });
                          },
                          child: Text(isAr ? 'إعادة ضبط البحث' : 'Reset Search'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final trail = filtered[index];
                    return _buildTrailCard(context, trail, isAr);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 12),
                    Text(isAr ? 'تعذر تحميل المسارات السياحية' : 'Failed to load trails', style: AppTypography.titleMedium),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.refresh(touristTrailsProvider(_searchController.text)),
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

  Widget _buildTrailCard(BuildContext context, TourModel trail, bool isAr) {
    final cleanDesc = HtmlUtils.stripHtml(trail.description);

    return GestureDetector(
      onTap: () => context.push('/experience/${trail.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: trail.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.surface,
                      child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: isAr ? 12 : null,
                  left: isAr ? null : 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.alt_route, color: AppColors.primaryGold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          trail.categoryName != null && trail.categoryName!.isNotEmpty ? trail.categoryName! : (isAr ? 'مسار سياحي' : 'Tourist Route'),
                          style: const TextStyle(color: AppColors.primaryGold, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                if (trail.duration != null && trail.duration!.isNotEmpty)
                  Positioned(
                    bottom: 12,
                    right: isAr ? 12 : null,
                    left: isAr ? null : 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(trail.duration!, style: const TextStyle(color: Colors.white, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          trail.title,
                          style: AppTypography.headingSmall.copyWith(fontSize: 17),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                          const SizedBox(width: 4),
                          Text('${trail.rating}', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cleanDesc.isNotEmpty ? cleanDesc : (isAr ? 'مسار سياحي وتراثي متكامل يروي أروع القصص والأحداث التاريخية.' : 'Comprehensive historical and heritage tour trail.'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isAr ? 'يبدأ من' : 'Starts from', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                          Text(trail.formattedPrice, style: AppTypography.price.copyWith(fontSize: 17)),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: AppColors.textDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        onPressed: () => context.push('/experience/${trail.id}'),
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: Text(
                          isAr ? 'استكشف المسار' : 'Explore Trail',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
