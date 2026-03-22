import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'category_totals.dart';

part 'categories_overview.freezed.dart';

@freezed
abstract class CategoriesOverview with _$CategoriesOverview {
  const factory CategoriesOverview({
    required Map<CategoryType, List<Category>> byType,
    required int totalCount,
    required Map<CategoryType, CategoryTotals> totalsByType,
  }) = _CategoriesOverview;
}
