import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/side_nav_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import 'menu_item_data.dart';
import 'new_transaction_modal.dart';
import 'profile_modal.dart';

class DesktopSideNav extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const DesktopSideNav({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = ref.watch(sideNavExpandedProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final isDark = themeMode == ThemeMode.dark;
    final isEn = locale.languageCode == 'en';
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final width = expanded ? 280.0 : 72.0;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(right: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          _LogoRow(
            expanded: expanded,
            onToggle: () => ref.read(sideNavExpandedProvider.notifier).toggle(),
          ),
          const SizedBox(height: 8),
          _NewTransactionButton(expanded: expanded),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (final section in menuSections) ...[
                  if (section.title != null && expanded)
                    _SectionHeader(title: section.title!),
                  if (section.title != null && !expanded)
                    const Divider(height: 24),
                  for (final item in section.items)
                    _NavItem(
                      item: item,
                      expanded: expanded,
                      isActive: _isActive(item, currentLocation),
                      onTap: () => _onItemTap(context, item),
                    ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: expanded
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('EN')),
                          ButtonSegment(value: false, label: Text('PT')),
                        ],
                        selected: {isEn},
                        onSelectionChanged: (_) {
                          ref.read(localeProvider.notifier).toggle();
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(themeModeProvider.notifier).toggle();
                        },
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(localeProvider.notifier).toggle();
                        },
                        icon: Text(
                          isEn ? 'EN' : 'PT',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(themeModeProvider.notifier).toggle();
                        },
                        icon: Icon(
                          isDark ? Icons.light_mode : Icons.dark_mode,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
          ),
          _ProfileTile(
            expanded: expanded,
            user: user,
            onTap: () => showProfileModal(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  bool _isActive(MenuItemData item, String location) {
    return location == item.route;
  }

  void _onItemTap(BuildContext context, MenuItemData item) {
    if (item.branchIndex != null) {
      navigationShell.goBranch(
        item.branchIndex!,
        initialLocation: item.branchIndex == navigationShell.currentIndex,
      );
    } else {
      context.go(item.route);
    }
  }
}

class _LogoRow extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _LogoRow({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: onToggle,
            icon: Icon(expanded ? Icons.menu_open : Icons.menu),
          ),
          if (expanded) ...[
            const SizedBox(width: 8),
            const Icon(Icons.account_balance_wallet),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Personal Finances',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NewTransactionButton extends StatelessWidget {
  final bool expanded;

  const _NewTransactionButton({required this.expanded});

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: FilledButton.icon(
          onPressed: () => showNewTransactionModal(context),
          icon: const Icon(Icons.add),
          label: const Text('New Transaction'),
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: IconButton.filled(
        onPressed: () => showNewTransactionModal(context),
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, bottom: 4),
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

class _NavItem extends StatelessWidget {
  final MenuItemData item;
  final bool expanded;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.expanded,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            isActive ? item.activeIcon : item.icon,
            color: isActive
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          tooltip: item.label,
        ),
      );
    }

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

class _ProfileTile extends StatelessWidget {
  final bool expanded;
  final dynamic user;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.expanded,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = user?.name?.isNotEmpty == true
        ? user.name[0].toUpperCase()
        : '?';

    if (!expanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: IconButton(
          onPressed: onTap,
          icon: CircleAvatar(
            radius: 16,
            child: Text(initial, style: const TextStyle(fontSize: 14)),
          ),
          tooltip: 'Profile',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        leading: CircleAvatar(
          radius: 16,
          child: Text(initial, style: const TextStyle(fontSize: 14)),
        ),
        title: Text(
          user?.name ?? 'User',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          user?.email ?? '',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: onTap,
      ),
    );
  }
}
