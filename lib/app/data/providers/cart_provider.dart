import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/cart_item_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Cart Provider
//  Raw Dio API calls for backend cart CRUD and guest merge operations.
// ════════════════════════════════════════════════════════════════════════════

class CartProvider {
  final DioClient _client = DioClient();

  /// Fetch full user cart from server.
  Future<CartResponseModel> getCart() async {
    final response = await _client.instance.get(ApiConfig.cart);
    return CartResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Add item to cart on server.
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    int? variantId,
    int quantity = 1,
  }) async {
    final response = await _client.instance.post(
      ApiConfig.cartItems,
      data: {
        'product_id': productId,
        'variant_id': variantId,
        'quantity': quantity,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update cart item quantity on server.
  Future<Map<String, dynamic>> updateQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await _client.instance.put(
      ApiConfig.cartItemDetail(cartItemId),
      data: {
        'quantity': quantity,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// Remove item from cart on server.
  Future<Map<String, dynamic>> removeItem(int cartItemId) async {
    final response = await _client.instance.delete(
      ApiConfig.cartItemDetail(cartItemId),
    );
    return response.data as Map<String, dynamic>;
  }

  /// Clear all cart items on server.
  Future<void> clearCart() async {
    await _client.instance.delete(ApiConfig.cartClear);
  }

  /// Merge guest local storage items to server database on login.
  Future<Map<String, dynamic>> mergeCart(List<Map<String, dynamic>> itemsPayload) async {
    final response = await _client.instance.post(
      ApiConfig.cartMerge,
      data: {
        'items': itemsPayload,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
