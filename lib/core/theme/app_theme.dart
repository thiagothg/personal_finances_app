import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'color_extensions.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
  extensions: [
    ExtraColors(success: AppColors.success, warning: AppColors.warning),
  ],
);

final ThemeData lightTheme = ThemeData(
  // fontFamily: GoogleFonts.varelaRound().fontFamily,
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  colorScheme: ThemeData().colorScheme.copyWith(
    secondary: AppColors.primary,
    primary: AppColors.primary,
    brightness: Brightness.light,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: AppColors.primary,
    elevation: 0,
    // textStyle not recommended as const if using ThemeData later, optionally set later
  ),
  // backgroundColor: AppColors.background,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primary,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
  ),
  // textTheme: GoogleFonts.varelaRoundTextTheme(ThemeData.light().textTheme).copyWith(
  //   bodyLarge: const TextStyle(color: Colors.black),
  //   bodyMedium: const TextStyle(color: Colors.black),
  //   button: const TextStyle(color: Colors.white),
  // ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 5,
    color: AppColors.primary,
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.white),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: AppColors.primary,
    hoverColor: AppColors.primary,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    labelStyle: const TextStyle(color: Colors.black),
    hintStyle: const TextStyle(color: Colors.black),
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black, opacity: 1),

  // indicatorColor: Colors.black,
);

final ThemeData darkTheme = ThemeData(
  // fontFamily: GoogleFonts.varelaRound().fontFamily,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black87,
  primaryColor: Colors.blueAccent,
  iconTheme: const IconThemeData(color: Colors.white),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueAccent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // primary: Colors.blueAccent,
      // onPrimary: Colors.white,
      elevation: 5,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    ),
  ),
  cardTheme: CardThemeData(
    shadowColor: Colors.white,
    elevation: 8,
    margin: const EdgeInsets.all(10),
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.white),
    ),
  ),
  // textTheme: GoogleFonts.varelaRoundTextTheme(ThemeData.dark().textTheme),
);
