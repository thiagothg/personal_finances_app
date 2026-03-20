import '../../repositories/auth_repository.dart';

class BiometricAuthUseCase {
  final AuthRepository repository;

  BiometricAuthUseCase(this.repository);

  Future<bool> canUseBiometrics() async {
    final deviceSupports = await repository.deviceSupportsBiometrics();
    final canCheck = await repository.canCheckBiometrics();
    final isEnabled = await repository.isBiometricsEnabled();

    return deviceSupports && canCheck && isEnabled;
  }

  Future<bool> authenticate({String reason = 'Authenticate to access your account'}) async {
    try {
      return await repository.authenticateWithBiometrics(reason: reason);
    } catch (e) {
      return false;
    }
  }

  Future<void> enable() async {
    await repository.enableBiometrics(true);
  }

  Future<void> disable() async {
    await repository.enableBiometrics(false);
  }
}
