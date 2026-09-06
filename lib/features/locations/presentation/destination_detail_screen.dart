import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../../core/utils/share_helper.dart';
import '../../../core/widgets/unified_item_card.dart';
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

  final List<Color> _tabColors = [
    const Color(0xFFFBBF24), // Tours - Amber
    const Color(0xFFF43F5E), // Events - Ruby Crimson
    const Color(0xFFC084FC), // Museums - Purple
    const Color(0xFF34D399), // Guides - Emerald
  ];

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
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.55),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () => ShareHelper.shareItem(
                      context: context,
                      title: cityName,
                      category: isAr ? 'وجهة سياحية' : 'Destination',
                      id: widget.locationId.toString(),
                      type: 'destination',
                    ),
                  ),
                ),
              ),
            ],
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
                        _buildTab(0, isAr ? 'المسارات والتجارب' : 'Trails & Tours', Icons.alt_route, _tabColors[0]),
                        const SizedBox(width: 8),
                        _buildTab(1, isAr ? 'الفعاليات والمواسم' : 'Events', Icons.festival_outlined, _tabColors[1]),
                        const SizedBox(width: 8),
                        _buildTab(2, isAr ? 'المتاحف' : 'Museums', Icons.account_balance_outlined, _tabColors[2]),
                        const SizedBox(width: 8),
                        _buildTab(3, isAr ? 'المرشدون' : 'Guides', Icons.person_pin_outlined, _tabColors[3]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          _buildActiveTabContent(isAr, cityName),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label, IconData icon, Color color) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : AppColors.border),
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
            Icon(icon, size: 16, color: isSelected ? AppColors.textDark : color),
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

  Widget _buildActiveTabContent(bool isAr, String cityName) {
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
                    return UnifiedItemCard(
                      title: t.title,
                      imageUrl: t.imageUrl,
                      locationName: t.locationName ?? cityName,
                      rating: t.rating,
                      subtitle: t.duration,
                      price: t.formattedPrice,
                      accentColor: _tabColors[0],
                      onTap: () => context.push('/experience/${t.id}'),
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
                    return UnifiedItemCard(
                      title: ev.title,
                      imageUrl: ev.imageUrl,
                      locationName: ev.location.isNotEmpty ? ev.location : cityName,
                      rating: 4.8,
                      subtitle: ev.duration,
                      price: ev.price,
                      accentColor: _tabColors[1],
                      onTap: () => context.push('/event/${ev.id}'),
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
                    return UnifiedItemCard(
                      title: m.title,
                      imageUrl: m.imageUrl,
                      locationName: m.locationName ?? cityName,
                      rating: m.rating,
                      subtitle: m.workingHours,
                      price: m.formattedPrice,
                      accentColor: _tabColors[2],
                      onTap: () => context.push('/museum/${m.id}'),
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
                    return UnifiedItemCard(
                      title: g.name,
                      imageUrl: g.imageUrl,
                      locationName: g.title,
                      rating: g.rating,
                      subtitle: g.languages.join(' • '),
                      price: g.hourlyRate,
                      accentColor: _tabColors[3],
                      onTap: () => context.push('/guide/${g.id}'),
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
