// lib/src/features/auth/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/biometric_auth_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth/datasource_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    datasource: ref.watch(authRemoteDatasourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
    localAuth: ref.watch(localAuthProvider),
  );
});

// Use case providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final biometricAuthUseCaseProvider = Provider<BiometricAuthUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return BiometricAuthUseCase(repository);
});

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _init();
    return AuthState(status: AuthStatus.unknown);
  }

  Future<void> _init() async {
    final repo = ref.read(authRepositoryProvider);
    final hasPin = await repo.hasPin();
    final bioAvail = await repo.deviceSupportsBiometrics() && await repo.canCheckBiometrics();

    // Check if user has a stored token (persistent login)
    final storedToken = await repo.retrieveStoredToken();
    final hasValidToken = storedToken != null && storedToken.isNotEmpty;

    final status = hasValidToken
        ? AuthStatus.authenticated
        : hasPin
        ? AuthStatus.unauthenticated
        : AuthStatus.onboarding;

    User? user;
    if (hasValidToken) {
      user = await repo.retrieveStoredUser();
    }

    state = AuthState(status: status, biometricAvailable: bioAvail, user: user);
  }

  void setAuthenticated(User user) {
    state = state.copyWith(status: AuthStatus.authenticated, user: user);
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
    final repo = ref.read(authRepositoryProvider);
    await repo.clearToken();
    await repo.clearUser();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
