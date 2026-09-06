import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/image_viewer_dialog.dart';
import '../../booking/data/booking_draft.dart';
import '../data/car_repository.dart';
import '../../wishlist/data/wishlist_repository.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  final dynamic carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen> {
  int _selectedImageIndex = 0;

  void _openBookingSheet(BuildContext context, CarModel car) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _CarBookingBottomSheet(car: car),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final carAsync = ref.watch(carDetailProvider(widget.carId));

    return Scaffold(
      body: carAsync.when(
        data: (car) {
          final images = car.gallery.isNotEmpty ? car.gallery : [car.imageUrl];
          final currentImage = _selectedImageIndex < images.length ? images[_selectedImageIndex] : car.imageUrl;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 320,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.55),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.55),
                          child: IconButton(
                            icon: Icon(
                              ref.watch(wishlistProvider).isFavorite(widget.carId, 'car')
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ref.watch(wishlistProvider).isFavorite(widget.carId, 'car')
                                  ? AppColors.error
                                  : AppColors.primaryGold,
                            ),
                            onPressed: () async {
                              final added = await ref.read(wishlistProvider.notifier).toggleFavorite(
                                WishlistItemModel(
                                  id: int.tryParse(widget.carId.toString()) ?? 0,
                                  objectId: int.tryParse(widget.carId.toString()) ?? 0,
                                  objectModel: 'car',
                                  title: car.title,
                                  imageUrl: car.imageUrl,
                                  price: car.price,
                                  location: car.locationName,
                                ),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(added
                                        ? (isAr ? 'تمت إضافة السيارة إلى المفضلة ❤️' : 'Added car to favorites ❤️')
                                        : (isAr ? 'تمت إزالة السيارة من المفضلة' : 'Removed from favorites')),
                                    backgroundColor: added ? AppColors.primaryGold : AppColors.card,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.55),
                          child: IconButton(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () => ShareHelper.shareItem(
                              context: context,
                              title: car.title,
                              category: 'تأجير سيارات فارهة',
                              id: widget.carId.toString(),
                              price: '${car.price} ر.س / يوم',
                              location: car.locationName,
                              type: 'car',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.55),
                          child: IconButton(
                            icon: const Icon(Icons.fullscreen, color: Colors.white),
                            onPressed: () => ImageViewerDialog.show(
                              context,
                              images: images,
                              initialIndex: _selectedImageIndex,
                            ),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: GestureDetector(
                        onTap: () => ImageViewerDialog.show(
                          context,
                          images: images,
                          initialIndex: _selectedImageIndex,
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: currentImage,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.surface,
                                child: const Icon(Icons.directions_car, color: AppColors.primaryGold, size: 80),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.photo_library_outlined, size: 14, color: AppColors.primaryGold),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_selectedImageIndex + 1}/${images.length}',
                                      style: AppTypography.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnails row if multiple images
                          if (images.length > 1) ...[
                            SizedBox(
                              height: 60,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, idx) {
                                  final isSel = idx == _selectedImageIndex;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedImageIndex = idx),
                                    child: Container(
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSel ? AppColors.primaryGold : AppColors.border,
                                          width: isSel ? 2 : 1,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: CachedNetworkImage(
                                        imageUrl: images[idx],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Category & Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
                                ),
                                child: Text(
                                  car.category,
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
                                  Text('${car.rating}', style: AppTypography.titleMedium),
                                  const SizedBox(width: 4),
                                  Text('(${car.reviewsCount} تقييم)', style: AppTypography.bodySmall),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Text(car.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 6),

                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primaryGold),
                              const SizedBox(width: 4),
                              Text(car.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Specs Grid
                          Text('المواصفات الأساسية', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: _buildSpecBox(Icons.people_outline, 'السعة', '${car.passengerCount} ركاب')),
                                    Container(width: 1, height: 45, color: AppColors.border),
                                    Expanded(child: _buildSpecBox(Icons.meeting_room_outlined, 'الأبواب', '${car.doors} أبواب')),
                                    Container(width: 1, height: 45, color: AppColors.border),
                                    Expanded(child: _buildSpecBox(Icons.luggage_outlined, 'الحقائب', '${car.baggage} حقائب')),
                                  ],
                                ),
                                const Divider(height: 24, color: AppColors.border),
                                Row(
                                  children: [
                                    Expanded(child: _buildSpecBox(Icons.settings_outlined, 'ناقل الحركة', car.transmission)),
                                    Container(width: 1, height: 45, color: AppColors.border),
                                    Expanded(child: _buildSpecBox(Icons.local_gas_station_outlined, 'الوقود', 'بنزين 95')),
                                    Container(width: 1, height: 45, color: AppColors.border),
                                    Expanded(child: _buildSpecBox(Icons.ac_unit_outlined, 'التكييف', 'مركزي حديث')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Description
                          Text('نبذة عن السيارة', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            car.description,
                            style: AppTypography.bodyMedium.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),

                          // Features & Inclusions
                          Text('المميزات والخدمات المشمولة', style: AppTypography.titleLarge),
                          const SizedBox(height: 12),
                          _buildFeatureRow(Icons.verified_outlined, 'تأمين شامل ضد الحوادث والمسؤولية'),
                          const SizedBox(height: 10),
                          _buildFeatureRow(Icons.gps_fixed, 'نظام ملاحة وخرائط ذكي ومحدث'),
                          const SizedBox(height: 10),
                          _buildFeatureRow(Icons.clean_hands_outlined, 'استلام وتسليم معقم بالكامل مع باقة ضيافة'),
                          const SizedBox(height: 10),
                          _buildFeatureRow(Icons.support_agent_outlined, 'دعم ومساعدة على الطريق على مدار 24 ساعة'),
                          const SizedBox(height: 10),
                          _buildFeatureRow(Icons.person_pin, 'خيار إضافة سائق خاص محترف مرخص'),

                          if (car.features.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: car.features.map((f) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check, size: 14, color: AppColors.primaryGold),
                                      const SizedBox(width: 6),
                                      Text(f.title, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Sticky Bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('سعر الإيجار اليومي', style: AppTypography.bodySmall),
                            Text(car.pricePerDay, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز واستئجار السيارة',
                            onPressed: () => _openBookingSheet(context, car),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(title: const Text('تفاصيل السيارة')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: 12),
                Text('تعذر تحميل تفاصيل السيارة', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(carDetailProvider(widget.carId)),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecBox(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 22),
        const SizedBox(height: 4),
        Text(title, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: AppTypography.titleSmall.copyWith(fontSize: 12), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGold, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}

class _CarBookingBottomSheet extends StatefulWidget {
  final CarModel car;

  const _CarBookingBottomSheet({required this.car});

  @override
  State<_CarBookingBottomSheet> createState() => _CarBookingBottomSheetState();
}

class _CarBookingBottomSheetState extends State<_CarBookingBottomSheet> {
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 4));
  bool _includeDriver = false;
  String _pickupLocation = 'مطار الملك خالد الدولي (الرياض)';

  int get _daysCount {
    final diff = _endDate.difference(_startDate).inDays;
    return diff <= 0 ? 1 : diff;
  }

  double get _baseDailyRate {
    return widget.car.salePrice != null && widget.car.salePrice! > 0 ? widget.car.salePrice! : widget.car.price;
  }

  double get _driverDailyRate => 200.0;

  double get _totalPrice {
    final daily = _baseDailyRate + (_includeDriver ? _driverDailyRate : 0.0);
    return daily * _daysCount;
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isAfter(_startDate) ? _endDate : _startDate.add(const Duration(days: 1)),
      firstDate: _startDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  void _proceedToCheckout() {
    Navigator.pop(context);

    final draft = BookingDraft(
      title: widget.car.title,
      serviceId: int.tryParse(widget.car.id) ?? 1,
      serviceType: 'car',
      imageUrl: widget.car.imageUrl,
      location: widget.car.locationName ?? _pickupLocation,
      date: _startDate,
      unitPrice: _baseDailyRate,
      personItems: [
        BookingPersonItem(name: 'أيام الاستئجار ($_daysCount أيام)', price: _baseDailyRate, quantity: _daysCount),
      ],
      extraItems: [
        if (_includeDriver)
          BookingExtraItem(name: 'سائق خاص محترف ($_daysCount أيام)', price: _driverDailyRate * _daysCount),
      ],
      totalAmount: _totalPrice,
    );

    context.push('/checkout/${widget.car.id}', extra: draft);
  }

  @override
  Widget build(BuildContext context) {
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
            // Handle bar & Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تحديد تفاصيل استئجار السيارة', style: AppTypography.headingSmall),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),

            // Date Range Selection
            Text('مدة الاستئجار', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectStartDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تاريخ الاستلام', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryGold),
                              const SizedBox(width: 6),
                              Text('${_startDate.day}/${_startDate.month}/${_startDate.year}', style: AppTypography.titleSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _selectEndDate,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تاريخ التسليم', style: AppTypography.bodySmall),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 16, color: AppColors.primaryGold),
                              const SizedBox(width: 6),
                              Text('${_endDate.day}/${_endDate.month}/${_endDate.year}', style: AppTypography.titleSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldGlow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('المدة الإجمالية: $_daysCount أيام', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),

            // Pick-up location
            Text('موقع الاستلام والتسليم', style: AppTypography.titleSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _pickupLocation,
                  isExpanded: true,
                  dropdownColor: AppColors.card,
                  items: [
                    'مطار الملك خالد الدولي (الرياض)',
                    'مطار الملك عبدالعزيز الدولي (جدة)',
                    'مطار الأمير محمد بن عبدالعزيز (المدينة)',
                    'مطار العلا الدولي',
                    'التسليم عند مقر إقامة العميل (الفندق)',
                  ].map((loc) => DropdownMenuItem(value: loc, child: Text(loc, style: AppTypography.bodyMedium))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _pickupLocation = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Driver Option Switch
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_pin, color: AppColors.primaryGold, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('طلب سائق خاص محترف', style: AppTypography.titleSmall),
                        Text('خدمة سائق مرافق مع السيارة (+200 ﷼/يوم)', style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                  Switch(
                    value: _includeDriver,
                    activeColor: AppColors.primaryGold,
                    onChanged: (val) => setState(() => _includeDriver = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pricing Breakdown Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('سعر الإيجار الأساسي ($_daysCount أيام):', style: AppTypography.bodySmall),
                      Text('${(_baseDailyRate * _daysCount).toStringAsFixed(0)} ﷼', style: AppTypography.titleSmall),
                    ],
                  ),
                  if (_includeDriver) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('خدمة السائق الخاص ($_daysCount أيام):', style: AppTypography.bodySmall),
                        Text('${(_driverDailyRate * _daysCount).toStringAsFixed(0)} ﷼', style: AppTypography.titleSmall),
                      ],
                    ),
                  ],
                  const Divider(height: 16, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الإجمالي المستحق:', style: AppTypography.titleMedium),
                      Text('${_totalPrice.toStringAsFixed(0)} ﷼', style: AppTypography.price),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Proceed Button
            CustomButton(
              text: 'متابعة إلى إتمام الحجز والدفع',
              onPressed: _proceedToCheckout,
            ),
          ],
        ),
      ),
    );
  }
}
