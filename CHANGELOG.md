# Changelog

All notable changes to **Grandmart Customer App** will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
versioned as `MAJOR.MINOR.PATCH`.

---

## [1.0.0] — 2026-08-06

### Added
- **Foundation & Configuration**
  - `app_config.dart` — centralized branding (name, logo, tagline, currency, feature flags)
  - `api_config.dart` — server URL + all API endpoint constants
  - Zero-dependency `R` responsive helper (`wp`, `hp`, `sp`, breakpoints, grid helpers)
  - `ResponsiveBuilder` layout switcher widget

- **Multi-Theme Engine**
  - 4 built-in premium themes: Indigo, Emerald, Rose, Ocean
  - Each theme has unique Google Fonts pairing (Poppins+Inter, Nunito+Lato, Raleway+Roboto, Outfit+Source Sans 3)
  - Light & Dark mode support with persistent user preference
  - Live theme switcher from Home screen

- **Networking**
  - Dio client with JWT auto-injection interceptor
  - Automatic `401 Unauthorized` → token refresh flow
  - Debug-only request/response logging

- **Authentication Flow**
  - Customer registration with email OTP verification (5-minute countdown timer + resend)
  - Login with email & password
  - Forgot Password — 3-step wizard (Email → OTP → New Password)
  - Guest mode (browse without login)

- **Main Screens**
  - Splash screen with Lottie animation
  - Configurable onboarding slides (from `app_config.dart`)
  - Home: Banner carousel, horizontal category chips, responsive product grid
  - Categories: Full responsive grid with icons
  - Product List: Search + category filter + responsive grid
  - Product Detail: Image thumbnail, variant selector (ChoiceChip), description, Add to Cart stub
  - Vendor Store List: Logo, name, description
  - Vendor Store Detail: Store profile + full product catalog

- **Shared UI Components**
  - `GMButton` — Primary, Secondary, Outlined, Text styles with loading state
  - `GMProductCard` — Responsive card with discount badge, featured star, shimmer
  - `GMCategoryChip` — Icon + label category selector
  - `GMShimmer` + `GMProductGridShimmer` — skeleton loaders
  - `GMErrorWidget` — retry-able error screen
  - `GMEmptyWidget` — zero-result placeholder
  - `GMAppBar` — themed consistent navigation bar

- **Assets**
  - 4 Lottie JSON animations: splash, success, empty, error
  - Asset folder structure: `assets/images/`, `assets/lottie/`
