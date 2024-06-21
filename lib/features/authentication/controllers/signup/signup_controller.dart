import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/data/authentication_repository/user_repository.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/widgets/verify_email.dart';
import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final privacyPolicy = true.obs;
  final hidePassword = true.obs;
  final email = TextEditingController();
  final phone = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// Sign-up
  Future<void> signup() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'We are processing your information...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!signupFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Privacy Policy Check

      if (!privacyPolicy.value) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        ELoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'In order to create account, you have to must accept the Privacy and Policy');
      }

      // -Register user in the Firebase Authentication and store data in Firebase

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // -Save Authenticated user data in Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email.text.trim(),
        phoneNumber: phone.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        userName: username.text.trim(),
        profilePicture: '',
        roles: ['User'],
      );
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Show success screen

      ELoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! verify email to continue');

      // -Move to email verification screen

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
