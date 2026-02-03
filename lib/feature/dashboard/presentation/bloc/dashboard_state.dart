import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';


abstract class DashboardState {}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<RecentTranscation> recentTransactions;
  DashboardLoaded({required this.recentTransactions});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}