import 'package:blogify/core/common/cubits/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _boxName = 'settings';
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeState.initial());

  Future<void> loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final themeModeIndex = box.get(_themeKey, defaultValue: 0) as int;
    final themeMode = ThemeMode.values[themeModeIndex];
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_themeKey, themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : state.themeMode == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
    await setThemeMode(newMode);
  }

  String get themeModeLabel {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  IconData get themeModeIcon {
    switch (state.themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
