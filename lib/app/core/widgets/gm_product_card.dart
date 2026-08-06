import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../services/cart_service.dart';
import '../services/wishlist_service.dart';
import '../storage/storage_service.dart';
import '../../data/models/product_model.dart';
import '../../routes/app_pages.dart';
import '../responsive/responsive_helper.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Product Card Widget (Responsive & Themed)
//  Includes reactive Wishlist Heart button with Optimistic UI.
// ════════════════════════════════════════════════════════════════════════════

class GMProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const GMProductCard({
    required this.product,
    this.onTap,
    super.key,
  });

  void _onWishlistTap() {
    // Login guard — guest users are directed to login
    if (!StorageService.to.isLoggedIn) {
      Get.snackbar(
        'Login Required',
        'Please login to save products to your wishlist.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        mainButton: TextButton(
          onPressed: () => Get.toNamed(Routes.LOGIN),
          child: const Text('Login', style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }
    WishlistService.to.toggle(product.id);
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.dividerColor.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badge + Wishlist Button ──────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      child: product.thumbnail != null &&
                              product.thumbnail!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.thumbnail!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                                size: 36,
                              ),
                            )
                          : const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.grey,
                              size: 40,
                            ),
                    ),
                  ),

                  // ── Discount Badge ──────────────────────────────────
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'OFFER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // ── ❤️ Wishlist Button (Reactive) ────────────────────
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: _onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            child: WishlistService.to.isWishlisted(product.id)
                                ? const Icon(
                                    Icons.favorite,
                                    key: ValueKey('filled'),
                                    color: Colors.red,
                                    size: 18,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    key: const ValueKey('outline'),
                                    color: Colors.grey.shade600,
                                    size: 18,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Product Details ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(R.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: R.sp(14),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${AppConfig.currencySymbol}${product.effectivePrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: R.sp(15),
                                  color: theme.primaryColor,
                                ),
                              ),
                            ),
                            if (product.hasDiscount)
                              Text(
                                '${AppConfig.currencySymbol}${product.originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: R.sp(12),
                                ),
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          CartService.to.addToCart(product);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 16,
                          ),
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
