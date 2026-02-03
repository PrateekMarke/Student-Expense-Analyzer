import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/repository/dashboard_repository.dart';


class GetRecentTransactions {
  final DashboardRepository repository;
  GetRecentTransactions(this.repository);

  Future<List<RecentTranscation>> call({int limit = 5}) {
    return repository.getRecentTransactions(limit);
  }
}