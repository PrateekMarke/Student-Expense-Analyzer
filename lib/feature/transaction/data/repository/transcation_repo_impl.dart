

import 'package:student_expense_analyzer/feature/transaction/data/datasources/trans_remote_data_source.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/repositories/transcation_repo.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createTransaction({
    required double amount,
    required String type,
    required String category,
    required String title,
  }) async {
    final data = {
      "amount": amount,
      "type": type, 
      "category": category,
      "title": title,
    };
    return await remoteDataSource.createTransaction(data);
  }
}