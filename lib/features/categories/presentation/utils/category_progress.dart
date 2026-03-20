double? calculateCategoryBudgetProgress({
  required double totalSpend,
  required double? budget,
}) {
  if (budget == null || budget <= 0) {
    return null;
  }

  final progress = totalSpend / budget;
  return progress.clamp(0.0, 1.0).toDouble();
}
