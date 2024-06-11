import 'dart:async';
import 'package:ecommerce_app/common/widgets/success_screens/success_screen_1.dart';
import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/text_strings.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// - Send Email when screen is open and redirect user after specific timer
  @override
  Future<void> onInit() async {
    sendEmailVerificationLink();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// - Send Email verification link
  sendEmailVerificationLink() async {
    try {
      AuthenticationRepository.instance.sendEmailVerification();
      ELoaders.successSnackBar(
          title: 'Email sent',
          message: 'Please check your inbox and verify email');
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// - Timer for auto redirect after email verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.offAll(
          () => SuccessScreen(
            image: EImages.successfullyRegisterationAnimation,
            title: ETextStrings.yourAccountCreatedTitle,
            subtitle: ETextStrings.yourAccountCreatedSubTitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ),
        );
      }
    });
  }

  /// - Manually check email is verified
  checkEmailVerificationStatus() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.offAll(
        () => SuccessScreen(
          image: EImages.successfullyRegisterationAnimation,
          title: ETextStrings.yourAccountCreatedTitle,
          subtitle: ETextStrings.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );
    }
  }
}
