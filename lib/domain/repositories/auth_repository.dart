abstract class AuthRepository {
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
