import 'package:ecommerce_app/features/authentication/controllers/onboarding/controller.onboarding.dart';
import 'package:ecommerce_app/features/authentication/screens/onBoarding/widgets/bottom_navigation_indicator.dart';
import 'package:ecommerce_app/features/authentication/screens/onBoarding/widgets/onboarding_next_button.dart';
import 'package:ecommerce_app/features/authentication/screens/onBoarding/widgets/onboarding_page.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/constants/text_strings.dart';
import 'package:ecommerce_app/util/devices/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          ///Horizontal Scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                  image: EImages.onBoardingImage1,
                  title: ETextStrings.onBoardingTitle1,
                  subtitle: ETextStrings.onBoardingSubTitle1),
              OnBoardingPage(
                  image: EImages.onBoardingImage2,
                  title: ETextStrings.onBoardingTitle2,
                  subtitle: ETextStrings.onBoardingSubTitle2),
              OnBoardingPage(
                  image: EImages.onBoardingImage3,
                  title: ETextStrings.onBoardingTitle3,
                  subtitle: ETextStrings.onBoardingSubTitle3),
            ],
          ),

          ///Skip Button
          Positioned(
            top: EDeviceUtils.getAppBarHeight(),
            right: ESizes.defaultSpace,
            child: TextButton(
              onPressed: () {
                OnBoardingController.instance.skipPage();
              },
              child: const Text("Skip"),
            ),
          ),

          /// Smooth page indicator
          const BottomNavigationIndicator(),

          /// Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
