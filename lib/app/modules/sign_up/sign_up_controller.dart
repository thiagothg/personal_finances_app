import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/consts/routers_const.dart';
import '../../shared/auth/auth_controller.dart';

part 'sign_up_controller.g.dart';

class SignUpController = _SignUpControllerBase with _$SignUpController;

abstract class _SignUpControllerBase with Store {
  AuthController auth = Modular.get();
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  @observable
  bool loading = false;

  // ignore: use_setters_to_change_properties
  @action
  void setName(String value) => name = value;

  @observable
  String name = '';

  // ignore: use_setters_to_change_properties
  @action
  void setEmail(String value) => email = value;

  @observable
  String email = '';

  @observable
  String password = '';

  // ignore: use_setters_to_change_properties
  @action
  void setPassword(String value) => password = value;

  @observable
  String confirmPassword = '';

  // ignore: use_setters_to_change_properties
  @action
  void setConfirmPassword(String value) => confirmPassword = value;

  @observable
  bool passwordVisible = false;

  @observable
  bool confirmPasswordVisible = false;

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isConfirmPasswordValid => confirmPassword.length >= 6;

  @computed
  bool get isNameValid => name.length >= 6;


  @action
  void togglePasswordVisibility() => passwordVisible = !passwordVisible;

  @action
  void toggleConfirmPasswordVisibility() 
    => confirmPasswordVisible = !confirmPasswordVisible;

  @computed
  bool get isEmailValid =>
    RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(email);
  
  @computed
  Function get loginPressed =>
      (isEmailValid && isPasswordValid 
        && isConfirmPasswordValid && isNameValid && !loading) ? register : null;


  @action
  Future<void> register() async {
    loading = true;

    await auth.loginEmail(email, password)
      .then((result) async {
      
      if(result.success) {
        Modular.to.pushReplacementNamed(RoutersConst.home);
      } else {
        await Future.delayed(Duration(seconds: 2));

        loading = false;
       
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(result.message),
          duration: Duration(seconds: 2),
          //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ));
      }
    });
  }

}
