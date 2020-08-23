import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/consts/colors.conts.dart';
import '../../shared/widgets/login/rounded_button.dart';
import 'welcome_controller.dart';
import 'widgets/background.dart';

class WelcomePage extends StatefulWidget {
  final String title;
  const WelcomePage({Key key, this.title = "Welcome"}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends ModularState<WelcomePage, WelcomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context)
    );
  }
}


Widget body(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return Background(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "WELCOME TO 52 Weeks",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.05),
          SvgPicture.asset(
            "assets/icons/chat.svg",
            height: size.height * 0.45,
          ),
          SizedBox(height: size.height * 0.05),
          RoundedButton(
            text: "LOGIN",
            press: () {
              
            },
          ),
          RoundedButton(
            text: "SIGN UP",
            color: ColorsConst.primaryLightColor,
            textColor: Colors.black,
            press: () {
              
            },
          ),
        ],
      ),
    ),
  );
}