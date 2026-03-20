import '../../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  const DeleteCategoryUseCase(this.repository);

  final CategoryRepository repository;

  Future<void> call(int id) => repository.deleteCategory(id);
}
