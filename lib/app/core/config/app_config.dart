// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — App & Branding Configuration
//  ▸ Buyers: Customize your app branding here. No other files need touching.
//  ▸ Change app name, logo paths, tagline, contact info, and feature flags.
// ════════════════════════════════════════════════════════════════════════════

class AppConfig {
  AppConfig._();

  // ── App Identity ─────────────────────────────────────────────────────────
  static const String appName     = 'Grandmart';
  static const String tagline     = 'Your Multi-Vendor Marketplace';
  static const String version     = '1.0.0';
  static const String packageName = 'com.yourcompany.grandmart';

  // ── Logo & Asset Paths ───────────────────────────────────────────────────
  // Replace these PNG/JSON files inside assets/ with your own branding.
  static const String logoLight    = 'assets/images/logo_light.png';
  static const String logoDark     = 'assets/images/logo_dark.png';
  static const String logoIcon     = 'assets/images/logo_icon.png';
  static const String placeholder  = 'assets/images/placeholder.png';
  static const String splashLottie = 'assets/lottie/splash.json';
  static const String successLottie = 'assets/lottie/success.json';
  static const String emptyLottie  = 'assets/lottie/empty.json';
  static const String errorLottie  = 'assets/lottie/error.json';

  // ── Onboarding Slides ───────────────────────────────────────────────────
  // Edit title, subtitle, and image for each slide.
  static const List<Map<String, String>> onboardingSlides = [
    {
      'title': 'Shop from Thousands of Stores',
      'subtitle': 'Explore products from verified vendors all in one place.',
      'image': 'assets/images/onboarding_1.png',
    },
    {
      'title': 'Best Deals, Every Day',
      'subtitle': 'Discover amazing offers and featured products daily.',
      'image': 'assets/images/onboarding_2.png',
    },
    {
      'title': 'Fast & Secure Ordering',
      'subtitle': 'Place orders easily and track them in real time.',
      'image': 'assets/images/onboarding_3.png',
    },
  ];

  // ── Contact & Legal ──────────────────────────────────────────────────────
  static const String supportEmail    = 'support@grandmart.com';
  static const String websiteUrl      = 'https://grandmart.com';
  static const String privacyPolicyUrl = 'https://grandmart.com/privacy';
  static const String termsUrl        = 'https://grandmart.com/terms';

  // ── Currency & Locale ────────────────────────────────────────────────────
  static const String currencySymbol = '৳';
  static const String currencyCode   = 'BDT';
  static const String locale         = 'en_US';

  // ── Feature Flags ────────────────────────────────────────────────────────
  // Set false to disable a feature without deleting code.
  static const bool enableDarkMode     = true;
  static const bool enableOnboarding   = true;
  static const bool showStoreTab       = true;
  static const bool showFeaturedBanner = true;
  static const bool enableGuestMode    = true; // Browse without login
  static const bool showWishlistTab    = true; // Show Wishlist in bottom nav
  static const bool showCartTab        = true; // Show Cart in bottom nav
}
