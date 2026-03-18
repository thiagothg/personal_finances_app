/// Auth state: unauthenticated / authenticated / onboarding (no PIN set)
enum AuthStatus { unknown, unauthenticated, authenticated, onboarding }

class AuthState {
  final AuthStatus status;
  final bool biometricAvailable;

  AuthState({
    required this.status,
    this.biometricAvailable = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? biometricAvailable,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }
}
