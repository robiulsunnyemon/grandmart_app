import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/providers/product_provider.dart';

class ProductListController extends GetxController {
  final ProductProvider _productProvider = ProductProvider();

  final searchController = TextEditingController();
  final products = <ProductModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  int? categoryId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('category_id')) {
      categoryId = args['category_id'];
    }
    fetchProducts();
  }

  void fetchProducts({String? search}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      products.value = await _productProvider.getProducts(
        categoryId: categoryId,
        search: search,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchSubmitted(String value) {
    fetchProducts(search: value.trim());
  }
}
