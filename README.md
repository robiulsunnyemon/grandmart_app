# 🛒 Grandmart — Multi-Vendor Customer App
**Flutter · GetX · CodeCanyon Edition**

---

## 🔧 Requirements

| Requirement | Version |
|-------------|---------|
| Flutter SDK | ≥ 3.10.0 |
| Dart SDK | ≥ 3.0.0 |
| Android | API 21+ (Android 5.0+) |
| iOS | iOS 12.0+ |
| Backend | Grandmart FastAPI Backend (sold separately or bundled) |

---

## ⚡ 3-Minute Setup for Buyers

### Step 1 — Set Your Branding
Open `lib/app/core/config/app_config.dart`:
```dart
static const String appName        = 'YourAppName';
static const String tagline        = 'Your Tagline';
static const String currencySymbol = '$';
static const String supportEmail   = 'support@yourstore.com';
```

### Step 2 — Connect Your Server
Open `lib/app/core/config/api_config.dart`:
```dart
static const String baseUrl = 'https://api.yourdomain.com/api/v1';
```

### Step 3 — Replace Logos
Replace files inside `assets/images/`:
- `logo_light.png` — shown on light backgrounds
- `logo_dark.png`  — shown on dark backgrounds
- `logo_icon.png`  — app icon / splash

### Step 4 — Change Android Package Name
In `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.yourcompany.yourapp"
    ...
}
```
In `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest package="com.yourcompany.yourapp">
```

### Step 5 — Install & Run
```bash
flutter pub get
flutter run
```

---

## 🎨 Multi-Theme System

The app ships with **4 premium built-in themes**, each with distinct Google Fonts:

| Theme ID | Primary | Accent | Heading Font | Body Font |
|----------|---------|--------|-------------|-----------|
| `indigo` | `#4F46E5` | `#F59E0B` | **Poppins** | Inter |
| `emerald` | `#059669` | `#EA580C` | **Nunito** | Lato |
| `rose` | `#E11D48` | `#7C3AED` | **Raleway** | Roboto |
| `ocean` | `#0284C7` | `#0D9488` | **Outfit** | Source Sans 3 |

To set the **default theme** on first launch, open `lib/app/core/theme/theme_config.dart`:
```dart
static const String defaultThemeId = 'ocean'; // indigo | emerald | rose | ocean
```

Users can also **switch themes live** from the Home screen top bar. Their preference is saved automatically.

---

## 📱 Features Included

- ✅ Splash Screen with Lottie animation
- ✅ Onboarding slides (configurable from `app_config.dart`)
- ✅ Customer Registration + Email OTP verification
- ✅ Login / Logout
- ✅ Forgot Password — 3-step wizard (Email → OTP → New Password)
- ✅ Home: Banner carousel + Category chips + Featured products
- ✅ All Categories grid (responsive)
- ✅ Product list with search/filter
- ✅ Product detail: Image gallery + Variants + Description
- ✅ Vendor Store list
- ✅ Vendor Store detail + Store products
- ✅ 4 built-in themes with Dark Mode support
- ✅ Guest Mode (browse without login)
- ✅ Responsive layout: Phone → Tablet → Desktop/Web
- ✅ Shimmer loading skeletons
- ✅ Network error and empty state screens

---

## 🗂️ Project Structure

```
lib/
├── main.dart
└── app/
    ├── core/
    │   ├── config/          ← ★ BUYER CUSTOMIZATION (app_config + api_config)
    │   ├── theme/           ← Multi-theme engine
    │   ├── responsive/      ← R helper (wp, hp, sp, productCols)
    │   ├── network/         ← Dio client + JWT interceptor
    │   ├── storage/         ← GetStorage wrapper
    │   └── widgets/         ← Shared reusable widgets
    ├── data/
    │   ├── models/          ← Dart model classes
    │   └── providers/       ← API call functions
    └── modules/             ← Feature screens (GetX MVC pattern)
        ├── splash/
        ├── onboarding/
        ├── auth/
        ├── home/
        ├── categories/
        ├── products/
        └── stores/
```

---

## 📐 Responsive Breakpoints

| Device | Width | Product Grid | Category Grid |
|--------|-------|-------------|---------------|
| Phone | ≤ 480px | 2 columns | 4 columns |
| Tablet | 481–900px | 3 columns | 6 columns |
| Desktop/Web | > 900px | 4 columns | 8 columns |

---

## 🔌 Feature Flags

Disable features without deleting code in `app_config.dart`:

```dart
static const bool enableOnboarding   = true;   // false = skip onboarding
static const bool enableDarkMode     = true;   // false = light only
static const bool showStoreTab       = true;   // false = hide Stores tab
static const bool showFeaturedBanner = true;   // false = hide banners
static const bool enableGuestMode    = true;   // false = login required
```

---

## 🛠️ Built With

- [Flutter](https://flutter.dev) — UI Framework
- [GetX](https://pub.dev/packages/get) — State Management & Routing
- [Dio](https://pub.dev/packages/dio) — HTTP Networking
- [GetStorage](https://pub.dev/packages/get_storage) — Local Persistence
- [CachedNetworkImage](https://pub.dev/packages/cached_network_image) — Image Caching
- [Google Fonts](https://pub.dev/packages/google_fonts) — Typography
- [Lottie](https://pub.dev/packages/lottie) — Animations
- [Shimmer](https://pub.dev/packages/shimmer) — Loading Skeletons
- [carousel_slider](https://pub.dev/packages/carousel_slider) — Banner Slider
- [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator) — Onboarding Dots

---

## 📄 Credits

Grandmart Customer App  
Developed for CodeCanyon / Envato Market  
Contact: support@grandmart.com

---

## 📝 Changelog

### v1.0.0 — Initial Release
- Foundation, Config, Responsive Engine, Multi-Theme System
- Authentication: Register, OTP Verify, Login, Forgot Password
- Home, Categories, Products, Product Detail
- Vendor Stores, Store Detail
- Guest Mode, Dark Mode, Theme Switcher
