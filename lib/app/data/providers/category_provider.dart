import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../models/category_model.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Category Provider
// ════════════════════════════════════════════════════════════════════════════

class CategoryProvider {
  final DioClient _client = DioClient();

  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.instance.get(ApiConfig.categories);
    return (response.data as List<dynamic>)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> getFlatCategories() async {
    final response = await _client.instance.get(ApiConfig.categoriesFlat);
    return (response.data as List<dynamic>)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
