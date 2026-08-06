// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Vendor Store Public Model
// ════════════════════════════════════════════════════════════════════════════

class VendorStoreModel {
  final int id;
  final int userId;
  final String storeName;
  final String storeSlug;
  final String? logoUrl;
  final String? bannerUrl;
  final String? description;
  final bool isApproved;

  VendorStoreModel({
    required this.id,
    required this.userId,
    required this.storeName,
    required this.storeSlug,
    this.logoUrl,
    this.bannerUrl,
    this.description,
    required this.isApproved,
  });

  factory VendorStoreModel.fromJson(Map<String, dynamic> json) {
    return VendorStoreModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeSlug: json['store_slug'] ?? '',
      logoUrl: json['logo_url'],
      bannerUrl: json['banner_url'],
      description: json['description'],
      isApproved: json['is_approved'] ?? true,
    );
  }
}
