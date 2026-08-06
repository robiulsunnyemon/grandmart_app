part of 'app_pages.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — App Route Constants
// ════════════════════════════════════════════════════════════════════════════

abstract class Routes {
  Routes._();

  static const SPLASH          = _Paths.SPLASH;
  static const ONBOARDING      = _Paths.ONBOARDING;
  static const LOGIN           = _Paths.LOGIN;
  static const REGISTER        = _Paths.REGISTER;
  static const OTP_VERIFY      = _Paths.OTP_VERIFY;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;

  static const MAIN_WRAPPER    = _Paths.MAIN_WRAPPER;
  static const HOME            = _Paths.HOME;
  static const CATEGORIES      = _Paths.CATEGORIES;
  static const PRODUCT_LIST    = _Paths.PRODUCT_LIST;
  static const PRODUCT_DETAIL  = _Paths.PRODUCT_DETAIL;
  static const STORE_LIST      = _Paths.STORE_LIST;
  static const STORE_DETAIL    = _Paths.STORE_DETAIL;
  static const WISHLIST        = _Paths.WISHLIST;
}

abstract class _Paths {
  _Paths._();

  static const SPLASH          = '/splash';
  static const ONBOARDING      = '/onboarding';
  static const LOGIN           = '/login';
  static const REGISTER        = '/register';
  static const OTP_VERIFY      = '/otp-verify';
  static const FORGOT_PASSWORD = '/forgot-password';

  static const MAIN_WRAPPER    = '/main';
  static const HOME            = '/home';
  static const CATEGORIES      = '/categories';
  static const PRODUCT_LIST    = '/products';
  static const PRODUCT_DETAIL  = '/product-detail';
  static const STORE_LIST      = '/stores';
  static const STORE_DETAIL    = '/store-detail';
  static const WISHLIST        = '/wishlist';
}
