import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'core/consts/routers_const.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      title: 'Flutter Slidy',
      theme: Modular.get<AppController>().themeApp.getTheme(),
      themeMode: Modular.get<AppController>().themeMode,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      initialRoute: RoutersConst.splash,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
