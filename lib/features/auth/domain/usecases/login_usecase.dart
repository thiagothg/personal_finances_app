import '../../../../../domain/entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call({required String email, required String password}) async {
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Formato de e-mail inválido.');
    }
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('A senha deve ter pelo menos 6 caracteres.');
    }
    return repository.login(email: email, password: password);
  }
}
