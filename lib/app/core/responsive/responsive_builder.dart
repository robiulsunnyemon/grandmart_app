import 'package:flutter/material.dart';
import 'responsive_helper.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Responsive Layout Builder
//
//  Usage:
//    ResponsiveBuilder(
//      mobile: MobileLayout(),
//      tablet: TabletLayout(),    // optional
//      desktop: DesktopLayout(),  // optional
//    )
// ════════════════════════════════════════════════════════════════════════════

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    if (R.isDesktop && desktop != null) return desktop!;
    if (R.isTablet && tablet != null) return tablet!;
    return mobile;
  }
}
