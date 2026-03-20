import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/categories/category.dart';
import '../../providers/category_providers.dart';
import 'category_icon_catalog.dart';

class CategoryForm extends ConsumerStatefulWidget {
  const CategoryForm({
    super.key,
    this.category,
    this.initialType,
    this.showCancelButton = false,
    this.onCancel,
    this.onSuccess,
  });

  final Category? category;
  final CategoryType? initialType;
  final bool showCancelButton;
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;

  @override
  ConsumerState<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends ConsumerState<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _budgetController;
  late final TextEditingController _colorController;

  CategoryType? _selectedType;
  String? _selectedIconKey;
  Color _selectedColor = _categoryColorPalette.first;
  bool _showIconError = false;

  static const List<Color> _categoryColorPalette = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.categoryFood,
    AppColors.categoryTransport,
    AppColors.success,
    AppColors.warning,
    AppColors.error,
    Color(0xFFE11D48),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
    Color(0xFF0EA5E9),
    Color(0xFFF97316),
  ];

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _nameController = TextEditingController(text: category?.name ?? '');
    _budgetController = TextEditingController(
      text: category?.budget?.toStringAsFixed(2) ?? '',
    );

    _selectedType = category?.type ?? widget.initialType;
    _selectedIconKey = category?.icon;
    _selectedColor =
        _parseColor(category?.color) ?? _categoryColorPalette.first;
    _colorController = TextEditingController(text: _colorToHex(_selectedColor));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _showIconError = _selectedIconKey == null;
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || _selectedIconKey == null || _selectedType == null) {
      return;
    }

    final budget = double.parse(_budgetController.text.trim());
    final mutationController = ref.read(
      categoryMutationControllerProvider.notifier,
    );

    final success = _isEditing
        ? await mutationController.updateCategory(
            id: widget.category!.id,
            name: _nameController.text.trim(),
            type: _selectedType!,
            budget: budget,
            icon: _selectedIconKey!,
            color: _colorController.text.trim().startsWith('#')
                ? _colorController.text.trim().toUpperCase()
                : '#${_colorController.text.trim().toUpperCase()}',
          )
        : await mutationController.createCategory(
            name: _nameController.text.trim(),
            type: _selectedType!,
            budget: budget,
            icon: _selectedIconKey!,
            color: _colorController.text.trim().startsWith('#')
                ? _colorController.text.trim().toUpperCase()
                : '#${_colorController.text.trim().toUpperCase()}',
          );

    if (success && mounted) {
      widget.onSuccess?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutationState = ref.watch(categoryMutationControllerProvider);
    final isLoading = mutationState.isLoading;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEditing ? 'Update category details' : 'Create a new category',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Groceries',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CategoryType>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'Type'),
              items: CategoryType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.label)),
                  )
                  .toList(growable: false),
              onChanged: isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
              validator: (value) {
                if (value == null) {
                  return 'Type is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _budgetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Budget',
                hintText: '1000.00',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Budget is required';
                }
                final parsed = double.tryParse(value.trim());
                if (parsed == null || parsed <= 0) {
                  return 'Budget must be greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Icon', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categoryIconOptions
                  .map((option) {
                    final isSelected = option.key == _selectedIconKey;
                    return InkWell(
                      key: ValueKey('icon-${option.key}'),
                      borderRadius: BorderRadius.circular(14),
                      onTap: isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedIconKey = option.key;
                                _showIconError = false;
                              });
                            },
                      child: Container(
                        width: 72,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primaryContainer
                              : colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(option.icon),
                            const SizedBox(height: 6),
                            Text(
                              option.label,
                              textAlign: TextAlign.center,
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            if (_showIconError)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Icon is required',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text('Color', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _categoryColorPalette
                  .map((color) {
                    final isSelected =
                        color.toARGB32() == _selectedColor.toARGB32();
                    return InkWell(
                      key: ValueKey('color-${_colorToHex(color)}'),
                      borderRadius: BorderRadius.circular(999),
                      onTap: isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedColor = color;
                                _colorController.text = _colorToHex(color);
                              });
                            },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.onSurface
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color:
                                    ThemeData.estimateBrightnessForColor(
                                          color,
                                        ) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 18,
                              )
                            : null,
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[#0-9A-Fa-f]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Custom color',
                hintText: '#4F46E5',
              ),
              onChanged: (value) {
                final color = _parseColor(value);
                if (color != null) {
                  setState(() {
                    _selectedColor = color;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Color is required';
                }
                if (_parseColor(value) == null) {
                  return 'Use a valid hex color';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (mutationState.hasError && !isLoading)
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
            Row(
              children: [
                if (widget.showCancelButton)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                if (widget.showCancelButton) const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isEditing ? 'Save changes' : 'Create category'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _colorToHex(Color color) {
    final rgb = color.toARGB32() & 0x00FFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Color? _parseColor(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    final normalized = input.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(normalized)) {
      return null;
    }
    return Color(int.parse('FF$normalized', radix: 16));
  }
}
