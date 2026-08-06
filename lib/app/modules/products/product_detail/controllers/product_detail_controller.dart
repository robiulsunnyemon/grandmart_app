import 'package:get/get.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/providers/product_provider.dart';

class ProductDetailController extends GetxController {
  final ProductProvider _productProvider = ProductProvider();

  final product = Rxn<ProductModel>();
  final selectedVariantIndex = 0.obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  int productId = 0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('product_id')) {
      productId = args['product_id'];
    }
    fetchDetail();
  }

  void fetchDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      product.value = await _productProvider.getProductDetail(productId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }
}
