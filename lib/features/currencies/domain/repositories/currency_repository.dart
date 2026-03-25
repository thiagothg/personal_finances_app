import '../entities/currency.dart';

abstract class CurrencyRepository {
  /// Returns all supported currencies with their current BRL rate.
  Future<List<Currency>> getCurrencies();
}
