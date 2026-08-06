import 'package:get/get.dart';
import '../../../../data/models/vendor_store_model.dart';
import '../../../../data/providers/store_provider.dart';

class StoreListController extends GetxController {
  final StoreProvider _storeProvider = StoreProvider();

  final stores = <VendorStoreModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStores();
  }

  void fetchStores({String? search}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      stores.value = await _storeProvider.getPublicStores(search: search);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
