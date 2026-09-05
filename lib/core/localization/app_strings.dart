class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _values = {
    'ar': {
      // Navigation
      'nav_home': 'الرئيسية',
      'nav_discover': 'اكتشف',
      'nav_reservations': 'حجوزاتي',
      'nav_favorites': 'المفضلة',
      'nav_profile': 'حسابي',

      // Home
      'welcome_back': 'مرحباً بك',
      'guest_traveler': 'مسافر مُضيف',
      'search_placeholder': 'ابحث عن وجهة، تجربة، أو فعالية...',
      'curated_experiences': 'تجارب مختارة بعناية',
      'hero_title': 'من التراث إلى التجربة',
      'hero_subtitle': 'اكتشف روائع المملكة الأصيلة',
      'explore_now': 'استكشف الآن',
      'featured_tours': 'تجارب سياحية مميزة',
      'featured_tours_sub': 'أبرز المغامرات والأنشطة الثقافية',
      'bazaar_title': 'بازار مُضيف للمقتنيات',
      'bazaar_sub': 'تحف سعودية، عطور وبخور، وحرف يدوية',

      // Services
      'service_museums': 'المتاحف',
      'service_events': 'الفعاليات',
      'service_guides': 'الأدلاء',
      'service_cars': 'السيارات',
      'service_shop': 'المتجر',

      // Booking & Checkout
      'book_now': 'حجز التذكرة',
      'starting_from': 'السعر يبدأ من',
      'select_date': 'اختر موعد الزيارة',
      'guests_count': 'عدد التذاكر / الضيوف',
      'total_price': 'المبلغ الإجمالي',
      'continue_booking': 'متابعة الحجز والدفع',
      'checkout_title': 'إتمام الحجز والدفع',
      'payment_method': 'طريقة الدفع',
      'confirm_payment': 'تأكيد الحجز والدفع',
      'booking_success': 'تم تأكيد حجزك بنجاح!',

      // Profile & Auth
      'login_title': 'تسجيل الدخول',
      'register_title': 'إنشاء حساب جديد',
      'no_account': 'ليس لديك حساب بعد؟',
      'create_account': 'إنشاء حساب جديد',
      'have_account': 'لديك حساب بالفعل؟',
      'browse_as_guest': 'تصفح كزائر',
      'logout': 'تسجيل الخروج',
      'language': 'اللغة / Language',
      'wallet': 'المحفظة والرصيد',
      'notifications': 'الإشعارات',
      'empty_reservations': 'لا توجد حجوزات حالياً',
      'empty_favorites': 'قائمة المفضلات فارغة',
      'explore_tours': 'استكشف التجارب والوجهات',
    },
    'en': {
      // Navigation
      'nav_home': 'Home',
      'nav_discover': 'Discover',
      'nav_reservations': 'Bookings',
      'nav_favorites': 'Wishlist',
      'nav_profile': 'Profile',

      // Home
      'welcome_back': 'Welcome back',
      'guest_traveler': 'Modeefe Traveler',
      'search_placeholder': 'Search destinations, tours, events...',
      'curated_experiences': 'Curated Experiences',
      'hero_title': 'From Heritage to Experience',
      'hero_subtitle': 'Discover authentic Saudi wonders',
      'explore_now': 'Explore Now',
      'featured_tours': 'Featured Experiences',
      'featured_tours_sub': 'Top cultural adventures & activities',
      'bazaar_title': 'Modeefe Heritage Bazaar',
      'bazaar_sub': 'Authentic Saudi antiques, perfumes & handicrafts',

      // Services
      'service_museums': 'Museums',
      'service_events': 'Events',
      'service_guides': 'Guides',
      'service_cars': 'Cars',
      'service_shop': 'Bazaar',

      // Booking & Checkout
      'book_now': 'Book Ticket',
      'starting_from': 'Starting from',
      'select_date': 'Select Visit Date',
      'guests_count': 'Number of Guests / Tickets',
      'total_price': 'Total Amount',
      'continue_booking': 'Proceed to Checkout',
      'checkout_title': 'Checkout & Payment',
      'payment_method': 'Payment Gateway',
      'confirm_payment': 'Confirm & Pay',
      'booking_success': 'Booking Confirmed Successfully!',

      // Profile & Auth
      'login_title': 'Sign In',
      'register_title': 'Create Account',
      'no_account': "Don't have an account?",
      'create_account': 'Register Now',
      'have_account': 'Already have an account?',
      'browse_as_guest': 'Browse as Guest',
      'logout': 'Sign Out',
      'language': 'Language / اللغة',
      'wallet': 'Wallet & Balance',
      'notifications': 'Notifications',
      'empty_reservations': 'No active bookings yet',
      'empty_favorites': 'Your wishlist is empty',
      'explore_tours': 'Explore Tours & Destinations',
    },
  };

  static String get(String key, String locale) {
    return _values[locale]?[key] ?? _values['ar']?[key] ?? key;
  }
}
