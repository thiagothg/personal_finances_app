import 'package:dio/dio.dart';
import '../models/currency_model.dart';

class CurrencyRemoteDatasource {
  const CurrencyRemoteDatasource(this._dio);

  final Dio _dio;

  Future<List<CurrencyModel>> getCurrencies() async {
    final response = await _dio.get<Map<String, dynamic>>('/currencies');

    final items = response.data?['data'] as List<dynamic>? ?? [];

    return items
        .map((j) => CurrencyModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
