import '../../domain/entities/currency.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasource/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._datasource);

  final CurrencyRemoteDatasource _datasource;

  @override
  Future<List<Currency>> getCurrencies() async {
    final models = await _datasource.getCurrencies();
    return models.map((m) => m.toDomain()).toList();
  }
}
