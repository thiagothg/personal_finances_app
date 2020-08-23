import 'dart:async';

import '../../../core/responses/response_default.dart';

abstract class IAuthRepository {
  Future<DefaultResponse> getUser();
  Future<DefaultResponse> getGoogleLogin();
  Future<DefaultResponse> getFacebookLogin();
  Future<DefaultResponse> getEmailPasswordLogin(
    {String email, String password});
  Future<String> getToken();
  Future<DefaultResponse> getLogout();
  Future<DefaultResponse> registerEmailPassword(
      {String email, String password});

}