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

class ExperienceDetailsScreen extends ConsumerWidget {
  final String experienceId;

  const ExperienceDetailsScreen({super.key, required this.experienceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourAsync = ref.watch(tourDetailProvider(experienceId));

    return Scaffold(
      body: tourAsync.when(
        data: (tour) {
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
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تمت الإضافة إلى المفضلة!'), backgroundColor: AppColors.success),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  tour.categoryName ?? 'تجربة سياحية',
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

                          Text(tour.title, style: AppTypography.headingMedium),
                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppColors.primaryGold, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(tour.locationName ?? 'المملكة العربية السعودية', style: AppTypography.bodyMedium),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

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
                                _buildInfoItem(Icons.access_time, 'ساعات العمل', '٩ص — ٩م'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.timelapse, 'المدة', tour.duration ?? 'ساعتان'),
                                Container(width: 1, height: 40, color: AppColors.border),
                                _buildInfoItem(Icons.confirmation_number_outlined, 'التذكرة', tour.formattedPrice),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Text('نبذة عن التجربة', style: AppTypography.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            HtmlUtils.stripHtml(tour.content).isNotEmpty
                                ? HtmlUtils.stripHtml(tour.content)
                                : 'استمتع بتجربة سياحية وثقافية فريدة من نوعها في المملكة العربية السعودية.',
                            style: AppTypography.bodyLarge.copyWith(height: 1.6),
                          ),
                          const SizedBox(height: 24),

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
                            Text('السعر يبدأ من', style: AppTypography.bodySmall),
                            Text(tour.formattedPrice, style: AppTypography.price),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            text: 'حجز التذكرة',
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
                  onPressed: () => ref.refresh(tourDetailProvider(experienceId)),
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
