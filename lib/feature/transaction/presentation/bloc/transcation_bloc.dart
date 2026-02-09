import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/get_filtered_trans.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_event.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetFilteredTransactions getTransactionsUseCase;
  int _currentPage = 1;
  bool _isFetching = false;


  List<RecentTranscation> _allLoadedTransactions = [];

  TransactionBloc(this.getTransactionsUseCase) : super(TransactionInitial()) {
    on<FetchTransactions>((event, emit) async {
     
      bool isSearching = event.query != null && event.query!.isNotEmpty;

      if (_isFetching) return;
      _isFetching = true;

      try {
        if (event.isRefresh) {
          _currentPage = 1;
          _allLoadedTransactions = [];
          emit(TransactionLoading());
        }

        if (event.isRefresh || (!isSearching && !state.props.contains(true))) {
          final results = await getTransactionsUseCase(
            type: event.type,
            page: _currentPage,
            period: event.period,
            date: event.date,
            limit: 10,
          );

          _allLoadedTransactions.addAll(results);
          _currentPage++;
        }

        List<RecentTranscation> displayList = _allLoadedTransactions;

        if (isSearching) {
          final query = event.query!.toLowerCase();
          displayList = _allLoadedTransactions.where((tx) {
            return tx.title.toLowerCase().contains(query) ||
                tx.category.toLowerCase().contains(query) ||
                tx.amount.toString().contains(query);
          }).toList();
        }

        emit(
          TransactionLoaded(
            transactions: displayList,
            selectedType: event.type ?? 'all',
            hasReachedMax:
                _allLoadedTransactions.length % 10 != 0 ||
                _allLoadedTransactions.isEmpty,
          ),
        );
      } catch (e) {
        emit(TransactionError("API Error: ${e.toString()}"));
      } finally {
        _isFetching = false;
      }
    });
  }
}
