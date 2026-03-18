// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';

// pages
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/dashboard/presentation/pages/dashboard_page.dart';

// domain
import 'domain/entities/auth_state.dart';

// auth provider
import 'features/auth/providers.dart';

/// Provide a GoRouter that reacts to auth state changes.
/// We create it as a Provider so we can access it from widgets easily.
final routerProvider = Provider<GoRouter>((ref) {
  // watch auth state so router refreshes when it changes
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: authState.status == AuthStatus.authenticated
        ? '/'
        : '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (c, s) => const SplashPage(),
      ),
      // GoRoute(
      //   path: '/add',
      //   name: 'add_transaction',
      //   builder: (context, state) => const AddTransactionPage(),
      // ),
      // GoRoute(
      //   path: '/goals',
      //   name: 'goals',
      //   builder: (context, state) => const GoalsPage(),
      // ),
    ],
    // redirect callback runs on navigation attempts and when `refreshListenable` triggers.
    redirect: (context, state) {
      // If auth is still initializing, don't redirect — allow splash to show.
      if (authState.status == AuthStatus.unknown) return null;

      final loggedIn = authState.status == AuthStatus.authenticated;
      // allow both login and splash to proceed when unauthenticated
      final loggingInOrSplash =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/splash';

      if (!loggedIn && !loggingInOrSplash) {
        // Not logged in, try to go to login
        return '/login';
      }
      if (loggedIn && loggingInOrSplash) {
        // Already logged in, prevent going back to login
        return '/';
      }
      // no redirect
      return null;
    },
    // debug logging can help while developing
    debugLogDiagnostics: false,
  );
});

/// App entry widget — uses the router from the routerProvider.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Finance App',
      theme: appTheme,
    );
  }
}
