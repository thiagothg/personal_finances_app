import 'package:flutter/material.dart';

class CategoryIconOption {
  const CategoryIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}

const List<CategoryIconOption> categoryIconOptions = [
  CategoryIconOption(key: 'salary', label: 'Salary', icon: Icons.payments),
  CategoryIconOption(
    key: 'shopping',
    label: 'Shopping',
    icon: Icons.shopping_bag,
  ),
  CategoryIconOption(key: 'food', label: 'Food', icon: Icons.restaurant),
  CategoryIconOption(
    key: 'transport',
    label: 'Transport',
    icon: Icons.directions_car,
  ),
  CategoryIconOption(key: 'home', label: 'Home', icon: Icons.home_work),
  CategoryIconOption(key: 'bills', label: 'Bills', icon: Icons.receipt_long),
  CategoryIconOption(key: 'health', label: 'Health', icon: Icons.favorite),
  CategoryIconOption(key: 'education', label: 'Education', icon: Icons.school),
  CategoryIconOption(key: 'travel', label: 'Travel', icon: Icons.flight),
  CategoryIconOption(key: 'savings', label: 'Savings', icon: Icons.savings),
  CategoryIconOption(key: 'freelance', label: 'Freelance', icon: Icons.work),
  CategoryIconOption(key: 'entertainment', label: 'Fun', icon: Icons.movie),
];

IconData iconForCategoryKey(String key) {
  return categoryIconOptions
          .where((option) => option.key == key)
          .map((option) => option.icon)
          .firstOrNull ??
      Icons.category;
}
