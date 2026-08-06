import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/theme/app_theme_controller.dart';
import '../../../core/widgets/gm_category_chip.dart';
import '../../../core/widgets/gm_error_widget.dart';
import '../../../core/widgets/gm_product_card.dart';
import '../../../core/widgets/gm_shimmer.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          GetBuilder<AppThemeController>(
            builder: (themeCtrl) => IconButton(
              icon: Icon(
                themeCtrl.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              onPressed: themeCtrl.toggleDarkMode,
              tooltip: themeCtrl.isDarkMode ? 'Switch to Light' : 'Switch to Dark',
            ),
          ),
          GetBuilder<AppThemeController>(
            builder: (themeCtrl) => PopupMenuButton<String>(
              icon: const Icon(Icons.palette_outlined),
              tooltip: 'Change Theme',
              onSelected: themeCtrl.switchTheme,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'indigo',
                  child: Row(children: [
                    Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    const Text('Indigo & Amber'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'emerald',
                  child: Row(children: [
                    Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    const Text('Emerald & Orange'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'rose',
                  child: Row(children: [
                    Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFFE11D48), shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    const Text('Rose & Purple'),
                  ]),
                ),
                PopupMenuItem(
                  value: 'ocean',
                  child: Row(children: [
                    Container(width: 14, height: 14, decoration: const BoxDecoration(color: Color(0xFF0284C7), shape: BoxShape.circle)),
                    const SizedBox(width: 10),
                    const Text('Ocean Blue & Teal'),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: GMProductGridShimmer(),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return GMErrorWidget(
            message: controller.errorMessage.value,
            onRetry: controller.fetchHomeData,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => controller.fetchHomeData(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: R.pagePadding, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Carousel
                if (AppConfig.showFeaturedBanner) ...[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: R.bannerHeight,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                    ),
                    items: [1, 2, 3].map((i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [theme.primaryColor, theme.colorScheme.secondary],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 20,
                              top: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GRAND SALE #$i',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Up to 50% Off\nOn Top Vendors',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Categories Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories', style: TextStyle(fontSize: R.sp(18), fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Categories Horizontal Scroll
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final cat = controller.categories[index];
                      return GMCategoryChip(
                        category: cat,
                        onTap: () => Get.toNamed(Routes.PRODUCT_LIST, arguments: {'category_id': cat.id}),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Products Header
                Text('Featured Products', style: TextStyle(fontSize: R.sp(18), fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Responsive Product Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: R.productCols,
                    childAspectRatio: R.productCardRatio,
                    crossAxisSpacing: R.gridGap,
                    mainAxisSpacing: R.gridGap,
                  ),
                  itemCount: controller.recentProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.recentProducts[index];
                    return GMProductCard(
                      product: product,
                      onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: {'product_id': product.id}),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
