import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileBottomNavBar extends StatelessWidget {
  const MobileBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = <_MobileNavItem>[
    _MobileNavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard),
    _MobileNavItem(
      label: 'Transactions',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
    ),
    _MobileNavItem(
      label: 'Investments',
      icon: Icons.trending_up_outlined,
      activeIcon: Icons.trending_up,
    ),
    _MobileNavItem(label: 'Settings', icon: Icons.settings_outlined, activeIcon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: true,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Row(
          children: [
            for (var index = 0; index < _items.length; index++)
              Expanded(
                child: _MobileBottomNavBarItem(
                  item: _items[index],
                  selected: navigationShell.currentIndex == index,
                  isDark: isDark,
                  onTap: () {
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomNavBarItem extends StatelessWidget {
  const _MobileBottomNavBarItem({
    required this.item,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final _MobileNavItem item;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedForeground = colorScheme.onPrimaryContainer;
    final unselectedForeground = isDark
        ? colorScheme.onSurface.withValues(alpha: 0.9)
        : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? colorScheme.primaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? item.activeIcon : item.icon,
                  color: selected ? selectedForeground : unselectedForeground,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? selectedForeground : unselectedForeground,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem {
  const _MobileNavItem({required this.label, required this.icon, required this.activeIcon});

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
