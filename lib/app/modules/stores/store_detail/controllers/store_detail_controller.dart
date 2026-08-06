import 'package:get/get.dart';
import '../../../../data/models/product_model.dart';
import '../../../../data/models/vendor_store_model.dart';
import '../../../../data/providers/store_provider.dart';

class StoreDetailController extends GetxController {
  final StoreProvider _storeProvider = StoreProvider();

  final store = Rxn<VendorStoreModel>();
  final storeProducts = <ProductModel>[].obs;

  final isLoading = true.obs;
  final errorMessage = ''.obs;

  String storeSlug = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('store_slug')) {
      storeSlug = args['store_slug'];
    }
    fetchStoreDetail();
  }

  void fetchStoreDetail() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _storeProvider.getStoreDetail(storeSlug),
        _storeProvider.getStoreProducts(storeSlug),
      ]);

      store.value = results[0] as VendorStoreModel;
      storeProducts.value = results[1] as List<ProductModel>;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
