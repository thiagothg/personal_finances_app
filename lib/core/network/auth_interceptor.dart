import 'dart:async';
import 'package:dio/dio.dart';
import 'token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required Future<void> Function(Dio dio, String refreshToken) onRefresh,
    required Future<void> Function() onForceLogout,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _onRefresh = onRefresh,
        _onForceLogout = onForceLogout;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final Future<void> Function(Dio dio, String refreshToken) _onRefresh;
  final Future<void> Function() _onForceLogout;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthEndpoint(options.path)) return handler.next(options);

    if (await _tokenStorage.isAccessExpired()) {
      final refreshed = await _tryRefresh();
      if (!refreshed) {
        await _onForceLogout();
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.cancel,
            error: 'Session expired. Please log in again.',
          ),
          true,
        );
      }
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isAuthEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return _retryRequest(err.requestOptions, handler);
    }

    final refreshed = await _tryRefresh();
    if (!refreshed) {
      await _onForceLogout();
      return handler.next(err);
    }

    return _retryRequest(err.requestOptions, handler);
  }

  Future<bool> _tryRefresh() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return _tokenStorage.hasTokens();
    }

    _isRefreshing     = true;
    _refreshCompleter = Completer<void>();

    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;
      await _onRefresh(_dio, refreshToken);
      return true;
    } catch (_) {
      await _tokenStorage.clearTokens();
      return false;
    } finally {
      _isRefreshing = false;
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }

  Future<void> _retryRequest(
    RequestOptions options,
    ErrorInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await _dio.fetch(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _isAuthEndpoint(String path) =>
      path.contains('/auth/login') ||
      path.contains('/auth/register') ||
      path.contains('/auth/refresh');
}
