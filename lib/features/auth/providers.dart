// lib/src/features/auth/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init(); // Fire & forget initialization
    return AuthState(status: AuthStatus.unknown);
  }

  Future<void> _init() async {
    final repo = ref.read(authRepositoryProvider);
    final hasPin = await repo.hasPin();
    final bioAvail =
        await repo.deviceSupportsBiometrics() &&
        await repo.canCheckBiometrics();
    state = AuthState(
      status: hasPin ? AuthStatus.unauthenticated : AuthStatus.onboarding,
      biometricAvailable: bioAvail,
    );
  }

  Future<void> setPin(String pin) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.setPin(pin);
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<bool> submitPin(String pin) async {
    final repo = ref.read(authRepositoryProvider);
    final ok = await repo.verifyPin(pin);
    state = ok ? state.copyWith(status: AuthStatus.authenticated) : state;
    return ok;
  }

  Future<bool> authenticateBiometrics() async {
    final repo = ref.read(authRepositoryProvider);
    final ok = await repo.authenticateWithBiometrics();
    if (!ok) return false;

    // Check if biometric is allowed in settings (we store a flag); if not, enable it
    final enabled = await repo.isBiometricsEnabled();
    if (!enabled) {
      await repo.enableBiometrics(true);
    }
    state = state.copyWith(status: AuthStatus.authenticated);
    return true;
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
