import 'package:get/get.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';

import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';

import '../modules/auth/otp_verify/bindings/otp_verify_binding.dart';
import '../modules/auth/otp_verify/views/otp_verify_view.dart';

import '../modules/auth/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/auth/forgot_password/views/forgot_password_view.dart';

import '../modules/main_wrapper/bindings/main_wrapper_binding.dart';
import '../modules/main_wrapper/views/main_wrapper_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';

import '../modules/products/product_list/bindings/product_list_binding.dart';
import '../modules/products/product_list/views/product_list_view.dart';

import '../modules/products/product_detail/bindings/product_detail_binding.dart';
import '../modules/products/product_detail/views/product_detail_view.dart';

import '../modules/stores/store_list/bindings/store_list_binding.dart';
import '../modules/stores/store_list/views/store_list_view.dart';

import '../modules/stores/store_detail/bindings/store_detail_binding.dart';
import '../modules/stores/store_detail/views/store_detail_view.dart';

import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';

part 'app_routes.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — App Pages Registry
// ════════════════════════════════════════════════════════════════════════════

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => const OtpVerifyView(),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_WRAPPER,
      page: () => const MainWrapperView(),
      binding: MainWrapperBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.STORE_LIST,
      page: () => const StoreListView(),
      binding: StoreListBinding(),
    ),
    GetPage(
      name: _Paths.STORE_DETAIL,
      page: () => const StoreDetailView(),
      binding: StoreDetailBinding(),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];
}
