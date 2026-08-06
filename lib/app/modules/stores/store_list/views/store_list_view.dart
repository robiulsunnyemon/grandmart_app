import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/responsive/responsive_helper.dart';
import '../../../../core/widgets/gm_empty_widget.dart';
import '../../../../core/widgets/gm_error_widget.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/store_list_controller.dart';

class StoreListView extends GetView<StoreListController> {
  const StoreListView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verified Vendor Stores'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchStores,
          );
        }

        if (controller.stores.isEmpty) {
          return const GMEmptyWidget(
            title: 'No stores available',
            subtitle: 'Check back later for newly approved vendor stores.',
          );
        }

        return ListView.separated(
          padding: EdgeInsets.all(R.pagePadding),
          itemCount: controller.stores.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final store = controller.stores[index];
            return InkWell(
              onTap: () => Get.toNamed(Routes.STORE_DETAIL, arguments: {'store_slug': store.storeSlug}),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.all(R.cardPadding),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: store.logoUrl != null && store.logoUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: store.logoUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, err) => Icon(Icons.storefront, color: theme.primaryColor),
                              )
                            : Icon(Icons.storefront, color: theme.primaryColor, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.storeName,
                            style: TextStyle(fontSize: R.sp(16), fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            store.description ?? 'Official Store on Grandmart',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: R.sp(12), color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
