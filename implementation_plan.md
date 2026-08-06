# 📱 Grandmart Customer App — Final Implementation Plan
### CodeCanyon-Ready | Multi-Theme | Responsive | Buyer-Friendly Customization

---

## 🎯 এই ফেজের স্কোপ

> Foundation → Branding Config → Responsive Engine → Theme Engine → Auth → Bottom Nav → Home → Category → Products → Product Detail → Stores

**Cart / Order / Wishlist পরবর্তী ফেজে।**

---

## 📦 pubspec.yaml — Final Package List

```yaml
dependencies:
  flutter:
    sdk: flutter

  # ── State Management & Routing ──────────────────────
  get: ^4.7.3                        # GetX (বিদ্যমান)

  # ── Networking ───────────────────────────────────────
  dio: ^5.7.0                        # HTTP client + interceptor

  # ── Local Storage ────────────────────────────────────
  get_storage: ^2.1.1                # Token, theme prefs (no async needed)

  # ── Images ───────────────────────────────────────────
  cached_network_image: ^3.4.1       # Cloudinary CDN image caching

  # ── UI & Animation ───────────────────────────────────
  shimmer: ^3.0.0                    # Skeleton loading
  carousel_slider: ^5.0.0            # Banner slider
  lottie: ^3.1.2                     # Splash / success animation
  smooth_page_indicator: ^1.2.0      # Onboarding dots

  # ── Typography ───────────────────────────────────────
  google_fonts: ^6.2.1               # Multi font combination support

  # ── Utility ──────────────────────────────────────────
  intl: ^0.19.0                      # BDT currency, date formatting
```

> [!TIP]
> **কেন `flutter_screenutil` নয়?** — এটি context-dependent এবং অনেক সময় miscalculate করে। আমরা নিজস্ব lightweight `ResponsiveHelper` তৈরি করব যা ScreenUtil-এর চেয়ে সহজ, dependency-free এবং buyer-friendly।

---

## 🗂️ সম্পূর্ণ Folder Structure

```
lib/
├── main.dart
└── app/
    ├── routes/
    │   ├── app_routes.dart
    │   └── app_pages.dart
    │
    ├── core/
    │   │
    │   ├── config/                          ★ BUYER CUSTOMIZATION ZONE
    │   │   ├── app_config.dart              ← App নাম, লোগো, ট্যাগলাইন, contact
    │   │   └── api_config.dart              ← Backend URL, endpoints
    │   │
    │   ├── responsive/                      ★ RESPONSIVE ENGINE
    │   │   ├── responsive_helper.dart       ← sp(), wp(), hp() helpers
    │   │   ├── responsive_builder.dart      ← Mobile/Tablet layout switcher
    │   │   └── breakpoints.dart             ← Screen size constants
    │   │
    │   ├── theme/                           ★ THEME ENGINE
    │   │   ├── app_theme_controller.dart
    │   │   ├── theme_config.dart
    │   │   ├── font_config.dart
    │   │   └── themes/
    │   │       ├── indigo_theme.dart        ← Theme 1 (default)
    │   │       ├── emerald_theme.dart       ← Theme 2
    │   │       ├── rose_theme.dart          ← Theme 3
    │   │       └── ocean_theme.dart         ← Theme 4
    │   │
    │   ├── network/
    │   │   └── dio_client.dart              ← JWT interceptor, error handling
    │   │
    │   ├── storage/
    │   │   └── storage_service.dart         ← GetStorage wrapper
    │   │
    │   └── widgets/                         ← Shared UI Components
    │       ├── gm_button.dart
    │       ├── gm_product_card.dart         ← responsive card
    │       ├── gm_category_chip.dart
    │       ├── gm_shimmer.dart
    │       ├── gm_error_widget.dart
    │       ├── gm_empty_widget.dart
    │       └── gm_app_bar.dart              ← Custom themed AppBar
    │
    ├── data/
    │   ├── models/
    │   │   ├── user_model.dart
    │   │   ├── product_model.dart
    │   │   ├── category_model.dart
    │   │   └── vendor_store_model.dart
    │   └── providers/
    │       ├── auth_provider.dart
    │       ├── product_provider.dart
    │       ├── category_provider.dart
    │       └── store_provider.dart
    │
    └── modules/
        ├── splash/
        ├── onboarding/
        ├── main_wrapper/
        ├── auth/
        │   ├── login/
        │   ├── register/
        │   ├── otp_verify/
        │   └── forgot_password/
        ├── home/
        ├── categories/
        ├── products/
        │   ├── product_list/
        │   └── product_detail/
        └── stores/
            ├── store_list/
            └── store_detail/
```

