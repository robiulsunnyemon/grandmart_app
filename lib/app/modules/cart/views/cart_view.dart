import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/widgets/gm_app_bar.dart';
import '../../../core/widgets/gm_empty_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  CartController get controller => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: GMAppBar(
        title: 'Shopping Cart',
        actions: [
          Obx(() {
            if (controller.cartService.totalItemCount == 0) return const SizedBox.shrink();
            return TextButton.icon(
              onPressed: () => _showClearCartConfirmation(context),
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 20),
              label: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
            );
          }),
        ],
      ),
      body: Obx(() {
        final totalCount = controller.cartService.totalItemCount;

        if (controller.cartService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (totalCount == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(R.pagePadding),
              child: GMEmptyWidget(
                title: 'Your Cart is Empty',
                subtitle: 'Looks like you haven\'t added any items to your shopping cart yet.',
                icon: Icons.shopping_cart_outlined,
                actionText: 'Start Shopping',
                onAction: () => Get.offAllNamed(Routes.MAIN_WRAPPER),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshCart,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: R.pagePadding, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Groups or Local Guest Cart List
                if (controller.cartService.stores.isNotEmpty)
                  ...controller.cartService.stores.map((store) => _buildStoreGroupCard(context, store))
                else
                  _buildGuestCartCard(context),

                const SizedBox(height: 16),

                // Promo / Coupon Code Input Card
                _buildPromoCodeCard(context),

                const SizedBox(height: 16),

                // Order Summary Card
                _buildOrderSummaryCard(context),

                const SizedBox(height: 110), // Spacing for sticky bottom bar
              ],
            ),
          ),
        );
      }),
      bottomSheet: Obx(() {
        if (controller.cartService.totalItemCount == 0) return const SizedBox.shrink();
        return _buildStickyCheckoutBar(context);
      }),
    );
  }

  // ── Multi-Vendor Store Group Card ──────────────────────────────────────────

  Widget _buildStoreGroupCard(BuildContext context, store) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          // Store Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    store.storeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${AppConfig.currencySymbol}${store.storeSubtotal.toStringAsFixed(0)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final item = store.items[index];
              return _buildCartItemTile(context, item);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGuestCartCard(BuildContext context) {
    final theme = Theme.of(context);
    final items = controller.cartService.localGuestItems;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Guest Shopping Cart',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) => _buildCartItemTile(context, items[index]),
          ),
        ],
      ),
    );
  }

  // ── Cart Item Tile (Pixel Perfect Responsive Layout) ──────────────────────

  Widget _buildCartItemTile(BuildContext context, item) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 72,
              height: 72,
              color: Colors.grey.shade100,
              child: item.thumbnail != null && item.thumbnail!.isNotEmpty
                  ? Image.network(item.thumbnail!, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),

          // ── Details Column ──────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Title + Delete Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.productTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => controller.cartService.removeItem(item.cartItemId),
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                      ),
                    ),
                  ],
                ),

                // Variant Chip
                if (item.variant != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Variant: ${item.variant!.sku}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Bottom Row: Price (left) + Quantity Stepper (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price Details (Wrapped in Flexible to prevent overflow)
                    Flexible(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Text(
                            '${AppConfig.currencySymbol}${item.effectivePrice.toStringAsFixed(0)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.discountPrice != null &&
                              item.discountPrice! > 0 &&
                              item.discountPrice! < item.unitPrice)
                            Text(
                              '${AppConfig.currencySymbol}${item.unitPrice.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Quantity Stepper
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => controller.cartService.updateQuantity(
                              item.cartItemId,
                              item.quantity - 1,
                            ),
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Icon(Icons.remove, size: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${item.quantity}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => controller.cartService.updateQuantity(
                              item.cartItemId,
                              item.quantity + 1,
                            ),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Icon(Icons.add, size: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Promo Code Card ────────────────────────────────────────────────────────

  Widget _buildPromoCodeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'Have a Promo Code?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter promo code (e.g. GRAND10)',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: controller.applyPromoCode,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Order Summary Card ─────────────────────────────────────────────────────

  Widget _buildOrderSummaryCard(BuildContext context) {
    final theme = Theme.of(context);
    final service = controller.cartService;

    final subtotal = service.subtotal;
    final savings = service.totalSavings;
    final promoDiscount = controller.promoDiscount.value;
    final deliveryFee = service.estimatedDeliveryFee;
    final netPayable = (subtotal - savings - promoDiscount) + deliveryFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            'Order Summary',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _summaryRow('Subtotal', '${AppConfig.currencySymbol}${subtotal.toStringAsFixed(0)}'),
          if (savings > 0)
            _summaryRow(
              'Discount Savings',
              '- ${AppConfig.currencySymbol}${savings.toStringAsFixed(0)}',
              color: Colors.green,
            ),
          if (promoDiscount > 0)
            _summaryRow(
              'Promo Coupon',
              '- ${AppConfig.currencySymbol}${promoDiscount.toStringAsFixed(0)}',
              color: Colors.green,
            ),
          _summaryRow(
            'Estimated Delivery Fee',
            '${AppConfig.currencySymbol}${deliveryFee.toStringAsFixed(0)}',
          ),
          const Divider(height: 20),
          _summaryRow(
            'Total Payable',
            '${AppConfig.currencySymbol}${netPayable.toStringAsFixed(0)}',
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color, bool isBold = false, double fontSize = 14}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ── Sticky Checkout Bar ───────────────────────────────────────────────────

  Widget _buildStickyCheckoutBar(BuildContext context) {
    final theme = Theme.of(context);
    final service = controller.cartService;
    final netPayable = (service.subtotal - service.totalSavings - controller.promoDiscount.value) + service.estimatedDeliveryFee;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Payable', style: TextStyle(fontSize: 11, color: Colors.grey)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${AppConfig.currencySymbol}${netPayable.toStringAsFixed(0)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Proceed to Checkout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Cart?'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.cartService.clearCart();
              Get.back();
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
