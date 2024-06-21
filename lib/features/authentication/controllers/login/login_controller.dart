import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/features/personalization/controllers/user_controller.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final userController = Get.put(UserController());

  /// - Variables
  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  /// - Login with Email and Password
  Future<void> signInWithEmailAndPassword() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Logging you in...', EImages.docerAnimation);

      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!loginFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Save data if remember me is selected
      if (rememberMe.value) {
        localStorage.write("REMEMBER_ME_EMAIL", email.text.trim());
        localStorage.write("REMEMBER_ME_PASSWORD", password.text.trim());
      }

      // -Login user using email and password authentication
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// - Sign in with google
  Future<void> signInWithGoogle() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Signing you in...', EImages.docerAnimation);

      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // - Google sign in
      final userCredential =
          await AuthenticationRepository.instance.signInWithGoogle();

      // - Save User Record
      userController.saveUserRecord(userCredential);

      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Screen Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
