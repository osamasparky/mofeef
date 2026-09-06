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
import '../cars/data/car_repository.dart';
import '../guides/data/guide_repository.dart';
import '../shop/data/shop_repository.dart';
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
    final carsAsync = ref.watch(carsListProvider);
    final guidesAsync = ref.watch(guidesListProvider);
    final productsAsync = ref.watch(productsListProvider);
    final cartState = ref.watch(cartNotifierProvider);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Integrated Hero Header matching Image 2
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF263A4D), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // AlUla Mountain Background
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1590073844006-33379778ae09?w=1200&q=85',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF0F1B26)),
                    ),
                  ),

                  // Teal / Amber Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF1B4E4A).withOpacity(0.65), // Turquoise top tint
                            const Color(0xFF09141D).withOpacity(0.55),
                            const Color(0xFF070F17).withOpacity(0.92), // Dark bottom
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Hero Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar: User Profile & Notification
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // User Info (Right side in RTL)
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF5A623),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x66F5A623),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          authState.userName != null && authState.userName!.isNotEmpty
                                              ? authState.userName!.characters.first.toUpperCase()
                                              : 'م',
                                          style: const TextStyle(
                                            color: Color(0xFF0C1926),
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5A623),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFF0C1926), width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAr ? 'مرحباً بك' : 'Welcome',
                                      style: const TextStyle(
                                        color: Color(0xFF8FD1C8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      authState.userName ?? (isAr ? 'مسافر مُضيف' : 'Modeefe Traveler'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Notification & Cart Icons
                            Row(
                              children: [
                                if (cartState.items.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => context.push('/cart'),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E353B).withOpacity(0.85),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFF5A623),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                '${cartState.items.length}',
                                                style: const TextStyle(color: Color(0xFF0C1926), fontSize: 9, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () => context.push('/notifications'),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF203B3E).withOpacity(0.85),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // Handpicked Experiences Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF18242D).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, color: Color(0xFFF5A623), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                isAr ? 'تجارب مختارة بعناية' : 'Handpicked Experiences',
                                style: const TextStyle(
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Big Hero Title
                        Text(
                          isAr ? 'من التراث إلى التجربة' : 'From Heritage to Experience',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Tajawal',
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 3)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Search Bar inside Hero
                        GestureDetector(
                          onTap: () => context.go('/discover'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16222D).withOpacity(0.92),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: const Color(0xFF26384A), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Color(0xFFF5A623), size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isAr ? 'ابحث عن وجهة، تجربة، أو فعالية' : 'Search for a destination, trail, or event...',
                                    style: const TextStyle(
                                      color: Color(0xFF8A9BB0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                // 3. Complete Categories Grid/Row (7 Core Services from API)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'الوجهات' : 'Destinations',
                            icon: Icons.map_outlined,
                            accentColor: const Color(0xFF38BDF8),
                            gradientColors: const [Color(0xFF0F2B3C), Color(0xFF081924)],
                            onTap: () => context.push('/locations'),
                          ),
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'المسارات' : 'Trails',
                            icon: Icons.alt_route,
                            accentColor: const Color(0xFFFBBF24),
                            gradientColors: const [Color(0xFF2C210E), Color(0xFF191206)],
                            onTap: () => context.push('/trails'),
                          ),
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'المتاحف' : 'Museums',
                            icon: Icons.account_balance_outlined,
                            accentColor: const Color(0xFFC084FC),
                            gradientColors: const [Color(0xFF261833), Color(0xFF140B1D)],
                            onTap: () => context.push('/museums'),
                          ),
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'الفعاليات' : 'Events',
                            icon: Icons.festival_outlined,
                            accentColor: const Color(0xFFF43F5E),
                            gradientColors: const [Color(0xFF33141E), Color(0xFF1E080F)],
                            onTap: () => context.push('/events'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'المرشدون' : 'Guides',
                            icon: Icons.person_pin_outlined,
                            accentColor: const Color(0xFF34D399),
                            gradientColors: const [Color(0xFF0D2B20), Color(0xFF061A13)],
                            onTap: () => context.push('/guides'),
                          ),
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'السيارات' : 'Cars',
                            icon: Icons.directions_car_outlined,
                            accentColor: const Color(0xFF60A5FA),
                            gradientColors: const [Color(0xFF162536), Color(0xFF0B141E)],
                            onTap: () => context.push('/cars'),
                          ),
                          _buildCategoryCard(
                            context,
                            label: isAr ? 'المتجر' : 'Shop',
                            icon: Icons.storefront_outlined,
                            accentColor: const Color(0xFFFB923C),
                            gradientColors: const [Color(0xFF2F1D12), Color(0xFF1A0E07)],
                            onTap: () => context.push('/store'),
                          ),
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

                // 5. Featured Tourist Trails & Experiences ("المسارات السياحية")
                SectionHeader(
                  title: isAr ? 'المسارات السياحية والتاريخية' : 'Tourist & Heritage Trails',
                  subtitle: isAr ? 'مسارات حية ومغامرات استكشافية متكاملة' : 'Curated itineraries and adventures',
                  actionText: isAr ? 'عرض الكل' : 'View all',
                  onActionTap: () => context.push('/trails'),
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

                // 8. Cars & Transport Section ("السيارات والتنقل السياحي")
                SectionHeader(
                  title: isAr ? 'السيارات والتنقل السياحي' : 'Car Rentals & Transport',
                  subtitle: isAr ? 'أسطول فاخر وخدمات نقل سياحية مريحة' : 'Luxury fleet and tourist transport',
                  actionText: isAr ? 'المزيد' : 'More',
                  onActionTap: () => context.push('/cars'),
                ),

                carsAsync.when(
                  data: (cars) {
                    if (cars.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: cars.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          return GestureDetector(
                            onTap: () => context.push('/car/${car.id}'),
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
                                      imageUrl: car.imageUrl,
                                      height: 105,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
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
                                            Row(
                                              children: [
                                                const Icon(Icons.people_alt_outlined, size: 14, color: AppColors.textSecondary),
                                                const SizedBox(width: 4),
                                                Text('${car.passengerCount}', style: AppTypography.bodySmall),
                                              ],
                                            ),
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

                const SizedBox(height: 24),

                // 9. Certified Tour Guides Section ("المرشدون السياحيون المعتمدون")
                SectionHeader(
                  title: isAr ? 'المرشدون السياحيون المعتمدون' : 'Certified Tour Guides',
                  subtitle: isAr ? 'نخبة من المرشدين المرخصين والمحترفين' : 'Licensed & professional tour guides',
                  actionText: isAr ? 'المزيد' : 'More',
                  onActionTap: () => context.push('/guides'),
                ),

                guidesAsync.when(
                  data: (guides) {
                    if (guides.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 125,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: guides.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final guide = guides[index];
                          return GestureDetector(
                            onTap: () => context.push('/guide/${guide.id}'),
                            child: Container(
                              width: 240,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: CachedNetworkImageProvider(guide.imageUrl),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          guide.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.titleSmall,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          guide.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.star, color: AppColors.primaryGold, size: 13),
                                                const SizedBox(width: 3),
                                                Text('${guide.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            Text(guide.hourlyRate, style: AppTypography.price.copyWith(fontSize: 11)),
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

                // 10. Gift Shop Section ("متجر الهدايا")
                SectionHeader(
                  title: isAr ? 'متجر الهدايا والتذكارات' : 'Gift Shop & Souvenirs',
                  subtitle: isAr ? 'هدايا وتذكارات تراثية سعودية أصيلة' : 'Authentic Saudi gifts and souvenirs',
                  actionText: isAr ? 'المزيد' : 'More',
                  onActionTap: () => context.push('/store'),
                ),

                productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) return const SizedBox.shrink();
                    return SizedBox(
                      height: 200,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () => context.push('/product/${product.id}'),
                            child: Container(
                              width: 160,
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
                                    imageUrl: product.imageUrl,
                                    height: 110,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTypography.titleSmall),
                                        const SizedBox(height: 4),
                                        Text(product.price, style: AppTypography.price.copyWith(fontSize: 13)),
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

                const SizedBox(height: 16),

                // Gift Shop Promo Card
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
                            child: const Icon(Icons.card_giftcard, color: AppColors.primaryGold, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isAr ? 'متجر الهدايا والتذكارات' : 'Modeefe Gift Shop', style: AppTypography.titleMedium),
                                const SizedBox(height: 4),
                                Text(
                                  isAr ? 'تصفح جميع الهدايا، التمور، العطور، والتحف التراثية' : 'Explore all souvenirs, dates, oud, and gifts',
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

  Widget _buildCategoryCard(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required Color accentColor,
    required List<Color> gradientColors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accentColor.withOpacity(0.35), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.titleSmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
