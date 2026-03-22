import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_provider.dart';

part 'biometric_auth_provider.g.dart';

@riverpod
class BiometricAuthController extends _$BiometricAuthController {
  @override
  FutureOr<bool> build() async {
    final usecase = ref.read(biometricAuthUseCaseProvider);
    return await usecase.canUseBiometrics();
  }

  Future<bool> authenticate({String reason = 'Authenticate to access your account'}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final usecase = ref.read(biometricAuthUseCaseProvider);
      final success = await usecase.authenticate(reason: reason);
      return success;
    });

    return state.maybeWhen(data: (success) => success, orElse: () => false);
  }

  Future<void> enable() async {
    final usecase = ref.read(biometricAuthUseCaseProvider);
    await usecase.enable();
    ref.invalidateSelf();
  }

  Future<void> disable() async {
    final usecase = ref.read(biometricAuthUseCaseProvider);
    await usecase.disable();
    ref.invalidateSelf();
  }

  String? getErrorMessage() {
    return state.maybeWhen(error: (error, stackTrace) => error.toString(), orElse: () => null);
  }
}
