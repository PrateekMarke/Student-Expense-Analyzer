import 'package:equatable/equatable.dart';

class CategorySavingGoal extends Equatable {
  final String id;
  final String category;
  final double targetAmount;
  final double expensesAmount;
  final double remainingAmount;

  const CategorySavingGoal({
    required this.id,
    required this.category,
    required this.targetAmount,
    required this.expensesAmount,
    required this.remainingAmount,
  });

  @override
  List<Object?> get props => [id, category, targetAmount, expensesAmount, remainingAmount];
}