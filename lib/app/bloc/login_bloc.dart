import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../core/enums/app_enums.dart';
import '../shared/auth/auth_controller.dart';
import '../shared/validators/login_validators.dart';

// ignore: prefer_mixin
class LoginBloc extends BlocBase with LoginValidators {
  AuthController auth = Modular.get();
  
  LoginBloc() {
      if(auth.user != null) {
          _stateController.add(LoginState.SUCCESS);
      } else {
        _stateController.add(LoginState.IDLE);
      }
    // _streamSubscription = FirebaseAuth.instance.onAuthStateChanged
    // .listen((user) async {
    //   if(user != null) {
    //     if(await verifyPrivigeles(user)) {
    //       _stateController.add(LoginState.SUCCESS);
    //     } else {
    //       _stateController.add(LoginState.FAIL);
    //       FirebaseAuth.instance.signOut();
    //     }
    //   } else {
    //      _stateController.add(LoginState.IDLE);
    //   }
    // });
  }

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail 
    => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword 
    => _passwordController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => CombineLatestStream.combine2(
    outEmail, outPassword, (a , b) => true
  );

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  StreamSubscription _streamSubscription;

  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);
  
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password
      ).catchError((e) {
        print(e);
        _stateController.add(LoginState.FAIL);

    });
  }

  // Future<bool> verifyPrivigeles(FirebaseUser user) async {
  //   return await Firestore.instance.collection('admins')
  //   .document(user.uid).get().then((doc) {
  //     if(doc.data != null) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }).catchError((e){
  //     return false;
  //   });
  // }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    // _streamSubscription.cancel();

    super.dispose();
  }
}