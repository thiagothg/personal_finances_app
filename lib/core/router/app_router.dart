import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// pages
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';

// domain
import '../../domain/entities/auth_state.dart';

// auth provider
import '../../features/auth/providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: authState.status == AuthStatus.authenticated ? '/' : '/splash',
    routes: <RouteBase>[
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/', name: 'dashboard', builder: (context, state) => const DashboardPage()),
      GoRoute(path: '/splash', name: 'splash', builder: (c, s) => const SplashPage()),
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
    redirect: (context, state) {
      if (authState.status == AuthStatus.unknown) return null;

      final loggedIn = authState.status == AuthStatus.authenticated;
      final loggingInOrSplash =
          state.matchedLocation == '/login' || state.matchedLocation == '/splash';

      if (!loggedIn && !loggingInOrSplash) {
        return '/login';
      }
      if (loggedIn && loggingInOrSplash) {
        return '/';
      }
      return null;
    },
    debugLogDiagnostics: false,
  );
});
