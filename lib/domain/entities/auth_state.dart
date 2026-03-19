import 'user.dart';

/// Auth state: unauthenticated / authenticated / onboarding (no PIN set)
enum AuthStatus { unknown, unauthenticated, authenticated, onboarding }

class AuthState {
  final AuthStatus status;
  final bool biometricAvailable;
  final User? user;

  AuthState({
    required this.status,
    this.biometricAvailable = false,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? biometricAvailable,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      user: user ?? this.user,
    );
  }
}

