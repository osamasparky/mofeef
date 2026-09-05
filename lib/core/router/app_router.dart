import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/discovery/discovery_screen.dart';
import '../../features/booking/my_reservations_screen.dart';
import '../../features/booking/checkout_screen.dart';
import '../../features/profile/favorites_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/notifications_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/shop/store_screen.dart';
import '../../features/shop/product_details_screen.dart';
import '../../features/shop/cart_screen.dart';
import '../../features/experiences/experience_details_screen.dart';
import '../constants/app_colors.dart';

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
          final id = state.pathParameters['id'] ?? 'exp_1';
          return ExperienceDetailsScreen(experienceId: id);
        },
      ),
      GoRoute(
        path: '/checkout/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'exp_1';
          return CheckoutScreen(experienceId: id);
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
          final id = state.pathParameters['id'] ?? 'prod_1';
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
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

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
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.primaryGold),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: AppColors.primaryGold),
              label: 'اكتشف',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(Icons.confirmation_number, color: AppColors.primaryGold),
              label: 'حجوزاتي',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite, color: AppColors.primaryGold),
              label: 'المفضلة',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.primaryGold),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
