import 'package:ecommerce_app/bindings/general_binding.dart';
import 'package:ecommerce_app/data/authentication_repository/authentication_repository.dart';
import 'package:ecommerce_app/util/constants/colors.dart';
import 'package:ecommerce_app/util/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  /// -Widgets Bindings
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  ///-Flutter Native Splash Screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  /// -Initialization of Firebase & AuthenticationRepository
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  /// -GetsX Local Storage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: EThemeApp.lightTheme,
      darkTheme: EThemeApp.darkTheme,
      initialBinding: GeneralBinding(),
      home: const Scaffold(
        backgroundColor: EColors.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: EColors.white,
          ),
        ),
      ),
    );
  }
}
