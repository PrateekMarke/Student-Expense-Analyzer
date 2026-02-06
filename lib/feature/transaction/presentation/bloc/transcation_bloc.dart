import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/get_filtered_trans.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_event.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetFilteredTransactions getTransactionsUseCase;
  int _currentPage = 1;
  bool _isFetching = false;

  TransactionBloc(this.getTransactionsUseCase) : super(TransactionInitial()) {
    on<FetchTransactions>((event, emit) async {
      if (_isFetching) return;
      _isFetching = true;

      try {
        if (event.isRefresh) {
          _currentPage = 1;
          emit(TransactionLoading());
        }

        final results = await getTransactionsUseCase(
          type: event.type,     
          page: _currentPage,
          period: event.period, 
          date: event.date,      
          limit: 10,
        );

        final currentList = event.isRefresh ? <RecentTranscation>[] : (state as TransactionLoaded).transactions;
        
        emit(TransactionLoaded(
          transactions: currentList + results,
          selectedType: event.type ?? 'all',
          hasReachedMax: results.length < 10,
        ));

        _currentPage++;
      } catch (e) {
        emit(TransactionError("API Error: ${e.toString()}"));
      } finally {
        _isFetching = false;
      }
    });
  }
}