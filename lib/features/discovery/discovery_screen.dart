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

  // Global / General Filters
  String _selectedCity = 'الكل';
  RangeValues _globalPriceRange = const RangeValues(0, 3000);
  double _minRating = 0.0;

  // 1. Tours Specific Filters
  String _tourDurationFilter = 'الكل'; // 'الكل', 'نصف يوم', 'يوم كامل', 'أيام متعددة'

  // 2. Museums Specific Filters
  String _museumEntryType = 'الكل'; // 'الكل', 'مجاني', 'مدفوع'
  RangeValues _museumPriceRange = const RangeValues(0, 500);

  // 3. Events Specific Filters
  String _eventEntryType = 'الكل'; // 'الكل', 'مجاني', 'مدفوع'
  String _eventTimingFilter = 'الكل'; // 'الكل', 'اليوم', 'هذا الأسبوع'
  RangeValues _eventPriceRange = const RangeValues(0, 2000);

  // 4. Guides Specific Filters
  String _guideLanguageFilter = 'الكل'; // 'الكل', 'العربية', 'الإنجليزية', 'الفرنسية', 'الإسبانية', 'الألمانية', 'الصينية'
  RangeValues _guideHourlyRange = const RangeValues(0, 1000);
  double _guideMinRating = 0.0;

  // 5. Cars Specific Filters
  String _carPassengerFilter = 'الكل'; // 'الكل', '2', '4-5', '7+'
  String _carTransmissionFilter = 'الكل'; // 'الكل', 'أوتوماتيك', 'يدوي'
  RangeValues _carPriceRange = const RangeValues(0, 2500);

  // 6. Shop Specific Filters
  String _productCategoryFilter = 'الكل'; // 'الكل', 'عطور وبخور', 'تمور ومأكولات', 'مقتنيات وهدايا', 'أزياء وتراث'
  bool _productOnlyInStock = false;
  bool _productOnlyOnSale = false;
  RangeValues _productPriceRange = const RangeValues(0, 1500);

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
    Icons.alt_route,
    Icons.account_balance_outlined,
    Icons.festival_outlined,
    Icons.person_pin_outlined,
    Icons.directions_car_outlined,
    Icons.card_giftcard,
  ];

  final List<Color> _categoryColors = [
    AppColors.primaryGold,
    const Color(0xFFFBBF24), // Trails - Amber Gold
    const Color(0xFFC084FC), // Museums - Purple
    const Color(0xFFF43F5E), // Events - Crimson
    const Color(0xFF34D399), // Guides - Emerald
    const Color(0xFF60A5FA), // Cars - Sky Blue
    const Color(0xFFFB923C), // Shop - Orange
  ];

  final List<String> _citiesAr = ['الكل', 'العُلا', 'الرياض', 'جدة', 'الدرعية', 'مكة المكرمة', 'المدينة المنورة', 'عسير', 'أبها', 'الدمام'];
  final List<String> _citiesEn = ['All', 'AlUla', 'Riyadh', 'Jeddah', 'Diriyah', 'Makkah', 'Madinah', 'Asir', 'Abha', 'Dammam'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetAllFilters() {
    _selectedCity = 'الكل';
    _globalPriceRange = const RangeValues(0, 3000);
    _minRating = 0.0;
    _tourDurationFilter = 'الكل';
    _museumEntryType = 'الكل';
    _museumPriceRange = const RangeValues(0, 500);
    _eventEntryType = 'الكل';
    _eventTimingFilter = 'الكل';
    _eventPriceRange = const RangeValues(0, 2000);
    _guideLanguageFilter = 'الكل';
    _guideHourlyRange = const RangeValues(0, 1000);
    _guideMinRating = 0.0;
    _carPassengerFilter = 'الكل';
    _carTransmissionFilter = 'الكل';
    _carPriceRange = const RangeValues(0, 2500);
    _productCategoryFilter = 'الكل';
    _productOnlyInStock = false;
    _productOnlyOnSale = false;
    _productPriceRange = const RangeValues(0, 1500);
  }

  bool _isAnyFilterActive() {
    if (_selectedCity != 'الكل') return true;
    if (_minRating > 0.0) return true;
    if (_selectedCategoryIndex == 1 && _tourDurationFilter != 'الكل') return true;
    if (_selectedCategoryIndex == 2 && (_museumEntryType != 'الكل' || _museumPriceRange.end < 500)) return true;
    if (_selectedCategoryIndex == 3 && (_eventEntryType != 'الكل' || _eventTimingFilter != 'الكل' || _eventPriceRange.end < 2000)) return true;
    if (_selectedCategoryIndex == 4 && (_guideLanguageFilter != 'الكل' || _guideMinRating > 0.0 || _guideHourlyRange.end < 1000)) return true;
    if (_selectedCategoryIndex == 5 && (_carPassengerFilter != 'الكل' || _carTransmissionFilter != 'الكل' || _carPriceRange.end < 2500)) return true;
    if (_selectedCategoryIndex == 6 && (_productCategoryFilter != 'الكل' || _productOnlyInStock || _productOnlyOnSale || _productPriceRange.end < 1500)) return true;
    return false;
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

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune, color: _categoryColors[_selectedCategoryIndex], size: 22),
                        const SizedBox(width: 8),
                        Text(
                          isAr ? 'تصفية نتائج: ${categories[_selectedCategoryIndex]}' : 'Filter: ${categories[_selectedCategoryIndex]}',
                          style: AppTypography.headingSmall.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _resetAllFilters();
                        });
                      },
                      child: Text(isAr ? 'إعادة ضبط' : 'Reset', style: const TextStyle(color: AppColors.primaryGold)),
                    ),
                  ],
                ),
                const Divider(color: AppColors.border),
                const SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Main Category Tabs inside sheet
                        Text(isAr ? 'التصنيف الرئيسي' : 'Service Category', style: AppTypography.titleSmall),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(categories.length, (idx) {
                            final cat = categories[idx];
                            final isSel = _selectedCategoryIndex == idx;
                            final color = _categoryColors[idx];
                            return ChoiceChip(
                              avatar: Icon(_categoryIcons[idx], size: 16, color: isSel ? AppColors.textDark : color),
                              label: Text(cat),
                              selected: isSel,
                              onSelected: (val) {
                                setModalState(() => _selectedCategoryIndex = idx);
                              },
                              selectedColor: color,
                              backgroundColor: AppColors.card,
                              labelStyle: TextStyle(
                                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                fontSize: 12,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // Render Category Specific Filter Options
                        if (_selectedCategoryIndex == 0) ...[
                          _buildAllFiltersSection(setModalState, isAr, cities),
                        ] else if (_selectedCategoryIndex == 1) ...[
                          _buildTourFiltersSection(setModalState, isAr, cities),
                        ] else if (_selectedCategoryIndex == 2) ...[
                          _buildMuseumFiltersSection(setModalState, isAr, cities),
                        ] else if (_selectedCategoryIndex == 3) ...[
                          _buildEventFiltersSection(setModalState, isAr, cities),
                        ] else if (_selectedCategoryIndex == 4) ...[
                          _buildGuideFiltersSection(setModalState, isAr),
                        ] else if (_selectedCategoryIndex == 5) ...[
                          _buildCarFiltersSection(setModalState, isAr),
                        ] else if (_selectedCategoryIndex == 6) ...[
                          _buildShopFiltersSection(setModalState, isAr),
                        ],

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                CustomButton(
                  text: isAr ? 'تطبيق الفلاتر والبحث' : 'Apply Filters',
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Filter Sections by Category ---

  // 0. All Categories Filter
  Widget _buildAllFiltersSection(StateSetter setModalState, bool isAr, List<String> cities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCityFilter(setModalState, isAr, cities),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'نطاق السعر العام' : 'Price Range',
          values: _globalPriceRange,
          max: 3000,
          divisions: 30,
          onChanged: (val) => setModalState(() => _globalPriceRange = val),
        ),
        const SizedBox(height: 16),
        _buildRatingFilter(
          setModalState,
          isAr: isAr,
          currentRating: _minRating,
          onSelected: (val) => setModalState(() => _minRating = val),
        ),
      ],
    );
  }

  // 1. Tours Filter Section
  Widget _buildTourFiltersSection(StateSetter setModalState, bool isAr, List<String> cities) {
    final durations = isAr ? ['الكل', 'نصف يوم (< 6 ساعات)', 'يوم كامل', 'أكثر من يوم'] : ['All', 'Half Day (< 6h)', 'Full Day', 'Multi-day'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCityFilter(setModalState, isAr, cities),
        const SizedBox(height: 16),
        Text(isAr ? 'مدة المسار السياحي' : 'Tour Duration', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: durations.map((dur) {
            final isSel = _tourDurationFilter == dur;
            return ChoiceChip(
              label: Text(dur),
              selected: isSel,
              onSelected: (_) => setModalState(() => _tourDurationFilter = dur),
              selectedColor: const Color(0xFFFBBF24),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر المسار' : 'Tour Price',
          values: _globalPriceRange,
          max: 3000,
          divisions: 30,
          onChanged: (val) => setModalState(() => _globalPriceRange = val),
        ),
        const SizedBox(height: 16),
        _buildRatingFilter(
          setModalState,
          isAr: isAr,
          currentRating: _minRating,
          onSelected: (val) => setModalState(() => _minRating = val),
        ),
      ],
    );
  }

  // 2. Museums Filter Section
  Widget _buildMuseumFiltersSection(StateSetter setModalState, bool isAr, List<String> cities) {
    final entryTypes = isAr ? ['الكل', 'دخول مجاني فقط', 'تذاكر مدفوعة'] : ['All', 'Free Entry Only', 'Paid Tickets'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCityFilter(setModalState, isAr, cities),
        const SizedBox(height: 16),
        Text(isAr ? 'نوع تذكرة الدخول' : 'Entry Type', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: entryTypes.map((type) {
            final isSel = _museumEntryType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSel,
              onSelected: (_) => setModalState(() => _museumEntryType = type),
              selectedColor: const Color(0xFFC084FC),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر التذكرة' : 'Ticket Price',
          values: _museumPriceRange,
          max: 500,
          divisions: 20,
          onChanged: (val) => setModalState(() => _museumPriceRange = val),
        ),
      ],
    );
  }

  // 3. Events Filter Section
  Widget _buildEventFiltersSection(StateSetter setModalState, bool isAr, List<String> cities) {
    final entryTypes = isAr ? ['الكل', 'فعاليات مجانية فقط', 'فعاليات مدفوعة'] : ['All', 'Free Only', 'Paid'];
    final timings = isAr ? ['الكل', 'فعاليات اليوم', 'خلال هذا الأسبوع'] : ['All', 'Today', 'This Week'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCityFilter(setModalState, isAr, cities),
        const SizedBox(height: 16),
        Text(isAr ? 'موعد الفعالية' : 'Event Schedule', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: timings.map((t) {
            final isSel = _eventTimingFilter == t;
            return ChoiceChip(
              label: Text(t),
              selected: isSel,
              onSelected: (_) => setModalState(() => _eventTimingFilter = t),
              selectedColor: const Color(0xFFF43F5E),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(isAr ? 'نوع الفعالية' : 'Event Entry', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: entryTypes.map((type) {
            final isSel = _eventEntryType == type;
            return ChoiceChip(
              label: Text(type),
              selected: isSel,
              onSelected: (_) => setModalState(() => _eventEntryType = type),
              selectedColor: const Color(0xFFF43F5E),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر التذكرة' : 'Ticket Price',
          values: _eventPriceRange,
          max: 2000,
          divisions: 20,
          onChanged: (val) => setModalState(() => _eventPriceRange = val),
        ),
      ],
    );
  }

  // 4. Tour Guides Filter Section
  Widget _buildGuideFiltersSection(StateSetter setModalState, bool isAr) {
    final languages = isAr
        ? ['الكل', 'العربية', 'الإنجليزية', 'الفرنسية', 'الإسبانية', 'الألمانية', 'الصينية']
        : ['All', 'Arabic', 'English', 'French', 'Spanish', 'German', 'Chinese'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'لغات المرشد السياحي' : 'Guide Languages', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: languages.map((lang) {
            final isSel = _guideLanguageFilter == lang;
            return ChoiceChip(
              label: Text(lang),
              selected: isSel,
              onSelected: (_) => setModalState(() => _guideLanguageFilter = lang),
              selectedColor: const Color(0xFF34D399),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر الساعة للإرشاد' : 'Hourly Rate',
          values: _guideHourlyRange,
          max: 1000,
          divisions: 20,
          onChanged: (val) => setModalState(() => _guideHourlyRange = val),
        ),
        const SizedBox(height: 16),
        _buildRatingFilter(
          setModalState,
          isAr: isAr,
          currentRating: _guideMinRating,
          onSelected: (val) => setModalState(() => _guideMinRating = val),
        ),
      ],
    );
  }

  // 5. Cars Filter Section
  Widget _buildCarFiltersSection(StateSetter setModalState, bool isAr) {
    final passengers = isAr ? ['الكل', 'شخصين (2)', '4 إلى 5 ركاب', '7+ عائلية'] : ['All', '2 Passengers', '4-5 Passengers', '7+ Family'];
    final transmissions = isAr ? ['الكل', 'أوتوماتيك', 'يدوي / عادي'] : ['All', 'Automatic', 'Manual'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'سعة الركاب' : 'Passenger Capacity', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: passengers.map((p) {
            final isSel = _carPassengerFilter == p;
            return ChoiceChip(
              label: Text(p),
              selected: isSel,
              onSelected: (_) => setModalState(() => _carPassengerFilter = p),
              selectedColor: const Color(0xFF60A5FA),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text(isAr ? 'نوع ناقل الحركة (القير)' : 'Transmission', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: transmissions.map((t) {
            final isSel = _carTransmissionFilter == t;
            return ChoiceChip(
              label: Text(t),
              selected: isSel,
              onSelected: (_) => setModalState(() => _carTransmissionFilter = t),
              selectedColor: const Color(0xFF60A5FA),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر الإيجار اليومي' : 'Daily Price',
          values: _carPriceRange,
          max: 2500,
          divisions: 25,
          onChanged: (val) => setModalState(() => _carPriceRange = val),
        ),
      ],
    );
  }

  // 6. Shop Filter Section
  Widget _buildShopFiltersSection(StateSetter setModalState, bool isAr) {
    final categories = isAr
        ? ['الكل', 'عطور وبخور', 'تمور ومأكولات', 'مقتنيات وهدايا', 'أزياء وتراث']
        : ['All', 'Perfumes & Oud', 'Dates & Gourmet', 'Gifts & Souvenirs', 'Apparel & Heritage'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'تصنيف المنتج التراثي' : 'Product Category', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((cat) {
            final isSel = _productCategoryFilter == cat;
            return ChoiceChip(
              label: Text(cat),
              selected: isSel,
              onSelected: (_) => setModalState(() => _productCategoryFilter = cat),
              selectedColor: const Color(0xFFFB923C),
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFFFB923C),
                title: Text(isAr ? 'المتوفر في المخزون فقط' : 'In-Stock Only', style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                value: _productOnlyInStock,
                onChanged: (val) => setModalState(() => _productOnlyInStock = val),
              ),
              const Divider(color: AppColors.border, height: 1),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFFFB923C),
                title: Text(isAr ? 'العروض والتخفيضات فقط' : 'On-Sale Only', style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                value: _productOnlyOnSale,
                onChanged: (val) => setModalState(() => _productOnlyOnSale = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildPriceRangeFilter(
          setModalState,
          title: isAr ? 'سعر المنتج' : 'Product Price',
          values: _productPriceRange,
          max: 1500,
          divisions: 15,
          onChanged: (val) => setModalState(() => _productPriceRange = val),
        ),
      ],
    );
  }

  // --- Helper filter widgets ---

  Widget _buildCityFilter(StateSetter setModalState, bool isAr, List<String> cities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              onSelected: (_) => setModalState(() => _selectedCity = city),
              selectedColor: _categoryColors[_selectedCategoryIndex],
              backgroundColor: AppColors.card,
              labelStyle: TextStyle(
                color: isSel ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeFilter(
    StateSetter setModalState, {
    required String title,
    required RangeValues values,
    required double max,
    required int divisions,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.titleSmall),
            Text(
              '${values.start.round()} — ${values.end.round()} ﷼',
              style: AppTypography.price.copyWith(fontSize: 14, color: _categoryColors[_selectedCategoryIndex]),
            ),
          ],
        ),
        RangeSlider(
          values: values,
          min: 0,
          max: max,
          divisions: divisions,
          activeColor: _categoryColors[_selectedCategoryIndex],
          inactiveColor: AppColors.border,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildRatingFilter(
    StateSetter setModalState, {
    required bool isAr,
    required double currentRating,
    required ValueChanged<double> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isAr ? 'الحد الأدنى للتقييم' : 'Minimum Rating', style: AppTypography.titleSmall),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [0.0, 3.0, 4.0, 4.5, 4.8].map((r) {
            final isSel = currentRating == r;
            final color = _categoryColors[_selectedCategoryIndex];
            return GestureDetector(
              onTap: () => onSelected(r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? color : AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSel ? color : AppColors.border),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final categories = isAr ? _categoriesAr : _categoriesEn;
    final search = _searchController.text.trim();
    final isFilterActive = _isAnyFilterActive();

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'اكتشف المملكة' : 'Discover Saudi', style: AppTypography.headingSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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
                        prefixIcon: Icon(Icons.search, color: _categoryColors[_selectedCategoryIndex]),
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
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isFilterActive ? _categoryColors[_selectedCategoryIndex].withOpacity(0.15) : AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isFilterActive ? _categoryColors[_selectedCategoryIndex] : AppColors.border,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: isFilterActive ? _categoryColors[_selectedCategoryIndex] : AppColors.primaryGold,
                          size: 22,
                        ),
                      ),
                      if (isFilterActive)
                        Positioned(
                          top: -3,
                          right: isAr ? null : -3,
                          left: isAr ? -3 : null,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _categoryColors[_selectedCategoryIndex],
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surface, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Categories Horizontal Chips with Figma Category Colors
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
                final icon = _categoryIcons[index];
                final color = _categoryColors[index];

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: 1.2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.35),
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
                          color: isSelected ? AppColors.textDark : color,
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

          // Active filter banner (if any active)
          if (isFilterActive)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _categoryColors[_selectedCategoryIndex].withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _categoryColors[_selectedCategoryIndex].withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.filter_list, size: 14, color: _categoryColors[_selectedCategoryIndex]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isAr ? 'فلاتر مخصصة مفعلة' : 'Active category filters',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: _categoryColors[_selectedCategoryIndex]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _resetAllFilters()),
                    child: Text(
                      isAr ? 'إلغاء الكل' : 'Clear',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: _categoryColors[_selectedCategoryIndex],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 10),

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

  // --- Combined All List ---
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
            accentColor: _categoryColors[1],
            onTapMore: () => setState(() => _selectedCategoryIndex = 1),
            isAr: isAr,
          ),
          toursAsync.when(
            data: (tours) {
              final list = tours.where((t) {
                final price = t.salePrice ?? t.price;
                if (price < _globalPriceRange.start || price > _globalPriceRange.end) return false;
                if (t.rating < _minRating) return false;
                if (_selectedCity != 'الكل' && _selectedCity != 'All') {
                  if (t.locationName != null && !t.locationName!.contains(_selectedCity)) return false;
                }
                return true;
              }).take(6).toList();

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
            accentColor: _categoryColors[2],
            onTapMore: () => setState(() => _selectedCategoryIndex = 2),
            isAr: isAr,
          ),
          museumsAsync.when(
            data: (museums) {
              final list = museums.where((m) {
                if (m.price < _globalPriceRange.start || m.price > _globalPriceRange.end) return false;
                if (m.rating < _minRating) return false;
                if (_selectedCity != 'الكل' && _selectedCity != 'All') {
                  if (m.locationName != null && !m.locationName!.contains(_selectedCity)) return false;
                }
                return true;
              }).take(6).toList();

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
            accentColor: _categoryColors[3],
            onTapMore: () => setState(() => _selectedCategoryIndex = 3),
            isAr: isAr,
          ),
          eventsAsync.when(
            data: (events) {
              final list = events.where((e) {
                if (e.priceNum < _globalPriceRange.start || e.priceNum > _globalPriceRange.end) return false;
                if (_selectedCity != 'الكل' && _selectedCity != 'All') {
                  if (!e.location.contains(_selectedCity)) return false;
                }
                return true;
              }).take(6).toList();

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
            accentColor: _categoryColors[4],
            onTapMore: () => setState(() => _selectedCategoryIndex = 4),
            isAr: isAr,
          ),
          guidesAsync.when(
            data: (guides) {
              final list = guides.where((g) {
                if (g.rating < _minRating) return false;
                return true;
              }).take(6).toList();

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
            accentColor: _categoryColors[5],
            onTapMore: () => setState(() => _selectedCategoryIndex = 5),
            isAr: isAr,
          ),
          carsAsync.when(
            data: (cars) {
              final list = cars.where((c) {
                if (c.price < _globalPriceRange.start || c.price > _globalPriceRange.end) return false;
                return true;
              }).take(6).toList();

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
    required Color accentColor,
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
                  style: AppTypography.bodySmall.copyWith(color: accentColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 12, color: accentColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Category 1: Tours List ---
  Widget _buildToursList(bool isAr, String search) {
    final toursAsync = ref.watch(toursListProvider(search.isEmpty ? null : search));
    return toursAsync.when(
      data: (tours) {
        final filtered = tours.where((t) {
          final price = t.salePrice ?? t.price;
          if (price < _globalPriceRange.start || price > _globalPriceRange.end) return false;
          if (t.rating < _minRating) return false;
          if (_selectedCity != 'الكل' && _selectedCity != 'All') {
            if (t.locationName != null && !t.locationName!.contains(_selectedCity)) return false;
          }
          if (_tourDurationFilter != 'الكل' && _tourDurationFilter != 'All') {
            final dur = t.duration ?? '';
            if (_tourDurationFilter.contains('نصف') && !dur.contains('نصف') && !dur.contains('ساع')) return false;
            if (_tourDurationFilter.contains('كامل') && !dur.contains('يوم')) return false;
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
                                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFFFBBF24)),
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
                                    const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                                    const SizedBox(width: 4),
                                    Text('${tour.rating}', style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                                    if (tour.duration != null) ...[
                                      const SizedBox(width: 8),
                                      Text('• ${tour.duration}', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                    ],
                                  ],
                                ),
                                Text(tour.formattedPrice, style: AppTypography.price.copyWith(fontSize: 14, color: const Color(0xFFFBBF24))),
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
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFBBF24))),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(toursListProvider(search.isEmpty ? null : search))),
    );
  }

  // --- Category 2: Museums List ---
  Widget _buildMuseumsList(bool isAr, String search) {
    final museumsAsync = ref.watch(museumsListProvider);
    return museumsAsync.when(
      data: (museums) {
        final filtered = museums.where((m) {
          if (search.isNotEmpty && !m.title.toLowerCase().contains(search.toLowerCase())) return false;
          if (m.price < _museumPriceRange.start || m.price > _museumPriceRange.end) return false;
          if (_selectedCity != 'الكل' && _selectedCity != 'All') {
            if (m.locationName != null && !m.locationName!.contains(_selectedCity)) return false;
          }
          if (_museumEntryType.contains('مجاني') && m.price > 0) return false;
          if (_museumEntryType.contains('مدفوع') && m.price == 0) return false;
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
                            Text(museum.locationName ?? (isAr ? 'الرياض' : 'Riyadh'), style: AppTypography.bodySmall),
                            const SizedBox(height: 8),
                            Text(museum.formattedPrice, style: AppTypography.price.copyWith(fontSize: 14, color: const Color(0xFFC084FC))),
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
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFC084FC))),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(museumsListProvider)),
    );
  }

  // --- Category 3: Events List ---
  Widget _buildEventsList(bool isAr, String search) {
    final eventsAsync = ref.watch(eventsListProvider);
    return eventsAsync.when(
      data: (events) {
        final filtered = events.where((e) {
          if (search.isNotEmpty && !e.title.toLowerCase().contains(search.toLowerCase())) return false;
          if (e.priceNum < _eventPriceRange.start || e.priceNum > _eventPriceRange.end) return false;
          if (_selectedCity != 'الكل' && _selectedCity != 'All') {
            if (!e.location.contains(_selectedCity)) return false;
          }
          if (_eventEntryType.contains('مجاني') && e.priceNum > 0) return false;
          if (_eventEntryType.contains('مدفوع') && e.priceNum == 0) return false;
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
                            Text(event.price, style: AppTypography.price.copyWith(fontSize: 14, color: const Color(0xFFF43F5E))),
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
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFF43F5E))),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(eventsListProvider)),
    );
  }

  // --- Category 4: Tour Guides List ---
  Widget _buildGuidesList(bool isAr, String search) {
    final guidesAsync = ref.watch(guidesListProvider);
    return guidesAsync.when(
      data: (guides) {
        final filtered = guides.where((g) {
          if (search.isNotEmpty && !g.name.toLowerCase().contains(search.toLowerCase())) return false;
          if (g.rating < _guideMinRating) return false;
          if (_guideLanguageFilter != 'الكل' && _guideLanguageFilter != 'All') {
            if (!g.languages.any((l) => l.contains(_guideLanguageFilter))) return false;
          }
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
                              const Icon(Icons.star, color: Color(0xFF34D399), size: 16),
                              const SizedBox(width: 4),
                              Text('${guide.rating}', style: AppTypography.titleSmall),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  guide.languages.join(', '),
                                  style: AppTypography.bodySmall.copyWith(color: const Color(0xFF34D399), fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(guide.hourlyRate, style: AppTypography.price.copyWith(fontSize: 13, color: const Color(0xFF34D399))),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF34D399))),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(guidesListProvider)),
    );
  }

  // --- Category 5: Cars List ---
  Widget _buildCarsList(bool isAr, String search) {
    final carsAsync = ref.watch(carsListProvider);
    return carsAsync.when(
      data: (cars) {
        final filtered = cars.where((c) {
          if (search.isNotEmpty && !c.title.toLowerCase().contains(search.toLowerCase())) return false;
          if (c.price < _carPriceRange.start || c.price > _carPriceRange.end) return false;
          if (_carPassengerFilter != 'الكل' && _carPassengerFilter != 'All') {
            if (_carPassengerFilter.contains('2') && c.passengerCount > 2) return false;
            if (_carPassengerFilter.contains('4') && (c.passengerCount < 4 || c.passengerCount > 5)) return false;
            if (_carPassengerFilter.contains('7') && c.passengerCount < 7) return false;
          }
          if (_carTransmissionFilter != 'الكل' && _carTransmissionFilter != 'All') {
            if (_carTransmissionFilter.contains('أوتوماتيك') && !c.transmission.contains('أوتوماتيك') && !c.transmission.contains('Auto')) return false;
            if (_carTransmissionFilter.contains('يدوي') && !c.transmission.contains('يدوي') && !c.transmission.contains('Manual')) return false;
          }
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
                            Text(car.pricePerDay, style: AppTypography.price.copyWith(fontSize: 14, color: const Color(0xFF60A5FA))),
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
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF60A5FA))),
      error: (err, _) => _buildErrorState(isAr, () => ref.refresh(carsListProvider)),
    );
  }

  // --- Category 6: Heritage Shop Products Grid ---
  Widget _buildProductsList(bool isAr, String search) {
    final productsAsync = ref.watch(productsListProvider);
    return productsAsync.when(
      data: (products) {
        final filtered = products.where((p) {
          if (search.isNotEmpty && !p.title.toLowerCase().contains(search.toLowerCase())) return false;
          if (p.priceNumeric < _productPriceRange.start || p.priceNumeric > _productPriceRange.end) return false;
          if (_productOnlyInStock && !p.inStock) return false;
          if (_productOnlyOnSale && (p.discountPercent == null || p.discountPercent!.isEmpty)) return false;
          if (_productCategoryFilter != 'الكل' && _productCategoryFilter != 'All') {
            if (!p.category.contains(_productCategoryFilter) && !p.title.contains(_productCategoryFilter)) return false;
          }
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
                                  color: const Color(0xFFFB923C),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'خصم ${product.discountPercent}',
                                  style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
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
                                  style: AppTypography.bodySmall.copyWith(fontSize: 10, color: const Color(0xFFFB923C)),
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
                                  style: AppTypography.price.copyWith(fontSize: 14, color: const Color(0xFFFB923C)),
                                ),
                                const Icon(Icons.shopping_bag_outlined, size: 16, color: Color(0xFFFB923C)),
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
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFB923C))),
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
                  _resetAllFilters();
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
