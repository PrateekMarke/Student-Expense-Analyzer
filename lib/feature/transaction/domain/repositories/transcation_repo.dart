
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';

abstract class TransactionRepository {
  Future<void> createTransaction({
    required double amount,
    required String type,
    required String category,
    required String title,
  });
  Future<List<RecentTranscation>> getTransactions({
    String? type,
    int page = 1,
    int limit = 10,
    String? period,
    String? date,
  });
}