import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/booking/my_reservations_screen.dart';
import '../../features/booking/checkout_screen.dart';
import '../../features/booking/data/booking_draft.dart';
import '../../features/profile/favorites_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/profile/privacy_policy_screen.dart';
import '../../features/profile/terms_conditions_screen.dart';
import '../../features/profile/notifications_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/shop/store_screen.dart';
import '../../features/shop/product_details_screen.dart';
import '../../features/shop/cart_screen.dart';
import '../../features/experiences/experience_details_screen.dart';
import '../../features/locations/presentation/locations_list_screen.dart';
import '../../features/locations/presentation/destination_detail_screen.dart';
import '../../features/tours/presentation/tourist_trails_screen.dart';
import '../../features/museums/presentation/museum_list_screen.dart';
import '../../features/museums/presentation/museum_detail_screen.dart';
import '../../features/guides/presentation/guide_list_screen.dart';
import '../../features/guides/presentation/guide_detail_screen.dart';
import '../../features/cars/presentation/car_list_screen.dart';
import '../../features/cars/presentation/car_detail_screen.dart';
import '../../features/events/presentation/event_list_screen.dart';
import '../../features/events/presentation/event_detail_screen.dart';
import '../constants/app_colors.dart';
import '../localization/locale_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/discover',
            pageBuilder: (context, state) => const NoTransitionPage(child: DiscoveryScreen()),
          ),
          GoRoute(
            path: '/reservations',
            pageBuilder: (context, state) => const NoTransitionPage(child: MyReservationsScreen()),
          ),
          GoRoute(
            path: '/favorites',
            pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/experience/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '17';
          return ExperienceDetailsScreen(experienceId: id);
        },
      ),
      GoRoute(
        path: '/checkout/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '17';
          final draft = state.extra is BookingDraft ? state.extra as BookingDraft : null;
          return CheckoutScreen(experienceId: id, draft: draft);
        },
      ),
      GoRoute(
        path: '/store',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const StoreScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '11';
          return ProductDetailsScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/wallet',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/terms-conditions',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: '/trails',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TouristTrailsScreen(),
      ),
      GoRoute(
        path: '/locations',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LocationsListScreen(),
      ),
      GoRoute(
        path: '/location/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
          final name = state.uri.queryParameters['name'];
          return DestinationDetailScreen(locationId: id, initialName: name);
        },
      ),
      GoRoute(
        path: '/museums',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const MuseumListScreen(),
      ),
      GoRoute(
        path: '/museum/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '1';
          return MuseumDetailScreen(museumId: id);
        },
      ),
      GoRoute(
        path: '/guides',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GuideListScreen(),
      ),
      GoRoute(
        path: '/guide/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '61';
          return GuideDetailScreen(guideId: id);
        },
      ),
      GoRoute(
        path: '/cars',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CarListScreen(),
      ),
      GoRoute(
        path: '/car/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '3';
          return CarDetailScreen(carId: id);
        },
      ),
      GoRoute(
        path: '/events',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EventListScreen(),
      ),
      GoRoute(
        path: '/event/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '12';
          return EventDetailScreen(eventId: id);
        },
      ),
    ],
  );
});


class ScaffoldWithNavBar extends ConsumerWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/discover')) return 1;
    if (location.startsWith('/reservations')) return 2;
    if (location.startsWith('/favorites')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/discover');
        break;
      case 2:
        context.go('/reservations');
        break;
      case 3:
        context.go('/favorites');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _calculateSelectedIndex(context);
    final currentLocale = ref.watch(localeProvider);
    final isAr = currentLocale.languageCode == 'ar';

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onItemTapped(index, context),
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.goldGlow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home, color: AppColors.primaryGold),
              label: isAr ? 'الرئيسية' : 'Home',
            ),
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: const Icon(Icons.explore, color: AppColors.primaryGold),
              label: isAr ? 'اكتشف' : 'Discover',
            ),
            NavigationDestination(
              icon: const Icon(Icons.confirmation_number_outlined),
              selectedIcon: const Icon(Icons.confirmation_number, color: AppColors.primaryGold),
              label: isAr ? 'حجوزاتي' : 'Bookings',
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_border),
              selectedIcon: const Icon(Icons.favorite, color: AppColors.primaryGold),
              label: isAr ? 'المفضلة' : 'Wishlist',
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person, color: AppColors.primaryGold),
              label: isAr ? 'حسابي' : 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
