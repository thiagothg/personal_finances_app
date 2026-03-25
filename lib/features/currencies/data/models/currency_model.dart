import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/currency.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

@freezed
abstract class CurrencyModel with _$CurrencyModel {
  const CurrencyModel._();

  const factory CurrencyModel({
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'label') required String label,
    @JsonKey(name: 'symbol') required String symbol,
    @JsonKey(name: 'decimals') required int decimals,
    @JsonKey(name: 'rate_to_brl') @Default(1.0) double rateToBrl,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Currency toDomain() => Currency(
        code:      code,
        label:     label,
        symbol:    symbol,
        decimals:  decimals,
        rateToBrl: rateToBrl,
      );
}
