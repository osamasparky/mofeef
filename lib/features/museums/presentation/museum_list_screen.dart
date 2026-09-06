import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../data/museum_repository.dart';

class MuseumListScreen extends ConsumerStatefulWidget {
  const MuseumListScreen({super.key});

  @override
  ConsumerState<MuseumListScreen> createState() => _MuseumListScreenState();
}

class _MuseumListScreenState extends ConsumerState<MuseumListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCity = 'الكل';
  RangeValues _priceRange = const RangeValues(0, 500);
  double _minRating = 0.0;

  final List<String> _cities = ['الكل', 'الرياض', 'العُلا', 'جدة التاريخية', 'الدرعية', 'مكة المكرمة', 'المدينة المنورة', 'عسير'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
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
                      Text('تصفية المتاحف والمعالم', style: AppTypography.headingSmall),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCity = 'الكل';
                            _priceRange = const RangeValues(0, 500);
                            _minRating = 0.0;
                          });
                          setState(() {});
                        },
                        child: const Text('إعادة ضبط', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // City Filter
                  Text('المدينة / الوجهة', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cities.map((city) {
                      final isSel = _selectedCity == city;
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
                      Text('نطاق السعر', style: AppTypography.titleSmall),
                      Text(
                        '${_priceRange.start.round()} — ${_priceRange.end.round()} ﷼',
                        style: AppTypography.price.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 500,
                    divisions: 10,
                    activeColor: AppColors.primaryGold,
                    inactiveColor: AppColors.border,
                    onChanged: (val) {
                      setModalState(() => _priceRange = val);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),

                  // Minimum Rating
                  Text('الحد الأدنى للتقييم', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [0.0, 3.0, 4.0, 4.5].map((r) {
                      final isSel = _minRating == r;
                      final label = r == 0.0 ? 'الكل' : '$r+ ⭐';
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

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: AppColors.textDark,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('تطبيق الفلاتر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final museumsAsync = ref.watch(museumsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('المتاحف والتراث', style: AppTypography.headingSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن متحف أو صرح تراثي...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _showFilterSheet,
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
          Expanded(
            child: museumsAsync.when(
              data: (museums) {
                final filtered = museums.where((m) {
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase();
                    final matches = m.title.toLowerCase().contains(q) || (m.locationName?.toLowerCase().contains(q) ?? false);
                    if (!matches) return false;
                  }
                  if (m.price < _priceRange.start || m.price > _priceRange.end) return false;
                  if (m.rating < _minRating) return false;
                  if (_selectedCity != 'الكل') {
                    if (m.locationName != null && !m.locationName!.contains(_selectedCity)) return false;
                  }
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text('لا توجد متاحف مطابقة للبحث', style: AppTypography.bodyMedium),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final museum = filtered[index];
                    return GestureDetector(
                      onTap: () => context.push('/museum/${museum.id}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: museum.imageUrl ?? 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?w=800&q=80',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Container(
                                    height: 180,
                                    color: AppColors.surface,
                                    child: const Icon(Icons.museum_outlined, color: AppColors.primaryGold, size: 48),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                                        const SizedBox(width: 4),
                                        Text('${museum.rating}', style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryGold,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      museum.formattedPrice,
                                      style: AppTypography.titleSmall.copyWith(color: AppColors.textDark, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(museum.title, style: AppTypography.titleLarge),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 16),
                                      const SizedBox(width: 4),
                                      Text(museum.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
                                      const Spacer(),
                                      const Icon(Icons.access_time, color: AppColors.textSecondary, size: 16),
                                      const SizedBox(width: 4),
                                      Text(museum.workingHours ?? '٩ص — ٩م', style: AppTypography.bodySmall),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (err, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('تعذر تحميل قائمة المتاحف', style: AppTypography.bodyMedium),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.refresh(museumsListProvider),
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
