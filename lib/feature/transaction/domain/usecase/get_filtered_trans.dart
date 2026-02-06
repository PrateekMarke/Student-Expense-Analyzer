import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/repositories/transcation_repo.dart';

class GetFilteredTransactions {
  final TransactionRepository repository;
  GetFilteredTransactions(this.repository);

  Future<List<RecentTranscation>> call({
    String? type,
    int page = 1,
    int limit = 10,
    String? period,
    String? date,
  }) {
    return repository.getTransactions(
      type: type,
      page: page,
      limit: limit,
      period: period,
      date: date,
    );
  }
}