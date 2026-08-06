// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Screen Breakpoints
//  Defines pixel boundaries for phone, tablet, and desktop layouts.
// ════════════════════════════════════════════════════════════════════════════

class Breakpoints {
  Breakpoints._();

  static const double mobileMax  = 480.0;
  static const double tabletMin  = 481.0;
  static const double tabletMax  = 900.0;
  static const double desktopMin = 901.0;

  // ── Grid Columns ─────────────────────────────────────────────────────────
  static int productGridCols(double width) {
    if (width <= mobileMax) return 2;
    if (width <= tabletMax) return 3;
    return 4;
  }

  static int categoryGridCols(double width) {
    if (width <= mobileMax) return 4;
    if (width <= tabletMax) return 6;
    return 8;
  }

  static int storeGridCols(double width) {
    if (width <= mobileMax) return 1;
    if (width <= tabletMax) return 2;
    return 3;
  }
}
