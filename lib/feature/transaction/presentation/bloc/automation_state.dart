import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';

class AutomationState {
  final List<DetectedTransaction> pendingTransactions;

  AutomationState({this.pendingTransactions = const []});
}

class AutomationInitial extends AutomationState {
  AutomationInitial() : super(pendingTransactions: []);
}

class AutomationLoaded extends AutomationState {
  AutomationLoaded({required List<DetectedTransaction> pendingTransactions}) 
    : super(pendingTransactions: pendingTransactions);
}
class TransactionSuccess extends AutomationState {
  final String message;
  TransactionSuccess(this.message);
}