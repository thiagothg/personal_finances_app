import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

enum CategoryType { income, expense }

extension CategoryTypeX on CategoryType {
  String get label => switch (this) {
    CategoryType.income => 'Income',
    CategoryType.expense => 'Expense',
  };

  String get apiValue => label;
}

CategoryType categoryTypeFromJson(String value) {
  switch (value.trim().toLowerCase()) {
    case 'income':
      return CategoryType.income;
    case 'expense':
      return CategoryType.expense;
    default:
      throw ArgumentError('Unsupported category type: $value');
  }
}

String categoryTypeToJson(CategoryType type) => type.apiValue;

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    required double? budget,
    required int? userId,
    required double totalSpend,
  }) = _Category;
}
