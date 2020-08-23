import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/consts/assets_const.dart';
import '../../shared/widgets/custom_icon_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/login/already_have_an_account_acheck.dart';
import '../../shared/widgets/login/rounded_button.dart';
import '../login/widgets/background.dart';
import '../login/widgets/or_divider.dart';
import '../login/widgets/social_icon.dart';
import 'sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  final String title;
  const SignUpPage({Key key, this.title = "SignUp"}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ModularState<SignUpPage, SignUpController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      body: body(context, controller)
    );
  }
}

Widget body(BuildContext context, SignUpController controller) {
  var size = MediaQuery.of(context).size;
  
  return Background(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/signup.svg",
            height: size.height * 0.35,
          ),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'Name',
                // prefix: Icon(
                //   Icons.account_circle,
                //   color: Theme.of(context).primaryColor,
                // ),
                textInputType: TextInputType.text,
                onChanged: controller.setName,
                enabled: !controller.loading,
              );
            }
          ),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'Your Email',
                // prefix: Icon(
                //   Icons.account_circle,
                //   color: Theme.of(context).primaryColor,
                // ),
                textInputType: TextInputType.emailAddress,
                onChanged: controller.setEmail,
                enabled: !controller.loading,
              );
            }
          ),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'Password',
                prefix: Icon(
                  Icons.lock, 
                  color: Theme.of(context).primaryColor,
                ),
                obscure: !controller.passwordVisible,
                onChanged: controller.setPassword,
                enabled: !controller.loading,
                suffix: CustomIconButton(
                  radius: 32,
                  icon: Icon(
                    controller.passwordVisible ?
                      Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: controller.togglePasswordVisibility,
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'Confirm Password',
                prefix: Icon(
                  Icons.lock, 
                  color: Theme.of(context).primaryColor,
                ),
                obscure: !controller.passwordVisible,
                onChanged: controller.setPassword,
                enabled: !controller.loading,
                suffix: CustomIconButton(
                  radius: 32,
                  icon: Icon(
                    controller.passwordVisible ?
                      Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: controller.togglePasswordVisibility,
                ),
              );
            },
          ),
           Observer(
            builder: (_) {
              return RoundedButton(
                loading: controller.loading,
                text: "SIGNUP",
                press: controller.loginPressed,
              );
          }),
         
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Modular.to.pop();
            },
          ),
          OrDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SocalIcon(
                iconSrc: AssetIconsConst.faceSvg,
                press: () {},
              ),
              SocalIcon(
                iconSrc: "assets/icons/twitter.svg",
                press: () {},
              ),
              SocalIcon(
                iconSrc: AssetIconsConst.googleSvg,
                press: () {},
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    ),
  );
}
