import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Local Storage Service
//  Handles persistent storage using GetStorage for tokens, theme preference,
//  onboarding status, and user profile data.
// ════════════════════════════════════════════════════════════════════════════

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  final GetStorage _box = GetStorage();

  // Storage Keys
  static const String _keyAccessToken    = 'access_token';
  static const String _keyRefreshToken   = 'refresh_token';
  static const String _keyThemeId        = 'theme_id';
  static const String _keyDarkMode       = 'dark_mode';
  static const String _keyOnboardingSeen = 'onboarding_seen';
  static const String _keyUserData       = 'user_data';

  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  // ── Access Token ─────────────────────────────────────────────────────────
  String? getAccessToken() => _box.read<String>(_keyAccessToken);
  Future<void> saveAccessToken(String token) => _box.write(_keyAccessToken, token);

  // ── Refresh Token ────────────────────────────────────────────────────────
  String? getRefreshToken() => _box.read<String>(_keyRefreshToken);
  Future<void> saveRefreshToken(String token) => _box.write(_keyRefreshToken, token);

  // ── Tokens Pair Save/Clear ───────────────────────────────────────────────
  Future<void> saveTokens({required String access, required String refresh}) async {
    await _box.write(_keyAccessToken, access);
    await _box.write(_keyRefreshToken, refresh);
  }

  Future<void> clearAuth() async {
    await _box.remove(_keyAccessToken);
    await _box.remove(_keyRefreshToken);
    await _box.remove(_keyUserData);
  }

  bool get isLoggedIn => getAccessToken() != null && getAccessToken()!.isNotEmpty;

  // ── Theme Preferences ────────────────────────────────────────────────────
  String getThemeId() => _box.read<String>(_keyThemeId) ?? 'indigo';
  Future<void> saveThemeId(String themeId) => _box.write(_keyThemeId, themeId);

  bool getDarkMode() => _box.read<bool>(_keyDarkMode) ?? false;
  Future<void> saveDarkMode(bool isDark) => _box.write(_keyDarkMode, isDark);

  // ── Onboarding ───────────────────────────────────────────────────────────
  bool get isOnboardingSeen => _box.read<bool>(_keyOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen() => _box.write(_keyOnboardingSeen, true);

  // ── User Data Cache ──────────────────────────────────────────────────────
  Map<String, dynamic>? getUserData() => _box.read<Map<String, dynamic>>(_keyUserData);
  Future<void> saveUserData(Map<String, dynamic> json) => _box.write(_keyUserData, json);
}
