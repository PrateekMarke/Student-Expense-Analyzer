import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/feature/auth/data/repository/auth_repo_impl.dart';
import 'package:student_expense_analyzer/feature/auth/domain/repositories/auth_repo.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';


final sl = GetIt.instance;

Future<void> initInjection() async {

  sl.registerLazySingleton(() => Dio(BaseOptions(
    headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    },
  )));


  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerFactory(() => AuthBloc(sl()));
}