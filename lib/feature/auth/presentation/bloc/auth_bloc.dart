import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:student_expense_analyzer/feature/auth/data/models/auth_user_model.dart';
import 'package:student_expense_analyzer/feature/auth/domain/repositories/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

   
    on<AuthLogoutRequested>((event, emit) {
      emit(AuthInitial());
    });
  }



  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['user'] != null) {
        final user = AuthUserModel.fromJson(json['user']);
        return AuthSuccess(user);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthSuccess) {
      return {
        'user': (state.user as AuthUserModel).toJson(),
      };
    }
    return null;
  }
}
