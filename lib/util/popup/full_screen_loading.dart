import 'package:ecommerce_app/common/widgets/loaders/animation_loader_widget.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible:
          false, // The dialog cannot be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: EHelperFunctions.isDarkMode(Get.context!)
              ? EColors.dark
              : EColors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              EAnimationOverlayWidget(text: text, animation: animation)
            ],
          ),
        ),
      ),
    );
  }

  /// -Close the currently open dialog
  /// -This method does not return anything
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // Close the dialog using Navigator
  }
}
