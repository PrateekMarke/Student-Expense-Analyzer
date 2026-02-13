import 'package:student_expense_analyzer/feature/dashboard/data/model/catergory_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/repository/dashboard_repository.dart';

class GetCategorySpending {
  final DashboardRepository repository;

  GetCategorySpending(this.repository);

  Future<List<CategorySpending>> call() {
    return repository.getCategorySpending();
  }
}