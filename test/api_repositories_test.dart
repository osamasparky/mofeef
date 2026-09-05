import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modeef/features/discovery/data/repositories/discovery_repository.dart';
import 'package:modeef/features/tours/data/repositories/tour_repository.dart';
import 'package:modeef/features/guides/data/guide_repository.dart';
import 'package:modeef/features/cars/data/car_repository.dart';
import 'package:modeef/features/events/data/event_repository.dart';
import 'package:modeef/features/museums/data/museum_repository.dart';
import 'package:modeef/features/shop/data/shop_repository.dart';
import 'package:modeef/features/wishlist/data/wishlist_repository.dart';
import 'package:modeef/features/booking/data/booking_repository.dart';
import 'package:modeef/features/cart/data/cart_repository.dart';
import 'package:modeef/features/auth/data/repositories/auth_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FlutterSecureStorage.setMockInitialValues({});
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('All API Endpoints & Repositories Test Suite', () {
    test('1. DiscoveryRepository fetches services, locations, news', () async {
      final repo = container.read(discoveryRepositoryProvider);
      
      final services = await repo.getServices();
      expect(services.isNotEmpty, true);
      expect(services.first.name, isNotEmpty);

      final locations = await repo.getLocations();
      expect(locations.isNotEmpty, true);
      expect(locations.first.name, isNotEmpty);

      final news = await repo.getNews();
      expect(news.isNotEmpty, true);
      expect(news.first.title, isNotEmpty);
    });

    test('2. TourRepository searches tours and fetches details', () async {
      final repo = container.read(tourRepositoryProvider);

      final tours = await repo.searchTours();
      expect(tours.isNotEmpty, true);
      expect(tours.first.id, greaterThan(0));
      expect(tours.first.title, isNotEmpty);

      final detail = await repo.getTourDetail(16);
      expect(detail.id, 16);
      expect(detail.title, isNotEmpty);
      expect(detail.rating, greaterThan(0));
    });

    test('3. GuideRepository searches guides and fetches details', () async {
      final repo = container.read(guideRepositoryProvider);

      final guides = await repo.searchGuides();
      expect(guides.isNotEmpty, true);
      expect(guides.first.name, isNotEmpty);

      final detail = await repo.getGuideDetail('72');
      expect(detail.id, '72');
      expect(detail.name, isNotEmpty);
    });

    test('4. CarRepository searches cars and fetches details', () async {
      final repo = container.read(carRepositoryProvider);

      final cars = await repo.searchCars();
      expect(cars.isNotEmpty, true);
      expect(cars.first.title, isNotEmpty);

      final detail = await repo.getCarDetail('10');
      expect(detail.title, isNotEmpty);
    });

    test('5. EventRepository searches events and fetches details', () async {
      final repo = container.read(eventRepositoryProvider);

      final events = await repo.searchEvents();
      expect(events.isNotEmpty, true);
      expect(events.first.title, isNotEmpty);

      final detail = await repo.getEventDetail('12');
      expect(detail.title, isNotEmpty);
    });

    test('6. MuseumRepository searches museums and fetches details', () async {
      final repo = container.read(museumRepositoryProvider);

      final museums = await repo.searchMuseums();
      expect(museums.isNotEmpty, true);
      expect(museums.first.title, isNotEmpty);

      final detail = await repo.getMuseumDetail('31');
      expect(detail.title, isNotEmpty);
    });

    test('7. ShopRepository searches products and fetches details', () async {
      final repo = container.read(shopRepositoryProvider);

      final products = await repo.searchProducts();
      expect(products.isNotEmpty, true);
      expect(products.first.title, isNotEmpty);

      final detail = await repo.getProductDetail(22);
      expect(detail.id, '22');
      expect(detail.title, isNotEmpty);
    });

    test('8. WishlistRepository fetches wishlist items', () async {
      final repo = container.read(wishlistRepositoryProvider);

      final wishlist = await repo.getWishlist();
      expect(wishlist.isNotEmpty, true);
      expect(wishlist.first.title, isNotEmpty);
    });

    test('9. BookingRepository fetches booking history and adds to cart', () async {
      final repo = container.read(bookingRepositoryProvider);

      final history = await repo.getBookingHistory();
      expect(history.isNotEmpty, true);
      expect(history.first.serviceTitle, isNotEmpty);

      final result = await repo.addToCart(
        serviceId: 16,
        serviceType: 'tour',
        startDate: '2026-10-01',
        guests: 2,
      );
      expect(result['status'], 1);
    });

    test('10. CartNotifier fetches cart and manages items', () async {
      final cartNotifier = container.read(cartNotifierProvider.notifier);
      await cartNotifier.fetchCart();

      final cartState = container.read(cartNotifierProvider);
      expect(cartState.subtotal, greaterThanOrEqualTo(0));
    });

    test('11. AuthRepository performs login, registration and fetches profile', () async {
      final repo = container.read(authRepositoryProvider);

      final user = await repo.login('osama@example.com', 'password123');
      expect(user.email, 'osama@example.com');
      expect(user.displayName, isNotEmpty);

      final registeredUser = await repo.register({
        'first_name': 'أسامة',
        'last_name': 'صبري',
        'email': 'osama@example.com',
        'password': 'password123',
        'phone': '+966555123456',
        'term': 1,
      });
      expect(registeredUser.email, 'osama@example.com');
    });
  });
}

