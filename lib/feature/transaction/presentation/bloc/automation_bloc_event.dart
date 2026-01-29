import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';

abstract class AutomationEvent {}

class TransactionDetected extends AutomationEvent {
  final DetectedTransaction transaction;
  TransactionDetected(this.transaction);
}

class CategorizeTransaction extends AutomationEvent {
  final DetectedTransaction transaction;
  final String category;
  CategorizeTransaction(this.transaction, this.category);
}