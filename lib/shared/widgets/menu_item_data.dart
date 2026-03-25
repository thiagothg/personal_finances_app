import 'package:flutter/material.dart';

class MenuItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final int? branchIndex;

  const MenuItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.branchIndex,
  });
}

class MenuSection {
  final String? title;
  final List<MenuItemData> items;

  const MenuSection({this.title, required this.items});
}

const List<MenuSection> menuSections = [
  MenuSection(
    items: [
      MenuItemData(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        route: '/dashboard',
        branchIndex: 0,
      ),
      MenuItemData(
        label: 'Transactions',
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        route: '/transactions',
        branchIndex: 1,
      ),
      MenuItemData(
        label: 'Investments',
        icon: Icons.trending_up_outlined,
        activeIcon: Icons.trending_up,
        route: '/investments',
        branchIndex: 2,
      ),
      MenuItemData(
        label: 'Goals',
        icon: Icons.flag_outlined,
        activeIcon: Icons.flag,
        route: '/goals',
        branchIndex: 5,
      ),
    ],
  ),
  MenuSection(
    title: 'MANAGE',
    items: [
      MenuItemData(
        label: 'People',
        icon: Icons.people_outlined,
        activeIcon: Icons.people,
        route: '/people',
        branchIndex: 6,
      ),
      MenuItemData(
        label: 'Categories',
        icon: Icons.category_outlined,
        activeIcon: Icons.category,
        route: '/categories',
        branchIndex: 7,
      ),
      MenuItemData(
        label: 'Accounts',
        icon: Icons.account_balance_outlined,
        activeIcon: Icons.account_balance,
        route: '/accounts',
      ),
    ],
  ),
  MenuSection(
    title: 'PLANNING',
    items: [
      MenuItemData(
        label: 'Recurring',
        icon: Icons.repeat_outlined,
        activeIcon: Icons.repeat,
        route: '/recurring',
      ),
      MenuItemData(
        label: 'Budget',
        icon: Icons.pie_chart_outline,
        activeIcon: Icons.pie_chart,
        route: '/budget',
      ),
    ],
  ),
  MenuSection(
    title: 'INSIGHTS',
    items: [
      MenuItemData(
        label: 'Reports',
        icon: Icons.assessment_outlined,
        activeIcon: Icons.assessment,
        route: '/reports',
      ),
      MenuItemData(
        label: 'Net Worth',
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        route: '/net-worth',
      ),
      MenuItemData(
        label: 'Cash Flow',
        icon: Icons.swap_horiz_outlined,
        activeIcon: Icons.swap_horiz,
        route: '/cash-flow',
      ),
      MenuItemData(
        label: 'Spending',
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart,
        route: '/spending',
      ),
      MenuItemData(
        label: 'Trends',
        icon: Icons.show_chart_outlined,
        activeIcon: Icons.show_chart,
        route: '/trends',
      ),
    ],
  ),
];
