# Development Progress Tracker 📊

- [x] **Phase 1: Foundation & Project Shell**
  - [x] Flutter project structure (Clean Architecture / Feature-First)
  - [x] Design tokens extracted from Figma (AppColors, AppTypography, AppTheme)
  - [x] Full Dio network client with Interceptors
  - [x] GoRouter setup with Shell Navigation
  - [x] Arabic RTL & English LTR localization
  - [x] Core Design System reusable widgets (CustomButton, CustomTextField, ExperienceCard, EmptyStateView)

- [x] **Phase 2: Authentication**
  - [x] Auth Models & State (AuthUser, TokenStorage)
  - [x] Auth Repository & DataSource (`/auth/login`, `/auth/register`, `/auth/me`, `/auth/logout`)
  - [x] Login & Register screens with real validation and state

- [x] **Phase 3: Home & Discovery**
  - [x] Discovery & Home Models (HomeLayout, ServiceCategory, DestinationLocation)
  - [x] Home & Discovery Repositories (`/home-page`, `/services`, `/locations`, `/news`)
  - [x] Home & Discovery UI with banners, category chips, and search

- [x] **Phase 4: Tours & Experiences**
  - [x] Tour Models (TourItem, TourDetail, TourAvailability, TourReview)
  - [x] Tour Repository (`/tour/search`, `/tour/detail/{id}`, `/tour/availability/{id}`)
  - [x] Tour List, Search, Filters, and Detail screens

- [x] **Phase 5: Guides**
  - [x] Guide Models (GuideItem, GuideDetail, GuideFilters)
  - [x] Guide Repository (`/guide/search`, `/guide/detail/{id}`)
  - [x] Guide List & Detail screens

- [x] **Phase 6: Cars**
  - [x] Car Models (CarItem, CarDetail, CarAvailability)
  - [x] Car Repository (`/car/search`, `/car/detail/{id}`)
  - [x] Car List & Detail screens

- [x] **Phase 7: Events**
  - [x] Event Models (EventItem, EventDetail, EventTicketType)
  - [x] Event Repository (`/event/search`, `/event/detail/{id}`)
  - [x] Event List & Detail screens

- [x] **Phase 8: Museums**
  - [x] Museum Models (MuseumItem, MuseumDetail, VisitingHours)
  - [x] Museum Repository (`/museum/search`, `/museum/detail/{id}`)
  - [x] Museum List & Detail screens

- [x] **Phase 9: Shop & Bazaar**
  - [x] Product Models (ProductItem, ProductDetail, ProductReview)
  - [x] Shop Repository (`/product/search`, `/product/detail/{id}`)
  - [x] Bazaar Store & Product Details screens

- [x] **Phase 10: Wishlist / Favorites**
  - [x] Wishlist Repository (`/user/wishlist`)
  - [x] Favorites Screen with real add/remove wishlist state

- [x] **Phase 11: Bookings & Tickets**
  - [x] Booking Models (BookingHistoryItem, TicketItem)
  - [x] Booking Repository (`/user/booking-history`, `/user/ticket`, `/user/ticket/qr-image/{id}`)
  - [x] My Reservations Screen with Upcoming/Completed tabs & QR modal

- [x] **Phase 12: Cart & Checkout**
  - [x] Cart Models (CartResponse, CartItem, Coupon)
  - [x] Cart Repository (`/cart`, `/cart/coupon/apply`, `/cart/update`, `/cart/remove`, `/cart/checkout`)
  - [x] Cart Screen with dynamic calculation, coupon application, and orders receipt
