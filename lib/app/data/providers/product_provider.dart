import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/product_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Product Provider
// ════════════════════════════════════════════════════════════════════════════

class ProductProvider {
  final DioClient _client = DioClient();

  Future<List<ProductModel>> getProducts({
    int? categoryId,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _client.instance.get(
      ApiConfig.products,
      queryParameters: queryParams,
    );

    return (response.data as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductDetail(int id) async {
    final response = await _client.instance.get(ApiConfig.productDetail(id));
    return ProductModel.fromJson(response.data);
  }
}
