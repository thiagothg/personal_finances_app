import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:personal_finances_app/data/datasource/category_remote_datasource.dart';
import 'package:personal_finances_app/data/models/categories/categories_response_model.dart';
import 'package:personal_finances_app/data/models/categories/category_model.dart';
import 'package:personal_finances_app/data/models/categories/create_or_update_category_request_model.dart';
import 'package:personal_finances_app/data/repositories/category_repository_impl.dart';
import 'package:personal_finances_app/domain/entities/categories/category.dart';
import 'package:personal_finances_app/domain/entities/categories/category_totals.dart';

class MockCategoryRemoteDatasource extends Mock
    implements CategoryRemoteDatasource {}

void main() {
  late MockCategoryRemoteDatasource datasource;
  late CategoryRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(
      const CreateOrUpdateCategoryRequestModel(
        name: 'Fallback',
        type: CategoryType.income,
        budget: 1,
        icon: 'salary',
        color: '#000000',
      ),
    );
  });

  const salaryModel = CategoryModel(
    id: 1,
    name: 'Salary',
    type: CategoryType.income,
    icon: 'salary',
    color: '#4F46E5',
    budget: 5000,
    userId: 7,
    totalSpend: 2500,
  );

  const overviewModel = CategoriesResponseModel(
    data: {
      CategoryType.income: [salaryModel],
      CategoryType.expense: [],
    },
    meta: CategoriesMetaModel(
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
    ),
  );

  setUp(() {
    datasource = MockCategoryRemoteDatasource();
    repository = CategoryRepositoryImpl(datasource: datasource);
  });

  test('getCategories returns mapped domain overview', () async {
    when(
      () => datasource.getCategories(),
    ).thenAnswer((_) async => overviewModel);

    final result = await repository.getCategories();

    expect(result.totalCount, 1);
    expect(result.byType[CategoryType.income]!.first.name, 'Salary');
    verify(() => datasource.getCategories()).called(1);
  });

  test('createCategory delegates to datasource and maps domain', () async {
    when(
      () => datasource.createCategory(any()),
    ).thenAnswer((_) async => salaryModel);

    final result = await repository.createCategory(
      name: 'Salary',
      type: CategoryType.income,
      budget: 5000,
      icon: 'salary',
      color: '#4F46E5',
    );

    expect(result.id, 1);
    expect(result.type, CategoryType.income);
    verify(() => datasource.createCategory(any())).called(1);
  });

  test('updateCategory delegates to datasource and maps domain', () async {
    when(
      () => datasource.updateCategory(any(), any()),
    ).thenAnswer((_) async => salaryModel);

    final result = await repository.updateCategory(
      id: 1,
      name: 'Salary',
      type: CategoryType.income,
      budget: 5000,
      icon: 'salary',
      color: '#4F46E5',
    );

    expect(result.name, 'Salary');
    verify(() => datasource.updateCategory(1, any())).called(1);
  });

  test('deleteCategory delegates to datasource', () async {
    when(() => datasource.deleteCategory(1)).thenAnswer((_) async {});

    await repository.deleteCategory(1);

    verify(() => datasource.deleteCategory(1)).called(1);
  });
}
