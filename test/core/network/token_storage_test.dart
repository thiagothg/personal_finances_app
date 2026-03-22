import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/core/network/token_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late TokenStorage tokenStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    tokenStorage = TokenStorage(mockStorage);
  });

  group('TokenStorage', () {
    const kAccessToken = 'auth.access_token';
    const kRefreshToken = 'auth.refresh_token';
    const kAccessExpiresAt = 'auth.access_expires_at';
    const kRefreshExpiresAt = 'auth.refresh_expires_at';

    test('saveTokens writes all 4 keys correctly', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      final accessExpires = DateTime.utc(2025, 1, 1);
      final refreshExpires = DateTime.utc(2025, 2, 1);

      await tokenStorage.saveTokens(
        accessToken: 'new_access',
        refreshToken: 'new_refresh',
        accessExpiresAt: accessExpires,
        refreshExpiresAt: refreshExpires,
      );

      verify(() => mockStorage.write(key: kAccessToken, value: 'new_access')).called(1);
      verify(() => mockStorage.write(key: kRefreshToken, value: 'new_refresh')).called(1);
      verify(() => mockStorage.write(key: kAccessExpiresAt, value: accessExpires.toIso8601String())).called(1);
      verify(() => mockStorage.write(key: kRefreshExpiresAt, value: refreshExpires.toIso8601String())).called(1);
    });

    test('hasTokens returns true when both tokens exist', () async {
      when(() => mockStorage.read(key: kAccessToken)).thenAnswer((_) async => 'access');
      when(() => mockStorage.read(key: kRefreshToken)).thenAnswer((_) async => 'refresh');

      expect(await tokenStorage.hasTokens(), isTrue);
    });

    test('hasTokens returns false when access token is missing', () async {
      when(() => mockStorage.read(key: kAccessToken)).thenAnswer((_) async => null);
      when(() => mockStorage.read(key: kRefreshToken)).thenAnswer((_) async => 'refresh');

      expect(await tokenStorage.hasTokens(), isFalse);
    });

    test('isAccessExpired returns true when saved expire date is missing', () async {
      when(() => mockStorage.read(key: kAccessExpiresAt)).thenAnswer((_) async => null);

      expect(await tokenStorage.isAccessExpired(), isTrue);
    });

    test('clearTokens deletes all 4 keys correctly', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});

      await tokenStorage.clearTokens();

      verify(() => mockStorage.delete(key: kAccessToken)).called(1);
      verify(() => mockStorage.delete(key: kRefreshToken)).called(1);
      verify(() => mockStorage.delete(key: kAccessExpiresAt)).called(1);
      verify(() => mockStorage.delete(key: kRefreshExpiresAt)).called(1);
    });
  });
}