---

## ⚙️ PART 1 — BUYER CUSTOMIZATION CONFIG FILES

### `app_config.dart` — সকল Branding এক জায়গায়

> ডায়াশবোর্ডের `app.config.js` pattern-এর সাথে সামঞ্জস্য রেখে তৈরি।

```dart
// lib/app/core/config/app_config.dart
// ════════════════════════════════════════════════════════════════════
//  GRANDMART — App & Branding Configuration
//  Buyers: Customize your app here. No need to touch other files.
// ════════════════════════════════════════════════════════════════════

class AppConfig {
  AppConfig._();

  // ── App Identity ─────────────────────────────────────────────────
  static const String appName        = 'Grandmart';
  static const String tagline        = 'Your Multi-Vendor Marketplace';
  static const String version        = '1.0.0';
  static const String packageName    = 'com.yourcompany.grandmart';

  // ── Logo & Assets ────────────────────────────────────────────────
  // Replace these with your own asset paths (assets/images/)
  static const String logoLight      = 'assets/images/logo_light.png';
  static const String logoDark       = 'assets/images/logo_dark.png';
  static const String logoIcon       = 'assets/images/logo_icon.png';
  static const String splashLottie   = 'assets/lottie/splash.json';
  static const String successLottie  = 'assets/lottie/success.json';

  // ── Onboarding Content ───────────────────────────────────────────
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
      'title': 'Fast & Secure Delivery',
      'subtitle': 'Track your orders in real-time from checkout to doorstep.',
      'image': 'assets/images/onboarding_3.png',
    },
  ];

  // ── Contact & Support ────────────────────────────────────────────
  static const String supportEmail   = 'support@grandmart.com';
  static const String websiteUrl     = 'https://grandmart.com';
  static const String privacyPolicyUrl = 'https://grandmart.com/privacy';
  static const String termsUrl       = 'https://grandmart.com/terms';

  // ── Currency & Region ────────────────────────────────────────────
  static const String currencySymbol = '৳';
  static const String currencyCode   = 'BDT';
  static const String locale         = 'en_US';

  // ── Feature Flags ────────────────────────────────────────────────
  static const bool enableDarkMode       = true;
  static const bool enableOnboarding     = true;
  static const bool showStoreTab         = true;
  static const bool showFeaturedBanner   = true;
}
```

---

### `api_config.dart` — Backend Connection

```dart
// lib/app/core/config/api_config.dart
// ════════════════════════════════════════════════════════════════════
//  GRANDMART — API & Server Configuration
//  Buyers: Change baseUrl to point to your server.
// ════════════════════════════════════════════════════════════════════

class ApiConfig {
  ApiConfig._();

  // ── Server URL ───────────────────────────────────────────────────
  // Option A: Same server (FastAPI serves app via static)
  static const String baseUrl = 'http://YOUR_SERVER_IP/api/v1';

  // Option B: Separate deployment
  // static const String baseUrl = 'https://api.yourdomain.com/api/v1';

  // ── Request Settings ─────────────────────────────────────────────
  static const int connectTimeout = 15000;  // ms
  static const int receiveTimeout = 15000;

  // ── Endpoints ────────────────────────────────────────────────────
  static const String login              = '/auth/login';
  static const String register           = '/auth/register';
  static const String verifyOtp          = '/auth/verify-otp';
  static const String resendOtp          = '/auth/resend-otp';
  static const String forgotPassword     = '/auth/forgot-password';
  static const String verifyResetOtp     = '/auth/verify-reset-otp';
  static const String resetPassword      = '/auth/reset-password';
  static const String refreshToken       = '/auth/refresh';
  static const String me                 = '/auth/me';
  static const String profile            = '/auth/profile';
  static const String products           = '/products';
  static const String categories         = '/categories';
  static const String categoriesFlat     = '/categories/flat';
  static const String vendorStores       = '/vendor-stores';

  static String productDetail(int id)      => '/products/$id';
  static String storeDetail(String slug)   => '/vendor-stores/$slug';
  static String storeProducts(String slug) => '/vendor-stores/$slug/products';
}
```

