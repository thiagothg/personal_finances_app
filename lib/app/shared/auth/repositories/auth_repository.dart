import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/register_error_interceptor.dart';
import '../../../core/responses/response_builder.dart';
import '../../../core/responses/response_default.dart';
import 'auth_repository_interface.dart';

class AuthRepository implements IAuthRepository {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<DefaultResponse> getEmailPasswordLogin(
      {String email, String password}) async {
     try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      return ResponseBuilder.success<FirebaseUser>(
          object: await _auth.currentUser());
    } on PlatformException catch (e) {
      print(e);
      var message = RegisterErrorInterceptor().handleAuthError(e.code);
      return ResponseBuilder.failed(object: e, message: message);
    } on Exception catch (e) {
      return ResponseBuilder.failed(object: e, message: e.toString());
    }
  }

  @override
  Future<DefaultResponse> getFacebookLogin() {
    throw UnimplementedError();
  }

  @override
  Future<String> getToken() {
    throw UnimplementedError();
  }

  @override
  Future<DefaultResponse> getGoogleLogin() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user =
          (await _auth.signInWithCredential(credential)).user;

      return ResponseBuilder.success<FirebaseUser>(
          object: user, message: 'Logou com sucesso');
    } on Exception catch (e) {
      return ResponseBuilder.failed(
          object: e, message: 'Falha ao Logar com Google. e: ${e.toString()}');
    }
  }

  @override
  Future<DefaultResponse> getUser() async {
    try {
      return ResponseBuilder.success<FirebaseUser>(
          object: await _auth.currentUser());
    } on Exception catch (e) {
      return ResponseBuilder.failed(object: e, message: e.toString());
    }
  }

  @override
  Future<DefaultResponse> getLogout() async {
    try {
      await _auth.signOut();
      return ResponseBuilder.success();
    } on Exception catch (e) {
      return ResponseBuilder.failed(object: e, message: e.toString());
    }
  }

  @override
  Future<DefaultResponse> registerEmailPassword(
      {String email, String password}) async {
    try {
      return await _auth
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim())
          .then(
        (auth) {
          return ResponseBuilder.success<FirebaseUser>(object: auth.user);
        },
      );
    } on Exception catch (e) {
      return ResponseBuilder.failed(
          object: e,
          message: e.toString(),
          errorInterceptor: RegisterErrorInterceptor());
    }
  }
}