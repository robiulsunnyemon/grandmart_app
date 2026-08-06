import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/cart_service.dart';

class CartController extends GetxController {
  final CartService cartService = CartService.to;

  final promoCodeController = TextEditingController();
  final appliedPromoCode = ''.obs;
  final promoDiscount = 0.0.obs;

  Future<void> refreshCart() async {
    await cartService.initCart();
  }

  void applyPromoCode() {
    final code = promoCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      Get.snackbar('Promo Code', 'Please enter a valid promo code');
      return;
    }

    if (code == 'GRAND10') {
      appliedPromoCode.value = code;
      promoDiscount.value = 100.0; // 100 BDT flat discount
      Get.snackbar(
        'Promo Applied!',
        'You saved ৳100 with promo code $code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade800,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Invalid Promo',
        'Promo code $code is invalid or expired',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
      );
    }
  }

  void removePromoCode() {
    appliedPromoCode.value = '';
    promoDiscount.value = 0.0;
    promoCodeController.clear();
  }

  void proceedToCheckout() {
    if (cartService.totalItemCount == 0) {
      Get.snackbar('Empty Cart', 'Your shopping cart is empty');
      return;
    }
    Get.snackbar(
      'Checkout',
      'Proceeding to Checkout...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.indigo.shade800,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    promoCodeController.dispose();
    super.onClose();
  }
}