---

## 📐 PART 2 — RESPONSIVE ENGINE

### কেন Custom Responsive Helper?

| | flutter_screenutil | আমাদের ResponsiveHelper |
|--|---|---|
| Dependency | বাইরের package | শূন্য |
| Setup complexity | context + init required | শুধু `BuildContext` |
| Tablet support | হ্যাঁ | হ্যাঁ |
| Buyer-friendly | মাঝারি | খুব সহজ |

### `breakpoints.dart`

```dart
class Breakpoints {
  static const double mobileMax  = 480;   // Phone
  static const double tabletMin  = 481;   // Tablet
  static const double tabletMax  = 900;   // Large Tablet
  static const double desktopMin = 901;   // Web / Desktop

  // Grid columns by screen width
  static int productGridCols(double width) {
    if (width < mobileMax) return 2;       // Phone → 2 columns
    if (width < tabletMax) return 3;       // Tablet → 3 columns
    return 4;                              // Desktop → 4 columns
  }

  static int categoryGridCols(double width) {
    if (width < mobileMax) return 4;
    if (width < tabletMax) return 6;
    return 8;
  }
}
```

### `responsive_helper.dart`

```dart
import 'package:flutter/material.dart';
import 'breakpoints.dart';

class R {
  R._();

  static late MediaQueryData _mq;
  static void init(BuildContext context) => _mq = MediaQuery.of(context);

  // ── Screen dimensions ─────────────────────────────────────────
  static double get width  => _mq.size.width;
  static double get height => _mq.size.height;

  // ── Responsive values ────────────────────────────────────────
  // wp(percent)  → % of screen width
  // hp(percent)  → % of screen height
  // sp(size)     → scalable font size (respects accessibility)
  static double wp(double percent) => width  * percent / 100;
  static double hp(double percent) => height * percent / 100;
  static double sp(double size)    => size * _mq.textScaler.scale(1.0);

  // ── Device type ──────────────────────────────────────────────
  static bool get isMobile => width <= Breakpoints.mobileMax;
  static bool get isTablet => width > Breakpoints.mobileMax && width <= Breakpoints.tabletMax;
  static bool get isDesktop => width > Breakpoints.tabletMax;

  // ── Grid helpers ──────────────────────────────────────────────
  static int get productCols    => Breakpoints.productGridCols(width);
  static int get categoryCols   => Breakpoints.categoryGridCols(width);

  // ── Padding helpers ───────────────────────────────────────────
  static double get pagePadding  => isMobile ? 16 : isTablet ? 24 : 32;
  static double get cardPadding  => isMobile ? 12 : 16;
  static double get sectionGap   => isMobile ? 24 : 32;
}
```

### `responsive_builder.dart` — Layout Switcher

```dart
// Usage in any View:
// ResponsiveBuilder(
//   mobile: MobileProductGrid(),
//   tablet: TabletProductGrid(),
// )
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({required this.mobile, this.tablet, this.desktop, super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    if (R.isDesktop && desktop != null) return desktop!;
    if (R.isTablet && tablet != null) return tablet!;
    return mobile;
  }
}
```

### Responsive Usage Pattern — View-এ কীভাবে ব্যবহার হবে

