import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finances_app/features/categories/presentation/utils/category_progress.dart';

void main() {
  group('calculateCategoryBudgetProgress', () {
    test('returns null when budget is null', () {
      final result = calculateCategoryBudgetProgress(
        totalSpend: 100,
        budget: null,
      );

      expect(result, isNull);
    });

    test('returns null when budget is zero', () {
      final result = calculateCategoryBudgetProgress(
        totalSpend: 100,
        budget: 0,
      );

      expect(result, isNull);
    });

    test('returns clamped progress for positive budgets', () {
      final result = calculateCategoryBudgetProgress(
        totalSpend: 150,
        budget: 100,
      );

      expect(result, 1.0);
    });
  });
}
