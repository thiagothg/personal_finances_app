import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;

  AuthRemoteDatasource(this.dio);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
      final data = response.data as Map<String, dynamic>;
      final user = data['user'] as Map<String, dynamic>;
      final token = data['token'] as String;

      // Ensure id is parsed to String if backend returns an INT, and inject the token.
      final userModel = UserModel.fromJson({
        ...user,
        'id': user['id'].toString(),
        'access_token': token,
      });

      return userModel;
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
