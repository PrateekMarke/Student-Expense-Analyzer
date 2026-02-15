import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/dashboard/data/model/catergory_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/data/model/recent_trans_model.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/entites/recent_transcation.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio dio;
  DashboardRepositoryImpl(this.dio);

  @override
  Future<List<RecentTranscation>> getRecentTransactions(int limit) async {
    try {
      final response = await dio.get(
        'v1/transaction/recent',
        queryParameters: {'limit': limit},
      );

      final List? dataList = response.data['data'];

      if (dataList == null) {
        return [];
      }

      return dataList.map((json) => RecentTransModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          e.response?.data['statusCode'] == "10001") {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<List<CategorySpending>> getCategorySpending() async {
    try {
      final response = await dio.get(
        'v1/transaction/total-amounts-by-category',
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => CategorySpending.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 ||
          e.response?.data['statusCode'] == "10001") {
        return [];
      }
      rethrow;
    }
  }
}
