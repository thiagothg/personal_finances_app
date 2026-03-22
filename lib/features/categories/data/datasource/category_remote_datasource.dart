import 'package:dio/dio.dart';

import '../models/categories_response_model.dart';
import '../models/category_model.dart';
import '../models/create_or_update_category_request_model.dart';

class CategoryRemoteDatasource {
  CategoryRemoteDatasource(this.dio);

  final Dio dio;

  Future<CategoriesResponseModel> getCategories() async {
    try {
      final response = await dio.get('/categories');

      final json = Map<String, dynamic>.from(response.data as Map);
      return CategoriesResponseModel.fromJson(json);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    }
  }

  Future<CategoryModel> createCategory(
    CreateOrUpdateCategoryRequestModel request,
  ) async {
    try {
      final response = await dio.post('/categories', data: request.toJson());
      return _parseCategoryResponse(response.data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    }
  }

  Future<CategoryModel> updateCategory(
    int id,
    CreateOrUpdateCategoryRequestModel request,
  ) async {
    try {
      final response = await dio.put('/categories/$id', data: request.toJson());
      return _parseCategoryResponse(response.data);
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await dio.delete('/categories/$id');
    } on DioException catch (error) {
      throw Exception(_extractErrorMessage(error));
    }
  }

  CategoryModel _parseCategoryResponse(dynamic responseData) {
    final json = Map<String, dynamic>.from(responseData as Map);
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return CategoryModel.fromJson(data);
    }
    return CategoryModel.fromJson(json);
  }

  String _extractErrorMessage(DioException error) {
    var message = 'Unknown API error.';
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      if (responseData['errors'] is Map<String, dynamic>) {
        final errors = responseData['errors'] as Map<String, dynamic>;
        message = errors.values
            .map((value) => (value as List<dynamic>).first.toString())
            .join('\n');
      } else if (responseData['message'] != null) {
        message = responseData['message'].toString();
      }
    } else if (responseData is String && responseData.isNotEmpty) {
      message = responseData;
    }

    return message;
  }
}
