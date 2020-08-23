// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SignUpController on _SignUpControllerBase, Store {
  Computed<bool> _$isPasswordValidComputed;

  @override
  bool get isPasswordValid =>
      (_$isPasswordValidComputed ??= Computed<bool>(() => super.isPasswordValid,
              name: '_SignUpControllerBase.isPasswordValid'))
          .value;
  Computed<bool> _$isEmailValidComputed;

  @override
  bool get isEmailValid =>
      (_$isEmailValidComputed ??= Computed<bool>(() => super.isEmailValid,
              name: '_SignUpControllerBase.isEmailValid'))
          .value;
  Computed<Function> _$loginPressedComputed;

  @override
  Function get loginPressed =>
      (_$loginPressedComputed ??= Computed<Function>(() => super.loginPressed,
              name: '_SignUpControllerBase.loginPressed'))
          .value;

  final _$loadingAtom = Atom(name: '_SignUpControllerBase.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$nameAtom = Atom(name: '_SignUpControllerBase.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$emailAtom = Atom(name: '_SignUpControllerBase.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_SignUpControllerBase.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$passwordVisibleAtom =
      Atom(name: '_SignUpControllerBase.passwordVisible');

  @override
  bool get passwordVisible {
    _$passwordVisibleAtom.reportRead();
    return super.passwordVisible;
  }

  @override
  set passwordVisible(bool value) {
    _$passwordVisibleAtom.reportWrite(value, super.passwordVisible, () {
      super.passwordVisible = value;
    });
  }

  final _$registerAsyncAction = AsyncAction('_SignUpControllerBase.register');

  @override
  Future<void> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  final _$_SignUpControllerBaseActionController =
      ActionController(name: '_SignUpControllerBase');

  @override
  void setName(String value) {
    final _$actionInfo = _$_SignUpControllerBaseActionController.startAction(
        name: '_SignUpControllerBase.setName');
    try {
      return super.setName(value);
    } finally {
      _$_SignUpControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_SignUpControllerBaseActionController.startAction(
        name: '_SignUpControllerBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_SignUpControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_SignUpControllerBaseActionController.startAction(
        name: '_SignUpControllerBase.setPassword');
    try {
      return super.setPassword(value);
    } finally {
      _$_SignUpControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void togglePasswordVisibility() {
    final _$actionInfo = _$_SignUpControllerBaseActionController.startAction(
        name: '_SignUpControllerBase.togglePasswordVisibility');
    try {
      return super.togglePasswordVisibility();
    } finally {
      _$_SignUpControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
name: ${name},
email: ${email},
password: ${password},
passwordVisible: ${passwordVisible},
isPasswordValid: ${isPasswordValid},
isEmailValid: ${isEmailValid},
loginPressed: ${loginPressed}
    ''';
  }
}
