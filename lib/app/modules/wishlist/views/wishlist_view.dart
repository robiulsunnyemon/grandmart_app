import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/widgets/gm_empty_widget.dart';
import '../../../core/widgets/gm_error_widget.dart';
import '../../../core/widgets/gm_shimmer.dart';
import '../../../routes/app_pages.dart';
import '../controllers/wishlist_controller.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Wishlist View
// ════════════════════════════════════════════════════════════════════════════

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  WishlistController get controller => Get.isRegistered<WishlistController>()
      ? Get.find<WishlistController>()
      : Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() {
            if (controller.wishlistItems.isEmpty) return const SizedBox.shrink();
            return TextButton.icon(
              onPressed: () => _confirmClearAll(context),
              icon: const Icon(Icons.delete_sweep_outlined, size: 18),
              label: const Text('Clear All'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Padding(
            padding: EdgeInsets.all(R.pagePadding),
            child: const GMProductGridShimmer(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchWishlist,
          );
        }

        if (controller.wishlistItems.isEmpty) {
          return GMEmptyWidget(
            title: 'Your wishlist is empty',
            subtitle: 'Save products you love by tapping the ❤️ icon',
            actionText: 'Explore Products',
            onAction: () => Get.toNamed(Routes.PRODUCT_LIST),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchWishlist,
          child: GridView.builder(
            padding: EdgeInsets.all(R.pagePadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: R.productCols,
              childAspectRatio: R.isMobile ? 0.72 : 0.78,
              crossAxisSpacing: R.cardPadding,
              mainAxisSpacing: R.cardPadding,
            ),
            itemCount: controller.wishlistItems.length,
            itemBuilder: (context, index) {
              final item = controller.wishlistItems[index];
              return _WishlistCard(
                productId: item.productId,
                title: item.product.title,
                thumbnail: item.product.thumbnail,
                price: item.product.price,
                discountPrice: item.product.discountPrice,
                isFeatured: item.product.isFeatured,
                onRemove: () => controller.removeItem(item.productId),
                onTap: () => Get.toNamed(
                  Routes.PRODUCT_DETAIL,
                  arguments: item.productId,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Wishlist'),
        content: const Text('Remove all items from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.clearAll();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// ── Wishlist Product Card ─────────────────────────────────────────────────

class _WishlistCard extends StatelessWidget {
  final int productId;
  final String title;
  final String? thumbnail;
  final double? price;
  final double? discountPrice;
  final bool isFeatured;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _WishlistCard({
    required this.productId,
    required this.title,
    this.thumbnail,
    this.price,
    this.discountPrice,
    this.isFeatured = false,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Remove Button ───────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: thumbnail ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 1.0),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Image.asset(
                          AppConfig.placeholder,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Remove (Heart) button — top right
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Featured badge
                  if (isFeatured)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '★ TOP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Title & Price ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (price != null)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          '${AppConfig.currencySymbol}${(discountPrice ?? price)!.toStringAsFixed(0)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (discountPrice != null)
                          Text(
                            '${AppConfig.currencySymbol}${price!.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: theme.colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
