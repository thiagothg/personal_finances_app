import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances_app/core/network/auth_tokens.dart';

void main() {
  group('AuthTokens', () {
    test('isAccessExpired returns false if accessExpiresAt is in the future (>30s buffer)', () {
      final tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(minutes: 1)),
        refreshExpiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      
      expect(tokens.isAccessExpired, isFalse);
      expect(tokens.isRefreshExpired, isFalse);
    });

    test('isAccessExpired returns true if accessExpiresAt is within 30s buffer', () {
      final tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(seconds: 15)),
        refreshExpiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      
      expect(tokens.isAccessExpired, isTrue);
    });

    test('isAccessExpired returns true if accessExpiresAt is in the past', () {
      final tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        refreshExpiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      
      expect(tokens.isAccessExpired, isTrue);
    });

    test('isRefreshExpired returns true if refreshExpiresAt is in the past', () {
      final tokens = AuthTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now().add(const Duration(minutes: 15)),
        refreshExpiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      
      expect(tokens.isRefreshExpired, isTrue);
    });
  });
}
