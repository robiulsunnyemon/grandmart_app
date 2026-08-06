import 'package:get/get.dart';
import '../../data/providers/wishlist_provider.dart';
import '../storage/storage_service.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Wishlist Service (Global GetX Singleton)
//
//  ★ This is the single source of truth for wishlist state across all screens.
//  ★ Uses RxSet<int> (product IDs) for O(1) isWishlisted() lookups.
//  ★ Implements Optimistic UI — instant toggle, background API, rollback on fail.
//
//  Usage (any widget):
//    Obx(() => Icon(WishlistService.to.isWishlisted(id) ? Icons.favorite : Icons.favorite_border))
//    WishlistService.to.toggle(productId)
// ════════════════════════════════════════════════════════════════════════════

class WishlistService extends GetxService {
  static WishlistService get to => Get.find<WishlistService>();

  final _provider = WishlistProvider();

  /// Reactive set of wishlisted product IDs — O(1) lookup.
  final _wishlistIds = <int>{}.obs;

  /// Total count for Bottom Nav badge.
  int get count => _wishlistIds.length;

  /// Check if a product is in the wishlist.
  bool isWishlisted(int productId) => _wishlistIds.contains(productId);

  // ── Initialization ─────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Only fetch if user is logged in
    if (StorageService.to.isLoggedIn) {
      fetchIds();
    }
  }

  /// Fetch wishlist product IDs from server (lightweight call).
  Future<void> fetchIds() async {
    try {
      final ids = await _provider.getWishlistIds();
      _wishlistIds.assignAll(ids);
    } catch (_) {
      // Silent fail — wishlist IDs are non-critical on startup
    }
  }

  /// Clear local wishlist state (called on logout).
  void clearLocal() {
    _wishlistIds.clear();
  }

  // ── Core: Optimistic Toggle ─────────────────────────────────────────────
  /// Toggle wishlist state with Optimistic UI + rollback on API failure.
  Future<void> toggle(int productId) async {
    final wasWishlisted = isWishlisted(productId);

    // Step 1 — Optimistic update (instant visual feedback)
    if (wasWishlisted) {
      _wishlistIds.remove(productId);
    } else {
      _wishlistIds.add(productId);
    }

    // Step 2 — Background API call
    try {
      if (wasWishlisted) {
        await _provider.removeFromWishlist(productId);
      } else {
        await _provider.addToWishlist(productId);
      }
    } catch (e) {
      // Step 3 — Rollback on failure
      if (wasWishlisted) {
        _wishlistIds.add(productId);
      } else {
        _wishlistIds.remove(productId);
      }
      Get.snackbar(
        'Wishlist Error',
        'Could not update wishlist. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
