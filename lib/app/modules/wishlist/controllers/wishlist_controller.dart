import 'package:get/get.dart';
import '../../../core/services/wishlist_service.dart';
import '../../../data/models/wishlist_model.dart';
import '../../../data/providers/wishlist_provider.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Wishlist Controller
//  Manages the Wishlist Screen data (full items with product details).
//  WishlistService handles the global toggle state.
// ════════════════════════════════════════════════════════════════════════════

class WishlistController extends GetxController {
  final _provider = WishlistProvider();

  final wishlistItems = <WishlistItemModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  /// Fetch full wishlist items with product details.
  Future<void> fetchWishlist() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final items = await _provider.getWishlist();
      wishlistItems.assignAll(items);
    } catch (e) {
      errorMessage.value = 'Failed to load wishlist. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove item — also syncs with WishlistService global state.
  Future<void> removeItem(int productId) async {
    // Optimistic removal from UI
    wishlistItems.removeWhere((item) => item.productId == productId);

    // Sync with global service (handles API call + rollback)
    await WishlistService.to.toggle(productId);
  }

  /// Clear all wishlist items.
  Future<void> clearAll() async {
    try {
      await _provider.clearWishlist();
      wishlistItems.clear();
      WishlistService.to.clearLocal();
      Get.snackbar(
        'Wishlist Cleared',
        'All items have been removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not clear wishlist. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
