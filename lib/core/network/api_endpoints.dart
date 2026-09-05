class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String updateProfile = '/auth/me';
  static const String changePassword = '/auth/change-password';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Account
  static const String uploadMedia = '/account/upload-media';
  static const String deleteAccount = '/account/delete';

  // Discovery & Content
  static const String homeLayout = '/content/home';
  static const String services = '/content/services';
  static const String locations = '/content/locations';
  static const String news = '/content/news';

  // Tours & Experiences
  static const String tours = '/tours';
  static const String tourDetail = '/tours/{id}';

  // Museums
  static const String museums = '/museums';
  static const String museumDetail = '/museums/{id}';

  // Events
  static const String events = '/events';
  static const String eventDetail = '/events/{id}';

  // Guides
  static const String guides = '/guides';

  // Shop & Bazaar
  static const String products = '/shop/products';
  static const String productDetail = '/shop/products/{id}';
  static const String cart = '/cart';
  static const String applyCoupon = '/cart/apply-coupon';
  static const String cartCheckout = '/cart/checkout';
  static const String myOrders = '/cart/orders';

  // Bookings & Tickets
  static const String addToCartBooking = '/booking/add-to-cart';
  static const String bookingCheckout = '/booking/checkout';
  static const String bookingHistory = '/booking/history';
  static const String myTickets = '/tickets/my-tickets';
  static const String scanTicket = '/tickets/scan';

  // Wishlist
  static const String wishlist = '/wishlist';
}
