import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/localization/locale_provider.dart';
import '../../discovery/data/models/discovery_models.dart';
import '../../discovery/data/repositories/discovery_repository.dart';

class LocationsListScreen extends ConsumerStatefulWidget {
  const LocationsListScreen({super.key});

  @override
  ConsumerState<LocationsListScreen> createState() => _LocationsListScreenState();
}

class _LocationsListScreenState extends ConsumerState<LocationsListScreen> {
  final _searchController = TextEditingController();

  final List<LocationModel> _featuredLocations = const [
    LocationModel(
      id: 1,
      name: 'مكة المكرمة',
      slug: 'تراث وإسلامي',
      imageUrl: 'https://staging.modeefe.com/uploads/0000/6/2026/06/03/1395849838834267800-jpg-webp.jpg',
      bannerUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
    ),
    LocationModel(
      id: 2,
      name: 'المدينة المنورة',
      slug: 'تراث وإسلامي',
      imageUrl: 'https://staging.modeefe.com/uploads/0000/6/2026/06/03/almzarat-aldyny.jpg',
      bannerUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
    ),
    LocationModel(
      id: 3,
      name: 'العُلا',
      slug: 'تراث عالمي',
      imageUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
    ),
    LocationModel(
      id: 4,
      name: 'الدرعية',
      slug: 'تاريخ وأصالة',
      imageUrl: 'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=800&q=80',
    ),
    LocationModel(
      id: 5,
      name: 'جدة التاريخية (البلد)',
      slug: 'ثقافة وحضارة',
      imageUrl: 'https://images.unsplash.com/photo-1578895101407-28d8442e61df?w=800&q=80',
    ),
    LocationModel(
      id: 6,
      name: 'الرياض',
      slug: 'عاصمة الثقافة',
      imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&q=80',
    ),
    LocationModel(
      id: 7,
      name: 'عسير ورجال ألمع',
      slug: 'طبيعة وتراث',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
    ),
    LocationModel(
      id: 8,
      name: 'البحر الأحمر',
      slug: 'طبيعة وسياحة ساحلية',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationsProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'الوجهات السياحية السعودية' : 'Saudi Destinations', style: AppTypography.headingSmall),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Box
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
                  hintText: isAr ? 'ابحث عن مدينة أو وجهة (مكة، المدينة، العلا)...' : 'Search destination (Makkah, Madinah, AlUla)...',
                  hintStyle: AppTypography.bodySmall,
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryGold),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
          ),

          // Destinations Grid
          Expanded(
            child: locationsAsync.when(
              data: (apiLocations) {
                final allLocations = apiLocations.isNotEmpty ? apiLocations : _featuredLocations;
                final query = _searchController.text.toLowerCase();
                final filtered = allLocations.where((loc) {
                  return query.isEmpty ||
                      loc.name.toLowerCase().contains(query) ||
                      (loc.slug?.toLowerCase().contains(query) == true);
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(isAr ? 'لا توجد وجهات مطابقة للبحث' : 'No destinations found', style: AppTypography.bodyMedium),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.82,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final loc = filtered[index];
                    final img = loc.imageUrl ?? loc.bannerUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80';

                    return GestureDetector(
                      onTap: () => context.push('/location/${loc.id}?name=${Uri.encodeComponent(loc.name)}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF162534),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.35), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF38BDF8).withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: img,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.surface,
                                child: const Icon(Icons.image_not_supported, color: AppColors.textMuted),
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.15),
                                    Colors.black.withOpacity(0.4),
                                    const Color(0xFF0F2B3C).withOpacity(0.95),
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                            if (loc.slug != null && loc.slug!.isNotEmpty)
                              Positioned(
                                top: 10,
                                right: isAr ? 10 : null,
                                left: isAr ? null : 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.65),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.7)),
                                  ),
                                  child: Text(
                                    loc.slug!,
                                    style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    loc.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(Icons.explore, color: Color(0xFF38BDF8), size: 13),
                                      const SizedBox(width: 4),
                                      Text(
                                        isAr ? 'استكشف الوجهة' : 'Explore city',
                                        style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
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
                    Text(isAr ? 'تعذر تحميل الوجهات' : 'Failed to load destinations', style: AppTypography.bodyMedium),
                    TextButton(
                      onPressed: () => ref.refresh(locationsProvider),
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
