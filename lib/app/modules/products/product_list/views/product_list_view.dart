import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_empty_widget.dart';
import '../../../../core/widgets/gm_error_widget.dart';
import '../../../../core/widgets/gm_product_card.dart';
import '../../../../core/widgets/gm_shimmer.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Products'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(R.pagePadding),
            child: TextField(
              controller: controller.searchController,
              onSubmitted: controller.onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Search products by title...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.fetchProducts();
                  },
                ),
              ),
            ),
          ),

          // Products Grid Feed
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: R.pagePadding),
                  child: const GMProductGridShimmer(),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return GMErrorWidget(
                  message: controller.errorMessage.value,
                  onRetry: () => controller.fetchProducts(),
                );
              }

              if (controller.products.isEmpty) {
                return const GMEmptyWidget(
                  title: 'No products found',
                  subtitle: 'Try searching for something else or explore categories.',
                );
              }

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: R.pagePadding, vertical: 8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: R.productCols,
                  childAspectRatio: R.productCardRatio,
                  crossAxisSpacing: R.gridGap,
                  mainAxisSpacing: R.gridGap,
                ),
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return GMProductCard(
                    product: product,
                    onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: {'product_id': product.id}),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
