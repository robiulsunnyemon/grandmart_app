import 'package:flutter/material.dart';
import 'font_config.dart';
import 'themes/indigo_theme.dart';
import 'themes/emerald_theme.dart';
import 'themes/rose_theme.dart';
import 'themes/ocean_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Theme Registry & Configuration Model
// ════════════════════════════════════════════════════════════════════════════

class AppThemeConfig {
  final String id;
  final String displayName;
  final Color primaryColor;
  final Color accentColor;
  final FontConfig fontConfig;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const AppThemeConfig({
    required this.id,
    required this.displayName,
    required this.primaryColor,
    required this.accentColor,
    required this.fontConfig,
    required this.lightTheme,
    required this.darkTheme,
  });
}

class ThemeRegistry {
  ThemeRegistry._();

  static const String defaultThemeId = 'indigo';

  static final List<AppThemeConfig> allThemes = [
    AppThemeConfig(
      id: 'indigo',
      displayName: 'Indigo & Amber',
      primaryColor: IndigoTheme.primaryColor,
      accentColor: IndigoTheme.accentColor,
      fontConfig: FontConfig.fontIndigo,
      lightTheme: IndigoTheme.light(),
      darkTheme: IndigoTheme.dark(),
    ),
    AppThemeConfig(
      id: 'emerald',
      displayName: 'Emerald & Orange',
      primaryColor: EmeraldTheme.primaryColor,
      accentColor: EmeraldTheme.accentColor,
      fontConfig: FontConfig.fontEmerald,
      lightTheme: EmeraldTheme.light(),
      darkTheme: EmeraldTheme.dark(),
    ),
    AppThemeConfig(
      id: 'rose',
      displayName: 'Rose & Purple',
      primaryColor: RoseTheme.primaryColor,
      accentColor: RoseTheme.accentColor,
      fontConfig: FontConfig.fontRose,
      lightTheme: RoseTheme.light(),
      darkTheme: RoseTheme.dark(),
    ),
    AppThemeConfig(
      id: 'ocean',
      displayName: 'Ocean Blue & Teal',
      primaryColor: OceanTheme.primaryColor,
      accentColor: OceanTheme.accentColor,
      fontConfig: FontConfig.fontOcean,
      lightTheme: OceanTheme.light(),
      darkTheme: OceanTheme.dark(),
    ),
  ];

  static AppThemeConfig getById(String id) {
    return allThemes.firstWhere(
      (theme) => theme.id == id,
      orElse: () => allThemes.first,
    );
  }
}
