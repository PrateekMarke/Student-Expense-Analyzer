import 'package:equatable/equatable.dart';

class SavingGoal extends Equatable {
  final String id;
  final double targetAmount;
  final double remainingAmount; 
  final double expensesAmount;
  final DateTime createdAt;

  const SavingGoal({
    required this.id,
    required this.targetAmount,
    required this.createdAt, required this.remainingAmount, required this.expensesAmount,
  });

  @override
  List<Object?> get props => [id, targetAmount, remainingAmount, expensesAmount, createdAt];
}