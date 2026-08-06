import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/wishlist_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Wishlist Provider
//  Raw Dio API calls for wishlist operations.
//  All endpoints require JWT (handled by DioClient interceptor).
// ════════════════════════════════════════════════════════════════════════════

class WishlistProvider {
  final DioClient _client = DioClient();

  /// Fetch full wishlist with embedded product details.
  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _client.instance.get(ApiConfig.wishlist);
    final data = response.data as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    return items
        .map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch only product_ids — lightweight call for toggle state.
  Future<List<int>> getWishlistIds() async {
    final response = await _client.instance.get(ApiConfig.wishlistIds);
    final data = response.data as Map<String, dynamic>;
    return (data['product_ids'] as List<dynamic>)
        .map((e) => e as int)
        .toList();
  }

  /// Add product to wishlist. Returns true on success.
  Future<bool> addToWishlist(int productId) async {
    final response = await _client.instance.post(
      ApiConfig.wishlistToggle(productId),
    );
    return response.data['is_wishlisted'] as bool? ?? true;
  }

  /// Remove product from wishlist. Returns true on success.
  Future<bool> removeFromWishlist(int productId) async {
    final response = await _client.instance.delete(
      ApiConfig.wishlistToggle(productId),
    );
    return !(response.data['is_wishlisted'] as bool? ?? false);
  }

  /// Clear all wishlist items.
  Future<void> clearWishlist() async {
    await _client.instance.delete(ApiConfig.wishlist);
  }
}
