import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/services/wishlist_service.dart';
import '../../../../core/storage/storage_service.dart';
import '../../../../core/widgets/gm_button.dart';
import '../../../../core/widgets/gm_error_widget.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          Obx(() {
            final product = controller.product.value;
            if (product == null) return const SizedBox.shrink();
            final wishlisted = WishlistService.to.isWishlisted(product.id);
            return IconButton(
              tooltip: wishlisted ? 'Remove from Wishlist' : 'Add to Wishlist',
              onPressed: () {
                if (!StorageService.to.isLoggedIn) {
                  Get.snackbar(
                    'Login Required',
                    'Please login to save to wishlist.',
                    snackPosition: SnackPosition.BOTTOM,
                    mainButton: TextButton(
                      onPressed: () => Get.toNamed(Routes.LOGIN),
                      child: const Text('Login', style: TextStyle(color: Colors.white)),
                    ),
                  );
                  return;
                }
                WishlistService.to.toggle(product.id);
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  wishlisted ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(wishlisted),
                  color: wishlisted ? Colors.red : null,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchDetail,
          );
        }

        final p = controller.product.value!;
        final selectedVariant = p.variants.isNotEmpty && controller.selectedVariantIndex.value < p.variants.length
            ? p.variants[controller.selectedVariantIndex.value]
            : null;

        final currentPrice = selectedVariant?.discountPrice ?? selectedVariant?.price ?? p.effectivePrice;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(R.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Thumbnail Header Image
                    Container(
                      height: R.hp(32),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: p.thumbnail != null && p.thumbnail!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: p.thumbnail!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, err) => const Icon(Icons.image_not_supported, size: 64),
                              )
                            : const Icon(Icons.shopping_bag_outlined, size: 64),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      p.title,
                      style: TextStyle(
                        fontSize: R.sp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price Section
                    Row(
                      children: [
                        Text(
                          '${AppConfig.currencySymbol}${currentPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: R.sp(22),
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        if (p.hasDiscount) ...[
                          const SizedBox(width: 10),
                          Text(
                            '${AppConfig.currencySymbol}${p.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: R.sp(16),
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Product Variants Selector
                    if (p.variants.isNotEmpty) ...[
                      Text('Select Variant:', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: List.generate(p.variants.length, (index) {
                          final variant = p.variants[index];
                          final isSelected = controller.selectedVariantIndex.value == index;
                          return ChoiceChip(
                            label: Text(variant.sku),
                            selected: isSelected,
                            onSelected: (_) => controller.selectVariant(index),
                            selectedColor: theme.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Description
                    if (p.description != null && p.description!.isNotEmpty) ...[
                      Text('Description:', style: TextStyle(fontSize: R.sp(16), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        p.description!,
                        style: TextStyle(fontSize: R.sp(14), height: 1.5, color: Colors.grey.shade700),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Add to Cart Action Bar Placeholder
            Container(
              padding: EdgeInsets.all(R.pagePadding),
              decoration: BoxDecoration(
                color: theme.cardTheme.color ?? Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: GMButton(
                  text: 'Add to Cart',
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: () {
                    Get.snackbar('Cart', 'Cart management will be enabled in the next phase!', snackPosition: SnackPosition.BOTTOM);
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
