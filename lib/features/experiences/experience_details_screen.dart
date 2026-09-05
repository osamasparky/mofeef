import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/html_utils.dart';
import '../../core/widgets/custom_button.dart';
import '../tours/data/models/tour_model.dart';
import '../tours/data/repositories/tour_repository.dart';

final tourDetailProvider = FutureProvider.family<TourModel, String>((ref, id) async {
  return ref.watch(tourRepositoryProvider).getTourDetail(id);
});

class ExperienceDetailsScreen extends ConsumerStatefulWidget {
  final String experienceId;

  const ExperienceDetailsScreen({super.key, required this.experienceId});

  @override
  ConsumerState<ExperienceDetailsScreen> createState() => _ExperienceDetailsScreenState();
}

class _ExperienceDetailsScreenState extends ConsumerState<ExperienceDetailsScreen> {
  int _currentGalleryIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tourAsync = ref.watch(tourDetailProvider(widget.experienceId));

    return Scaffold(
      body: tourAsync.when(
        data: (tour) {
          final gallery = tour.gallery.isNotEmpty
              ? tour.gallery
              : [tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80'];

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Multi-Image Gallery SliverAppBar
                  SliverAppBar(
                    expandedHeight: 340,
                    pinned: true,
                    backgroundColor: AppColors.background,
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
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
                          backgroundColor: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت الإضافة إلى المفضلة!'), backgroundColor: AppColors.success),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            icon: const Icon(Icons.share_outlined, color: Colors.white),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم نسخ رابط التجربة للمشاركة'), backgroundColor: AppColors.primaryGold),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: gallery.length,
                            onPageChanged: (index) => setState(() => _currentGalleryIndex = index),
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: gallery[index],
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Image.network(
                                  'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                          // Dark gradient overlay
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Image counter badge
                          if (gallery.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.photo_library_outlined, color: AppColors.primaryGold, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${_currentGalleryIndex + 1} / ${gallery.length}',
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Content Body
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category and Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  tour.categoryName ?? 'مسار سياحي',
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
                                    '${tour.rating} (${tour.reviewsCount} تقييم)',
                                    style: AppTypography.titleSmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Main Title
                          Text(tour.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 8),

                          // Location Address
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  tour.address ?? tour.locationName ?? 'المملكة العربية السعودية',
                                  style: AppTypography.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Quick Info Highlights Bar
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
                                _buildInfoItem(Icons.timelapse, 'مدة المسار', tour.duration ?? 'ساعتان'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.people_outline, 'المجموعة', '١ — ١٠ أفراد'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.confirmation_number_outlined, 'التذكرة', tour.formattedPrice),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Gallery Thumbnails Preview
                          if (gallery.length > 1) ...[
                            Text('معرض الصور والمشاهد', style: AppTypography.titleLarge),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 70,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: gallery.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  final isSelected = index == _currentGalleryIndex;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() => _currentGalleryIndex = index);
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Container(
                                      width: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected ? AppColors.primaryGold : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: gallery[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Overview / About
                          Text('عن المسار السياحي', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            HtmlUtils.stripHtml(tour.content).isNotEmpty
                                ? HtmlUtils.stripHtml(tour.content)
                                : 'استمتع بتجربة سياحية وثقافية متكاملة تأخذك في جولة حية بين أحضان المعالم التاريخية والتراثية الأصيلة في المملكة العربية السعودية.',
                            style: AppTypography.bodyLarge.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),

                          // Itinerary & Stages (محطات المسار)
                          if (tour.itinerary.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('محطات وجدول المسار', style: AppTypography.titleLarge),
                                Text('${tour.itinerary.length} محطات', style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tour.itinerary.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final stage = tour.itinerary[index];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.goldGlow,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(color: AppColors.primaryGold, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(stage.title, style: AppTypography.titleMedium),
                                            if (stage.desc != null && stage.desc!.isNotEmpty) ...[
                                              const SizedBox(height: 2),
                                              Text(stage.desc!, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                                            ],
                                            if (stage.content != null && stage.content!.isNotEmpty) ...[
                                              const SizedBox(height: 6),
                                              Text(HtmlUtils.stripHtml(stage.content!), style: AppTypography.bodyMedium),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Included & Excluded Services
                          if (tour.includes.isNotEmpty || tour.excludes.isNotEmpty) ...[
                            Text('ما تشمله التجربة', style: AppTypography.titleLarge),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tour.includes.isNotEmpty) ...[
                                    Text('مشمول في الباقة', style: AppTypography.titleSmall.copyWith(color: AppColors.success)),
                                    const SizedBox(height: 8),
                                    ...tour.includes.map(
                                      (inc) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                                            const SizedBox(width: 10),
                                            Expanded(child: Text(inc, style: AppTypography.bodyMedium)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (tour.includes.isNotEmpty && tour.excludes.isNotEmpty)
                                    const Divider(color: AppColors.border, height: 20),
                                  if (tour.excludes.isNotEmpty) ...[
                                    Text('غير مشمول في الباقة', style: AppTypography.titleSmall.copyWith(color: AppColors.error)),
                                    const SizedBox(height: 8),
                                    ...tour.excludes.map(
                                      (exc) => Padding(
                                        padding: const EdgeInsets.only(bottom: 6),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.cancel, color: AppColors.error, size: 16),
                                            const SizedBox(width: 10),
                                            Expanded(child: Text(exc, style: AppTypography.bodyMedium)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // FAQs
                          if (tour.faqs.isNotEmpty) ...[
                            Text('الأسئلة الشائعة', style: AppTypography.titleLarge),
                            const SizedBox(height: 12),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tour.faqs.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final faq = tour.faqs[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: ExpansionTile(
                                    iconColor: AppColors.primaryGold,
                                    collapsedIconColor: AppColors.textSecondary,
                                    title: Text(faq.title, style: AppTypography.titleSmall),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                                        child: Text(HtmlUtils.stripHtml(faq.content), style: AppTypography.bodyMedium.copyWith(height: 1.5)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Map Section
                          Text('الموقع الجغرافي والوصول', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.map_outlined, color: AppColors.primaryGold, size: 36),
                                  const SizedBox(height: 8),
                                  Text(
                                    tour.address ?? tour.locationName ?? 'عرض الموقع على الخريطة',
                                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('انقر لفتح الاتجاهات عبر خرائط Google', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
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

              // Bottom Sticky Booking Bar
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
                            Text('السعر الإجمالي يبدأ من', style: AppTypography.bodySmall),
                            Text(tour.formattedPrice, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز التذكرة والموعد',
                            onPressed: () => _showBookingModal(context, tour),
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
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 54, color: AppColors.error),
                const SizedBox(height: 16),
                Text('تعذر تحميل تفاصيل التجربة', style: AppTypography.titleLarge),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(tourDetailProvider(widget.experienceId)),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingModal(BuildContext context, TourModel tour) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => _BookingBottomSheet(tour: tour),
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

class _BookingBottomSheet extends StatefulWidget {
  final TourModel tour;

  const _BookingBottomSheet({required this.tour});

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  int _guests = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.tour.salePrice ?? widget.tour.price;
    final total = unitPrice * _guests;

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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.tour.title, style: AppTypography.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('${widget.tour.formattedPrice} / للشخص', style: AppTypography.price.copyWith(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 28),

          // Date Selector
          Text('تاريخ الزيارة', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primaryGold,
                        surface: AppColors.card,
                        onSurface: AppColors.textPrimary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primaryGold, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                        style: AppTypography.titleSmall,
                      ),
                    ],
                  ),
                  const Text('تغيير التاريخ', style: TextStyle(color: AppColors.primaryGold, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Guest Counter
          Text('عدد الزوار / التذاكر', style: AppTypography.titleSmall),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_guests تذكرة', style: AppTypography.titleSmall),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryGold),
                      onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                    ),
                    Text('$_guests', style: AppTypography.titleMedium),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryGold),
                      onPressed: () => setState(() => _guests++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Total & Checkout Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المجموع الإجمالي', style: AppTypography.bodySmall),
                  Text('${total.toStringAsFixed(0)} ر.س', style: AppTypography.price),
                ],
              ),
              CustomButton(
                text: 'متابعة للدفع والتأكيد',
                width: 200,
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/checkout/${widget.tour.id}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
