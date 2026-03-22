import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken      = 'auth.access_token';
  static const _kRefreshToken     = 'auth.refresh_token';
  static const _kAccessExpiresAt  = 'auth.access_expires_at';
  static const _kRefreshExpiresAt = 'auth.refresh_expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessExpiresAt,
    required DateTime refreshExpiresAt,
  }) async {
    await Future.wait([
      _storage.write(key: _kAccessToken,      value: accessToken),
      _storage.write(key: _kRefreshToken,     value: refreshToken),
      _storage.write(key: _kAccessExpiresAt,  value: accessExpiresAt.toIso8601String()),
      _storage.write(key: _kRefreshExpiresAt, value: refreshExpiresAt.toIso8601String()),
    ]);
  }

  Future<String?> getAccessToken()  => _storage.read(key: _kAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<DateTime?> getAccessExpiresAt() async {
    try {
      final value = await _storage.read(key: _kAccessExpiresAt);
      if (value == null || value.isEmpty || value == 'null') return null;
      return DateTime.parse(value);
    } catch (_) {
      // If the stored date is malformed or the OS Keychain throws an exception (e.g. PlatformException),
      // treat the token as having no expiry (or already expired, handled by caller).
      return null;
    }
  }

  Future<bool> isAccessExpired() async {
    final expiresAt = await getAccessExpiresAt();
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(
      expiresAt.subtract(const Duration(seconds: 30)),
    );
  }

  Future<bool> hasTokens() async {
    final access  = await getAccessToken();
    final refresh = await getRefreshToken();
    return access != null && refresh != null;
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _kAccessToken),
      _storage.delete(key: _kRefreshToken),
      _storage.delete(key: _kAccessExpiresAt),
      _storage.delete(key: _kRefreshExpiresAt),
    ]);
  }
}
