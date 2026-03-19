import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Global Dio instance provider that reads the base URL from .env
final dioProvider = Provider<Dio>((ref) {
  // Safe fallback to 'http://10.0.2.2:8000' if env variable is missing
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';

  return Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );
});
