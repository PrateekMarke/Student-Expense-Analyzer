import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:student_expense_analyzer/core/network/auth_interceptor.dart';
import 'package:student_expense_analyzer/feature/analytics/presentation/bloc/bloc/analytics_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/data/repository/auth_repo_impl.dart';
import 'package:student_expense_analyzer/feature/auth/domain/repositories/auth_repo.dart';

import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/budget/data/repository/budget_repo_impl.dart';
import 'package:student_expense_analyzer/feature/budget/domain/repository/budget_repo.dart';
import 'package:student_expense_analyzer/feature/budget/domain/usecases/manage_saving_goal.dart';
import 'package:student_expense_analyzer/feature/budget/presentation/bloc/budget_bloc.dart';
import 'package:student_expense_analyzer/feature/dashboard/data/repository/dashboard_repo_impl.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/repository/dashboard_repository.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_category_spending.dart';
import 'package:student_expense_analyzer/feature/dashboard/domain/usecase/get_recent_transaction.dart';
import 'package:student_expense_analyzer/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/data/datasources/trans_remote_data_source.dart';
import 'package:student_expense_analyzer/feature/transaction/data/repository/automation_repository_impl.dart';
import 'package:student_expense_analyzer/feature/transaction/data/repository/transcation_repo_impl.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/repositories/transcation_repo.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/create_tran.dart';
import 'package:student_expense_analyzer/feature/transaction/domain/usecase/get_filtered_trans.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/automation_bloc.dart';
import 'package:student_expense_analyzer/feature/transaction/presentation/bloc/transcation_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://expenses-tracking-zusn.onrender.com/',
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return dio;
  });

  // Data Sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AutomationRepositoryImpl>(
    () => AutomationRepositoryImpl(),
  );
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));
  // Use Cases
  sl.registerLazySingleton(() => CreateTransactionUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentTransactions(sl()));
  sl.registerLazySingleton(() => GetCategorySpending(sl()));
  sl.registerLazySingleton(() => GetFilteredTransactions(sl()));
  sl.registerLazySingleton(() => GetSavingGoalUseCase(sl()));
  sl.registerLazySingleton(() => SetSavingGoalUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSavingGoalUseCase(sl()));
  // Blocs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => AutomationBloc(sl<CreateTransactionUseCase>()));
  sl.registerFactory(
    () => DashboardBloc(
      getRecentTransactions: sl<GetRecentTransactions>(),
      getCategorySpending: sl<GetCategorySpending>(),
    ),
  );
  sl.registerFactory(() => TransactionBloc(sl<GetFilteredTransactions>()));

  sl.registerFactory(
    () => AnalyticsBloc(
      sl<GetFilteredTransactions>(),
      getCategorySpending: sl<GetCategorySpending>(),
    ),
  );
  sl.registerFactory(
    () => BudgetBloc(
      getSavingGoal: sl(),
      setSavingGoal: sl(),
      updateSavingGoalUseCase: sl(),
    ),
  );
}
