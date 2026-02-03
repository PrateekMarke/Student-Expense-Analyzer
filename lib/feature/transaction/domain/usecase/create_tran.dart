
import 'package:student_expense_analyzer/feature/transaction/domain/repositories/transcation_repo.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<void> call({
    required double amount,
    required String type,
    required String category,
    required String title,
  }) {
    return repository.createTransaction(
      amount: amount,
      type: type,
      category: category,
      title: title,
    );
  }
}