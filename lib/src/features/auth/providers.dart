// lib/src/features/auth/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Auth state: unauthenticated / authenticated / onboarding (no PIN set)
enum AuthStatus { unknown, unauthenticated, authenticated, onboarding }

class AuthState {
  final AuthStatus status;
  final bool biometricAvailable;
  AuthState({required this.status, this.biometricAvailable = false});

  AuthState copyWith({AuthStatus? status, bool? biometricAvailable}) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository repo;
  AuthController(this.repo) : super(AuthState(status: AuthStatus.unknown)) {
    _init();
  }

  Future<void> _init() async {
    final hasPin = await repo.hasPin();
    final bioAvail = await repo.deviceSupportsBiometrics() && await repo.canCheckBiometrics();
    state = AuthState(
      status: hasPin ? AuthStatus.unauthenticated : AuthStatus.onboarding,
      biometricAvailable: bioAvail,
    );
  }

  Future<void> setPin(String pin) async {
    await repo.setPin(pin);
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }

  Future<bool> submitPin(String pin) async {
    final ok = await repo.verifyPin(pin);
    state = ok ? state.copyWith(status: AuthStatus.authenticated) : state;
    return ok;
  }

  Future<bool> authenticateBiometrics() async {
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

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo);
});
