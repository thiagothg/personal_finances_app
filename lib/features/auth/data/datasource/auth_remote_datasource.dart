import 'package:dio/dio.dart';
import '../models/user_model.dart';

class LoginResult {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;
  final DateTime refreshExpiresAt;

  LoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });
}

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
      final mainData = response.data['data'] as Map<String, dynamic>;
      final userMap = mainData['user'] as Map<String, dynamic>;

      final accessToken = mainData['access_token'] as String;
      final refreshToken = mainData['refresh_token'] as String;
      final accessExpiresAt = DateTime.parse(mainData['access_expires_at'] as String);
      final refreshExpiresAt = DateTime.parse(mainData['refresh_expires_at'] as String);

      // Ensure id is parsed to String if backend returns an INT, and inject the token.
      final userModel = UserModel.fromJson({
        ...userMap,
        'id': userMap['id'].toString(),
        'access_token': accessToken,
      });

      return LoginResult(
        user: userModel,
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessExpiresAt: accessExpiresAt,
        refreshExpiresAt: refreshExpiresAt,
      );
    } on DioException catch (e) {
      // Repassar erro tratado da API
      String message = 'Erro desconhecido na API.';
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          message = errors.values.map((v) => (v as List).first.toString()).join('\n');
        } else if (responseData.containsKey('message')) {
          message = responseData['message'].toString();
        }
      } else if (responseData is String) {
        message = responseData;
      }
      throw Exception(message);
    }
  }
}
