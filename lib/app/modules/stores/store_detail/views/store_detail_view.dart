import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_empty_widget.dart';
import '../../../../core/widgets/gm_error_widget.dart';
import '../../../../core/widgets/gm_product_card.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/store_detail_controller.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  const StoreDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.store.value?.storeName ?? 'Store')),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchStoreDetail,
          );
        }

        final s = controller.store.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(R.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Header Card
              Container(
                padding: EdgeInsets.all(R.cardPadding),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: s.logoUrl != null && s.logoUrl!.isNotEmpty
                            ? CachedNetworkImage(imageUrl: s.logoUrl!, fit: BoxFit.cover)
                            : Icon(Icons.storefront, color: theme.primaryColor, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.storeName, style: TextStyle(fontSize: R.sp(18), fontWeight: FontWeight.bold)),
                          if (s.description != null) ...[
                            const SizedBox(height: 4),
                            Text(s.description!, style: TextStyle(fontSize: R.sp(12), color: Colors.grey)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Store Products Section Title
              Text('Store Products', style: TextStyle(fontSize: R.sp(18), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              if (controller.storeProducts.isEmpty)
                const GMEmptyWidget(
                  title: 'No products in this store yet',
                  subtitle: 'This store has not published any products yet.',
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: R.productCols,
                    childAspectRatio: R.productCardRatio,
                    crossAxisSpacing: R.gridGap,
                    mainAxisSpacing: R.gridGap,
                  ),
                  itemCount: controller.storeProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.storeProducts[index];
                    return GMProductCard(
                      product: product,
                      onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: {'product_id': product.id}),
                    );
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}
