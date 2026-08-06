import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../storage/storage_service.dart';
import 'theme_config.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — App Theme Controller
//  Manages current active theme and dark/light mode with reactivity & persistence.
// ════════════════════════════════════════════════════════════════════════════

class AppThemeController extends GetxController {
  static AppThemeController get to => Get.find();

  final _currentThemeId = ThemeRegistry.defaultThemeId.obs;
  final _isDarkMode = false.obs;

  String get currentThemeId => _currentThemeId.value;
  bool get isDarkMode => _isDarkMode.value;

  AppThemeConfig get currentConfig => ThemeRegistry.getById(_currentThemeId.value);

  ThemeData get activeThemeData => isDarkMode ? currentConfig.darkTheme : currentConfig.lightTheme;
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final savedId = StorageService.to.getThemeId();
    final savedDark = StorageService.to.getDarkMode();
    _currentThemeId.value = savedId;
    _isDarkMode.value = savedDark;
  }

  void switchTheme(String themeId) {
    if (_currentThemeId.value == themeId) return;
    _currentThemeId.value = themeId;
    StorageService.to.saveThemeId(themeId);
    Get.changeTheme(activeThemeData);
    update();
  }

  void toggleDarkMode() {
    _isDarkMode.value = !_isDarkMode.value;
    StorageService.to.saveDarkMode(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
    Get.changeTheme(activeThemeData);
    update();
  }
}
