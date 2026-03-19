import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  // Token Management
  Future<void> storeToken(String token);
  Future<String?> retrieveStoredToken();
  Future<void> clearToken();

  // User Management
  Future<void> storeUser(User user);
  Future<User?> retrieveStoredUser();
  Future<void> clearUser();

  Future<bool> hasPin();
  Future<void> setPin(String pin);
  Future<bool> verifyPin(String pin);
  Future<void> removePin();

  // Biometrics
  Future<bool> deviceSupportsBiometrics();
  Future<bool> canCheckBiometrics();
  Future<bool> authenticateWithBiometrics({String reason = 'Authenticate'});
  Future<void> enableBiometrics(bool enable);
  Future<bool> isBiometricsEnabled();
}
