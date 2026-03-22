import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api/v1';
}
