import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_recent_transaction.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetRecentTransactions getRecentTransactions;

  DashboardBloc({required this.getRecentTransactions})
    : super(DashboardInitial()) {
    on<FetchDashboardData>((event, emit) async {
      if (state is! DashboardLoaded) {
        emit(DashboardLoading());
      }
      try {
        final transactions = await getRecentTransactions(limit: event.limit);
        emit(DashboardLoaded(recentTransactions: transactions));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });
  }
}
