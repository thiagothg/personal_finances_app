import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_providers.dart'; // for dioProvider
import '../data/datasource/currency_remote_datasource.dart';
import '../data/repositories/currency_repository_impl.dart';
import '../domain/entities/currency.dart';
import '../domain/repositories/currency_repository.dart';
import '../domain/usecases/get_currencies.dart';

part 'currency_providers.g.dart';

@riverpod
CurrencyRemoteDatasource currencyDatasource(Ref ref) {
  return CurrencyRemoteDatasource(ref.watch(dioProvider));
}

@riverpod
CurrencyRepository currencyRepository(Ref ref) {
  return CurrencyRepositoryImpl(ref.watch(currencyDatasourceProvider));
}

/// Fetches currencies and caches the result.
///
/// keepAlive + a manual 6h expiry mirrors the server-side cache TTL.
/// The provider auto-disposes and re-fetches after 6 hours if the user
/// is still active — otherwise it re-fetches on next access.
@Riverpod(keepAlive: true)
Future<List<Currency>> currencies(Ref ref) async {
  final result = await GetCurrencies(ref.watch(currencyRepositoryProvider))();

  // Auto-invalidate after 6 hours to match server cache TTL.
  Future.delayed(const Duration(hours: 6), () {
    ref.invalidateSelf();
  });

  return result;
}

/// The currency the user currently has selected in the transaction form.
/// Defaults to BRL.
@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  @override
  Currency build() {
    // Default: BRL with 1:1 rate — used as fallback before currencies load.
    return const Currency(
      code:      'BRL',
      label:     'Brazilian Real',
      symbol:    'R\$',
      decimals:  2,
      rateToBrl: 1.0,
    );
  }

  void select(Currency currency) => state = currency;
}
