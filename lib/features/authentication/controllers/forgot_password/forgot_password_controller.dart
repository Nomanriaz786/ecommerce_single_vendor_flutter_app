import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  /// - Send Password Reset Email
  sendPasswordResetEmail() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Processing your request...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!forgotFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // -Send reset email
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());
      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Show success screen

      ELoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);

      // -Redirect

      Get.to(() => ResetPassword(email: email.text.trim()));
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Processing your request...', EImages.docerAnimation);

      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }
      // -Send reset email
      await AuthenticationRepository.instance.sendPasswordResetEmail(email);
      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Show success screen

      ELoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to reset your password'.tr);
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
