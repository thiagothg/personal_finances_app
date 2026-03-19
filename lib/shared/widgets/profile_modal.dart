import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

void showProfileModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const _ProfileSheet(),
  );
}

class _ProfileSheet extends ConsumerWidget {
  const _ProfileSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isEn = locale.languageCode == 'en';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            child: Text(
              user?.name.isNotEmpty == true
                  ? user!.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 12),
          if (user != null) ...[
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('EN')),
                  ButtonSegment(value: false, label: Text('PT')),
                ],
                selected: {isEn},
                onSelectionChanged: (_) {
                  ref
                      .read(localeProvider.notifier)
                      .toggle();
                },
              ),
              IconButton(
                onPressed: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .toggle();
                },
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                ref
                    .read(authControllerProvider.notifier)
                    .signOut();
                context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    Theme.of(context).colorScheme.error,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
