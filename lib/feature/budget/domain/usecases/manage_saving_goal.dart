import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/repository/budget_repo.dart';


class SetSavingGoalUseCase {
  final BudgetRepository repository;
  SetSavingGoalUseCase(this.repository);

  Future<SavingGoal> call(double amount) => repository.setSavingGoal(amount);
}

class GetSavingGoalUseCase {
  final BudgetRepository repository;
  GetSavingGoalUseCase(this.repository);

  Future<SavingGoal> call() => repository.getSavingGoal();
}
class UpdateSavingGoalUseCase {
  final BudgetRepository repository;
  UpdateSavingGoalUseCase(this.repository);

  Future<SavingGoal> call(String id, double amount) => repository.updateSavingGoal(id, amount);
}