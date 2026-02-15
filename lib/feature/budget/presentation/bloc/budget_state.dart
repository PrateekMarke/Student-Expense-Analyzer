import 'package:equatable/equatable.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';


abstract class BudgetState extends Equatable {
  const BudgetState();
  
  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final SavingGoal savingGoal;
  final List<CategorySavingGoal> categoryGoals; 
  const BudgetLoaded({
    required this.savingGoal, 
    this.categoryGoals = const [],
  });

  @override
  List<Object?> get props => [savingGoal, categoryGoals];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}