# Current State Audit (Modeefe Flutter App) 🔍

## 1. UI & Figma Alignment
- **Figma Screens Implemented**:
  - `Login` (`1714:4624`), `Home` (`1714:4701`), `Discover` (`1714:4922`), `My R.` (`1714:5087`), `Fav.` (`1714:5217`), `Account` (`1714:5311`), `AV.` (`1714:5449`), `Det.` (`1714:5586`), `Profile` (`1735:830`), `Checkout` (`1735:1193`), `Payment` (`1735:1600`), `Wallet` (`1735:1959`), `Notification` (`1735:2245`), `View-Store` (`1812:2917`), `View-item` (`1812:574`), `View-cart` (`1812:1390`), `Cart-Empty` (`1812:2175`).
- **Inferred Screens Implemented**:
  - Guides List, Cars List, Events List, Register Screen.
- **UI Gaps Identified**:
  - Some screens were directly consuming static `mockExperiences` / `mockProducts` / `mockGuides` / `mockCars` instead of Async Riverpod Providers.
  - Loading skeletons (Shimmer) and Error retry states need to be integrated into all list and detail screens.

## 2. API Integration Audit
- **Defined Endpoints**: 68 endpoints in `lib/core/network/api_endpoints.dart`.
- **Existing Repositories**:
  - `AuthRepository`: `/auth/login`, `/auth/register`, `/auth/me`, `/auth/logout`.
  - `DiscoveryRepository`: `/services`, `/locations`, `/news`, `/home-page`.
  - `TourRepository`: `/tour/search`, `/tour/detail/{id}`, `/tour/availability/{id}`.
  - `MuseumRepository`: `/museum/search`, `/museum/detail/{id}`.
  - `WishlistRepository`: `/user/wishlist`.
  - `BookingRepository`: `/booking/addToCart`, `/booking/doCheckout`, `/user/booking-history`, `/user/ticket`.
  - `ShopRepository`: `/product/search`, `/product/detail/{id}`.
  - `CartRepository`: `/cart`, `/cart/coupon/apply`, `/cart/update`, `/cart/remove`, `/cart/checkout`.
- **Identified Mock Data to Remove**:
  - `mockExperiences` in `experience_model.dart` -> replace with `toursListProvider` & `museumsListProvider`.
  - `mockProducts` in `product_model.dart` -> replace with `productsListProvider` & `productDetailProvider`.
  - `mockGuides` in `guide_list_screen.dart` -> replace with `guidesListProvider` from `GuideRepository`.
  - `mockCars` in `car_list_screen.dart` -> replace with `carsListProvider` from `CarRepository`.
  - `mockEvents` in `event_list_screen.dart` -> replace with `eventsListProvider` from `EventRepository`.
  - Hardcoded list in `FavoritesScreen` -> replace with `wishlistItemsProvider`.
  - Hardcoded list in `MyReservationsScreen` -> replace with `bookingHistoryProvider` and `myTicketsProvider`.
  - Hardcoded list in `CartScreen` -> replace with `cartNotifierProvider`.

## 3. Architecture & Environment
- State management: Pure Flutter Riverpod.
- Environment: Needs an `AppConfig` / `EnvironmentConfig` class allowing runtime or build-time base URL configuration (dev/staging/production).
- Token storage: `FlutterSecureStorage` with proper interceptor.

## 4. Quality & Code Analysis
- Clean architecture layers in place.
- All mock lists will be purged from production flows and replaced with proper AsyncValue handling.
