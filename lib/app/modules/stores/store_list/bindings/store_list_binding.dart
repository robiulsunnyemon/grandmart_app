import 'package:get/get.dart';
import '../controllers/store_list_controller.dart';

class StoreListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreListController>(() => StoreListController());
  }
}
