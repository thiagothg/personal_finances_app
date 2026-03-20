import '../../entities/categories/category.dart';
import '../../repositories/category_repository.dart';

class CreateCategoryUseCase {
  const CreateCategoryUseCase(this.repository);

  final CategoryRepository repository;

  Future<Category> call({
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) {
    return repository.createCategory(
      name: name,
      type: type,
      budget: budget,
      icon: icon,
      color: color,
    );
  }
}
