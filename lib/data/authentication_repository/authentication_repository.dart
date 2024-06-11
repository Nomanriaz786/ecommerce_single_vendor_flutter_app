import 'package:ecommerce_app/bottom_navigation_bar.dart';
import 'package:ecommerce_app/data/authentication_repository/user_repository.dart';
import 'package:ecommerce_app/exceptions/firebase_auth_exceptions.dart';
import 'package:ecommerce_app/exceptions/firebase_exceptions.dart';
import 'package:ecommerce_app/exceptions/format_exceptions.dart';
import 'package:ecommerce_app/exceptions/platform_exceptions.dart';
import 'package:ecommerce_app/features/authentication/screens/login/login.dart';
import 'package:ecommerce_app/features/authentication/screens/onBoarding/on_boarding_screen.dart';
import 'package:ecommerce_app/features/authentication/screens/signup/widgets/verify_email.dart';
import 'package:ecommerce_app/util/local_storage/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// -Variable
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Getter to get authenticated user data
  User? get authUser => _auth.currentUser;

  /// - Run on main.dart file
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// -Function to show relevant screen
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        // - Initialize user specific storage
        await ELocalStorage.init(user.uid);
        Get.offAll(() => const BottomNavigation());
      } else {
        Get.offAll(() => const VerifyEmailScreen());
      }
    } else {
      // local storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      // -Check if the user first time launching the app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() =>
              const LoginScreen()) // - Redirect to login screen if not first time
          : Get.offAll(() =>
              const OnBoarding()); // - Redirect to onBoarding screen if it's first time
    }
  }

  /*-----------------------------------Email & Password Sign In------------------------------*/
  /// [EmailAuthentication]  -Login
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

  /// [EmailAuthentication]  -Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

  /// [EmailAuthentication]  - Mail_Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

  /// [ForgotPassword]  - Forgot Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

  /// [ReAuthentication]  -Re Authenticate user
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // - Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      // - ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

/*-----------------------------------Federated Email and Social Sign in-----------------------------------*/
  /// [GoogleAuthentication]  - Google SignIn
  Future<UserCredential> signInWithGoogle() async {
    try {
      // -Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // - Obtain the details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      // -Create the new credentials
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // -Once signed in, return the  credentials
      return _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

/*----------------------------------./end Federated Email and Social Sign in------------------------------*/
  /// [LogoutUser]  - For Authentication
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }

  /// [DeleteAccount]  - For deleting account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserData(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, Please try again later';
    }
  }
}
