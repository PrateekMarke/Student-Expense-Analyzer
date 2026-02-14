import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class FetchSavingGoal extends BudgetEvent {}
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