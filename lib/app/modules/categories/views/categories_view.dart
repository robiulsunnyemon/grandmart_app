import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/widgets/gm_category_chip.dart';
import '../../../core/widgets/gm_error_widget.dart';
import '../../../routes/app_pages.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchCategories,
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(R.pagePadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: R.categoryCols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return GMCategoryChip(
              category: category,
              onTap: () => Get.toNamed(Routes.PRODUCT_LIST, arguments: {'category_id': category.id}),
            );
          },
        );
      }),
    );
  }
}
