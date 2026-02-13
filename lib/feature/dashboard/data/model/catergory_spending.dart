class CategorySpending {
  final String category;
  final double withdrawalTotal;
  final double depositTotal;

  CategorySpending({
    required this.category,
    required this.withdrawalTotal,
    required this.depositTotal,
  });

  factory CategorySpending.fromJson(Map<String, dynamic> json) {
    return CategorySpending(
      category: json['category'] ?? 'Others',
      withdrawalTotal: (json['withdrawalTotal'] as num).toDouble(),
      depositTotal: (json['depositTotal'] as num).toDouble(),
    );
  }
}