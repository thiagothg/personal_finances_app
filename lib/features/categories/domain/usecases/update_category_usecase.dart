import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  const UpdateCategoryUseCase(this.repository);

  final CategoryRepository repository;

  Future<Category> call({
    required int id,
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) {
    return repository.updateCategory(
      id: id,
      name: name,
      type: type,
      budget: budget,
      icon: icon,
      color: color,
    );
  }
}
