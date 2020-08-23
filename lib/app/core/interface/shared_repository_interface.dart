import 'dart:async';

import 'package:flutter/material.dart';

abstract class ISharedRepositoryInterface {
  String readUserInfo();
  void saveUserInfo(String userInfo);

  Future<ThemeMode> readThemeMode();
  Future<bool>saveThemeMode(ThemeMode themeMode);
}