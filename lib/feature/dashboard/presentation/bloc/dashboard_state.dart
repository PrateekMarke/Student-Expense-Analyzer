import 'package:student_expense_analyzer/feature/dashboard/data/model/catergory_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';


abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<RecentTranscation> recentTransactions;
  final List<CategorySpending> categorySpending;
 final double totalBalance;
  final double totalIncome;
  final double totalExpenses;

  DashboardLoaded({
    required this.categorySpending,
    required this.recentTransactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
  });
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}