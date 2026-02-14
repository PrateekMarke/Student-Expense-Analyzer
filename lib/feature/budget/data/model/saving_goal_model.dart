import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';


class SavingGoalModel extends SavingGoal {
  const SavingGoalModel({
    required super.id,
    required super.targetAmount,
    
    required super.createdAt, required super.remainingAmount, required super.expensesAmount,
  });

  factory SavingGoalModel.fromJson(Map<String, dynamic> json) {
  return SavingGoalModel(
    id: json['id'] ?? '',
    targetAmount: (json['target_amount'] ?? 0).toDouble(),
    remainingAmount: (json['remaining_amount'] ?? 0.0).toDouble(),
    expensesAmount: (json['expenses_amount'] ?? 0.0).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
  );
}

  Map<String, dynamic> toJson() => {'target_amount': targetAmount, 'remaining_amount': remainingAmount, 'expenses_amount': expensesAmount};
}