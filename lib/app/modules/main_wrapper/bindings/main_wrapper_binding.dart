import 'package:get/get.dart';
import '../controllers/main_wrapper_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../categories/controllers/categories_controller.dart';
import '../../products/product_list/controllers/product_list_controller.dart';
import '../../stores/store_list/controllers/store_list_controller.dart';

class MainWrapperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainWrapperController>(() => MainWrapperController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<ProductListController>(() => ProductListController());
    Get.lazyPut<StoreListController>(() => StoreListController());
  }
}
