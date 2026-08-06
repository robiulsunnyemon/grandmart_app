import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';
import '../models/vendor_store_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Vendor Store Provider
// ════════════════════════════════════════════════════════════════════════════

class StoreProvider {
  final DioClient _client = DioClient();

  Future<List<VendorStoreModel>> getPublicStores({String? search}) async {
    final queryParams = <String, dynamic>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _client.instance.get(
      ApiConfig.vendorStores,
      queryParameters: queryParams,
    );

    return (response.data as List<dynamic>)
        .map((e) => VendorStoreModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VendorStoreModel> getStoreDetail(String slug) async {
    final response = await _client.instance.get(ApiConfig.storeDetail(slug));
    return VendorStoreModel.fromJson(response.data);
  }

  Future<List<ProductModel>> getStoreProducts(String slug) async {
    final response = await _client.instance.get(ApiConfig.storeProducts(slug));
    return (response.data as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
