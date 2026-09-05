# API Mapping Matrix 🗺️

| API Endpoint | Method | Feature | Repository | Riverpod Provider | Primary Screen / UI Action |
|---|---|---|---|---|---|
| `/auth/login` | POST | Auth | `AuthRepository` | `authNotifierProvider` | `LoginScreen` -> Submit Form |
| `/auth/register` | POST | Auth | `AuthRepository` | `authNotifierProvider` | `RegisterScreen` -> Submit Form |
| `/auth/me` | GET / POST | Auth | `AuthRepository` | `currentUserProvider` | `ProfileScreen` -> Load Profile & Edit |
| `/auth/logout` | POST | Auth | `AuthRepository` | `authNotifierProvider` | `ProfileScreen` -> Logout |
| `/auth/refresh` | POST | Auth | `AuthRepository` | Token Interceptor | Automatic on 401 |
| `/home-page` | GET | Home | `HomeRepository` | `homeLayoutProvider` | `HomeScreen` -> Layout & Banners |
| `/services` | GET | Discovery | `DiscoveryRepository` | `servicesProvider` | `HomeScreen` & `DiscoveryScreen` -> Service Icons |
| `/locations` | GET | Discovery | `DiscoveryRepository` | `locationsProvider` | `DiscoveryScreen` -> City Filters |
| `/tour/search` | GET | Tours | `TourRepository` | `tourSearchProvider` | `TourListScreen` -> Search & Paginated List |
| `/tour/detail/{id}` | GET | Tours | `TourRepository` | `tourDetailProvider` | `TourDetailScreen` -> Tour Details |
| `/tour/availability/{id}` | GET | Tours | `TourRepository` | `tourAvailabilityProvider`| `TourDetailScreen` -> Date Selection |
| `/guide/search` | GET | Guides | `GuideRepository` | `guideSearchProvider` | `GuideListScreen` -> Search Guides |
| `/guide/detail/{id}` | GET | Guides | `GuideRepository` | `guideDetailProvider` | `GuideDetailScreen` -> Guide Details |
| `/car/search` | GET | Cars | `CarRepository` | `carSearchProvider` | `CarListScreen` -> Search Cars |
| `/car/detail/{id}` | GET | Cars | `CarRepository` | `carDetailProvider` | `CarDetailScreen` -> Car Details |
| `/event/search` | GET | Events | `EventRepository` | `eventSearchProvider` | `EventListScreen` -> Search Events |
| `/event/detail/{id}` | GET | Events | `EventRepository` | `eventDetailProvider` | `EventDetailScreen` -> Event Details |
| `/museum/search` | GET | Museums | `MuseumRepository` | `museumSearchProvider` | `MuseumListScreen` -> Search Museums |
| `/museum/detail/{id}` | GET | Museums | `MuseumRepository` | `museumDetailProvider` | `MuseumDetailScreen` -> Museum Details |
| `/product/search` | GET | Shop | `ShopRepository` | `productSearchProvider`| `StoreScreen` -> Bazaar Grid |
| `/product/detail/{id}` | GET | Shop | `ShopRepository` | `productDetailProvider`| `ProductDetailsScreen` -> Item Details |
| `/user/wishlist` | GET / POST / DEL | Wishlist | `WishlistRepository`| `wishlistProvider` | `FavoritesScreen` & Favorite Buttons |
| `/booking/addToCart` | POST | Booking | `BookingRepository` | `bookingProvider` | `CheckoutScreen` -> Add Booking Item |
| `/booking/doCheckout` | POST | Booking | `BookingRepository` | `checkoutProvider` | `CheckoutScreen` -> Confirm Payment |
| `/user/booking-history`| GET | Booking | `BookingRepository` | `bookingHistoryProvider`| `MyReservationsScreen` -> History Tabs |
| `/user/ticket` | GET | Tickets | `TicketRepository` | `myTicketsProvider` | `MyReservationsScreen` -> QR Tickets |
| `/cart` | GET | Cart | `CartRepository` | `cartProvider` | `CartScreen` -> Active Cart |
| `/cart/coupon/apply` | POST | Cart | `CartRepository` | `cartProvider` | `CartScreen` -> Apply Coupon |
| `/cart/checkout` | POST | Cart | `CartRepository` | `cartProvider` | `CartScreen` -> Shop Checkout |
| `/my-orders` | GET | Cart | `CartRepository` | `myOrdersProvider` | `ProfileScreen` -> Orders History |
