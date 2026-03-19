import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth_provider.dart';

part 'login_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final usecase = ref.read(loginUseCaseProvider);
      final user = await usecase(email: email, password: password);

      ref.read(authControllerProvider.notifier).setAuthenticated(user);
      return;
    });

    return !state.hasError;
  }

  // Method to get error message if any
  String? getErrorMessage() {
    return state.maybeWhen(error: (error, stackTrace) => error.toString(), orElse: () => null);
  }

  // Method to clear error state
  void clearError() {
    state = const AsyncValue.data(null);
  }
}
