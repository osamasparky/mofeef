import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/widgets/experience_card.dart';
import '../../core/widgets/section_header.dart';
import '../tours/data/repositories/tour_repository.dart';
import '../discovery/data/repositories/discovery_repository.dart';
import '../discovery/data/models/discovery_models.dart';
import '../events/data/event_repository.dart';
import '../museums/data/museum_repository.dart';
import '../cart/data/cart_repository.dart';
import '../auth/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final toursAsync = ref.watch(toursListProvider(null));
    final locationsAsync = ref.watch(locationsProvider);
    final eventsAsync = ref.watch(eventsListProvider);
    final museumsAsync = ref.watch(museumsListProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Luxury Header matching Figma
          SliverAppBar(
            pinned: true,
            expandedHeight: 80,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldGlow,
                          border: Border.all(color: AppColors.primaryGold, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            authState.userName != null && authState.userName!.isNotEmpty
                                ? authState.userName!.characters.first.toUpperCase()
                                : 'م',
                            style: const TextStyle(
                              color: AppColors.primaryGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(isAr ? 'مرحباً بك' : 'Welcome', style: AppTypography.bodySmall),
                          Text(
                            authState.userName ?? (isAr ? 'مسافر مُضيف' : 'Modeefe Traveler'),
                            style: AppTypography.titleSmall.copyWith(color: AppColors.primaryGold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Cart Button with badge
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 22),
                            onPressed: () => context.push('/cart'),
                          ),
                          if (cartState.items.isNotEmpty)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryGold,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${cartState.items.length}',
                                  style: const TextStyle(color: AppColors.textDark, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Notifications Button
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                        onPressed: () => context.push('/notifications'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Body Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Banner matching Figma ("من التراث إلى التجربة")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E2D38), Color(0xFF07121A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.primaryGold.withOpacity(0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Opacity(
                            opacity: 0.35,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppColors.goldGlow,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primaryGold.withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.auto_awesome, color: AppColors.primaryGold, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      isAr ? 'تجارب مختارة بعناية' : 'Handpicked Experiences',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.primaryGold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isAr ? 'من التراث إلى التجربة' : 'From Heritage to Experience',
                                style: AppTypography.headingMedium.copyWith(fontSize: 22),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isAr ? 'اكتشف روائع المملكة الأصيلة ومساراتها التاريخية' : 'Discover the authentic wonders of the Kingdom',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar matching Figma
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: GestureDetector(
                    onTap: () => context.go('/discover'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: AppColors.primaryGold),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              isAr ? 'ابحث عن وجهة، مسار سياحي، أو فعالية...' : 'Search for a destination, trail, or event...',
                              style: AppTypography.bodyMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.goldGlow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.tune, color: AppColors.primaryGold, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Complete Categories Grid/Row matching Figma (Includes "المسارات السياحية")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryCard(context, isAr ? 'الوجهات' : 'Destinations', Icons.map_outlined, () => context.push('/locations')),
                          _buildCategoryCard(context, isAr ? 'المسارات' : 'Trails', Icons.alt_route, () => context.push('/trails')),
                          _buildCategoryCard(context, isAr ? 'التجارب' : 'Experiences', Icons.explore_outlined, () => context.go('/discover')),
                          _buildCategoryCard(context, isAr ? 'المتاحف' : 'Museums', Icons.account_balance_outlined, () => context.push('/museums')),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryCard(context, isAr ? 'الفعاليات' : 'Events', Icons.festival_outlined, () => context.push('/events')),
                          _buildCategoryCard(context, isAr ? 'المرشدون' : 'Guides', Icons.person_pin_outlined, () => context.push('/guides')),
                          _buildCategoryCard(context, isAr ? 'السيارات' : 'Cars', Icons.directions_car_outlined, () => context.push('/cars')),
                          _buildCategoryCard(context, isAr ? 'المتجر' : 'Shop', Icons.storefront_outlined, () => context.push('/store')),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Inspiring Destinations Section matching Figma ("الوجهات الملهمة")
                SectionHeader(
                  title: isAr ? 'الوجهات الملهمة' : 'Inspiring Destinations',
                  subtitle: isAr ? 'أعرق الوجهات في المملكة العربية السعودية' : 'Top heritage destinations across KSA',
                  actionText: isAr ? 'الكل' : 'See all',
                  onActionTap: () => context.push('/locations'),
                ),

                locationsAsync.when(
                  data: (locations) {
                    final displayLocations = locations.isNotEmpty
                        ? locations
                        : const [
                            LocationModel(id: 1, name: 'العُلا', imageUrl: 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80', slug: 'تراث'),
                            LocationModel(id: 2, name: 'الدرعية', imageUrl: 'https://images.unsplash.com/photo-1586724237569-f3d0c1dee8c6?w=800&q=80', slug: 'تراث'),
                            LocationModel(id: 3, name: 'جدة التاريخية', imageUrl: 'https://images.unsplash.com/photo-1578895101407-28d8442e61df?w=800&q=80', slug: 'ثقافة'),
                            LocationModel(id: 4, name: 'الرياض', imageUrl: 'https://images.unsplash.com/photo-1548013146-72479768bada?w=800&q=80', slug: 'حضرية'),
                            LocationModel(id: 5, name: 'البحر الأحمر', imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80', slug: 'طبيعة'),
                          ];

                    return SizedBox(
                      height: 160,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: displayLocations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final loc = displayLocations[index];
                          final name = loc.name.isNotEmpty ? loc.name : 'وجهة سياحية';
                          final region = isAr ? 'المملكة العربية السعودية' : 'Saudi Arabia';
                          final tag = loc.slug ?? (isAr ? 'تراث' : 'Heritage');
                          final img = loc.imageUrl ?? loc.bannerUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80';

                          return GestureDetector(
                            onTap: () => context.push('/location/${loc.id}?name=${Uri.encodeComponent(name)}'),
                            child: Container(
                              width: 140,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: CachedNetworkImage(
                                      imageUrl: img,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.85),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: Text(tag, style: const TextStyle(color: AppColors.primaryGold, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(name, style: AppTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                        Text(region, style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 10)),
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
                  loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // 5. Featured Tourist Trails & Experiences ("المسارات والتجارب السياحية")
                SectionHeader(
                  title: isAr ? 'المسارات والتجارب السياحية' : 'Tourist Trails & Experiences',
                  subtitle: isAr ? 'مسارات حية ومغامرات استكشافية متكاملة' : 'Curated itineraries and adventures',
                  actionText: isAr ? 'عرض الكل' : 'View all',
                  onActionTap: () => context.go('/discover'),
                ),

                toursAsync.when(
                  data: (tours) {
                    if (tours.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Center(child: Text(isAr ? 'لا توجد مسارات متاحة حالياً' : 'No trails available', style: AppTypography.bodyMedium)),
                      );
                    }
                    return SizedBox(
                      height: 290,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: tours.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final tour = tours[index];
                          return ExperienceCard(
                            title: tour.title,
                            category: tour.categoryName ?? (isAr ? 'مسار سياحي' : 'Tourist Trail'),
                            location: tour.locationName ?? (isAr ? 'المملكة' : 'KSA'),
                            price: tour.formattedPrice,
                            duration: tour.duration ?? (isAr ? 'ساعتان' : '2 hours'),
                            rating: tour.rating,
                            imageUrl: tour.imageUrl ?? 'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=800&q=80',
                            onTap: () => context.push('/experience/${tour.id}'),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const SizedBox(height: 220, child: Center(child: CircularProgressIndicator(color: AppColors.primaryGold))),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // 6. Live Events Section ("الفعاليات والمواسم")
                SectionHeader(
                  title: isAr ? 'الفعاليات والمواسم' : 'Events & Festivals',
                  subtitle: isAr ? 'عروض حية ومهرجانات ثقافية كبرى' : 'Live cultural shows & festivals',
                  actionText: isAr ? 'المزيد' : 'More',
                  onActionTap: () => context.push('/events'),
                ),

                eventsAsync.when(
                  data: (events) {
                    if (events.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return GestureDetector(
                            onTap: () => context.push('/event/${event.id}'),
                            child: Container(
                              width: 220,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                                    child: CachedNetworkImage(
                                      imageUrl: event.imageUrl,
                                      height: 110,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(event.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(event.location, style: AppTypography.bodySmall),
                                            Text(event.price, style: AppTypography.price.copyWith(fontSize: 13)),
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

                // 7. Museums Section ("المتاحف والمعالم")
                SectionHeader(
                  title: isAr ? 'المتاحف والمعالم' : 'Museums & Heritage',
                  subtitle: isAr ? 'شواهد تاريخية وصروح ثقافية' : 'Historical landmarks and museums',
                  actionText: isAr ? 'المزيد' : 'More',
                  onActionTap: () => context.push('/museums'),
                ),

                museumsAsync.when(
                  data: (museums) {
                    if (museums.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 190,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: museums.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final museum = museums[index];
                          return GestureDetector(
                            onTap: () => context.push('/museum/${museum.id}'),
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    child: CachedNetworkImage(
                                      imageUrl: museum.imageUrl ?? 'https://images.unsplash.com/photo-1566127444979-b3d2b654e3d7?w=800&q=80',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(museum.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                        const SizedBox(height: 4),
                                        Text(museum.formattedPrice, style: AppTypography.price.copyWith(fontSize: 13)),
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

                // 8. Heritage Bazaar Promo Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => context.push('/store'),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.goldGlow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.storefront, color: AppColors.primaryGold, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isAr ? 'بازار مُضيف للمقتنيات التراثية' : 'Modeefe Heritage Bazaar', style: AppTypography.titleMedium),
                                const SizedBox(height: 4),
                                Text(
                                  isAr ? 'تحف فاخرة، عطور وبخور، ومصنوعات يدوية' : 'Authentic gifts, oud, perfumes, and handicrafts',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: AppColors.primaryGold, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primaryGold, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.titleSmall.copyWith(fontSize: 12), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
