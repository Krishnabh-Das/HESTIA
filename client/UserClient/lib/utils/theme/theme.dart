import 'package:flutter/material.dart';

import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: MyAppTextTheme.lightTextTheme,
    appBarTheme: MyAppAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: MyAppBottomSheetTheme.lightMyAppBottomSheetTheme,
    checkboxTheme: MyAppCheckBoxTheme.lightCheckboxTheme,
    chipTheme: MyAppChipTheme.lightChipTheme,
    elevatedButtonTheme: MyAppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyAppOutlinedButtonTheme.lightMyAppOutlinedButtonTheme,
    inputDecorationTheme: MyAppTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: MyAppTextTheme.darkTextTheme,
    appBarTheme: MyAppAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: MyAppBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: MyAppCheckBoxTheme.darkCheckboxTheme,
    chipTheme: MyAppChipTheme.darkChipTheme,
    elevatedButtonTheme: MyAppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyAppOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MyAppTextFormFieldTheme.darkInputDecorationTheme,
  );
}
