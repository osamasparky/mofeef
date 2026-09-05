# Screen Mapping Matrix (Figma & API Alignment) 📱

| Figma Screen Name | Node ID | Flutter Screen File | API Endpoint / Source | Status |
|---|---|---|---|---|
| **Login** | `1714:4624` | `features/auth/presentation/login_screen.dart` | `/auth/login` | `IMPLEMENTED` |
| **Home** | `1714:4701` | `features/home/presentation/home_screen.dart` | `/home-page`, `/services` | `IMPLEMENTED` |
| **Discover** | `1714:4922` | `features/discovery/presentation/discovery_screen.dart` | `/locations`, `/services` | `IMPLEMENTED` |
| **My R. (Reservations)**| `1714:5087` | `features/booking/presentation/my_reservations_screen.dart` | `/user/booking-history`, `/user/ticket` | `IMPLEMENTED` |
| **Fav. (Favorites)** | `1714:5217` | `features/wishlist/presentation/favorites_screen.dart` | `/user/wishlist` | `IMPLEMENTED` |
| **Account** | `1714:5311` | `features/profile/presentation/profile_screen.dart` | `/auth/me`, `/user` | `IMPLEMENTED` |
| **AV. (Experiences)** | `1714:5449` | `features/tours/presentation/tour_list_screen.dart` | `/tour/search`, `/museum/search` | `IMPLEMENTED` |
| **Det. (Details)** | `1714:5586` | `features/experiences/presentation/experience_details_screen.dart`| `/tour/detail/{id}`, `/museum/detail/{id}` | `IMPLEMENTED` |
| **Profile** | `1735:830` | `features/profile/presentation/profile_screen.dart` | `/auth/me` | `IMPLEMENTED` |
| **Checkout** | `1735:1193`| `features/booking/presentation/checkout_screen.dart` | `/booking/addToCart`, `/gateways` | `IMPLEMENTED` |
| **Payment** | `1735:1600`| `features/booking/presentation/payment_screen.dart` | `/booking/doCheckout` | `IMPLEMENTED` |
| **Wallet** | `1735:1959`| `features/wallet/presentation/wallet_screen.dart` | Inferred / Balance API | `IMPLEMENTED` |
| **Notification** | `1735:2245`| `features/profile/presentation/notifications_screen.dart` | `/news` / Notifications | `IMPLEMENTED` |
| **View-Store** | `1812:2917`| `features/shop/presentation/store_screen.dart` | `/product/search`, `/product/filters` | `IMPLEMENTED` |
| **View-item** | `1812:574` | `features/shop/presentation/product_details_screen.dart` | `/product/detail/{id}` | `IMPLEMENTED` |
| **View-cart** | `1812:1390`| `features/cart/presentation/cart_screen.dart` | `/cart`, `/cart/coupon/apply` | `IMPLEMENTED` |
| **Cart-Empty** | `1812:2175`| `features/cart/presentation/empty_cart_view.dart` | `/cart` (When count == 0) | `IMPLEMENTED` |
| **Guides List (New)** | Inferred | `features/guides/presentation/guide_list_screen.dart` | `/guide/search`, `/guide/filters` | `DESIGN_INFERRED` |
| **Guide Detail (New)**| Inferred | `features/guides/presentation/guide_detail_screen.dart` | `/guide/detail/{id}` | `DESIGN_INFERRED` |
| **Cars List (New)** | Inferred | `features/cars/presentation/car_list_screen.dart` | `/car/search`, `/car/filters` | `DESIGN_INFERRED` |
| **Car Detail (New)** | Inferred | `features/cars/presentation/car_detail_screen.dart` | `/car/detail/{id}` | `DESIGN_INFERRED` |
| **Events List (New)** | Inferred | `features/events/presentation/event_list_screen.dart` | `/event/search`, `/event/filters` | `DESIGN_INFERRED` |
| **Event Detail (New)**| Inferred | `features/events/presentation/event_detail_screen.dart` | `/event/detail/{id}` | `DESIGN_INFERRED` |
