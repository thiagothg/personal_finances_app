import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/core/network/token_storage.dart';
import 'package:personal_finances_app/features/auth/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockTokenStorage extends Mock implements TokenStorage {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockTokenStorage mockTokenStorage;

  setUp(() {
    mockTokenStorage = MockTokenStorage();
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        tokenStorageProvider.overrideWithValue(mockTokenStorage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('AuthState Provider', () {
    test('build returns authenticated if hasTokens is true', () async {
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => true);
      
      final container = createContainer();
      final authStateAsync = await container.read(authStateProvider.future);
      
      expect(authStateAsync, equals(AuthStatus.authenticated));
    });

    test('build returns unauthenticated if hasTokens is false', () async {
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => false);
      
      final container = createContainer();
      final authStateAsync = await container.read(authStateProvider.future);
      
      expect(authStateAsync, equals(AuthStatus.unauthenticated));
    });

    test('onLoginSuccess saves tokens and sets state to authenticated', () async {
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => false);
      when(() => mockTokenStorage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
        accessExpiresAt: any(named: 'accessExpiresAt'),
        refreshExpiresAt: any(named: 'refreshExpiresAt'),
      )).thenAnswer((_) async {});

      final container = createContainer();
      
      // Wait for initial build
      await container.read(authStateProvider.future);
      
      await container.read(authStateProvider.notifier).onLoginSuccess(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: DateTime.now(),
        refreshExpiresAt: DateTime.now(),
      );

      verify(() => mockTokenStorage.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
        accessExpiresAt: any(named: 'accessExpiresAt'),
        refreshExpiresAt: any(named: 'refreshExpiresAt'),
      )).called(1);

      expect(container.read(authStateProvider).value, equals(AuthStatus.authenticated));
    });

    test('onLogout clears tokens and sets state to unauthenticated', () async {
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => true);
      when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});

      final container = createContainer();
      
      // Wait for initial build
      await container.read(authStateProvider.future);

      await container.read(authStateProvider.notifier).onLogout();

      verify(() => mockTokenStorage.clearTokens()).called(1);
      expect(container.read(authStateProvider).value, equals(AuthStatus.unauthenticated));
    });
  });
}
