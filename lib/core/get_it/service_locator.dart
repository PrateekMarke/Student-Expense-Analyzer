import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/core/network/auth_interceptor.dart';
import 'package:student_expense_analyzer/feature/auth/data/repository/auth_repo_impl.dart';
import 'package:student_expense_analyzer/feature/auth/domain/repositories/auth_repo.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';


final sl = GetIt.instance;

Future<void> initInjection() async {

 sl.registerLazySingleton(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://expense-analyzer-1xod.onrender.com/',
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

   
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  });

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerFactory(() => AuthBloc(sl()));
}