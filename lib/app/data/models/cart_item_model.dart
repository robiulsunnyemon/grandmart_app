// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Cart Models
// ════════════════════════════════════════════════════════════════════════════

double _parseDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

double? _parseNullableDouble(dynamic val) {
  if (val == null) return null;
  if (val is num) return val.toDouble();
  return double.tryParse(val.toString());
}

class CartVariantModel {
  final int id;
  final String sku;
  final double price;
  final double? discountPrice;
  final int stockQuantity;
  final Map<String, dynamic> variantAttributes;

  CartVariantModel({
    required this.id,
    required this.sku,
    required this.price,
    this.discountPrice,
    required this.stockQuantity,
    this.variantAttributes = const {},
  });

  factory CartVariantModel.fromJson(Map<String, dynamic> json) {
    return CartVariantModel(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      price: _parseDouble(json['price']),
      discountPrice: _parseNullableDouble(json['discount_price']),
      stockQuantity: json['stock_quantity'] ?? 0,
      variantAttributes: json['variant_attributes'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'price': price,
      'discount_price': discountPrice,
      'stock_quantity': stockQuantity,
      'variant_attributes': variantAttributes,
    };
  }
}

class CartItemModel {
  final int cartItemId;
  final int productId;
  final String productTitle;
  final String productSlug;
  final String? thumbnail;
  final CartVariantModel? variant;
  final double unitPrice;
  final double? discountPrice;
  final double effectivePrice;
  final int quantity;
  final int stockAvailable;
  final double itemTotal;

  CartItemModel({
    required this.cartItemId,
    required this.productId,
    required this.productTitle,
    required this.productSlug,
    this.thumbnail,
    this.variant,
    required this.unitPrice,
    this.discountPrice,
    required this.effectivePrice,
    required this.quantity,
    required this.stockAvailable,
    required this.itemTotal,
  });

  double get savings => (unitPrice > effectivePrice) ? (unitPrice - effectivePrice) : 0.0;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final unitP = _parseDouble(json['unit_price'] ?? json['price']);
    final discP = _parseNullableDouble(json['discount_price']);
    final effP = _parseDouble(json['effective_price'] ?? json['discount_price'] ?? json['unit_price'] ?? json['price']);

    return CartItemModel(
      cartItemId: json['cart_item_id'] ?? json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productTitle: json['product_title'] ?? json['title'] ?? '',
      productSlug: json['product_slug'] ?? json['slug'] ?? '',
      thumbnail: json['thumbnail'],
      variant: json['variant'] != null
          ? CartVariantModel.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
      unitPrice: unitP,
      discountPrice: discP,
      effectivePrice: effP,
      quantity: json['quantity'] ?? 1,
      stockAvailable: json['stock_available'] ?? json['stock'] ?? 99,
      itemTotal: _parseDouble(json['item_total']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'product_id': productId,
      'product_title': productTitle,
      'product_slug': productSlug,
      'thumbnail': thumbnail,
      'variant': variant?.toJson(),
      'unit_price': unitPrice,
      'discount_price': discountPrice,
      'effective_price': effectivePrice,
      'quantity': quantity,
      'stock_available': stockAvailable,
      'item_total': itemTotal,
    };
  }

  CartItemModel copyWith({
    int? quantity,
    double? itemTotal,
  }) {
    final newQty = quantity ?? this.quantity;
    return CartItemModel(
      cartItemId: cartItemId,
      productId: productId,
      productTitle: productTitle,
      productSlug: productSlug,
      thumbnail: thumbnail,
      variant: variant,
      unitPrice: unitPrice,
      discountPrice: discountPrice,
      effectivePrice: effectivePrice,
      quantity: newQty,
      stockAvailable: stockAvailable,
      itemTotal: itemTotal ?? (effectivePrice * newQty),
    );
  }
}

class CartStoreGroupModel {
  final int storeId;
  final String storeName;
  final String? storeSlug;
  final String? logoUrl;
  final List<CartItemModel> items;
  final double storeSubtotal;

  CartStoreGroupModel({
    required this.storeId,
    required this.storeName,
    this.storeSlug,
    this.logoUrl,
    required this.items,
    required this.storeSubtotal,
  });

  factory CartStoreGroupModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return CartStoreGroupModel(
      storeId: json['store_id'] ?? 0,
      storeName: json['store_name'] ?? 'Grandmart Store',
      storeSlug: json['store_slug'],
      logoUrl: json['logo_url'],
      items: itemsList.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      storeSubtotal: _parseDouble(json['store_subtotal']),
    );
  }
}

class CartSummaryModel {
  final int totalItems;
  final double subtotal;
  final double discountTotal;
  final double estimatedDeliveryFee;
  final double grandTotal;

  CartSummaryModel({
    required this.totalItems,
    required this.subtotal,
    required this.discountTotal,
    required this.estimatedDeliveryFee,
    required this.grandTotal,
  });

  factory CartSummaryModel.fromJson(Map<String, dynamic> json) {
    return CartSummaryModel(
      totalItems: json['total_items'] ?? 0,
      subtotal: _parseDouble(json['subtotal']),
      discountTotal: _parseDouble(json['discount_total']),
      estimatedDeliveryFee: _parseDouble(json['estimated_delivery_fee']),
      grandTotal: _parseDouble(json['grand_total']),
    );
  }
}

class CartResponseModel {
  final List<CartStoreGroupModel> stores;
  final CartSummaryModel summary;

  CartResponseModel({
    required this.stores,
    required this.summary,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    final storesList = json['stores'] as List<dynamic>? ?? [];
    return CartResponseModel(
      stores: storesList.map((e) => CartStoreGroupModel.fromJson(e as Map<String, dynamic>)).toList(),
      summary: CartSummaryModel.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }
}
