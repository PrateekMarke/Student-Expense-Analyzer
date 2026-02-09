import 'package:student_expense_analyzer/feature/transaction/domain/entites/dected_transaction.dart';

abstract class AutomationEvent {}

class TransactionDetected extends AutomationEvent {
  final DetectedTransaction transaction;
  TransactionDetected(this.transaction);
}

class CategorizeTransaction extends AutomationEvent {
  final DetectedTransaction transaction;
  final String category;
  final String title;
  CategorizeTransaction(this.transaction, this.category, {required this.title});
}

class CreateManualTransaction extends AutomationEvent {
  final double amount;
  final String type;
  final String category;
  final String title;

  CreateManualTransaction({
    required this.amount,
    required this.type,
    required this.category,
    required this.title,
  });
}
