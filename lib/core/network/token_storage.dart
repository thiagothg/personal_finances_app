import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'auth.access_token';
  static const _kRefreshToken = 'auth.refresh_token';
  static const _kAccessExpiresAt = 'auth.access_expires_at';
  static const _kRefreshExpiresAt = 'auth.refresh_expires_at';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required DateTime accessExpiresAt,
    required DateTime refreshExpiresAt,
  }) async {
    // RULE: Ensure dates are stored as UTC (ISO-8601) locally to avoid timezone parsing issues.
    // Use sequential writes since flutter_secure_storage has issues with concurrent writes on some platforms.
    await _storage.write(key: _kAccessToken, value: accessToken);
    await _storage.write(key: _kRefreshToken, value: refreshToken);
    await _storage.write(
      key: _kAccessExpiresAt,
      value: accessExpiresAt.toUtc().toIso8601String(),
    );
    await _storage.write(
      key: _kRefreshExpiresAt,
      value: refreshExpiresAt.toUtc().toIso8601String(),
    );
  }

  Future<String?> getAccessToken() => _storage.read(key: _kAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _kRefreshToken);

  Future<DateTime?> getAccessExpiresAt() async {
    try {
      final value = await _storage.read(key: _kAccessExpiresAt);
      if (value == null || value.isEmpty || value == 'null') return null;

      // Parse received UTC strings from the API/Storage ensuring it is UTC.
      final parsed = DateTime.parse(value);
      return parsed.isUtc ? parsed : parsed.toUtc();
    } catch (e, stack) {
      // If the stored date is malformed or the OS Keychain throws an exception (e.g. PlatformException),
      // treat the token as having no expiry (or already expired, handled by caller).
      // Print the error so we can debug it:
      print('TokenStorage.getAccessExpiresAt exception: $e\n$stack');
      return null;
    }
  }

  Future<bool> isAccessExpired() async {
    final expiresAt = await getAccessExpiresAt();
    if (expiresAt == null) {
      print('TokenStorage.isAccessExpired: expiresAt is null');
      return true;
    }

    // RULE: The frontend locally checks expiration by comparing the token's UTC expiration date
    // against the device's current UTC time to prevent unnecessary network requests.
    final nowUtc = DateTime.now().toUtc();
    final isExpired = nowUtc.isAfter(
      expiresAt.subtract(const Duration(seconds: 30)),
    );
    print(
      'TokenStorage.isAccessExpired: now=$nowUtc, expiresAt=$expiresAt, expired=$isExpired',
    );
    return isExpired;
  }

  Future<bool> hasTokens() async {
    final access = await getAccessToken();
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
