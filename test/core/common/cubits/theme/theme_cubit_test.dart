import 'package:bloc_test/bloc_test.dart';
import 'package:blogify/core/common/cubits/theme/theme_cubit.dart';
import 'package:blogify/core/common/cubits/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late ThemeCubit themeCubit;

  setUpAll(() async {
    // Initialize Hive for testing
    Hive.init('./test_hive');
  });

  setUp(() {
    themeCubit = ThemeCubit();
  });

  tearDown(() async {
    await themeCubit.close();
    // Clean up Hive boxes
    if (Hive.isBoxOpen('settings')) {
      await Hive.box('settings').clear();
    }
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('ThemeCubit', () {
    test('initial state should be ThemeMode.system', () {
      expect(themeCubit.state, const ThemeState(themeMode: ThemeMode.system));
    });

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeMode.light] when setThemeMode(ThemeMode.light) is called',
      build: () => themeCubit,
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [const ThemeState(themeMode: ThemeMode.light)],
    );

    blocTest<ThemeCubit, ThemeState>(
      'emits [ThemeMode.dark] when setThemeMode(ThemeMode.dark) is called',
      build: () => themeCubit,
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const ThemeState(themeMode: ThemeMode.dark)],
    );

    blocTest<ThemeCubit, ThemeState>(
      'toggleTheme cycles through light -> dark -> system',
      build: () => themeCubit,
      act: (cubit) async {
        // Start at system (default), toggle to light
        await cubit.setThemeMode(ThemeMode.light);
        // light -> dark
        await cubit.toggleTheme();
        // dark -> system
        await cubit.toggleTheme();
        // system -> light
        await cubit.toggleTheme();
      },
      expect: () => [
        const ThemeState(themeMode: ThemeMode.light),
        const ThemeState(themeMode: ThemeMode.dark),
        const ThemeState(themeMode: ThemeMode.system),
        const ThemeState(themeMode: ThemeMode.light),
      ],
    );

    test('themeModeLabel returns correct label', () async {
      await themeCubit.setThemeMode(ThemeMode.light);
      expect(themeCubit.themeModeLabel, 'Light');

      await themeCubit.setThemeMode(ThemeMode.dark);
      expect(themeCubit.themeModeLabel, 'Dark');

      await themeCubit.setThemeMode(ThemeMode.system);
      expect(themeCubit.themeModeLabel, 'System');
    });

    test('themeModeIcon returns correct icon', () async {
      await themeCubit.setThemeMode(ThemeMode.light);
      expect(themeCubit.themeModeIcon, Icons.light_mode);

      await themeCubit.setThemeMode(ThemeMode.dark);
      expect(themeCubit.themeModeIcon, Icons.dark_mode);

      await themeCubit.setThemeMode(ThemeMode.system);
      expect(themeCubit.themeModeIcon, Icons.brightness_auto);
    });

    test('theme persists after loadTheme', () async {
      // Set theme to dark
      await themeCubit.setThemeMode(ThemeMode.dark);
      expect(themeCubit.state.themeMode, ThemeMode.dark);

      // Create new cubit and load theme
      final newCubit = ThemeCubit();
      await newCubit.loadTheme();
      expect(newCubit.state.themeMode, ThemeMode.dark);

      await newCubit.close();
    });
  });

  group('ThemeState', () {
    test('ThemeState.initial() returns system mode', () {
      final state = ThemeState.initial();
      expect(state.themeMode, ThemeMode.system);
    });

    test('copyWith creates new state with updated themeMode', () {
      const state = ThemeState(themeMode: ThemeMode.light);
      final newState = state.copyWith(themeMode: ThemeMode.dark);
      expect(newState.themeMode, ThemeMode.dark);
    });

    test('copyWith without parameters returns same values', () {
      const state = ThemeState(themeMode: ThemeMode.light);
      final newState = state.copyWith();
      expect(newState.themeMode, ThemeMode.light);
    });

    test('props contains themeMode', () {
      const state = ThemeState(themeMode: ThemeMode.dark);
      expect(state.props, [ThemeMode.dark]);
    });
  });
}
