# Modeefe Application Architecture 🏛️

## 1. Architectural Style: Clean Architecture (Feature-First)

The project is structured according to Feature-First Clean Architecture principles, ensuring modularity, testability, high maintainability, and clear separation of concerns.

```text
Presentation Layer (UI & Widgets)
          ↓
Riverpod State Layer (StateNotifiers / AsyncNotifiers)
          ↓
Domain Layer (Use Cases, Entities & Domain Contracts)
          ↓
Data Layer (Repositories, Data Sources, Typed DTOs/Models)
          ↓
Network & Infrastructure (Dio, Interceptors, Secure Storage, API Endpoints)
```

---

## 2. Directory Structure

```text
lib/
├── core/
│   ├── constants/             # Design Tokens: AppColors, AppTypography, Dimensions, Assets
│   ├── errors/                # Failure, ServerException, NetworkException, ErrorMapper
│   ├── network/               # Dio Client, Interceptors (Auth, Logging), ApiEndpoints
│   ├── router/                # GoRouter, RouteGuards, AppRoutes
│   ├── storage/               # SecureStorageService, SharedPrefsService
│   ├── theme/                 # AppTheme (Dark Luxury Heritage Mode), SystemOverlay
│   ├── utils/                 # CurrencyFormatter (SAR), DateFormatter (Hijri/Gregorian), Validators
│   └── widgets/               # Core Design System Widgets (CustomButton, CustomTextField, etc.)
│
├── features/
│   ├── auth/                  # Register, Login, Refresh, Me, Forgot Password, Verification
│   ├── home/                  # Home Layout, Discovery Banners, Featured Services
│   ├── discovery/             # Locations, Services, Search, Filters
│   ├── tours/                 # Tour Search, Tour Filters, Tour Details, Availability, Reviews
│   ├── guides/                # Guide Search, Guide Details, Filters
│   ├── cars/                  # Car Search, Car Details, Availability, Booking
│   ├── events/                # Event Search, Event Details, Availability, Ticket Types
│   ├── museums/               # Museum Search, Museum Details, Visiting Hours, Tickets
│   ├── shop/                  # Products (Bazaar), Categories, Product Detail, Reviews
│   ├── wishlist/              # Wishlist List, Add, Remove, Clear
│   ├── booking/               # Booking Engine, AddToCart, DoCheckout, CheckStatus, Gateways
│   ├── tickets/               # My Tickets, QR Generator, Ticket Scanner
│   ├── cart/                  # Cart Items, Coupon Apply, Quantity Update, Order Invoices
│   └── profile/               # User Profile, Notifications, Security, Language Settings
│
└── main.dart
```

---

## 3. Technology Stack & Key Libraries

- **Framework**: Flutter 3.24.3 (Dart 3.5.3)
- **State Management**: `flutter_riverpod: ^2.5.1`
- **Routing**: `go_router: ^14.8.1`
- **Networking**: `dio: ^5.7.0`
- **Security & Storage**: `flutter_secure_storage: ^9.2.2`, `shared_preferences: ^2.3.2`
- **Typography & UI**: `google_fonts: ^6.2.1` (Reem Kufi, Tajawal), `flutter_svg: ^2.0.10+1`, `cached_network_image: ^3.4.1`, `shimmer: ^3.0.0`
- **Internationalization**: `flutter_localizations`, `intl: ^0.19.0` (Full Arabic RTL & English LTR support)
