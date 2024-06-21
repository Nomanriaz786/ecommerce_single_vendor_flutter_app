import 'dart:async';

import 'package:ecommerce_app/Admin_Panel/screen/manage_users/display_all_users.dart';
import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/data/authentication_repository/user_repository.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/personalization/models/user_model.dart';
import 'package:ecommerce_app/features/personalization/screens/profile/widgets/re_authenticate_user_form.dart';
import 'package:ecommerce_app/util/constants/image_strings.dart';
import 'package:ecommerce_app/util/constants/sizes.dart';
import 'package:ecommerce_app/util/helpers/network_manager.dart';
import 'package:ecommerce_app/util/popup/full_screen_loading.dart';
import 'package:ecommerce_app/util/popup/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final imageLoading = false.obs;
  RxBool refreshData = true.obs;

  late var firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  var selectedRoles = <String>[].obs;
  final List<String> availableRoles = ['admin', 'user', 'editor'];

  GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  final hidePassword = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  // - Fetch user data
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final userData = await userRepository.fetchUserDetails();
      user(userData);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // - Save user data from any authentication
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // -First update the RX user and then check if user data already exist. If not, store new data
      fetchUserRecord();
      // -If no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          // - Create first and last names
          final nameParts =
              UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // - Map Data
          final user = UserModel(
            id: userCredentials.user!.uid,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            firstName: nameParts[0],
            lastName:
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
            userName: username,
            profilePicture: userCredentials.user!.photoURL ?? '',
            roles: ['user'],
          );

          // - Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      ELoaders.warningSnackBar(
          title: 'Data not saved',
          message:
              'Something went wrong while saving your information. You can re-save your data in the profile');
    }
  }

  // - Delete account warning
  void deleteAccountWarningPopUp() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(ESizes.md),
      title: 'Delete Account',
      middleText:
          'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: ESizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Cancel')),
    );
  }

  // - Delete user account
  void deleteUserAccount() async {
    try {
      EFullScreenLoader.openLoadingDialog('Processing', EImages.docerAnimation);

      // - ReAuthenticate user
      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        // - Re verify auth
        if (provider == 'google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          EFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if (provider == 'password') {
          EFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // - Re Authentication
  Future<void> reAuthenticateEmailAndPassword() async {
    try {
      // -Start Loading
      EFullScreenLoader.openLoadingDialog(
          'Processing...', EImages.docerAnimation);
      // -Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Form Validation
      if (!reAuthFormKey.currentState!.validate()) {
        // -Remove Loader
        EFullScreenLoader.stopLoading();
        return;
      }

      // -Delete user account
      await AuthenticationRepository.instance
          .reAuthenticateWithEmailAndPassword(
              verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();

      // -Remove Loader
      EFullScreenLoader.stopLoading();

      // -Show success screen

      // -Move to login screen

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      // -Remove Loader
      EFullScreenLoader.stopLoading();
      // -Show some generic error to the user
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // - Upload any picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null) {
        // -Upload image
        imageLoading.value = true;
        final imageUrl =
            await userRepository.uploadImage('User/Images/Profile/', image);
        // -Update user image record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();
        // -Show success message
        ELoaders.successSnackBar(
            title: 'Congratulations!',
            message: 'Your profile image has been updated');
      }
    } catch (e) {
      // -Show some generic error to the user
      ELoaders.errorSnackBar(
          title: 'Oh Snap!', message: 'Something went wrong : $e');
    } finally {
      imageLoading.value = false;
    }
  }

/*----------------------------Admin Panel---------------------------------*/
  void loadUser(UserModel user) {
    firstName.text = user.firstName;
    lastName.text = user.lastName;
    email.text = user.email;
    phoneNumber.text = user.phoneNumber;
    selectedRoles.clear();
    selectedRoles.value = List<String>.from(user.roles);
  }

  Future<List<UserModel>> getUsers() {
    return UserRepository.instance.getAllUsers();
  }

  Future<void> updateUser(String id, UserModel user) async {
    try {
      EFullScreenLoader.openLoadingDialog(
          'Processing Information...', EImages.docerAnimation);
      final updatedUser = UserModel(
        id: user.id,
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        phoneNumber: phoneNumber.text,
        roles: selectedRoles.toList(),
        userName: user.userName,
        profilePicture: user.profilePicture,
      );
      await UserRepository.instance.updateUser(updatedUser);

      EFullScreenLoader.stopLoading();
      ELoaders.successSnackBar(title: 'Wao!', message: 'User is updated');
      refreshData.toggle();
      clearControllers();
      Get.to(() => const DisplayUsersScreen());
    } catch (e) {
      ELoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // -Clear controllers
  void clearControllers() {
    firstName.clear();
    lastName.clear();
    email.clear();
    phoneNumber.clear();
    selectedRoles.clear();
  }

  Future<void> deleteUser(String userId) async {
    await UserRepository.instance.deleteUser(userId);
  }
}
