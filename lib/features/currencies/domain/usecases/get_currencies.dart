import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

class GetCurrencies {
  const GetCurrencies(this._repository);

  final CurrencyRepository _repository;

  Future<List<Currency>> call() => _repository.getCurrencies();
}
