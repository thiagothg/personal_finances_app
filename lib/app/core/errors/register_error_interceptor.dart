import '../interface/error_interceptor_interface.dart';

class RegisterErrorInterceptor implements IErrorInterceptor {
  @override
  String handleError(String error) {
    switch (error) {
      case 'ERROR_WEAK_PASSWORD':
        return 'Acho que essa senha está muito curta, tente uma maior!';
        break;
      case 'ERROR_INVALID_EMAIL':
        return 'Ops! Esse email é inválido!';
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return 'Esse email já está cadastrado,'
            'se já tem uma conta basta fazer o login!';
        break;
      default:
        return 'Não foi possível realizar o registro,'
            'tente novamente mais tarde.';
    }
  }

  @override
  String handleAuthError(String error) {
    switch (error) {
      case "ERROR_INVALID_EMAIL":
        return "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        return "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        return "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password is not enabled.";
        break;
      default:
        return "An undefined Error happened.";
    }
  }
}