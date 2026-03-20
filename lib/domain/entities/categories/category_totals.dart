import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_totals.freezed.dart';

@freezed
abstract class CategoryTotals with _$CategoryTotals {
  const factory CategoryTotals({
    required double totalSpent,
    required int count,
    required double totalBudget,
    required double remainingBudget,
  }) = _CategoryTotals;
}
