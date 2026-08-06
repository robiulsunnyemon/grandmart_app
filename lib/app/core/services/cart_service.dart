import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/providers/cart_provider.dart';
import '../storage/storage_service.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Cart Service (Global GetX Singleton)
//
//  ★ Single source of truth for cart state across the entire Flutter app.
//  ★ Supports Hybrid Mode: Local GetStorage (Guest) & Server Database (Logged-in).
//  ★ Automatically merges guest cart to server DB upon successful login.
// ════════════════════════════════════════════════════════════════════════════

class CartService extends GetxService {
  static CartService get to => Get.find<CartService>();

  final CartProvider _provider = CartProvider();

  // Reactive State
  final stores = <CartStoreGroupModel>[].obs;
  final localGuestItems = <CartItemModel>[].obs;
  final isLoading = false.obs;

  // ── Computed Getters ───────────────────────────────────────────────────────

  /// Total item count across all stores / guest cart.
  int get totalItemCount {
    if (StorageService.to.isLoggedIn) {
      int count = 0;
      for (var store in stores) {
        for (var item in store.items) {
          count += item.quantity;
        }
      }
      return count;
    } else {
      return localGuestItems.fold(0, (sum, item) => sum + item.quantity);
    }
  }

  /// Combined Subtotal of all items.
  double get subtotal {
    if (StorageService.to.isLoggedIn) {
      return stores.fold(0.0, (sum, store) => sum + store.storeSubtotal);
    } else {
      return localGuestItems.fold(0.0, (sum, item) => sum + (item.unitPrice * item.quantity));
    }
  }

  /// Total Discount Savings.
  double get totalSavings {
    if (StorageService.to.isLoggedIn) {
      double savings = 0.0;
      for (var store in stores) {
        for (var item in store.items) {
          savings += item.savings * item.quantity;
        }
      }
      return savings;
    } else {
      return localGuestItems.fold(0.0, (sum, item) => sum + (item.savings * item.quantity));
    }
  }

  /// Estimated Delivery Fee (e.g. 60 BDT per store).
  double get estimatedDeliveryFee {
    if (totalItemCount == 0) return 0.0;
    if (StorageService.to.isLoggedIn) {
      return stores.length * 60.0;
    } else {
      return 60.0;
    }
  }

  /// Grand Total Payable Amount.
  double get grandTotal => (subtotal - totalSavings) + estimatedDeliveryFee;

