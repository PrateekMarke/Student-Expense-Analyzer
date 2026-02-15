import 'package:student_expense_analyzer/feature/budget/domain/entites/category_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';


abstract class BudgetRepository {
  Future<SavingGoal> getSavingGoal();
  Future<SavingGoal> setSavingGoal(double amount);
  Future<SavingGoal> updateSavingGoal(String id, double amount);
  Future<List<CategorySavingGoal>> catGetSavingGoal();
  Future<CategorySavingGoal> catSetSavingGoal(String category ,double amount);
  Future<CategorySavingGoal> catUpdateSavingGoal(String id, String category ,double amount);
}