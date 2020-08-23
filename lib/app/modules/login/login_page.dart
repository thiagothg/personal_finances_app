import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/consts/assets_const.dart';
import '../../core/consts/routers_const.dart';
import '../../shared/widgets/custom_icon_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/login/already_have_an_account_acheck.dart';
import '../../shared/widgets/login/rounded_button.dart';
import 'login_controller.dart';
import 'widgets/background.dart';
import 'widgets/or_divider.dart';
import 'widgets/social_icon.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ModularState<LoginPage, LoginController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      key: controller.scaffoldKey,
      body: body(context, controller)
    );
  }
}

Widget body(BuildContext context, LoginController controller) {
  var size = MediaQuery.of(context).size;
  return Background(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          SizedBox(height: size.height * 0.03),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'E-mail',
                prefix: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
                textInputType: TextInputType.emailAddress,
                onChanged: controller.setEmail,
                enabled: !controller.loading,
              );
            }
          ),
          Observer(
            builder: (_) {
              return CustomTextField(
                hint: 'Senha',
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
                text: "LOGIN",
                press: controller.loginPressed,
              );
          }),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccountCheck(
            login: true,
            press: () {
              Modular.to.pushNamed(RoutersConst.register);
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
                  press: () async {
                    controller.auth.loginWithGoogle();
                  },
                ),
              ],
            )
        ],
      ),
    ),
  );
}
