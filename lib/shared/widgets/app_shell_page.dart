import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'desktop_side_nav.dart';
import 'mobile_bottom_nav_bar.dart';
import 'mobile_drawer.dart';
import 'new_transaction_fab.dart';

class AppShellPage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShellPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;
        if (isDesktop) {
          return _DesktopShell(navigationShell: navigationShell);
        }
        return _MobileShell(navigationShell: navigationShell);
      },
    );
  }
}

class _DesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _DesktopShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DesktopSideNav(navigationShell: navigationShell),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _MobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MobileShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Personal Finances',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: MobileDrawer(navigationShell: navigationShell),
      body: navigationShell,
      bottomNavigationBar: navigationShell.currentIndex < 4
          ? MobileBottomNavBar(navigationShell: navigationShell)
          : null,
      floatingActionButton: navigationShell.currentIndex == 1 ? const NewTransactionFab() : null,
    );
  }
}
