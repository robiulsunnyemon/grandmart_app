import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../core/config/app_config.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animated Splash Logo
            Lottie.asset(
              AppConfig.splashLottie,
              width: 180,
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 45,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              AppConfig.appName,
              style: TextStyle(
                fontSize: R.sp(28),
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConfig.tagline,
              style: TextStyle(
                fontSize: R.sp(14),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
