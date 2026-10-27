import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_exception.dart';
import '../../../domain/usecases/signin_usecase.dart';
import '../../../domain/usecases/signout_usecase.dart';
import '../../../domain/usecases/signup_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUseCase _signupUseCase;
  final SigninUseCase _signinUseCase;
  final SignoutUseCase _signoutUseCase;

  AuthBloc(this._signupUseCase, this._signinUseCase, this._signoutUseCase)
      : super(AuthInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
    on<SigninSubmitted>(_onSigninSubmitted);
    on<SignoutRequested>(_onSignoutRequested);
  }

  Future<void> _onSignupSubmitted(
      SignupSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _signupUseCase(
        username: event.username,
        email:    event.email,
        password: event.password,
        role:     event.role,
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(AuthFailure(ApiException.messageOf(e)));
    }
  }

  Future<void> _onSigninSubmitted(
      SigninSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      final user = await _signinUseCase(
        username: event.username,
        password: event.password,
      );
      emit(SigninSuccess(user));
    } catch (e) {
      emit(AuthFailure(ApiException.messageOf(e)));
    }
  }

  Future<void> _onSignoutRequested(
      SignoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    try {
      await _signoutUseCase();
      emit(SignoutSuccess());
    } catch (e) {
      emit(AuthFailure(ApiException.messageOf(e)));
    }
  }
}
