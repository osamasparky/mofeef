import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/custom_button.dart';
import '../tours/data/repositories/tour_repository.dart';
import '../museums/data/museum_repository.dart';
import '../events/data/event_repository.dart';
import '../guides/data/guide_repository.dart';
import '../cars/data/car_repository.dart';
import '../shop/data/shop_repository.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;
  String _selectedCity = 'الكل';
  RangeValues _priceRange = const RangeValues(0, 2000);
  double _minRating = 0.0;

  final List<String> _categoriesAr = [
    'الكل',
    'المسارات السياحية',
    'المتاحف والمعالم',
    'الفعاليات والمواسم',
    'المرشدون السياحيون',
    'السيارات والتنقل',
    'المتجر التراثي',
  ];

  final List<String> _categoriesEn = [
    'All',
    'Tourist Trails',
    'Museums & Landmarks',
    'Events & Seasons',
    'Tour Guides',
    'Cars & Transport',
    'Heritage Shop',
  ];

  final List<IconData> _categoryIcons = [
    Icons.explore,
    Icons.route,
    Icons.account_balance,
    Icons.festival,
    Icons.person_pin,
    Icons.directions_car,
    Icons.card_giftcard,
  ];

  final List<String> _citiesAr = ['الكل', 'العُلا', 'الرياض', 'جدة التاريخية', 'الدرعية', 'مكة المكرمة', 'المدينة المنورة', 'عسير'];
  final List<String> _citiesEn = ['All', 'AlUla', 'Riyadh', 'Historic Jeddah', 'Diriyah', 'Makkah', 'Madinah', 'Asir'];

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
                      Text(
                        isAr ? 'تصفية النتائج' : 'Filter Results',
                        style: AppTypography.headingSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCategoryIndex = 0;
                            _selectedCity = 'الكل';
                            _priceRange = const RangeValues(0, 2000);
                            _minRating = 0.0;
                          });
                        },
                        child: Text(isAr ? 'إعادة ضبط' : 'Reset', style: const TextStyle(color: AppColors.primaryGold)),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),
                  // Category Filter
                  Text(isAr ? 'التصنيف الرئيسي' : 'Category', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(categories.length, (idx) {
                      final cat = categories[idx];
                      final isSel = _selectedCategoryIndex == idx;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        onSelected: (val) {
                          setModalState(() => _selectedCategoryIndex = idx);
                        },
                        selectedColor: AppColors.primaryGold,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.textDark : AppColors.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),

                  // City Filter
                  Text(isAr ? 'المدينة / الوجهة' : 'City / Destination', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cities.map((city) {
                      final isSel = _selectedCity == city;
                      return ChoiceChip(
                        label: Text(city),
                        selected: isSel,
                        onSelected: (val) {
                          setModalState(() => _selectedCity = city);
                        },
                        selectedColor: AppColors.primaryGold,
                        backgroundColor: AppColors.card,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.textDark : AppColors.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

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
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    activeColor: AppColors.primaryGold,
                    inactiveColor: AppColors.border,
                    onChanged: (val) {
                      setModalState(() => _priceRange = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Min Rating
                  Text(isAr ? 'الحد الأدنى للتقييم' : 'Minimum Rating', style: AppTypography.titleSmall),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [0.0, 3.0, 4.0, 4.5, 4.8].map((r) {
                      final isSel = _minRating == r;
                      return GestureDetector(
                        onTap: () => setModalState(() => _minRating = r),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primaryGold : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isSel ? AppColors.primaryGold : AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 14, color: isSel ? AppColors.textDark : AppColors.primaryGold),
                              const SizedBox(width: 4),
                              Text(
                                r == 0.0 ? (isAr ? 'الكل' : 'All') : '$r+',
                                style: TextStyle(
                                  color: isSel ? AppColors.textDark : AppColors.textPrimary,
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Apply Button
                  CustomButton(
                    text: isAr ? 'تطبيق الفلاتر' : 'Apply Filters',
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
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
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final categories = isAr ? _categoriesAr : _categoriesEn;
    final search = _searchController.text.trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'اكتشف المملكة' : 'Discover Saudi', style: AppTypography.headingSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: isAr ? 'ابحث عن مسار، فعالية، مرشد أو منتج...' : 'Search trails, events, guides, cars...',
                        hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                        prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _showFilterSheet(isAr),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                    ),
                    child: const Icon(Icons.tune, color: AppColors.primaryGold, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Categories Horizontal Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategoryIndex == index;
                final icon = _categoryIcons[index % _categoryIcons.length];
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGold : AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGold : AppColors.border,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primaryGold.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? AppColors.textDark : AppColors.primaryGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // Content body based on selected category index
          Expanded(
            child: _buildCategoryContent(isAr, search),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent(bool isAr, String search) {
    switch (_selectedCategoryIndex) {
      case 1: // المسارات السياحية
        return _buildToursList(isAr, search);
      case 2: // المتاحف والمعالم
        return _buildMuseumsList(isAr, search);
      case 3: // الفعاليات والمواسم
        return _buildEventsList(isAr, search);
      case 4: // المرشدون السياحيون
        return _buildGuidesList(isAr, search);
      case 5: // السيارات والتنقل
        return _buildCarsList(isAr, search);
      case 6: // المتجر التراثي
        return _buildProductsList(isAr, search);
      case 0: // الكل (كل التصنيفات فيما عدا المتجر)
      default:
        return _buildAllCombinedList(isAr, search);
    }
  }

  Widget _buildAllCombinedList(bool isAr, String search) {
    final toursAsync = ref.watch(toursListProvider(search.isEmpty ? null : search));
    final museumsAsync = ref.watch(museumsListProvider);
    final eventsAsync = ref.watch(eventsListProvider);
    final guidesAsync = ref.watch(guidesListProvider);
    final carsAsync = ref.watch(carsListProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. المسارات السياحية
          _buildSectionHeader(
            title: isAr ? 'المسارات السياحية' : 'Tourist Trails',
            onTapMore: () => setState(() => _selectedCategoryIndex = 1),
            isAr: isAr,
          ),
          toursAsync.when(
            data: (tours) {
              final list = tours.take(6).toList();
              if (list.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 230,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final tour = list[index];
                    return GestureDetector(
                      onTap: () => context.push('/experience/${tour.id}'),
                      child: Container(
                        width: 220,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                                  height: 125,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 8,
                                  right: isAr ? 8 : null,
                                  left: isAr ? null : 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, color: AppColors.primaryGold, size: 12),
                                        const SizedBox(width: 4),
                                        Text('${tour.rating}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tour.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.primaryGold),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(tour.locationName ?? (isAr ? 'المملكة' : 'KSA'), style: AppTypography.bodySmall.copyWith(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(tour.formattedPrice, style: AppTypography.price.copyWith(fontSize: 13)),
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
                ),
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: AppColors.primaryGold))),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // 2. المتاحف والمعالم
          _buildSectionHeader(
            title: isAr ? 'المتاحف والمعالم' : 'Museums & Landmarks',
            onTapMore: () => setState(() => _selectedCategoryIndex = 2),
            isAr: isAr,
          ),
          museumsAsync.when(
            data: (museums) {
              final list = museums.take(6).toList();
              if (list.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 210,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final m = list[index];
                    return GestureDetector(
                      onTap: () => context.push('/museum/${m.id}'),
                      child: Container(
                        width: 210,
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
                              imageUrl: m.imageUrl ?? 'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?w=800&q=80',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(m.locationName ?? (isAr ? 'الرياض' : 'Riyadh'), style: AppTypography.bodySmall),
                                      Text(m.formattedPrice, style: AppTypography.price.copyWith(fontSize: 13)),
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
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // 3. الفعاليات والمواسم
          _buildSectionHeader(
            title: isAr ? 'الفعاليات والمواسم' : 'Events & Seasons',
            onTapMore: () => setState(() => _selectedCategoryIndex = 3),
            isAr: isAr,
          ),
          eventsAsync.when(
            data: (events) {
              final list = events.take(6).toList();
              if (list.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 210,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final ev = list[index];
                    return GestureDetector(
                      onTap: () => context.push('/event/${ev.id}'),
                      child: Container(
                        width: 210,
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
                              imageUrl: ev.imageUrl,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ev.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ev.location, style: AppTypography.bodySmall),
                                      Text(ev.price, style: AppTypography.price.copyWith(fontSize: 13)),
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
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // 4. المرشدون السياحيون
          _buildSectionHeader(
            title: isAr ? 'نخبة المرشدين السياحيين' : 'Tour Guides',
            onTapMore: () => setState(() => _selectedCategoryIndex = 4),
            isAr: isAr,
          ),
          guidesAsync.when(
            data: (guides) {
              final list = guides.take(6).toList();
              if (list.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 130,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final g = list[index];
                    return GestureDetector(
                      onTap: () => context.push('/guide/${g.id}'),
                      child: Container(
                        width: 240,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: CachedNetworkImageProvider(g.imageUrl),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                  const SizedBox(height: 2),
                                  Text(g.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                  const SizedBox(height: 4),
                                  Text(g.hourlyRate, style: AppTypography.price.copyWith(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),

          // 5. السيارات والتنقل
          _buildSectionHeader(
            title: isAr ? 'السيارات والتنقل الفاخر' : 'Cars & Transport',
            onTapMore: () => setState(() => _selectedCategoryIndex = 5),
            isAr: isAr,
          ),
          carsAsync.when(
            data: (cars) {
              final list = cars.take(6).toList();
              if (list.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 210,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final car = list[index];
                    return GestureDetector(
                      onTap: () => context.push('/car/${car.id}'),
                      child: Container(
                        width: 220,
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
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(car.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${car.passengerCount} ${isAr ? 'ركاب' : 'passengers'}', style: AppTypography.bodySmall),
                                      Text(car.pricePerDay, style: AppTypography.price.copyWith(fontSize: 13)),
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
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onTapMore,
    required bool isAr,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onTapMore,
            child: Row(
              children: [
                Text(
                  isAr ? 'عرض الكل' : 'View All',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primaryGold),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToursList(bool isAr, String search) {
    final toursAsync = ref.watch(toursListProvider(search.isEmpty ? null : search));
    return toursAsync.when(
      data: (tours) {
        final filtered = tours.where((t) {
          final price = t.salePrice ?? t.price;
          if (price < _priceRange.start || price > _priceRange.end) return false;
          if (t.rating < _minRating) return false;
          if (_selectedCity != 'الكل' && _selectedCity != 'All') {
            if (t.locationName != null && !t.locationName!.contains(_selectedCity)) return false;
          }
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final tour = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/experience/${tour.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                        width: 120,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tour.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.primaryGold),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(tour.locationName ?? (isAr ? 'المملكة' : 'KSA'), style: AppTypography.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: AppColors.primaryGold, size: 14),
                                    const SizedBox(width: 4),
                                    Text('${tour.rating}', style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                                    if (tour.duration != null) ...[
                                      const SizedBox(width: 8),
                                      Text('• ${tour.duration}', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                    ],
                                  ],
                                ),
                                Text(tour.formattedPrice, style: AppTypography.price.copyWith(fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
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
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(toursListProvider(search.isEmpty ? null : search))),
    );
  }

  Widget _buildMuseumsList(bool isAr, String search) {
    final museumsAsync = ref.watch(museumsListProvider);
    return museumsAsync.when(
      data: (museums) {
        final filtered = museums.where((m) {
          if (search.isNotEmpty && !m.title.toLowerCase().contains(search.toLowerCase())) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final museum = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/museum/${museum.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: museum.imageUrl ?? 'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?w=800&q=80',
                        width: 120,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(museum.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text(museum.locationName ?? (isAr ? 'المملكة' : 'KSA'), style: AppTypography.bodySmall),
                            const SizedBox(height: 8),
                            Text(museum.formattedPrice, style: AppTypography.price.copyWith(fontSize: 14)),
                          ],
                        ),
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
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(museumsListProvider)),
    );
  }

  Widget _buildEventsList(bool isAr, String search) {
    final eventsAsync = ref.watch(eventsListProvider);
    return eventsAsync.when(
      data: (events) {
        final filtered = events.where((e) {
          if (search.isNotEmpty && !e.title.toLowerCase().contains(search.toLowerCase())) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final event = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/event/${event.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: event.imageUrl,
                        width: 120,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text(event.location, style: AppTypography.bodySmall),
                            const SizedBox(height: 8),
                            Text(event.price, style: AppTypography.price.copyWith(fontSize: 14)),
                          ],
                        ),
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
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(eventsListProvider)),
    );
  }

  Widget _buildGuidesList(bool isAr, String search) {
    final guidesAsync = ref.watch(guidesListProvider);
    return guidesAsync.when(
      data: (guides) {
        final filtered = guides.where((g) {
          if (search.isNotEmpty && !g.name.toLowerCase().contains(search.toLowerCase())) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final guide = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/guide/${guide.id}'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: CachedNetworkImageProvider(guide.imageUrl),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(guide.name, style: AppTypography.titleMedium),
                          const SizedBox(height: 2),
                          Text(guide.title, style: AppTypography.bodySmall),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.primaryGold, size: 16),
                              const SizedBox(width: 4),
                              Text('${guide.rating}', style: AppTypography.titleSmall),
                              const SizedBox(width: 12),
                              Text(guide.languages.join(', '), style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(guide.hourlyRate, style: AppTypography.price.copyWith(fontSize: 13)),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(guidesListProvider)),
    );
  }

  Widget _buildCarsList(bool isAr, String search) {
    final carsAsync = ref.watch(carsListProvider);
    return carsAsync.when(
      data: (cars) {
        final filtered = cars.where((c) {
          if (search.isNotEmpty && !c.title.toLowerCase().contains(search.toLowerCase())) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final car = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/car/${car.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        imageUrl: car.imageUrl,
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(car.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleMedium),
                            const SizedBox(height: 4),
                            Text('${car.passengerCount} ${isAr ? 'ركاب' : 'passengers'} • ${car.transmission}', style: AppTypography.bodySmall),
                            const SizedBox(height: 8),
                            Text(car.pricePerDay, style: AppTypography.price.copyWith(fontSize: 14)),
                          ],
                        ),
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
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(carsListProvider)),
    );
  }

  Widget _buildProductsList(bool isAr, String search) {
    final productsAsync = ref.watch(productsListProvider);
    return productsAsync.when(
      data: (products) {
        final filtered = products.where((p) {
          if (search.isNotEmpty && !p.title.toLowerCase().contains(search.toLowerCase())) return false;
          return true;
        }).toList();

        if (filtered.isEmpty) return _buildEmptyState(isAr);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final product = filtered[index];
            return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (product.discountPercent != null && product.discountPercent!.isNotEmpty)
                            Positioned(
                              top: 8,
                              right: isAr ? 8 : null,
                              left: isAr ? null : 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGold,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'خصم ${product.discountPercent}',
                                  style: const TextStyle(color: AppColors.textDark, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.category,
                                  style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.primaryGold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.titleSmall.copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.price,
                                  style: AppTypography.price.copyWith(fontSize: 14),
                                ),
                                const Icon(Icons.shopping_bag_outlined, size: 16, color: AppColors.primaryGold),
                              ],
                            ),
                          ],
                        ),
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
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(productsListProvider)),
    );
  }

  Widget _buildEmptyState(bool isAr) {
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
                  _selectedCategoryIndex = 0;
                  _selectedCity = 'الكل';
                  _priceRange = const RangeValues(0, 2000);
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

  Widget _buildErrorState(bool isAr, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(isAr ? 'تعذر تحميل البيانات من الخادم' : 'Failed to load data from server', style: AppTypography.titleMedium),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
          ),
        ],
      ),
    );
  }
}
