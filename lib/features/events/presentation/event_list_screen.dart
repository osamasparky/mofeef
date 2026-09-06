import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/widgets/custom_button.dart';
import '../data/event_repository.dart';

class EventListScreen extends ConsumerStatefulWidget {
  const EventListScreen({super.key});

  @override
  ConsumerState<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends ConsumerState<EventListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsListProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الفعاليات والمواسم السعودية' : 'Saudi Events & Seasons', style: AppTypography.headingSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  hintText: isAr ? 'ابحث عن فعالية (اليوم الوطني، شتاء مكة)...' : 'Search events (National Day, Winter)...',
                  hintStyle: AppTypography.bodySmall,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),

          // Events List
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                final query = _searchController.text.toLowerCase();
                final filtered = events.where((ev) {
                  return query.isEmpty ||
                      ev.title.toLowerCase().contains(query) ||
                      ev.location.toLowerCase().contains(query) ||
                      ev.description.toLowerCase().contains(query);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(isAr ? 'لا توجد فعاليات متاحة حالياً' : 'No events found', style: AppTypography.bodyMedium),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final ev = filtered[index];
                    return GestureDetector(
                      onTap: () => context.push('/event/${ev.id}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: ev.imageUrl,
                                  height: 170,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Container(
                                    height: 170,
                                    color: AppColors.surface,
                                    child: const Icon(Icons.festival_outlined, size: 48, color: AppColors.textMuted),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  right: isAr ? 12 : null,
                                  left: isAr ? null : 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      isAr ? 'فعالية رسمية' : 'Official Event',
                                      style: const TextStyle(color: AppColors.primaryGold, fontSize: 11, fontWeight: FontWeight.bold),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ev.date, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                                      Text(ev.duration, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(ev.title, style: AppTypography.titleLarge),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(ev.location, style: AppTypography.bodySmall),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(isAr ? 'يبدأ من' : 'Starts from', style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                                          Text(ev.price, style: AppTypography.price),
                                        ],
                                      ),
                                      CustomButton(
                                        text: isAr ? 'حجز التذاكر' : 'Book Tickets',
                                        width: 140,
                                        height: 42,
                                        onPressed: () => context.push('/event/${ev.id}'),
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
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryGold)),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isAr ? 'تعذر تحميل بيانات الفعاليات' : 'Failed to load events', style: AppTypography.bodyMedium),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.refresh(eventsListProvider),
                      child: Text(isAr ? 'إعادة المحاولة' : 'Retry', style: const TextStyle(color: AppColors.primaryGold)),
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
