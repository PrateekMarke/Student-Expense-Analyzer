import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';

class CategorySavingGoalModel extends CategorySavingGoal {
  const CategorySavingGoalModel({
    required super.id,
    required super.category,
    required super.targetAmount,
    required super.expensesAmount,
    required super.remainingAmount,
  });

  factory CategorySavingGoalModel.fromJson(Map<String, dynamic> json) {
    return CategorySavingGoalModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      targetAmount: (json['target_amount'] ?? 0).toDouble(),
      expensesAmount: (json['expenses_amount'] ?? 0).toDouble(),
      remainingAmount: (json['remaining_amount'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() => {'target_amount': targetAmount, 'remaining_amount': remainingAmount, 'expenses_amount': expensesAmount};
}