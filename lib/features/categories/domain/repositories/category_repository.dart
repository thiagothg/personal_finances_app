import '../entities/categories_overview.dart';
import '../entities/category.dart';

abstract class CategoryRepository {
  Future<CategoriesOverview> getCategories();

  Future<Category> createCategory({
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  });

  Future<Category> updateCategory({
    required int id,
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  });

  Future<void> deleteCategory(int id);
}
