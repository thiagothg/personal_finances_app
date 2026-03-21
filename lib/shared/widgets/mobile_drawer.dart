import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'menu_item_data.dart';

class MobileDrawer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MobileDrawer({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet),
                  const SizedBox(width: 12),
                  Text('Personal Finances', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  for (final section in menuSections) ...[
                    if (section.title != null) _DrawerSectionHeader(title: section.title!),
                    for (final item in section.items)
                      _DrawerItem(
                        item: item,
                        isActive: currentLocation == item.route,
                        colorScheme: colorScheme,
                        onTap: () {
                          Navigator.of(context).pop();
                          if (item.branchIndex != null) {
                            navigationShell.goBranch(
                              item.branchIndex!,
                              initialLocation: item.branchIndex == navigationShell.currentIndex,
                            );
                          } else {
                            context.go(item.route);
                          }
                        },
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionHeader extends StatelessWidget {
  final String title;

  const _DrawerSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final MenuItemData item;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.item,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selected: isActive,
        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
        leading: Icon(
          isActive ? item.activeIcon : item.icon,
          color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
          size: 22,
        ),
        title: Text(
          item.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isActive ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
