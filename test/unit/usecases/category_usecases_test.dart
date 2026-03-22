import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/features/categories/domain/entities/categories_overview.dart';
import 'package:personal_finances_app/features/categories/domain/entities/category.dart';
import 'package:personal_finances_app/features/categories/domain/entities/category_totals.dart';
import 'package:personal_finances_app/features/categories/domain/repositories/category_repository.dart';
import 'package:personal_finances_app/features/categories/domain/usecases/create_category_usecase.dart';
import 'package:personal_finances_app/features/categories/domain/usecases/delete_category_usecase.dart';
import 'package:personal_finances_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:personal_finances_app/features/categories/domain/usecases/update_category_usecase.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository repository;

  setUpAll(() {
    registerFallbackValue(CategoryType.income);
  });

  const category = Category(
    id: 1,
    name: 'Salary',
    type: CategoryType.income,
    icon: 'salary',
    color: '#4F46E5',
    budget: 5000,
    userId: 1,
    totalSpend: 2500,
  );

  const overview = CategoriesOverview(
    byType: {
      CategoryType.income: [category],
      CategoryType.expense: [],
    },
    totalCount: 1,
    totalsByType: {
      CategoryType.income: CategoryTotals(
        totalSpent: 2500,
        count: 1,
        totalBudget: 5000,
        remainingBudget: 2500,
      ),
      CategoryType.expense: CategoryTotals(
        totalSpent: 0,
        count: 0,
        totalBudget: 0,
        remainingBudget: 0,
      ),
    },
  );

  setUp(() {
    repository = MockCategoryRepository();
  });

  test('GetCategoriesUseCase delegates to repository', () async {
    when(() => repository.getCategories()).thenAnswer((_) async => overview);

    final result = await GetCategoriesUseCase(repository)();

    expect(result, overview);
    verify(() => repository.getCategories()).called(1);
  });

  test('CreateCategoryUseCase delegates to repository', () async {
    when(
      () => repository.createCategory(
        name: any(named: 'name'),
        type: any(named: 'type'),
        budget: any(named: 'budget'),
        icon: any(named: 'icon'),
        color: any(named: 'color'),
      ),
    ).thenAnswer((_) async => category);

    final result = await CreateCategoryUseCase(repository)(
      name: 'Salary',
      type: CategoryType.income,
      budget: 5000,
      icon: 'salary',
      color: '#4F46E5',
    );

    expect(result, category);
    verify(
      () => repository.createCategory(
        name: 'Salary',
        type: CategoryType.income,
        budget: 5000,
        icon: 'salary',
        color: '#4F46E5',
      ),
    ).called(1);
  });

  test('UpdateCategoryUseCase delegates to repository', () async {
    when(
      () => repository.updateCategory(
        id: any(named: 'id'),
        name: any(named: 'name'),
        type: any(named: 'type'),
        budget: any(named: 'budget'),
        icon: any(named: 'icon'),
        color: any(named: 'color'),
      ),
    ).thenAnswer((_) async => category);

    final result = await UpdateCategoryUseCase(repository)(
      id: 1,
      name: 'Salary',
      type: CategoryType.income,
      budget: 5000,
      icon: 'salary',
      color: '#4F46E5',
    );

    expect(result, category);
    verify(
      () => repository.updateCategory(
        id: 1,
        name: 'Salary',
        type: CategoryType.income,
        budget: 5000,
        icon: 'salary',
        color: '#4F46E5',
      ),
    ).called(1);
  });

  test('DeleteCategoryUseCase delegates to repository', () async {
    when(() => repository.deleteCategory(1)).thenAnswer((_) async {});

    await DeleteCategoryUseCase(repository)(1);

    verify(() => repository.deleteCategory(1)).called(1);
  });
}
