import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class SetSavingGoal extends BudgetEvent {
  final double amount;

  const SetSavingGoal(this.amount);

  @override
  List<Object?> get props => [amount];
}
class UpdateSavingGoal extends BudgetEvent {
  final double amount;

  const UpdateSavingGoal(this.amount);

  @override
  List<Object?> get props => [amount];
}
class FetchAllBudgets extends BudgetEvent {}

class SetCategoryGoal extends BudgetEvent {
  final String category;
  final double amount;
  const SetCategoryGoal(this.category, this.amount);
}

class UpdateCategoryGoal extends BudgetEvent {
  final String id;
  final String category;
  final double amount;
  const UpdateCategoryGoal(this.id, this.category, this.amount);
}