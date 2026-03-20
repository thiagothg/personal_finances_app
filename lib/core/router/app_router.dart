import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/widgets/app_shell_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/investments/presentation/pages/investments_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/people/presentation/pages/people_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/accounts/presentation/pages/accounts_page.dart';
import '../../features/recurring/presentation/pages/recurring_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/net_worth/presentation/pages/net_worth_page.dart';
import '../../features/cash_flow/presentation/pages/cash_flow_page.dart';
import '../../features/spending/presentation/pages/spending_page.dart';
import '../../features/trends/presentation/pages/trends_page.dart';

import '../../domain/entities/auth/auth_state.dart';
import '../../shared/providers/auth/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: authState.status == AuthStatus.authenticated ? '/dashboard' : '/splash',
    routes: <RouteBase>[
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/splash', name: 'splash', builder: (c, s) => const SplashPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (c, s) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                name: 'transactions',
                builder: (c, s) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/investments',
                name: 'investments',
                builder: (c, s) => const InvestmentsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/settings', name: 'settings', builder: (c, s) => const SettingsPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/goals', name: 'goals', builder: (c, s) => const GoalsPage())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/people', name: 'people', builder: (c, s) => const PeoplePage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                name: 'categories',
                builder: (c, s) => const CategoriesPage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(path: '/accounts', name: 'accounts', builder: (c, s) => const AccountsPage()),
      GoRoute(path: '/recurring', name: 'recurring', builder: (c, s) => const RecurringPage()),
      GoRoute(path: '/budget', name: 'budget', builder: (c, s) => const BudgetPage()),
      GoRoute(path: '/reports', name: 'reports', builder: (c, s) => const ReportsPage()),
      GoRoute(path: '/net-worth', name: 'net-worth', builder: (c, s) => const NetWorthPage()),
      GoRoute(path: '/cash-flow', name: 'cash-flow', builder: (c, s) => const CashFlowPage()),
      GoRoute(path: '/spending', name: 'spending', builder: (c, s) => const SpendingPage()),
      GoRoute(path: '/trends', name: 'trends', builder: (c, s) => const TrendsPage()),
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
        return '/dashboard';
      }
      return null;
    },
    debugLogDiagnostics: false,
  );
});
