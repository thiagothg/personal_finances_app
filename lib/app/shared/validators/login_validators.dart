import 'dart:async';


class LoginValidators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains('@')) {
        sink.add(email);
      } else {
        sink.addError('Insere um e-mail valido');
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length > 5) {
        sink.add(password);
      } else {
        sink.addError('Password muito curto');
      }
    }
  );
}