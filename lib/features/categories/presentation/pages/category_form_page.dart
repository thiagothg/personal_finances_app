import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/categories/category.dart';
import '../widgets/category_form.dart';

class CategoryFormPage extends StatelessWidget {
  const CategoryFormPage({super.key, this.category, this.initialType});

  final Category? category;
  final CategoryType? initialType;

  bool get _isEditing => category != null;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 600 ? AppSpacing.md : AppSpacing.lg;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Category' : 'New Category'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: CategoryForm(
                category: category,
                initialType: initialType,
                onSuccess: () => Navigator.of(context).pop(true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showCategoryFormDialog(
  BuildContext context, {
  Category? category,
  CategoryType? initialType,
}) {
  final isEditing = category != null;

  return showDialog<void>(
    context: context,
    builder: (context) {
      final width = MediaQuery.sizeOf(context).width;
      final isCompact = width < 700;

      return AlertDialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isCompact ? AppSpacing.md : AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        title: Text(isEditing ? 'Edit Category' : 'New Category'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: CategoryForm(
            category: category,
            initialType: initialType,
            showCancelButton: true,
            onCancel: () => Navigator.of(context).pop(),
            onSuccess: () => Navigator.of(context).pop(true),
          ),
        ),
      );
    },
  );
}
