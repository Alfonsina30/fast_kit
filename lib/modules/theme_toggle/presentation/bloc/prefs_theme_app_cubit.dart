import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme_toggle_files.dart';

part 'prefs_theme_app_state.dart';

class PrefsThemeAppCubit extends Cubit<PrefsThemeAppState> {
  final CustomSharedPreference preference;
  final ThemeMode initialTheme;

  PrefsThemeAppCubit({required this.preference, required this.initialTheme})
      : super(PrefsThemeAppState(prefsTheme: initialTheme)) {
    getPrefsTheme();
  }

  void getPrefsTheme() async {
    ///-- read the theme selected by user
    final prefs = await preference.readPreferenceTheme();

    final getTheme =
        (prefs != null) ? ThemeMode.values.byName(prefs) : ThemeMode.system;

    ///-- if the user has not yet chosen a theme, the default theme is dark
    emit(state.copyWith(prefsTheme: getTheme));
  }

  void changeThemeMode(ThemeMode themeMode) async {
    //-- after change the CubitState save on shared preference the theme mode selected
    await preference.savePreferenceTheme(themeMode.name);
    emit(state.copyWith(prefsTheme: themeMode));
  }

  Future<void> removePrefsTheme() async {
    //-- can be use if user signOut session app

    await preference.deletePreferenceTheme();

    emit(state.copyWith(prefsTheme: ThemeMode.system));
  }
}
