import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/categories/category.dart';
import '../../providers/category_providers.dart';
import '../widgets/category_card.dart';
import 'category_form_page.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

  CategoryType get _currentType =>
      _tabController.index == 0 ? CategoryType.income : CategoryType.expense;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overviewState = ref.watch(categoriesOverviewControllerProvider);
    final mutationState = ref.watch(categoryMutationControllerProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () => ref.read(categoriesOverviewControllerProvider.notifier).reload(),
      child: overviewState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SelectableText.rich(
              TextSpan(
                text: error.toString().replaceFirst('Exception: ', ''),
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ref.read(categoriesOverviewControllerProvider.notifier).reload();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
        data: (overview) {
          final categories = overview.byType[_currentType] ?? const <Category>[];
          final totals = overview.totalsByType[_currentType];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageHeader(
                      isDesktop: isDesktop,
                      onAdd: () => _openCategoryForm(context, initialType: _currentType),
                    ),
                    if (mutationState.hasError && !mutationState.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SelectableText.rich(
                          TextSpan(
                            text: ref
                                .read(categoryMutationControllerProvider.notifier)
                                .errorMessage,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    _SummaryRow(
                      totalBudget: totals?.totalBudget ?? 0,
                      totalCategories: totals?.count ?? categories.length,
                      currencyFormat: _currencyFormat,
                    ),
                    const SizedBox(height: 24),
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Income'),
                        Tab(text: 'Expense'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (categories.isEmpty)
                      _EmptyState(
                        onAdd: () {
                          _openCategoryForm(context, initialType: _currentType);
                        },
                      )
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (!isDesktop) {
                            return Column(
                              children: categories
                                  .map(
                                    (category) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: CategoryCard(
                                        category: category,
                                        onEdit: () =>
                                            _openCategoryForm(context, category: category),
                                        onDelete: () => _confirmDelete(context, category),
                                      ),
                                    ),
                                  )
                                  .toList(growable: false),
                            );
                          }

                          const spacing = AppSpacing.md;
                          const minDesktopCardWidth = 320.0;
                          final columns = (constraints.maxWidth / minDesktopCardWidth)
                              .floor()
                              .clamp(1, 3);
                          final cardWidth =
                              (constraints.maxWidth - (spacing * (columns - 1))) / columns;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: categories
                                .map(
                                  (category) => SizedBox(
                                    width: cardWidth,
                                    child: CategoryCard(
                                      category: category,
                                      onEdit: () => _openCategoryForm(context, category: category),
                                      onDelete: () => _confirmDelete(context, category),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openCategoryForm(
    BuildContext context, {
    Category? category,
    CategoryType? initialType,
  }) async {
    final isDesktop = MediaQuery.sizeOf(context).width >= 800;
    if (isDesktop) {
      await showCategoryFormDialog(context, category: category, initialType: initialType);
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryFormPage(category: category, initialType: initialType),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category', style: Theme.of(context).textTheme.titleMedium),
          content: Text('Delete "${category.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(categoryMutationControllerProvider.notifier).deleteCategory(category.id);
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.isDesktop, required this.onAdd});

  final bool isDesktop;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories', style: textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'Track budgets and keep every category organized.',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isDesktop)
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('New Category'),
            )
          else
            IconButton.filled(
              onPressed: onAdd,
              tooltip: 'Add category',
              icon: const Icon(Icons.add),
            ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.totalBudget,
    required this.totalCategories,
    required this.currencyFormat,
  });

  final double totalBudget;
  final int totalCategories;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;
    final cards = [
      _SummaryCard(
        title: 'Total budget',
        value: currencyFormat.format(totalBudget),
        icon: Icons.account_balance_wallet_outlined,
      ),
      _SummaryCard(
        title: 'Total categories',
        value: '$totalCategories',
        icon: Icons.category_outlined,
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          cards[0],
          const SizedBox(height: AppSpacing.md),
          cards[1],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: cards[1]),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final summaryIconColor = isDark ? colorScheme.onPrimaryContainer : colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: summaryIconColor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: textTheme.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No categories yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Create your first category to start organizing budgets.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Create category'),
            ),
          ],
        ),
      ),
    );
  }
}
