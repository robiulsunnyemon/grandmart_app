import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/responsive/responsive_helper.dart';
import '../../../core/widgets/gm_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(R.pagePadding),
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.finish,
                  child: const Text('Skip'),
                ),
              ),

              // Slider Pages
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.slides.length,
                  itemBuilder: (context, index) {
                    final slide = controller.slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: R.hp(35),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 100,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide['title'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: R.sp(22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['subtitle'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: R.sp(14),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Indicator & Next Button
              Obx(
                () => Column(
                  children: [
                    SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.slides.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: theme.primaryColor,
                        dotColor: theme.primaryColor.withOpacity(0.2),
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GMButton(
                      text: controller.currentIndex.value == controller.slides.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: controller.next,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
