import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../domain/entities/categories/category.dart';
import '../utils/category_progress.dart';
import 'category_icon_catalog.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categoryColor = _parseColor(category.color);
    final progress = calculateCategoryBudgetProgress(
      totalSpend: category.totalSpend,
      budget: category.budget,
    );

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    iconForCategoryKey(category.icon),
                    color: categoryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(category.name, style: textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        '${category.type.label} • Budget ${_formatBudget(category.budget)}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit category',
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete category',
                  icon: Icon(Icons.delete_outline, color: colorScheme.error),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Spent ${_currencyFormat.format(category.totalSpend)}',
                    style: textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  progress == null
                      ? 'No budget set'
                      : '${(progress * 100).round()}%',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress != null && progress >= 1
                      ? colorScheme.error
                      : categoryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBudget(double? budget) {
    if (budget == null) {
      return 'Not set';
    }
    return _currencyFormat.format(budget);
  }

  Color _parseColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    final value = int.tryParse(normalized, radix: 16);
    if (value == null) {
      return Colors.grey;
    }
    return Color(0xFF000000 | value);
  }
}
