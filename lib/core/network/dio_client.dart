import 'package:dio/dio.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    required TokenStorage tokenStorage,
    required Future<void> Function() onForceLogout,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: tokenStorage,
        onRefresh: (innerDio, refreshToken) => _performRefresh(
          dio: innerDio,
          refreshToken: refreshToken,
          tokenStorage: tokenStorage,
        ),
        onForceLogout: onForceLogout,
      ),
    );

    assert(() {
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      return true;
    }());

    return dio;
  }

  static Future<void> _performRefresh({
    required Dio dio,
    required String refreshToken,
    required TokenStorage tokenStorage,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw Exception('Malformed refresh response.');

    await tokenStorage.saveTokens(
      accessToken:      data['access_token'] as String,
      refreshToken:     data['refresh_token'] as String,
      accessExpiresAt:  DateTime.parse(data['access_expires_at'] as String),
      refreshExpiresAt: DateTime.parse(data['refresh_expires_at'] as String),
    );
  }
}
