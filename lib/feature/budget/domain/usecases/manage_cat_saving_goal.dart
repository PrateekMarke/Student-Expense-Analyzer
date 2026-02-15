import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/repository/budget_repo.dart';

class GetCategorySavingGoalsUseCase {
  final BudgetRepository repository;
  GetCategorySavingGoalsUseCase(this.repository);
  Future<List<CategorySavingGoal>> call() => repository.catGetSavingGoal();
}

class CreateCategoryGoalUseCase {
  final BudgetRepository repository;
  CreateCategoryGoalUseCase(this.repository);
  Future<CategorySavingGoal> call(String category, double amount) => 
      repository.catSetSavingGoal(category, amount);
}

class UpdateCategoryGoalUseCase {
  final BudgetRepository repository;
  UpdateCategoryGoalUseCase(this.repository);
  Future<CategorySavingGoal> call(String id, String category, double amount) => 
      repository.catUpdateSavingGoal(id, category, amount);
}