// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — API & Server Configuration
//  ▸ Buyers: Change [baseUrl] to point to your deployed server.
//  ▸ All endpoints are centralized here for easy maintenance.
// ════════════════════════════════════════════════════════════════════════════

class ApiConfig {
  ApiConfig._();

  // ── Server URL ───────────────────────────────────────────────────────────
  // Option A: Same server — FastAPI serves Flutter app via static files
  static const String baseUrl = 'https://grandmart-backend.fastapicloud.dev/api/v1';

  // Option B: Separate deployment (Render, Railway, VPS, etc.)
  // static const String baseUrl = 'https://api.yourdomain.com/api/v1';

  // ── Request Timeouts (milliseconds) ─────────────────────────────────────
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // ── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login          = '/auth/login';
  static const String register       = '/auth/register';
  static const String verifyOtp      = '/auth/verify-otp';
  static const String resendOtp      = '/auth/resend-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resendForgotOtp = '/auth/resend-forgot-otp';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resetPassword  = '/auth/reset-password';
  static const String refreshToken   = '/auth/refresh';
  static const String me             = '/auth/me';
  static const String profile        = '/auth/profile';

  // ── Product Endpoints ────────────────────────────────────────────────────
  static const String products       = '/products';
  static String productDetail(int id) => '/products/$id';

  // ── Category Endpoints ───────────────────────────────────────────────────
  static const String categories     = '/categories';
  static const String categoriesFlat = '/categories/flat';

  // ── Vendor Store Endpoints ───────────────────────────────────────────────
  static const String vendorStores   = '/vendor-stores';
  static String storeDetail(String slug)   => '/vendor-stores/$slug';
  static String storeProducts(String slug) => '/vendor-stores/$slug/products';

  // ── Wishlist Endpoints ───────────────────────────────────────────────────
  static const String wishlist       = '/wishlist';
  static const String wishlistIds    = '/wishlist/ids';
  static String wishlistToggle(int productId) => '/wishlist/$productId';
}
