
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
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
  @override
@override
  Future<List<RecentTranscation>> getTransactions({
    String? type,
    int page = 1,
    int limit = 10,
    String? period,
    String? date,
  }) async {

    final queryParams = {
      if (type != null && type != 'all') 'type': type,
      'page': page,
      'limit': limit,
      if (period != null) 'period': period,
      if (date != null) 'date': date,
    };

    return await remoteDataSource.getFilteredTransactions(queryParams);
  }
  
  
  
}