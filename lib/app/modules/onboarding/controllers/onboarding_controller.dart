import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/storage_service.dart';
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  List<Map<String, String>> get slides => AppConfig.onboardingSlides;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void next() {
    if (currentIndex.value < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finish();
    }
  }

  void finish() async {
    await StorageService.to.setOnboardingSeen();
    if (StorageService.to.isLoggedIn || AppConfig.enableGuestMode) {
      Get.offAllNamed(Routes.MAIN_WRAPPER);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