```dart
// Product Grid — স্বয়ংক্রিয়ভাবে Mobile/Tablet adapt করে
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: R.productCols,          // ← Responsive!
    childAspectRatio: R.isMobile ? 0.72 : 0.78,
    crossAxisSpacing: R.cardPadding,
    mainAxisSpacing: R.cardPadding,
  ),
  ...
)

// Padding — সব জায়গায় consistent
Padding(
  padding: EdgeInsets.symmetric(horizontal: R.pagePadding),
  child: ...,
)

// Font size — accessibility সহ scale করে
Text(
  'Product Name',
  style: TextStyle(fontSize: R.sp(16)),  // ← accessible!
)
```

---

## 🎨 PART 3 — THEME ENGINE (Updated)

### ৪টি Built-in Theme

| # | ID | Light Primary | Dark Surface | Heading Font | Body Font |
|---|-----|--------------|-------------|-------------|----------|
| 1 | `indigo` | `#4F46E5` | `#0D0D1A` | **Poppins** | Inter |
| 2 | `emerald` | `#059669` | `#071A10` | **Nunito** | Lato |
| 3 | `rose` | `#E11D48` | `#1A0710` | **Raleway** | Roboto |
| 4 | `ocean` | `#0284C7` | `#050F1A` | **Outfit** | Source Sans 3 |

### ThemeData কীভাবে responsive typography ব্যবহার করবে

```dart
// indigo_theme.dart

ThemeData _buildLight(FontConfig font) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4F46E5),
    brightness: Brightness.light,
  ),
  textTheme: font.textTheme,           // ← Google Fonts injected here
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Color(0xFF4F46E5),
    unselectedItemColor: Color(0xFF9CA3AF),
    elevation: 0,
  ),
);
```

---

## 🗓️ Execution Order (Step-by-Step)

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PHASE A — Foundation (Core Layer)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1  pubspec.yaml  ← packages add, flutter pub get

STEP 2  core/config/
          └─ app_config.dart      ← Branding constants
          └─ api_config.dart      ← Server URL + endpoints

STEP 3  core/responsive/
          └─ breakpoints.dart
          └─ responsive_helper.dart (R class)
          └─ responsive_builder.dart

STEP 4  core/storage/storage_service.dart
          └─ token read/write, themeId, darkMode, onboardingSeen

STEP 5  core/theme/
          └─ font_config.dart
          └─ themes/ (indigo, emerald, rose, ocean)
          └─ theme_config.dart  (ThemeRegistry)
          └─ app_theme_controller.dart

STEP 6  main.dart  ← GetBuilder + GetMaterialApp theme injection

STEP 7  core/network/dio_client.dart
          └─ baseUrl from ApiConfig
          └─ JWT interceptor (attach token, 401 → refresh)

STEP 8  data/models/  ← Dart model classes (fromJson, toJson)
STEP 9  data/providers/  ← Raw Dio API calls

STEP 10 core/widgets/  ← Shared UI components (all responsive)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PHASE B — Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 11 routes/app_routes.dart + app_pages.dart  ← সব route

