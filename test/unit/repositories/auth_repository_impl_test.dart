import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/data/datasource/auth_remote_datasource.dart';
import 'package:personal_finances_app/data/models/user_model.dart';
import 'package:personal_finances_app/data/repositories/auth_repository_impl.dart';
import 'package:personal_finances_app/domain/entities/user.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late AuthRepositoryImpl authRepository;
  late MockAuthRemoteDatasource mockDatasource;
  late MockFlutterSecureStorage mockSecureStorage;
  late MockLocalAuthentication mockLocalAuth;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    mockSecureStorage = MockFlutterSecureStorage();
    mockLocalAuth = MockLocalAuthentication();

    authRepository = AuthRepositoryImpl(
      datasource: mockDatasource,
      secureStorage: mockSecureStorage,
      localAuth: mockLocalAuth,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'test_access_token';
  const testUserModel = UserModel(
    id: '1',
    name: 'Test User',
    email: testEmail,
    accessToken: testToken,
  );
  const testUser = User(id: '1', name: 'Test User', email: testEmail, token: testToken);

  group('AuthRepositoryImpl', () {
    group('login', () {
      test('should call datasource.login with correct email and password', () async {
        when(
          () => mockDatasource.login(testEmail, testPassword),
        ).thenAnswer((_) async => testUserModel);
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await authRepository.login(email: testEmail, password: testPassword);

        verify(() => mockDatasource.login(testEmail, testPassword)).called(1);
      });

      test('should return User when login is successful', () async {
        when(
          () => mockDatasource.login(testEmail, testPassword),
        ).thenAnswer((_) async => testUserModel);
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        final result = await authRepository.login(email: testEmail, password: testPassword);

        expect(result, testUser);
      });

      test('should store token after successful login', () async {
        when(
          () => mockDatasource.login(testEmail, testPassword),
        ).thenAnswer((_) async => testUserModel);
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await authRepository.login(email: testEmail, password: testPassword);

        verify(() => mockSecureStorage.write(key: 'auth_access_token', value: testToken)).called(1);
      });

      test('should throw exception when datasource throws', () async {
        when(
          () => mockDatasource.login(testEmail, testPassword),
        ).thenThrow(Exception('Network error'));

        expect(
          () => authRepository.login(email: testEmail, password: testPassword),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('token storage', () {
      test('should store token using secure storage', () async {
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await authRepository.storeToken(testToken);

        verify(() => mockSecureStorage.write(key: 'auth_access_token', value: testToken)).called(1);
      });

      test('should retrieve stored token', () async {
        when(
          () => mockSecureStorage.read(key: 'auth_access_token'),
        ).thenAnswer((_) async => testToken);

        final token = await authRepository.retrieveStoredToken();

        expect(token, testToken);
      });

      test('should return null when no token is stored', () async {
        when(() => mockSecureStorage.read(key: 'auth_access_token')).thenAnswer((_) async => null);

        final token = await authRepository.retrieveStoredToken();

        expect(token, null);
      });

      test('should clear stored token', () async {
        when(() => mockSecureStorage.delete(key: 'auth_access_token')).thenAnswer((_) async {});

        await authRepository.clearToken();

        verify(() => mockSecureStorage.delete(key: 'auth_access_token')).called(1);
      });
    });

    group('biometrics', () {
      test('should return true when device supports biometrics', () async {
        when(() => mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);

        final result = await authRepository.deviceSupportsBiometrics();

        expect(result, true);
      });

      test('should return false when device does not support biometrics', () async {
        when(() => mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

        final result = await authRepository.deviceSupportsBiometrics();

        expect(result, false);
      });

      test('should authenticate with biometrics', () async {
        when(
          () => mockLocalAuth.authenticate(localizedReason: any(named: 'localizedReason')),
        ).thenAnswer((_) async => true);

        final result = await authRepository.authenticateWithBiometrics();

        expect(result, true);
      });

      test('should return false when biometric authentication fails', () async {
        when(
          () => mockLocalAuth.authenticate(localizedReason: any(named: 'localizedReason')),
        ).thenAnswer((_) async => false);

        final result = await authRepository.authenticateWithBiometrics();

        expect(result, false);
      });

      test('should enable biometrics', () async {
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await authRepository.enableBiometrics(true);

        verify(() => mockSecureStorage.write(key: 'biometric_enabled', value: '1')).called(1);
      });

      test('should disable biometrics', () async {
        when(
          () => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          ),
        ).thenAnswer((_) async {});

        await authRepository.enableBiometrics(false);

        verify(() => mockSecureStorage.write(key: 'biometric_enabled', value: '0')).called(1);
      });

      test('should check if biometrics is enabled', () async {
        when(() => mockSecureStorage.read(key: 'biometric_enabled')).thenAnswer((_) async => '1');

        final result = await authRepository.isBiometricsEnabled();

        expect(result, true);
      });

      test('should return false when biometrics is not enabled', () async {
        when(() => mockSecureStorage.read(key: 'biometric_enabled')).thenAnswer((_) async => '0');

        final result = await authRepository.isBiometricsEnabled();

        expect(result, false);
      });
    });
  });
}
