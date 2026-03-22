import '../entities/categories_overview.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this.repository);

  final CategoryRepository repository;

  Future<CategoriesOverview> call() => repository.getCategories();
}
