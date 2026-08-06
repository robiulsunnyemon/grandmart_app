import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/providers/category_provider.dart';

class CategoriesController extends GetxController {
  final CategoryProvider _categoryProvider = CategoryProvider();

  final categories = <CategoryModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      categories.value = await _categoryProvider.getCategories();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
