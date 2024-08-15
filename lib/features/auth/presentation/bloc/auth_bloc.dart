import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/common/usecase/usecase.dart';
import 'package:blogify/features/auth/domain/entities/user_entity.dart';
import 'package:blogify/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_in_usecase.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_up_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUpUseCase _userSignUpUseCase;
  final UserSignInUseCase _userSignInUseCase;
  final GetCurrentUserUsecase _currentUserUsecase;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUpUseCase userSignUpUseCase,
      required UserSignInUseCase userSignInUseCase,
      required GetCurrentUserUsecase getCurrentUserUsecase,
      required AppUserCubit appUserCubit})
      : _userSignUpUseCase = userSignUpUseCase,
        _userSignInUseCase = userSignInUseCase,
        _currentUserUsecase = getCurrentUserUsecase,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<SignUpEvent>(_onSignUp);
    on<SignInEvent>(_onSignIn);
    on<IsUserLoggedInEvent>(_isUserLoggedIn);
  }
  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    final result = await _userSignUpUseCase.call(UserSignUpParams(
        name: event.name, email: event.email, password: event.password));

    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  void _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    final result = await _userSignInUseCase
        .call(UserSignInParams(email: event.email, password: event.password));

    result.fold((failure) {
      emit(AuthError(failure.message));
    }, (user) {
      _emitAuthSuccess(user, emit);
    });
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _isUserLoggedIn(
      IsUserLoggedInEvent event, Emitter<AuthState> emit) async {
    final res = await _currentUserUsecase.call(NoParams());

    res.fold(
      (failure) {
        emit(AuthError(failure.message));
        _appUserCubit.updateUser(null);
      },
      (user) {
        if (user != null) {
          emit(AuthSuccess(user));
          _appUserCubit.updateUser(user);
        } else {
          emit(AuthInitial());
          _appUserCubit.updateUser(null);
        }
      },
    );
  }
}
