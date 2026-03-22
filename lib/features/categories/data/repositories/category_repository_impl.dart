import '../../domain/entities/categories_overview.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasource/category_remote_datasource.dart';
import '../models/create_or_update_category_request_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required this.datasource});

  final CategoryRemoteDatasource datasource;

  @override
  Future<CategoriesOverview> getCategories() async {
    final response = await datasource.getCategories();
    return response.toDomain();
  }

  @override
  Future<Category> createCategory({
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) async {
    final model = await datasource.createCategory(
      CreateOrUpdateCategoryRequestModel(
        name: name,
        type: type,
        budget: budget,
        icon: icon,
        color: color,
      ),
    );
    return model.toDomain();
  }

  @override
  Future<Category> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) async {
    final model = await datasource.updateCategory(
      id,
      CreateOrUpdateCategoryRequestModel(
        name: name,
        type: type,
        budget: budget,
        icon: icon,
        color: color,
      ),
    );
    return model.toDomain();
  }

  @override
  Future<void> deleteCategory(int id) => datasource.deleteCategory(id);
}
