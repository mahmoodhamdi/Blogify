import 'package:blogify/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUseCase _userSignUpUseCase;

  AuthBloc({required UserSignUpUseCase userSignUpUseCase})
      : _userSignUpUseCase = userSignUpUseCase,
        super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());

      final result = await _userSignUpUseCase.call(UserSignUpParams(
          name: event.name, email: event.email, password: event.password));

      result.fold((failure) {
        emit(AuthError(failure.message));
      }, (uId) {
        emit(AuthSuccess(uId));
      });
    });
  }
}
