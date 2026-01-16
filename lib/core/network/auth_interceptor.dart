import 'package:dio/dio.dart';

import 'package:student_expense_analyzer/core/get_it/service_locator.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_event.dart';
import 'package:student_expense_analyzer/feature/auth/presentation/bloc/auth_state.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {

    final authBloc = sl<AuthBloc>();
    final state = authBloc.state;
    if (state is AuthSuccess && state.user.token != null) {
      options.headers['Authorization'] = 'Bearer ${state.user.token}';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
  
    if (err.response?.statusCode == 401) {
   
      sl<AuthBloc>().add(AuthLogoutRequested());
    }
    return handler.next(err);
  }
}