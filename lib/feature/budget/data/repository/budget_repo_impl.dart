import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/budget/data/model/saving_goal_model.dart';
import 'package:student_expense_analyzer/feature/budget/domain/repository/budget_repo.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final Dio dio;
  BudgetRepositoryImpl(this.dio);

  @override
  Future<SavingGoalModel> getSavingGoal() async {
    final response = await dio.get('v1/transaction/saving-goal');
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<SavingGoalModel> setSavingGoal(double amount) async {
    final response = await dio.post('v1/transaction/saving-goal', data: {'target_amount': amount});
    return SavingGoalModel.fromJson(response.data['data']);
  }

  @override
  Future<SavingGoalModel> updateSavingGoal(String id, double amount) async {
    final response = await dio.put('v1/transaction/saving-goal/$id', data: {'target_amount': amount});
    return SavingGoalModel.fromJson(response.data['data']);
  }
}