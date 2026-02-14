import 'package:student_expense_analyzer/feature/budget/domain/entites/saving_goal.dart';


abstract class BudgetRepository {
  Future<SavingGoal> getSavingGoal();
  Future<SavingGoal> setSavingGoal(double amount);
  Future<SavingGoal> updateSavingGoal(String id, double amount);
}