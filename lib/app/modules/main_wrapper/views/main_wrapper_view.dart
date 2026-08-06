import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/config/app_config.dart';
import '../../../core/services/wishlist_service.dart';
import '../controllers/main_wrapper_controller.dart';
import '../../home/views/home_view.dart';
import '../../categories/views/categories_view.dart';
import '../../products/product_list/views/product_list_view.dart';
import '../../wishlist/views/wishlist_view.dart';
import '../../stores/store_list/views/store_list_view.dart';

// ════════════════════════════════════════════════════════════════════════════
//  GRANDMART — Main Wrapper View
//  Bottom Navigation Shell with Wishlist Tab + Badge counter.
// ════════════════════════════════════════════════════════════════════════════

class MainWrapperView extends GetView<MainWrapperController> {
  const MainWrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> pages = [
      const HomeView(),
      const CategoriesView(),
      const ProductListView(),
      if (AppConfig.showWishlistTab) const WishlistView(),
      if (AppConfig.showStoreTab) const StoreListView(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: theme.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Categories',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag_rounded),
              label: 'Products',
            ),
            // ── Wishlist Tab with live badge counter ──────────────────
            if (AppConfig.showWishlistTab)
              BottomNavigationBarItem(
                icon: _WishlistNavIcon(isActive: false),
                activeIcon: _WishlistNavIcon(isActive: true),
                label: 'Wishlist',
              ),
            if (AppConfig.showStoreTab)
              const BottomNavigationBarItem(
                icon: Icon(Icons.storefront_outlined),
                activeIcon: Icon(Icons.storefront_rounded),
                label: 'Stores',
              ),
          ],
        ),
      ),
    );
  }
}

// ── Wishlist Nav Icon with Badge ─────────────────────────────────────────

class _WishlistNavIcon extends StatelessWidget {
  final bool isActive;

  const _WishlistNavIcon({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = WishlistService.to.count;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            isActive ? Icons.favorite_rounded : Icons.favorite_border,
          ),
          if (count > 0)
            Positioned(
              right: -6,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}
