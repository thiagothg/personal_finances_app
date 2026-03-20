import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances_app/domain/entities/categories/categories_overview.dart';
import 'package:personal_finances_app/domain/entities/categories/category.dart';
import 'package:personal_finances_app/domain/entities/categories/category_totals.dart';
import 'package:personal_finances_app/domain/repositories/category_repository.dart';
import 'package:personal_finances_app/features/categories/presentation/pages/categories_page.dart';
import 'package:personal_finances_app/features/categories/providers/category_providers.dart';

class FakeCategoryRepository implements CategoryRepository {
  FakeCategoryRepository(this._categories);

  final List<Category> _categories;
  int _nextId = 100;

  @override
  Future<Category> createCategory({
    required String name,
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) async {
    final category = Category(
      id: _nextId++,
      name: name,
      type: type,
      icon: icon,
      color: color,
      budget: budget,
      userId: 1,
      totalSpend: 0,
    );
    _categories.add(category);
    return category;
  }

  @override
  Future<void> deleteCategory(int id) async {
    _categories.removeWhere((category) => category.id == id);
  }

  @override
  Future<CategoriesOverview> getCategories() async {
    final income = _categories
        .where((category) => category.type == CategoryType.income)
        .toList(growable: false);
    final expense = _categories
        .where((category) => category.type == CategoryType.expense)
        .toList(growable: false);

    return CategoriesOverview(
      byType: {CategoryType.income: income, CategoryType.expense: expense},
      totalCount: _categories.length,
      totalsByType: {
        CategoryType.income: _buildTotals(income),
        CategoryType.expense: _buildTotals(expense),
      },
    );
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
    final index = _categories.indexWhere((category) => category.id == id);
    final updated = _categories[index].copyWith(
      name: name,
      type: type,
      budget: budget,
      icon: icon,
      color: color,
    );
    _categories[index] = updated;
    return updated;
  }

  CategoryTotals _buildTotals(List<Category> categories) {
    final totalSpent = categories.fold<double>(
      0,
      (sum, category) => sum + category.totalSpend,
    );
    final totalBudget = categories.fold<double>(
      0,
      (sum, category) => sum + (category.budget ?? 0),
    );

    return CategoryTotals(
      totalSpent: totalSpent,
      count: categories.length,
      totalBudget: totalBudget,
      remainingBudget: totalBudget - totalSpent,
    );
  }
}

void main() {
  late FakeCategoryRepository repository;

  setUp(() {
    repository = FakeCategoryRepository([
      const Category(
        id: 1,
        name: 'Salary',
        type: CategoryType.income,
        icon: 'salary',
        color: '#4F46E5',
        budget: 5000,
        userId: 1,
        totalSpend: 2500,
      ),
      const Category(
        id: 2,
        name: 'Groceries',
        type: CategoryType.expense,
        icon: 'food',
        color: '#DB525F',
        budget: 800,
        userId: 1,
        totalSpend: 200,
      ),
    ]);
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    Size size = const Size(430, 932),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [categoryRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: Scaffold(body: CategoriesPage())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders categories and summary data', (tester) async {
    await pumpPage(tester);

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('\$5,000.00'), findsOneWidget);
  });

  testWidgets('switches tabs between income and expense', (tester) async {
    await pumpPage(tester);

    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Groceries'), findsNothing);

    await tester.tap(find.text('Expense'));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Salary'), findsNothing);
  });

  testWidgets('opens create form as a page on mobile', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byTooltip('Add category'));
    await tester.pumpAndSettle();

    expect(find.text('New Category'), findsOneWidget);
    expect(find.text('Create a new category'), findsOneWidget);
  });

  testWidgets('opens create form as a dialog on desktop', (tester) async {
    await pumpPage(tester, size: const Size(1200, 900));

    await tester.tap(find.text('New Category'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Create a new category'), findsOneWidget);
  });

  testWidgets('shows validation errors on empty submit', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byTooltip('Add category'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Create category'));
    await tester.tap(find.text('Create category'));
    await tester.pumpAndSettle();

    expect(find.text('Name is required'), findsOneWidget);
    expect(find.text('Budget is required'), findsOneWidget);
    expect(find.text('Icon is required'), findsOneWidget);
  });

  testWidgets('creates a category and refreshes the list', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byTooltip('Add category'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Bonus');
    await tester.enterText(find.byType(TextFormField).at(1), '900');
    await tester.tap(find.byKey(const ValueKey('icon-salary')));
    await tester.enterText(find.byType(TextFormField).at(2), '#123456');
    await tester.ensureVisible(find.text('Create category'));
    await tester.tap(find.text('Create category'));
    await tester.pumpAndSettle();

    expect(find.text('Bonus'), findsOneWidget);
  });

  testWidgets('deletes a category and refreshes the list', (tester) async {
    await pumpPage(tester);
    await tester.tap(find.text('Expense'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete category'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Groceries'), findsNothing);
    expect(find.text('No categories yet'), findsOneWidget);
  });
}
