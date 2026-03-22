import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances_app/features/categories/data/models/categories_response_model.dart';
import 'package:personal_finances_app/features/categories/domain/entities/category.dart';

void main() {
  group('CategoriesResponseModel', () {
    test('parses grouped categories and totals from API response', () {
      final model = CategoriesResponseModel.fromJson({
        'data': {
          'Expense': [
            {
              'id': 26,
              'name': 'Groceries',
              'type': 'Expense',
              'icon': 'food',
              'color': '#DB525F',
              'budget': null,
              'user_id': 37,
              'total_spend': 13428.06,
            },
          ],
          'Income': [
            {
              'id': 27,
              'name': 'Salary',
              'type': 'Income',
              'icon': 'salary',
              'color': '#A932ED',
              'budget': 10000.0,
              'user_id': 38,
              'total_spend': 4571.81,
            },
          ],
        },
        'meta': {
          'total_count': 2,
          'total_by_type': {
            'Expense': {
              'total_spent': 13428.06,
              'count': 1,
              'total_budget': 0,
              'remaining_budget': -13428.06,
            },
            'Income': {
              'total_spent': 4571.81,
              'count': 1,
              'total_budget': 10000.0,
              'remaining_budget': 5428.19,
            },
          },
        },
      });

      expect(model.data[CategoryType.expense], hasLength(1));
      expect(model.data[CategoryType.income], hasLength(1));
      expect(model.data[CategoryType.expense]!.first.budget, isNull);
      expect(model.meta.totalCount, 2);
      expect(
        model.meta.totalsByType[CategoryType.income]!.totalBudget,
        10000.0,
      );

      final domain = model.toDomain();
      expect(domain.totalCount, 2);
      expect(domain.byType[CategoryType.income]!.first.name, 'Salary');
      expect(
        domain.totalsByType[CategoryType.expense]!.remainingBudget,
        -13428.06,
      );
    });
  });
}
