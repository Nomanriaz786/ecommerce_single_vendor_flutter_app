import 'package:ecommerce_app/util/theme/custom_themes/appBarTheme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/bottomSheetTheme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/checkBoxTheme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/chipTheme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/elevated_button_theme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/outlinedButtonTheme.dart';
import 'package:ecommerce_app/util/theme/custom_themes/textThemes.dart';
import 'package:ecommerce_app/util/theme/custom_themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class EThemeApp {
  EThemeApp._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    textTheme: ETextThemes.lightTextTheme,
    elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
    appBarTheme: EAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: EBottomSheetTheme.lightBottomSheetTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: ETextFieldTheme.lightTextFieldTheme,
    chipTheme: EChipTheme.lightChipTheme,
    checkboxTheme: ECheckBocTheme.lightCheckBoxTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: 'Poppins',
    primaryColor: Colors.blue,
    textTheme: ETextThemes.darkTextTheme,
    elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
    appBarTheme: EAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: EBottomSheetTheme.darkBottomSheetTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: ETextFieldTheme.darkTextFieldTheme,
    chipTheme: EChipTheme.darkChipTheme,
    checkboxTheme: ECheckBocTheme.darkCheckBoxTheme,
  );
}
