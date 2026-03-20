// lib/src/features/auth/data/auth_repository.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:personal_finances_app/data/datasource/auth/auth_remote_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Key names
  static const _pinKey = 'user_pin_hash';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _tokenKey = 'auth_access_token';
  static const _userKey = 'auth_user_profile';

  final AuthRemoteDatasource datasource;
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  AuthRepositoryImpl({
    FlutterSecureStorage? secureStorage,
    LocalAuthentication? localAuth,
    required this.datasource,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<User> login({required String email, required String password}) async {
    final model = await datasource.login(email, password);
    // Store the token upon successful login
    await storeToken(model.accessToken);
    final user = model.toDomain();
    await storeUser(user);
    return user;
  }

  // Token Management
  @override
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> retrieveStoredToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  @override
  Future<void> storeUser(User user) async {
    final userMap = {'id': user.id, 'name': user.name, 'email': user.email, 'token': user.token};
    await _secureStorage.write(key: _userKey, value: jsonEncode(userMap));
  }

  @override
  Future<User?> retrieveStoredUser() async {
    final userJson = await _secureStorage.read(key: _userKey);
    if (userJson == null) return null;
    try {
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return User(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        token: map['token'] as String,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    await _secureStorage.delete(key: _userKey);
  }

  // Hash a PIN using SHA-256
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<bool> hasPin() async {
    final v = await _secureStorage.read(key: _pinKey);
    return v != null;
  }

  @override
  Future<void> setPin(String pin) async {
    final hashed = _hashPin(pin);
    await _secureStorage.write(key: _pinKey, value: hashed);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final stored = await _secureStorage.read(key: _pinKey);
    if (stored == null) return false;
    return stored == _hashPin(pin);
  }

  @override
  Future<void> removePin() async {
    await _secureStorage.delete(key: _pinKey);
  }

  // Biometrics
  @override
  Future<bool> deviceSupportsBiometrics() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  // <-- updated method here (compatible across versions) -->
  @override
  Future<bool> authenticateWithBiometrics({String reason = 'Authenticate'}) async {
    try {
      // Use the older/common authenticate signature for broader compatibility.
      final didAuthenticate = await _localAuth.authenticate(localizedReason: reason);
      return didAuthenticate;
    } catch (_) {
      // If anything fails, return false — authentication not available or failed.
      return false;
    }
  }

  @override
  Future<void> enableBiometrics(bool enable) async {
    await _secureStorage.write(key: _biometricEnabledKey, value: enable ? '1' : '0');
  }

  @override
  Future<bool> isBiometricsEnabled() async {
    final v = await _secureStorage.read(key: _biometricEnabledKey);
    return v == '1';
  }
}
