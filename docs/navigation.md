# Navigation & Routing Architecture (GoRouter) 🧭

## 1. Route Hierarchy

```text
/splash                           -> SplashScreen
/login                            -> LoginScreen
/register                         -> RegisterScreen

Main Shell (Bottom Navigation Bar):
├── /home                         -> HomeScreen
├── /discover                     -> DiscoveryScreen
├── /reservations                 -> MyReservationsScreen (Upcoming, Completed, Cancelled tabs)
├── /favorites                    -> FavoritesScreen (Wishlist)
└── /profile                      -> ProfileScreen (Account & Stats)

Feature Sub-Routes:
├── /tours                        -> TourListScreen
├── /tour/:id                     -> TourDetailScreen
├── /guides                       -> GuideListScreen
├── /guide/:id                    -> GuideDetailScreen
├── /cars                         -> CarListScreen
├── /car/:id                      -> CarDetailScreen
├── /events                       -> EventListScreen
├── /event/:id                    -> EventDetailScreen
├── /museums                      -> MuseumListScreen
├── /museum/:id                   -> MuseumDetailScreen
├── /experience/:id               -> ExperienceDetailsScreen (Dynamic Tour/Museum Handler)
├── /checkout/:serviceType/:id    -> CheckoutScreen (Date & Guests/Tickets selector)
├── /payment                      -> PaymentScreen (Gateways & Online Payment WebView)
├── /store                        -> StoreScreen (Bazaar)
├── /product/:id                  -> ProductDetailsScreen
├── /cart                         -> CartScreen
├── /wallet                       -> WalletScreen
└── /notifications                -> NotificationsScreen
```

## 2. Authentication Guards
Protected routes automatically redirect to `/login` if no valid bearer token is present in `FlutterSecureStorage`.
