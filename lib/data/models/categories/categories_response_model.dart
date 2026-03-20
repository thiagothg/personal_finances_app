import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/categories/categories_overview.dart';
import '../../../domain/entities/categories/category.dart';
import '../../../domain/entities/categories/category_totals.dart';
import 'category_model.dart';

part 'categories_response_model.freezed.dart';
part 'categories_response_model.g.dart';

@freezed
abstract class CategoriesResponseModel with _$CategoriesResponseModel {
  const CategoriesResponseModel._();

  const factory CategoriesResponseModel({
    @JsonKey(fromJson: _categoryGroupsFromJson, toJson: _categoryGroupsToJson)
    required Map<CategoryType, List<CategoryModel>> data,
    required CategoriesMetaModel meta,
  }) = _CategoriesResponseModel;

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseModelFromJson(json);

  CategoriesOverview toDomain() => CategoriesOverview(
    byType: data.map(
      (key, value) => MapEntry(
        key,
        List<Category>.unmodifiable(
          value.map((category) => category.toDomain()),
        ),
      ),
    ),
    totalCount: meta.totalCount,
    totalsByType: meta.totalsByType.map((key, value) => MapEntry(key, value)),
  );
}

@freezed
abstract class CategoriesMetaModel with _$CategoriesMetaModel {
  const factory CategoriesMetaModel({
    @JsonKey(name: 'total_count', fromJson: _intFromJson)
    required int totalCount,
    @JsonKey(
      name: 'total_by_type',
      fromJson: _totalsByTypeFromJson,
      toJson: _totalsByTypeToJson,
    )
    required Map<CategoryType, CategoryTotals> totalsByType,
  }) = _CategoriesMetaModel;

  factory CategoriesMetaModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesMetaModelFromJson(json);
}

Map<CategoryType, List<CategoryModel>> _categoryGroupsFromJson(
  Map<String, dynamic> json,
) {
  return json.map((key, value) {
    final type = categoryTypeFromJson(key);
    final items = (value as List<dynamic>)
        .map(
          (item) =>
              CategoryModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false);
    return MapEntry(type, items);
  });
}

Map<String, dynamic> _categoryGroupsToJson(
  Map<CategoryType, List<CategoryModel>> groups,
) {
  return groups.map((key, value) {
    return MapEntry(
      key.apiValue,
      value.map((item) => item.toJson()).toList(growable: false),
    );
  });
}

Map<CategoryType, CategoryTotals> _totalsByTypeFromJson(
  Map<String, dynamic> json,
) {
  return json.map((key, value) {
    final type = categoryTypeFromJson(key);
    final totals = _categoryTotalsFromJson(
      Map<String, dynamic>.from(value as Map),
    );
    return MapEntry(type, totals);
  });
}

Map<String, dynamic> _totalsByTypeToJson(
  Map<CategoryType, CategoryTotals> totalsByType,
) {
  return totalsByType.map(
    (key, value) => MapEntry(key.apiValue, _categoryTotalsToJson(value)),
  );
}

int _intFromJson(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid int value: $value');
}

CategoryTotals _categoryTotalsFromJson(Map<String, dynamic> json) {
  return CategoryTotals(
    totalSpent: _doubleFromJson(json['total_spent']),
    count: _intFromJson(json['count']),
    totalBudget: _doubleFromJson(json['total_budget']),
    remainingBudget: _doubleFromJson(json['remaining_budget']),
  );
}

Map<String, dynamic> _categoryTotalsToJson(CategoryTotals value) {
  return <String, dynamic>{
    'total_spent': value.totalSpent,
    'count': value.count,
    'total_budget': value.totalBudget,
    'remaining_budget': value.remainingBudget,
  };
}

double _doubleFromJson(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.parse(value);
  throw FormatException('Invalid double value: $value');
}
