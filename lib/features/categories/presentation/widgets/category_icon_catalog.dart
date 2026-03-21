import 'package:flutter/material.dart';

class CategoryIconOption {
  const CategoryIconOption({required this.key, required this.icon});

  final String key;
  final IconData icon;
}

const List<CategoryIconOption> categoryIconOptions = [
  CategoryIconOption(key: 'salary', icon: Icons.payments),
  CategoryIconOption(key: 'shopping', icon: Icons.shopping_bag),
  CategoryIconOption(key: 'food', icon: Icons.restaurant),
  CategoryIconOption(key: 'transport', icon: Icons.directions_car),
  CategoryIconOption(key: 'home', icon: Icons.home_work),
  CategoryIconOption(key: 'bills', icon: Icons.receipt_long),
  CategoryIconOption(key: 'health', icon: Icons.favorite),
  CategoryIconOption(key: 'education', icon: Icons.school),
  CategoryIconOption(key: 'travel', icon: Icons.flight),
  CategoryIconOption(key: 'savings', icon: Icons.savings),
  CategoryIconOption(key: 'freelance', icon: Icons.work),
  CategoryIconOption(key: 'entertainment', icon: Icons.movie),
  CategoryIconOption(key: 'gift', icon: Icons.redeem),
  CategoryIconOption(key: 'pets', icon: Icons.pets),
  CategoryIconOption(key: 'coffee', icon: Icons.coffee),
  CategoryIconOption(key: 'fitness', icon: Icons.fitness_center),
  CategoryIconOption(key: 'beauty', icon: Icons.spa),
  CategoryIconOption(key: 'gaming', icon: Icons.sports_esports),
  CategoryIconOption(key: 'music', icon: Icons.music_note),
  CategoryIconOption(key: 'phone', icon: Icons.phone_iphone),
  CategoryIconOption(key: 'internet', icon: Icons.wifi),
  CategoryIconOption(key: 'taxes', icon: Icons.account_balance),
  CategoryIconOption(key: 'investment', icon: Icons.trending_up),
  CategoryIconOption(key: 'charity', icon: Icons.volunteer_activism),
  CategoryIconOption(key: 'insurance', icon: Icons.health_and_safety),
  CategoryIconOption(key: 'baby', icon: Icons.child_care),
  CategoryIconOption(key: 'laundry', icon: Icons.local_laundry_service),
  CategoryIconOption(key: 'fuel', icon: Icons.local_gas_station),
  CategoryIconOption(key: 'train', icon: Icons.train),
  CategoryIconOption(key: 'bus', icon: Icons.directions_bus),
  CategoryIconOption(key: 'taxi', icon: Icons.local_taxi),
  CategoryIconOption(key: 'book', icon: Icons.menu_book),
  CategoryIconOption(key: 'camera', icon: Icons.photo_camera),
  CategoryIconOption(key: 'tools', icon: Icons.build),
  CategoryIconOption(key: 'water', icon: Icons.water_drop),
  CategoryIconOption(key: 'electricity', icon: Icons.bolt),
  CategoryIconOption(key: 'rent', icon: Icons.apartment),
  CategoryIconOption(key: 'bank', icon: Icons.account_balance_wallet),
];

IconData iconForCategoryKey(String key) {
  return categoryIconOptions
          .where((option) => option.key == key)
          .map((option) => option.icon)
          .firstOrNull ??
      Icons.category;
}
