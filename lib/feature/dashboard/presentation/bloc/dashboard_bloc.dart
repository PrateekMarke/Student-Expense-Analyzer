import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_category_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_recent_transaction.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetRecentTransactions getRecentTransactions;
  final GetCategorySpending getCategorySpending;

  DashboardBloc({required this.getRecentTransactions, required this.getCategorySpending})
    : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {
      if (state is! DashboardLoaded) {
        emit(DashboardLoading());
      }
      try {
        final transactions = await getRecentTransactions(limit: event.limit);
        final catergorySpending = await getCategorySpending();
      double totalIncome = 0.0;
       double totalExpenses = 0.0;
       for (var tx in transactions) {

      if (tx.type == 'deposit') {
        totalIncome += tx.amount;
      } else if (tx.type == 'withdrawal') {
        totalExpenses += tx.amount;
      }
    }
  final double balance = totalIncome - totalExpenses;
        emit(DashboardLoaded(
      recentTransactions: transactions,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      totalBalance: balance, categorySpending: catergorySpending,
    ));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
