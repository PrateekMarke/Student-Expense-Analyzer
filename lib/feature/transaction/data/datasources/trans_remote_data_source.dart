import 'package:dio/dio.dart';

abstract class TransactionRemoteDataSource {
  Future<void> createTransaction(Map<String, dynamic> data);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl(this.dio);

  @override
  Future<void> createTransaction(Map<String, dynamic> data) async {
    await dio.post('v1/transaction/create', data: data);
  }
}
