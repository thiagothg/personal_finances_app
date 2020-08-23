import 'package:flutter/material.dart';

import '../consts/colors.conts.dart';
import '../interface/theme_app_interface.dart';



class AppThemeLight implements IThemeAppInterface {
  @override
  ThemeData getTheme() {
    return ThemeData(
      fontFamily: 'Google',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: ColorsConst.primaryColor,
      primaryColorLight: ColorsConst.primaryLightColor,
      buttonColor: ColorsConst.primaryColor,
      buttonTheme: ButtonThemeData(
        height: 50,
        minWidth: double.infinity,
        buttonColor: ColorsConst.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        textTheme: ButtonTextTheme.primary
      ),
      iconTheme: IconThemeData(
        color: Colors.white
      )
    );
  }

  @override
  String themeToString() {
    return ThemeMode.light.toString();
  }
  
}