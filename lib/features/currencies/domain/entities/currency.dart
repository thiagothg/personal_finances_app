import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

@freezed
abstract class Currency with _$Currency {
  const Currency._();

  const factory Currency({
    required String code,      // 'USD'
    required String label,     // 'US Dollar'
    required String symbol,    // '$'
    required int    decimals,  // 2
    required double rateToBrl, // 5.42
  }) = _Currency;

  /// True when this is the app base currency — no conversion needed.
  bool get isBase => code == 'BRL';

  /// Format an amount in this currency for display.
  String format(double amount) {
    final formatted = amount.toStringAsFixed(decimals);
    return '$symbol $formatted';
  }

  /// Convert an amount in this currency to BRL.
  double toBrl(double amount) => amount * rateToBrl;
}
