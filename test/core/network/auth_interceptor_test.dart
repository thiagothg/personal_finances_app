import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/core/network/auth_interceptor.dart';
import 'package:personal_finances_app/core/network/token_storage.dart';

class MockDio extends Mock implements Dio {}
class MockTokenStorage extends Mock implements TokenStorage {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

// We need a class to hold the callbacks so we can mock them
class InterceptorCallbacks {
  Future<void> onRefresh(Dio dio, String refreshToken) async {}
  Future<void> onForceLogout() async {}
}
class MockInterceptorCallbacks extends Mock implements InterceptorCallbacks {}

class FakeDio extends Fake implements Dio {}

void main() {
  late MockDio mockDio;
  late MockTokenStorage mockTokenStorage;
  late MockInterceptorCallbacks mockCallbacks;
  late AuthInterceptor interceptor;
  late MockRequestInterceptorHandler mockRequestHandler;
  late MockErrorInterceptorHandler mockErrorHandler;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
    registerFallbackValue(FakeDio());
  });

  setUp(() {
    mockDio = MockDio();
    mockTokenStorage = MockTokenStorage();
    mockCallbacks = MockInterceptorCallbacks();
    mockRequestHandler = MockRequestInterceptorHandler();
    mockErrorHandler = MockErrorInterceptorHandler();

    interceptor = AuthInterceptor(
      dio: mockDio,
      tokenStorage: mockTokenStorage,
      onRefresh: mockCallbacks.onRefresh,
      onForceLogout: mockCallbacks.onForceLogout,
    );
  });

  group('AuthInterceptor - onRequest', () {
    test('Skips token injection for auth endpoints', () async {
      final options = RequestOptions(path: '/auth/login');

      await interceptor.onRequest(options, mockRequestHandler);

      verify(() => mockRequestHandler.next(options)).called(1);
      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test('Injects access token if not expired', () async {
      final options = RequestOptions(path: '/transactions', headers: {});
      when(() => mockTokenStorage.isAccessExpired()).thenAnswer((_) async => false);
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => 'valid_token');

      await interceptor.onRequest(options, mockRequestHandler);

      verify(() => mockRequestHandler.next(options)).called(1);
      expect(options.headers['Authorization'], 'Bearer valid_token');
    });

    test('Proactively refreshes if token is expired', () async {
      final options = RequestOptions(path: '/transactions');
      when(() => mockTokenStorage.isAccessExpired()).thenAnswer((_) async => true);
      when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => 'valid_refresh');
      when(() => mockCallbacks.onRefresh(any(), any())).thenAnswer((_) async {});
      when(() => mockTokenStorage.getAccessToken()).thenAnswer((_) async => 'new_access_token');
      when(() => mockTokenStorage.hasTokens()).thenAnswer((_) async => true);

      await interceptor.onRequest(options, mockRequestHandler);

      verify(() => mockCallbacks.onRefresh(mockDio, 'valid_refresh')).called(1);
      verify(() => mockRequestHandler.next(options)).called(1);
      expect(options.headers['Authorization'], 'Bearer new_access_token');
    });

    test('Forces logout if refresh fails proactively', () async {
      final options = RequestOptions(path: '/transactions');
      when(() => mockTokenStorage.isAccessExpired()).thenAnswer((_) async => true);
      when(() => mockTokenStorage.getRefreshToken()).thenAnswer((_) async => 'bad_refresh');
      when(() => mockCallbacks.onRefresh(any(), any())).thenThrow(Exception('Refresh failed'));
      when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});
      when(() => mockCallbacks.onForceLogout()).thenAnswer((_) async {});

      await interceptor.onRequest(options, mockRequestHandler);

      verify(() => mockTokenStorage.clearTokens()).called(1);
      verify(() => mockCallbacks.onForceLogout()).called(1);
      verify(() => mockRequestHandler.reject(any(), true)).called(1);
    });
  });

  group('AuthInterceptor - onError', () {
    test('Passes err to next if statusCode is not 401', () async {
      final requestOptions = RequestOptions(path: '/transactions');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 500),
      );

      await interceptor.onError(err, mockErrorHandler);

      verify(() => mockErrorHandler.next(err)).called(1);
    });

    test('Passes err to next if endpoint is auth endpoint', () async {
      final requestOptions = RequestOptions(path: '/auth/login');
      final err = DioException(
        requestOptions: requestOptions,
        response: Response(requestOptions: requestOptions, statusCode: 401),
      );

      await interceptor.onError(err, mockErrorHandler);

      verify(() => mockErrorHandler.next(err)).called(1);
    });
  });
}
