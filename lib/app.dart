import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/providers/locale_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Finance App',
      theme: lightTheme,
      darkTheme: appTheme,
      themeMode: themeMode,
      locale: locale,
    );
  }
}