  // ── Initialization ────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    initCart();
  }

  Future<void> initCart() async {
    if (StorageService.to.isLoggedIn) {
      await fetchServerCart();
    } else {
      _loadLocalGuestCart();
    }
  }

  /// Fetch cart data from server for logged-in user.
  Future<void> fetchServerCart() async {
    isLoading.value = true;
    try {
      final cartResponse = await _provider.getCart();
      stores.assignAll(cartResponse.stores);
    } catch (_) {
      // Handle network error gracefully
    } finally {
      isLoading.value = false;
    }
  }

  // ── Add to Cart (Guest or Logged In) ───────────────────────────────────────

  Future<void> addToCart(
    ProductModel product, {
    ProductVariantModel? variant,
    int quantity = 1,
  }) async {
    final int variantId = variant?.id ?? (product.variants.isNotEmpty ? product.variants[0].id : 0);
    final double unitPrice = variant != null
        ? variant.price
        : product.originalPrice;
    final double? discountPrice = variant != null
        ? variant.discountPrice
        : (product.hasDiscount ? product.effectivePrice : null);
    final int stockAvailable = variant?.stockQuantity ??
        (product.variants.isNotEmpty ? product.variants.first.stockQuantity : 99);

    if (StorageService.to.isLoggedIn) {
      try {
        await _provider.addToCart(
          productId: product.id,
          variantId: variantId > 0 ? variantId : null,
          quantity: quantity,
        );
        await fetchServerCart();
        Get.snackbar(
          'Added to Cart',
          '${product.title} has been added to your cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade800,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          'Cart Error',
          'Failed to add item to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade800,
          colorText: Colors.white,
        );
      }
    } else {
      // Local Guest Cart Logic
      final existingIndex = localGuestItems.indexWhere(
        (item) => item.productId == product.id && (variantId == 0 || item.variant?.id == variantId),
      );

      if (existingIndex != -1) {
        final existingItem = localGuestItems[existingIndex];
        final newQty = existingItem.quantity + quantity;
        if (stockAvailable > 0 && newQty > stockAvailable) {
          Get.snackbar('Stock Limit', 'Only $stockAvailable items available in stock');
          return;
        }
        localGuestItems[existingIndex] = existingItem.copyWith(quantity: newQty);
      } else {
        final effectivePrice = (discountPrice != null && discountPrice > 0 && discountPrice < unitPrice)
            ? discountPrice
            : unitPrice;

        final newItem = CartItemModel(
          cartItemId: DateTime.now().millisecondsSinceEpoch,
          productId: product.id,
          productTitle: product.title,
          productSlug: product.slug,
          thumbnail: product.thumbnail,
          variant: variant != null
              ? CartVariantModel(
                  id: variant.id,
                  sku: variant.sku,
                  price: variant.price,
                  discountPrice: variant.discountPrice,
                  stockQuantity: variant.stockQuantity,
                  variantAttributes: variant.variantAttributes,
                )
              : null,
          unitPrice: unitPrice,
          discountPrice: discountPrice,
          effectivePrice: effectivePrice,
          quantity: quantity,
          stockAvailable: stockAvailable,
          itemTotal: effectivePrice * quantity,
        );
        localGuestItems.add(newItem);
      }
      _saveLocalGuestCart();
      Get.snackbar(
        'Added to Cart',
        '${product.title} has been added to your guest cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // ── Update Quantity ───────────────────────────────────────────────────────

  Future<void> updateQuantity(int cartItemId, int newQty) async {
    if (newQty < 1) return;

    if (StorageService.to.isLoggedIn) {
      try {
        await _provider.updateQuantity(cartItemId: cartItemId, quantity: newQty);
        await fetchServerCart();
      } catch (e) {
        Get.snackbar('Cart Error', 'Could not update item quantity');
      }
    } else {
      final index = localGuestItems.indexWhere((item) => item.cartItemId == cartItemId);
      if (index != -1) {
        final item = localGuestItems[index];
        if (item.stockAvailable > 0 && newQty > item.stockAvailable) {
          Get.snackbar('Stock Limit', 'Only ${item.stockAvailable} items available in stock');
          return;
        }
        localGuestItems[index] = item.copyWith(quantity: newQty);
        _saveLocalGuestCart();
      }
    }
  }

  // ── Remove Item ───────────────────────────────────────────────────────────

  Future<void> removeItem(int cartItemId) async {
    if (StorageService.to.isLoggedIn) {
      try {
        await _provider.removeItem(cartItemId);
        await fetchServerCart();
        Get.snackbar('Cart Updated', 'Item removed from cart');
      } catch (e) {
        Get.snackbar('Cart Error', 'Could not remove item');
      }
    } else {
      localGuestItems.removeWhere((item) => item.cartItemId == cartItemId);
      _saveLocalGuestCart();
      Get.snackbar('Cart Updated', 'Item removed from cart');
    }
  }

  // ── Clear Cart ────────────────────────────────────────────────────────────

  Future<void> clearCart() async {
    if (StorageService.to.isLoggedIn) {
      try {
        await _provider.clearCart();
        stores.clear();
      } catch (_) {}
    } else {
      localGuestItems.clear();
      StorageService.to.remove('guest_cart');
    }
  }

  // ── Guest to Server Merge on Login Event ──────────────────────────────────

  Future<void> mergeGuestCartOnLogin() async {
    if (localGuestItems.isEmpty) {
      await fetchServerCart();
      return;
    }

    final payload = localGuestItems
        .map((item) => {
              'product_id': item.productId,
              'variant_id': item.variant?.id,
              'quantity': item.quantity,
            })
        .toList();

    try {
      await _provider.mergeCart(payload);
      localGuestItems.clear();
      StorageService.to.remove('guest_cart');
      await fetchServerCart();
    } catch (_) {
      // Silently sync server cart if merge fails
      await fetchServerCart();
    }
  }

  // ── Guest Local Storage Persistence ───────────────────────────────────────

  void _saveLocalGuestCart() {
    final rawList = localGuestItems.map((e) => e.toJson()).toList();
    StorageService.to.write('guest_cart', rawList);
  }

  void _loadLocalGuestCart() {
    final rawList = StorageService.to.read<List>('guest_cart');
    if (rawList != null) {
      localGuestItems.value = rawList
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }
  }

  void clearLocalStateOnLogout() {
    stores.clear();
    localGuestItems.clear();
  }
}
