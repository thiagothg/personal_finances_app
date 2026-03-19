import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() => const Locale('en');

  void toggle() {
    state = state.languageCode == 'en'
        ? const Locale('pt')
        : const Locale('en');
  }
}
