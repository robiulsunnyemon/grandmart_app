import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Shimmer Skeleton Loaders
// ════════════════════════════════════════════════════════════════════════════

class GMShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const GMShimmer({
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      highlightColor: isDark ? const Color(0xFF4B5563) : const Color(0xFFF3F4F6),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class GMProductGridShimmer extends StatelessWidget {
  final int count;
  const GMProductGridShimmer({this.count = 6, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        return const GMShimmer(width: double.infinity, height: 220, borderRadius: 16);
      },
    );
  }
}
