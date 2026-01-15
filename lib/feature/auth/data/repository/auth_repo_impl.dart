import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/auth/domain/entities/auth_user.dart';
import 'package:student_expense_analyzer/feature/auth/domain/repositories/auth_repo.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthUser> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'https://expense-analyzer-1xod.onrender.com/v1/auth/signup',
        data: {
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
        },
      );

      return AuthUserModel.fromJson(response.data['user'] ?? response.data);
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? "Registration failed";
    }
  }
  @override
Future<AuthUser> login({required String email, required String password}) async {
  try {
    final response = await _dio.post(
      'https://expense-analyzer-1xod.onrender.com/v1/auth/login',
      data: {"email": email, "password": password},
    );

    final userData = response.data['data']['user'];
    final token = response.data['data']['token'];

    return AuthUserModel(
      id: userData['id'],
      firstName: userData['first_name'],
      lastName: userData['last_name'],
      email: userData['email'],
      token: token,
    );
  } on DioException catch (e) {
    throw e.response?.data['message'] ?? "Login failed";
  }
}
}
