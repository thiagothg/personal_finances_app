import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/token_storage.dart';
import 'auth_provider.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) {
  return const FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
}

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) {
  return TokenStorage(ref.watch(flutterSecureStorageProvider));
}

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return DioClient.create(
    baseUrl: AppConstants.baseUrl,
    tokenStorage: ref.watch(tokenStorageProvider),
    onForceLogout: () async {
      await ref.read(authControllerProvider.notifier).signOut();
    },
  );
}

enum AuthStatus { loading, authenticated, unauthenticated }

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  Future<AuthStatus> build() async {
    final hasTokens = await ref.watch(tokenStorageProvider).hasTokens();
    return hasTokens ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  Future<void> onLoginSuccess({
    required String accessToken,
    required String refreshToken,
    required DateTime accessExpiresAt,
    required DateTime refreshExpiresAt,
  }) async {
    await ref
        .read(tokenStorageProvider)
        .saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          accessExpiresAt: accessExpiresAt,
          refreshExpiresAt: refreshExpiresAt,
        );
    state = const AsyncData(AuthStatus.authenticated);
  }

  Future<void> onLogout() async {
    await ref.read(tokenStorageProvider).clearTokens();
    state = const AsyncData(AuthStatus.unauthenticated);
  }
}
