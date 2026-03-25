import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/currency.dart';
import '../../providers/currency_providers.dart';

class CurrencyPicker extends ConsumerWidget {
  const CurrencyPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currenciesAsync = ref.watch(currenciesProvider);
    final selected = ref.watch(selectedCurrencyProvider);

    return currenciesAsync.when(
      loading: () => const SizedBox(width: 80, child: LinearProgressIndicator()),
      error: (_, _) => const Text('Rates unavailable'),
      data: (currencies) => DropdownButton<Currency>(
        value: selected,
        underline: const SizedBox.shrink(),
        onChanged: (currency) {
          if (currency != null) {
            ref.read(selectedCurrencyProvider.notifier).select(currency);
          }
        },
        items: currencies.map((currency) {
          return DropdownMenuItem(
            value: currency,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currency.code,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 6),
                Text(
                  currency.isBase
                      ? currency.symbol
                      : '1 ${currency.code} = R\$ ${currency.rateToBrl.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
