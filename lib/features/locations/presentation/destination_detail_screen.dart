import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../tours/data/models/tour_model.dart';
import '../../tours/data/repositories/tour_repository.dart';
import '../../events/data/event_repository.dart';
import '../../museums/data/museum_repository.dart';
import '../../guides/data/guide_repository.dart';
import '../../guides/presentation/guide_list_screen.dart';

final destinationToursProvider = FutureProvider.family<List<TourModel>, int>((ref, locationId) async {
  return ref.watch(tourRepositoryProvider).searchTours(locationId: locationId);
});

final destinationEventsProvider = FutureProvider.family<List<EventItemModel>, int>((ref, locationId) async {
  return ref.watch(eventRepositoryProvider).searchEvents(locationId: locationId);
});

final destinationMuseumsProvider = FutureProvider.family<List<MuseumModel>, int>((ref, locationId) async {
  return ref.watch(museumRepositoryProvider).searchMuseums(locationId: locationId);
});

final destinationGuidesProvider = FutureProvider.family<List<GuideModel>, int>((ref, locationId) async {
  return ref.watch(guideRepositoryProvider).searchGuides(locationId: locationId);
});

class DestinationDetailScreen extends ConsumerStatefulWidget {
  final int locationId;
  final String? initialName;

  const DestinationDetailScreen({
    super.key,
    required this.locationId,
    this.initialName,
  });

  @override
  ConsumerState<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends ConsumerState<DestinationDetailScreen> {
  int _selectedTab = 0; // 0: Tours, 1: Events, 2: Museums, 3: Guides

  String _getCityBanner(int id) {
    switch (id) {
      case 1:
        return 'https://staging.modeefe.com/uploads/0000/6/2026/06/03/1395849838834267800-jpg-webp.jpg';
      case 2:
        return 'https://staging.modeefe.com/uploads/0000/6/2026/06/03/almzarat-aldyny.jpg';
      case 3:
        return 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80';
      case 4:
        return 'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&q=80';
    }
  }

  String _getCityName(int id, bool isAr) {
    if (widget.initialName != null && widget.initialName!.isNotEmpty) {
      return widget.initialName!;
    }
    switch (id) {
      case 1:
        return isAr ? 'مكة المكرمة' : 'Makkah';
      case 2:
        return isAr ? 'المدينة المنورة' : 'Madinah';
      case 3:
        return isAr ? 'العُلا' : 'AlUla';
      case 4:
        return isAr ? 'الدرعية' : 'Diriyah';
      default:
        return isAr ? 'الوجهة السياحية' : 'Destination';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';
    final cityName = _getCityName(widget.locationId, isAr);
    final bannerImg = _getCityBanner(widget.locationId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Banner
          SliverAppBar(
            expandedHeight: 260,
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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(cityName, style: AppTypography.headingSmall.copyWith(color: Colors.white)),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: bannerImg,
                    fit: BoxFit.cover,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                          AppColors.background.withOpacity(0.95),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabs & Filter Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr
                        ? 'استكشف كافة التجارب والفعاليات والمتاحف والمرشدين في $cityName'
                        : 'Explore all trails, events, museums and guides in $cityName',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),

                  // Segmented Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTab(0, isAr ? 'المسارات والتجارب' : 'Trails & Tours', Icons.alt_route),
                        const SizedBox(width: 8),
                        _buildTab(1, isAr ? 'الفعاليات والمواسم' : 'Events', Icons.festival_outlined),
                        const SizedBox(width: 8),
                        _buildTab(2, isAr ? 'المتاحف' : 'Museums', Icons.account_balance_outlined),
                        const SizedBox(width: 8),
                        _buildTab(3, isAr ? 'المرشدون' : 'Guides', Icons.person_pin_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          _buildActiveTabContent(isAr),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGold : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primaryGold : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColors.textDark : AppColors.primaryGold),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.textDark : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(bool isAr) {
    switch (_selectedTab) {
      case 0:
        // Tours & Trails in City
        final toursAsync = ref.watch(destinationToursProvider(widget.locationId));
        return toursAsync.when(
          data: (tours) {
            if (tours.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(isAr ? 'لا توجد مسارات متاحة حالياً في هذه الوجهة' : 'No trails available in this destination', style: AppTypography.bodyMedium)),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) {
                    final t = tours[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => context.push('/experience/${t.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: t.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                    const SizedBox(height: 4),
                                    Text(t.formattedPrice, style: AppTypography.price.copyWith(fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: AppColors.primaryGold, size: 14),
                                        const SizedBox(width: 4),
                                        Text('${t.rating}', style: AppTypography.bodySmall),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryGold),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: tours.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
          error: (_, __) => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(isAr ? 'تعذر تحميل المسارات' : 'Failed to load trails'))),
        );

      case 1:
        // Events in City
        final eventsAsync = ref.watch(destinationEventsProvider(widget.locationId));
        return eventsAsync.when(
          data: (events) {
            if (events.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(isAr ? 'لا توجد فعاليات في هذه الوجهة' : 'No events in this destination', style: AppTypography.bodyMedium)),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) {
                    final ev = events[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => context.push('/event/${ev.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: ev.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ev.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                    const SizedBox(height: 4),
                                    Text(ev.date, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold)),
                                    const SizedBox(height: 4),
                                    Text(ev.price, style: AppTypography.price.copyWith(fontSize: 13)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryGold),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: events.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
          error: (_, __) => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(isAr ? 'تعذر تحميل الفعاليات' : 'Failed to load events'))),
        );

      case 2:
        // Museums in City
        final museumsAsync = ref.watch(destinationMuseumsProvider(widget.locationId));
        return museumsAsync.when(
          data: (museums) {
            if (museums.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(isAr ? 'لا توجد متاحف في هذه الوجهة' : 'No museums in this destination', style: AppTypography.bodyMedium)),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) {
                    final m = museums[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => context.push('/museum/${m.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: m.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                    const SizedBox(height: 4),
                                    Text(m.formattedPrice, style: AppTypography.price.copyWith(fontSize: 13)),
                                    const SizedBox(height: 4),
                                    Text(m.workingHours ?? (isAr ? '٩ص — ٩م' : '9 AM — 9 PM'), style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryGold),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: museums.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
          error: (_, __) => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(isAr ? 'تعذر تحميل المتاحف' : 'Failed to load museums'))),
        );

      case 3:
      default:
        // Guides in City
        final guidesAsync = ref.watch(destinationGuidesProvider(widget.locationId));
        return guidesAsync.when(
          data: (guides) {
            if (guides.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(isAr ? 'لا يوجد مرشدون سياحيون متاحون في هذه الوجهة' : 'No guides in this destination', style: AppTypography.bodyMedium)),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) {
                    final g = guides[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: GestureDetector(
                        onTap: () => context.push('/guide/${g.id}'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundImage: CachedNetworkImageProvider(g.imageUrl),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(g.name, style: AppTypography.titleSmall),
                                    const SizedBox(height: 2),
                                    Text(g.title, style: AppTypography.bodySmall.copyWith(color: AppColors.primaryGold, fontSize: 11)),
                                    const SizedBox(height: 4),
                                    Text(g.hourlyRate, style: AppTypography.price.copyWith(fontSize: 13)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primaryGold),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: guides.length,
                ),
              ),
            );
          },
          loading: () => const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
          error: (_, __) => SliverFillRemaining(hasScrollBody: false, child: Center(child: Text(isAr ? 'تعذر تحميل المرشدين' : 'Failed to load guides'))),
        );
    }
  }
}
