import 'package:flutter/material.dart';
import 'breakpoints.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Responsive Helper  (R)
//
//  Usage:
//    R.init(context)          → Initialize once per build (in Scaffold/build)
//    R.wp(50)                 → 50% of screen width
//    R.hp(20)                 → 20% of screen height
//    R.sp(16)                 → Accessible, scaled font size
//    R.pagePadding            → Consistent horizontal padding
//    R.productCols            → Responsive grid column count
// ════════════════════════════════════════════════════════════════════════════

class R {
  R._();

  static late MediaQueryData _mq;

  /// Call once at the top of each Screen's build() method.
  static void init(BuildContext context) {
    _mq = MediaQuery.of(context);
  }

  // ── Screen dimensions ─────────────────────────────────────────────────────
  static double get width  => _mq.size.width;
  static double get height => _mq.size.height;

  // ── Proportional sizing ───────────────────────────────────────────────────
  /// Percentage of screen width.
  static double wp(double percent) => width * percent / 100;

  /// Percentage of screen height.
  static double hp(double percent) => height * percent / 100;

  /// Scalable font size — respects system text-scale for accessibility.
  static double sp(double size) => size * _mq.textScaler.scale(1.0);

  // ── Device type ───────────────────────────────────────────────────────────
  static bool get isMobile  => width <= Breakpoints.mobileMax;
  static bool get isTablet  => width > Breakpoints.mobileMax && width <= Breakpoints.tabletMax;
  static bool get isDesktop => width > Breakpoints.tabletMax;

  // ── Grid helpers ──────────────────────────────────────────────────────────
  static int get productCols  => Breakpoints.productGridCols(width);
  static int get categoryCols => Breakpoints.categoryGridCols(width);
  static int get storeCols    => Breakpoints.storeGridCols(width);

  // ── Consistent spacing ────────────────────────────────────────────────────
  /// Horizontal page padding.
  static double get pagePadding => isMobile ? 16.0 : isTablet ? 24.0 : 32.0;

  /// Inner card padding.
  static double get cardPadding => isMobile ? 12.0 : 16.0;

  /// Gap between sections.
  static double get sectionGap  => isMobile ? 24.0 : 32.0;

  /// Gap between grid items.
  static double get gridGap     => isMobile ? 12.0 : 16.0;

  // ── Product card aspect ratio ─────────────────────────────────────────────
  static double get productCardRatio => isMobile ? 0.72 : 0.78;

  // ── AppBar height ─────────────────────────────────────────────────────────
  static double get appBarHeight => isMobile ? 56.0 : 64.0;

  // ── Banner height ─────────────────────────────────────────────────────────
  static double get bannerHeight => isMobile ? 180.0 : isTablet ? 240.0 : 300.0;
}
