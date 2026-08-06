// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Product Model & Product Variant Model
// ════════════════════════════════════════════════════════════════════════════

class ProductVariantModel {
  final int id;
  final int productId;
  final String sku;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final String? imageUrl;
  final Map<String, dynamic> variantAttributes;

  ProductVariantModel({
    required this.id,
    required this.productId,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.stockQuantity,
    this.imageUrl,
    this.variantAttributes = const {},
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      sku: json['sku'] ?? '',
      price: (json['price'] != null) ? double.parse(json['price'].toString()) : 0.0,
      discountPrice: (json['discount_price'] != null)
          ? double.parse(json['discount_price'].toString())
          : null,
      stockQuantity: json['stock_quantity'] ?? 0,
      imageUrl: json['image_url'],
      variantAttributes: json['variant_attributes'] is Map
          ? Map<String, dynamic>.from(json['variant_attributes'])
          : {},
    );
  }
}

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final int vendorId;
  final int categoryId;
  final String? thumbnail;
  final List<String> images;
  final Map<String, dynamic> attributes;
  final String status;
  final bool isFeatured;
  final List<ProductVariantModel> variants;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    required this.vendorId,
    required this.categoryId,
    this.thumbnail,
    this.images = const [],
    this.attributes = const {},
    required this.status,
    required this.isFeatured,
    this.variants = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      vendorId: json['vendor_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      thumbnail: json['thumbnail'],
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      attributes: json['attributes'] is Map
          ? Map<String, dynamic>.from(json['attributes'])
          : {},
      status: json['status'] ?? 'published',
      isFeatured: json['is_featured'] ?? false,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariantModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Price helper — gets lowest active price
  double get effectivePrice {
    if (variants.isEmpty) return 0.0;
    final first = variants.first;
    return first.discountPrice ?? first.price;
  }

  double get originalPrice {
    if (variants.isEmpty) return 0.0;
    return variants.first.price;
  }

  bool get hasDiscount {
    if (variants.isEmpty) return false;
    return variants.first.discountPrice != null && variants.first.discountPrice! < variants.first.price;
  }
}
