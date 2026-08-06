import 'package:flutter/material.dart';
import '../font_config.dart';

// ════════════════════════════════════════════════════════════════════════════
//  THEME 2: Emerald & Orange
//  Primary: Emerald Green (#059669), Accent: Deep Orange (#EA580C)
// ════════════════════════════════════════════════════════════════════════════

class EmeraldTheme {
  EmeraldTheme._();

  static const Color primaryColor = Color(0xFF059669);
  static const Color accentColor  = Color(0xFFEA580C);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.light,
      ),
      textTheme: FontConfig.fontEmerald.textThemeBuilder(base.textTheme),
      scaffoldBackgroundColor: const Color(0xFFF0FDF4),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF065F46),
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFA7F3D0), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF9CA3AF),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: accentColor,
        brightness: Brightness.dark,
        surface: const Color(0xFF064E3B),
      ),
      textTheme: FontConfig.fontEmerald.textThemeBuilder(base.textTheme),
      scaffoldBackgroundColor: const Color(0xFF022C22),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF064E3B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF064E3B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF047857), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF064E3B),
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF6B7280),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