STEP 12 modules/splash/          ← Lottie + token check → redirect
STEP 13 modules/onboarding/      ← AppConfig.onboardingSlides ব্যবহার
STEP 14 modules/auth/login/
STEP 15 modules/auth/register/
STEP 16 modules/auth/otp_verify/ ← countdown timer, resend
STEP 17 modules/auth/forgot_password/ ← 3-step wizard

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PHASE C — Main App Screens
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 18 modules/main_wrapper/    ← Bottom Nav Shell (IndexedStack)
STEP 19 modules/home/            ← Banner + Categories + Featured Products
STEP 20 modules/categories/      ← Responsive category grid
STEP 21 modules/products/product_list/    ← Filter, search, pagination
STEP 22 modules/products/product_detail/  ← Gallery, variants, store info
STEP 23 modules/stores/store_list/        ← All vendor stores
STEP 24 modules/stores/store_detail/      ← Store + store products

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 PHASE D — Polish (CodeCanyon Submission Prep)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 25 Theme Switcher UI (Profile বা drawer-এ)
STEP 26 Error handling polish (network error, empty state, 503 maintenance)
STEP 27 Android app icon + splash screen (flutter_launcher_icons)
STEP 28 README.md — Buyer installation guide
```

---

## ✅ CodeCanyon Buyer Customization Map

```
╔══════════════════════════════════════════════════════════════╗
║  FILE                          কী পরিবর্তন করবে            ║
╠══════════════════════════════════════════════════════════════╣
║  core/config/app_config.dart   অ্যাপ নাম, লোগো, tagline,  ║
║                                 contact, feature flags       ║
╠══════════════════════════════════════════════════════════════╣
║  core/config/api_config.dart   Backend server URL           ║
╠══════════════════════════════════════════════════════════════╣
║  core/theme/themes/*.dart      Primary রঙ পরিবর্তন         ║
║                                (১ লাইন → পুরো অ্যাপ)       ║
╠══════════════════════════════════════════════════════════════╣
║  core/theme/font_config.dart   ফন্ট পরিবর্তন               ║
╠══════════════════════════════════════════════════════════════╣
║  assets/images/logo_*.png      লোগো replace                 ║
║  assets/lottie/splash.json     Splash animation replace      ║
╠══════════════════════════════════════════════════════════════╣
║  ThemeRegistry.defaultId       ডিফল্ট থিম সেট করা          ║
╚══════════════════════════════════════════════════════════════╝
```

---

## 💡 আমার অতিরিক্ত CodeCanyon Recommendations

### ১. Maintenance Mode Handling (Backend-এর সাথে sync)
Backend-এ `503` response এলে একটি সুন্দর `MaintenanceScreen` দেখাবে — এটি buyer-দের কাছে professional দেখায়।

### ২. `AppConfig.enableOnboarding = false` করলে Onboarding skip
Feature flags দিয়ে buyer পুরো Onboarding বন্ধ করতে পারবে — extra configuration ছাড়াই।

### ৩. Guest Mode (Login ছাড়া Browse)
Product ও Store দেখা যাবে — শুধু Order দিতে গেলে Login prompt। CodeCanyon-এ এটি highly rated feature।

### ৪. Network Error Overlay
কোনো screen-এ net না থাকলে একটি consistent "No Internet" widget — সব Controller-এ handle হবে।

### ৫. Image Fallback
Cloudinary URL fail হলে placeholder asset দেখাবে — `CachedNetworkImage` errorBuilder দিয়ে।

### ৬. `dio_client.dart`-এ Logging শুধু Debug Mode-এ
```dart
if (kDebugMode) interceptors.add(LogInterceptor(...));
```
Production build-এ কোনো log নেই — security ও performance উভয়ের জন্য ভালো।

### ৭. Semantic Versioning + Changelog
`app_config.dart`-এ version আছেই — `CHANGELOG.md` ফাইল রাখলে CodeCanyon reviewer-রা আনন্দিত হন।

---

## 🏗️ GetX Module Pattern (সকল Module একই নিয়মে)

```
module_name/
├── bindings/module_name_binding.dart    ← Get.lazyPut<Controller>()
├── controllers/module_name_controller.dart  ← Business logic, API calls
└── views/module_name_view.dart              ← UI only (GetView<Controller>)
```

> [!IMPORTANT]
> কোনো Module-এর `view.dart`-এ সরাসরি API call বা business logic **থাকবে না**। শুধু `controller.someState.value` পড়বে। এটি CodeCanyon review-তে code quality grade উন্নত করে।

---

## 🗺️ Navigation Flow

```
main.dart
└── SplashView
      ├── [token আছে] ──→ MainWrapperView
      │                        ├── Tab 0: HomeView
      │                        ├── Tab 1: CategoriesView
      │                        ├── Tab 2: ProductListView
      │                        └── Tab 3: StoreListView
      │                              │
      │                    (Full-screen push, Bottom Nav বাইরে)
      │                        ├── ProductDetailView (/product/:id)
      │                        └── StoreDetailView (/store/:slug)
      │
      └── [token নেই] ──→ LoginView
                              ├── RegisterView
                              │       └── OtpVerifyView ──→ MainWrapperView
                              └── ForgotPasswordView (3-step)
```
