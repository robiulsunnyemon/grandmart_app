import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/providers/category_provider.dart';
import '../../../data/providers/product_provider.dart';

class HomeController extends GetxController {
  final CategoryProvider _categoryProvider = CategoryProvider();
  final ProductProvider _productProvider = ProductProvider();

  final categories = <CategoryModel>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final recentProducts = <ProductModel>[].obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  void fetchHomeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _categoryProvider.getCategories(),
        _productProvider.getProducts(),
      ]);

      categories.value = results[0] as List<CategoryModel>;
      final allProducts = results[1] as List<ProductModel>;

      featuredProducts.value = allProducts.where((p) => p.isFeatured).toList();
      recentProducts.value = allProducts;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
