import 'package:blogify/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogify/core/usecase/usecase.dart';
import 'package:blogify/core/common/entities/user.dart';
import 'package:blogify/features/auth/domain/usecases/current_user.dart';
import 'package:blogify/features/auth/domain/usecases/user_login.dart';
import 'package:blogify/features/auth/domain/usecases/user_logout.dart';
import 'package:blogify/features/auth/domain/usecases/user_sign_up.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final UserLogout _userLogout;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required UserLogout userLogout,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _userLogout = userLogout,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(const AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(const AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogoutRequested>(_onAuthLogout);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onAuthLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogout(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (_) {
        _appUserCubit.updateUser(null);
        emit(const AuthLogoutSuccess());
      },
    );
  }
}
