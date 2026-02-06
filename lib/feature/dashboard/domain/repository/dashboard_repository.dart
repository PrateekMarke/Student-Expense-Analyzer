
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';


abstract class DashboardRepository {
  Future<List<RecentTranscation>> getRecentTransactions(int limit);
}