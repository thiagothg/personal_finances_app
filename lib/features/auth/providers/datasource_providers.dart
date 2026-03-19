import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../data/datasource/auth_remote_datasource.dart';
import '../../../data/datasource/local_token_datasource.dart';
import '../../../data/datasource/biometric_datasource.dart';
import '../../../core/network/dio_provider.dart';

// AuthRemoteDatasource provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDatasource(dio);
});

// LocalTokenDatasource provider
final localTokenDatasourceProvider = Provider<LocalTokenDatasource>((ref) {
  return LocalTokenDatasource();
});

// BiometricDatasource provider
final biometricDatasourceProvider = Provider<BiometricDatasource>((ref) {
  return BiometricDatasource();
});

// FlutterSecureStorage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
});

// LocalAuthentication provider
final localAuthProvider = Provider<LocalAuthentication>((ref) {
  return LocalAuthentication();
});
