import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/config/app_config.dart';
import 'app/core/services/wishlist_service.dart';
import 'app/core/storage/storage_service.dart';
import 'app/core/theme/app_theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent Storage Service
  final storage = StorageService();
  await storage.init();
  Get.put(storage);

  // Initialize Theme Controller
  Get.put(AppThemeController());

  // Register WishlistService as permanent singleton
  // (fetchIds is called inside onInit if user is logged in)
  Get.put(WishlistService(), permanent: true);

  runApp(const GrandmartApp());
}

class GrandmartApp extends StatelessWidget {
  const GrandmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppThemeController>(
      builder: (themeCtrl) {
        return GetMaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: themeCtrl.currentConfig.lightTheme,
          darkTheme: themeCtrl.currentConfig.darkTheme,
          themeMode: themeCtrl.themeMode,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
