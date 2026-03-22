import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'create_or_update_category_request_model.freezed.dart';
part 'create_or_update_category_request_model.g.dart';

@freezed
abstract class CreateOrUpdateCategoryRequestModel
    with _$CreateOrUpdateCategoryRequestModel {
  const factory CreateOrUpdateCategoryRequestModel({
    required String name,
    @JsonKey(fromJson: categoryTypeFromJson, toJson: categoryTypeToJson)
    required CategoryType type,
    required double budget,
    required String icon,
    required String color,
  }) = _CreateOrUpdateCategoryRequestModel;

  factory CreateOrUpdateCategoryRequestModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateOrUpdateCategoryRequestModelFromJson(json);
}
