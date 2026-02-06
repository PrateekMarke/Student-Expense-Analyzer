import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/dashboard/data/model/recent_trans_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> createTransaction(Map<String, dynamic> data);
  Future<List<RecentTransModel>> getFilteredTransactions(
    Map<String, dynamic> params,
  );
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createTransaction(Map<String, dynamic> data) async {
    await dio.post('v1/transaction/create', data: data);
  }

 @override
  Future<List<RecentTransModel>> getFilteredTransactions(Map<String, dynamic> params) async {
    final String type = params['type'] ?? 'all';
    final String path;
    
  
    if (type == 'all') {
      path = 'v1/transaction/transactionByUserId';
    } else {
      path = 'v1/transaction/get-transaction-by-type';
    }
    final cleanParams = Map<String, dynamic>.from(params)..removeWhere((key, value) => value == null || value == '');
    final response = await dio.get(path, queryParameters: cleanParams);


    final List dataList = response.data['data']['transactions'] ?? [];
    
    return dataList.map((json) => RecentTransModel.fromJson(json)).toList();
  }
}
