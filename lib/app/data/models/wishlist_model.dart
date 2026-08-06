// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Wishlist Models
// ════════════════════════════════════════════════════════════════════════════

/// Embedded product summary inside a wishlist item.
class WishlistProductSummary {
  final int id;
  final String title;
  final String slug;
  final String? thumbnail;
  final double? price;
  final double? discountPrice;
  final bool isFeatured;

  WishlistProductSummary({
    required this.id,
    required this.title,
    required this.slug,
    this.thumbnail,
    this.price,
    this.discountPrice,
    this.isFeatured = false,
  });

  factory WishlistProductSummary.fromJson(Map<String, dynamic> json) {
    return WishlistProductSummary(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      thumbnail: json['thumbnail'],
      price: (json['price'] as num?)?.toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      isFeatured: json['is_featured'] ?? false,
    );
  }
}

/// Single item in the wishlist list response.
class WishlistItemModel {
  final int id;
  final int productId;
  final String addedAt;
  final WishlistProductSummary product;

  WishlistItemModel({
    required this.id,
    required this.productId,
    required this.addedAt,
    required this.product,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      addedAt: json['added_at'] ?? '',
      product: WishlistProductSummary.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
