import 'package:blogify/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? user) {
    if (user == null) {
      print("AppUserCubit: Emitting AppUserInitial");
      emit(AppUserInitial());
    } else {
      print("AppUserCubit: Emitting AppUserLoggedIn - ${user.name}");
      emit(AppUserLoggedIn(user));
    }
  }
}
