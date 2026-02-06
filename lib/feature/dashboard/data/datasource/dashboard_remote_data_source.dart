import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/dashboard/data/model/recent_trans_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<RecentTransModel>> getRecentTransactions(int limit);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;
  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecentTransModel>> getRecentTransactions(int limit) async {
    final response = await dio.get(
      'v1/transaction/recent',
      queryParameters: {'limit': limit},
    );
    return (response.data['transactions'] as List)
        .map((e) => RecentTransModel.fromJson(e))
        .toList();
  }
}
