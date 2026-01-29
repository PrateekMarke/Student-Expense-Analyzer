import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/create_tran.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc_event.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc_state.dart';

class AutomationBloc extends HydratedBloc<AutomationEvent, AutomationState> {
  
  final CreateTransactionUseCase createTransactionUseCase;
  AutomationBloc(this.createTransactionUseCase) : super(AutomationInitial()) {
    on<TransactionDetected>(_onDetected);
    on<CategorizeTransaction>(_onCategorize);
  }

  void _onDetected(TransactionDetected event, Emitter<AutomationState> emit) {
    final updatedList = List<DetectedTransaction>.from(state.pendingTransactions)
      ..add(event.transaction);
    
    emit(AutomationLoaded(pendingTransactions: updatedList));
    
  }

Future<void> _onCategorize(CategorizeTransaction event, Emitter<AutomationState> emit) async {
    try {
  
      await createTransactionUseCase(
        amount: event.transaction.amount,
        type: 'expense', 
        category: event.category,
      );

      
      final updatedList = List<DetectedTransaction>.from(state.pendingTransactions)
        ..remove(event.transaction);
      
      emit(AutomationLoaded(pendingTransactions: updatedList));
    } catch (e) {
      print("Failed to sync transaction: $e");
    }
  }
  @override
  AutomationState? fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> pendingJson = json['pendingTransactions'];
      final pending = pendingJson
          .map((item) => DetectedTransaction.fromMap(item as Map<String, dynamic>))
          .toList();
      return AutomationLoaded(pendingTransactions: pending);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AutomationState state) {
    return {
      'pendingTransactions': state.pendingTransactions
          .map((tx) => tx.toMap())
          .toList(),
    };
  }
}