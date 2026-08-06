import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final storage = StorageService.to;
    if (AppConfig.enableOnboarding && !storage.isOnboardingSeen) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (storage.isLoggedIn || AppConfig.enableGuestMode) {
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
