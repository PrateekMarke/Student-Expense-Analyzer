import 'package:student_expense_analyzer/feature/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
}