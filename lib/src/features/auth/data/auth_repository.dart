// lib/src/features/auth/data/auth_repository.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthRepository {
  // Key names
  static const _pinKey = 'user_pin_hash';
  static const _biometricEnabledKey = 'biometric_enabled';

  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  AuthRepository({FlutterSecureStorage? secureStorage, LocalAuthentication? localAuth})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _localAuth = localAuth ?? LocalAuthentication();

  // Hash a PIN using SHA-256
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> hasPin() async {
    final v = await _secureStorage.read(key: _pinKey);
    return v != null;
  }

  Future<void> setPin(String pin) async {
    final hashed = _hashPin(pin);
    await _secureStorage.write(key: _pinKey, value: hashed);
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _secureStorage.read(key: _pinKey);
    if (stored == null) return false;
    return stored == _hashPin(pin);
  }

  Future<void> removePin() async {
    await _secureStorage.delete(key: _pinKey);
  }

  // Biometrics
  Future<bool> deviceSupportsBiometrics() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  // <-- updated method here (compatible across versions) -->
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

  Future<void> enableBiometrics(bool enable) async {
    await _secureStorage.write(key: _biometricEnabledKey, value: enable ? '1' : '0');
  }

  Future<bool> isBiometricsEnabled() async {
    final v = await _secureStorage.read(key: _biometricEnabledKey);
    return v == '1';
  }
}
