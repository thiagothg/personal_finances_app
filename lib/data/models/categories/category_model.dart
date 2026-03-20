import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/categories/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    @JsonKey(fromJson: _intFromJson) required int id,
    required String name,
    @JsonKey(fromJson: categoryTypeFromJson, toJson: categoryTypeToJson)
    required CategoryType type,
    required String icon,
    required String color,
    @JsonKey(fromJson: _doubleNullableFromJson) required double? budget,
    @JsonKey(name: 'user_id', fromJson: _intNullableFromJson)
    required int? userId,
    @JsonKey(name: 'total_spend', fromJson: _doubleFromJson)
    required double totalSpend,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Category toDomain() => Category(
    id: id,
    name: name,
    type: type,
    icon: icon,
    color: color,
    budget: budget,
    userId: userId,
    totalSpend: totalSpend,
  );
}

int _intFromJson(Object? value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid int value: $value');
}

int? _intNullableFromJson(Object? value) {
  if (value == null) return null;
  return _intFromJson(value);
}

double _doubleFromJson(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.parse(value);
  throw FormatException('Invalid double value: $value');
}

double? _doubleNullableFromJson(Object? value) {
  if (value == null) return null;
  return _doubleFromJson(value);
}
