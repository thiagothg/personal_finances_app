

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/consts/routers_const.dart';
import '../../core/enums/app_enums.dart';
import '../../core/responses/response_default.dart';
import 'repositories/auth_repository_interface.dart';

part 'auth_controller.g.dart';

class AuthController = _AuthControllerBase with _$AuthController;

abstract class _AuthControllerBase with Store {

  final IAuthRepository _authRepository = Modular.get();

  @observable
  AuthStatus status = AuthStatus.loading;

  @observable
  FirebaseUser user;

  @action
  void setUser(DefaultResponse result) {
    if(result.success) {
      status = AuthStatus.login;
    } else {
      status = AuthStatus.logoff;
    }
  }

  _AuthControllerBase() {
    _authRepository.getUser().then(setUser).catchError((e) {
      print('ERRORRRRRR');
    });
  }

  @action
  Future loginWithGoogle() async {
   await _authRepository.getGoogleLogin().then((result) {
     if(result.success) {
       print(result.object);
       Modular.to.pushReplacementNamed(RoutersConst.home);
     } else {
       print(result);
     }
   });
  }

  Future logout() async {
    var response = await _authRepository.getLogout();
    if (response.success) {
      Modular.to.pushReplacementNamed(RoutersConst.login);
    } else {
      print(response.message);
      throw response;
    }
  }

  Future<DefaultResponse> loginEmail(String email, String password) async {
    var result = await _authRepository
        .getEmailPasswordLogin(email: email.trim(), password: password.trim());
    print(result.message);
    //RegisterErrorInterceptor().handleAuthError(result.object);
    return result;
  }

  Future<void> register(String email, String password) async {
    var response = await _authRepository.registerEmailPassword(
      email: email,
      password: password,
    );
    if (response.success) {
      Modular.to.pushReplacementNamed(RoutersConst.home);
    } else {
      throw response;
    }
  }
}