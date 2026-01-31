import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'custom_shared_preference.dart';

class PrefsThemeAppCubit extends Cubit<PrefsThemeAppState> {
  final CustomSharedPreference preference;

  PrefsThemeAppCubit({required this.preference})
      : super(const PrefsThemeAppState(prefsTheme: ThemeMode.system)) {
    //true is darkTheme --- false is lightTheme
  }

  void getPrefsTheme() async {
    ///-- read the theme selected by user
    final prefs = await preference.readPreferenceTheme() as String?;

    final getTheme =
        (prefs != null) ? ThemeMode.values.byName(prefs) : ThemeMode.system;

    ///-- if the user has not yet chosen a theme, the default theme is dark
    emit(state.copyWith(prefsTheme: getTheme));
  }

  void changetoSystemMode() async {
    emit(state.copyWith(prefsTheme: ThemeMode.system));

    //-- after change the CubitState save on shared preference the theme mode selected
    await preference.savePreferenceTheme(ThemeMode.system.name);
  }

  void changeToDarkMode() async {
    emit(state.copyWith(prefsTheme: ThemeMode.dark));

    //-- after change the CubitState save on shared preference the theme mode selected
    await preference.savePreferenceTheme(ThemeMode.dark.name);
  }

  void changeToLightMode() async {
    emit(state.copyWith(prefsTheme: ThemeMode.light));

    //-- after change the CubitState save on shared preference the theme mode selected
    await preference.savePreferenceTheme(ThemeMode.light.name);
  }

  Future<void> removePrefsTheme() async {
    //-- can be use if user signOut session app

    await preference.deletePreferenceTheme();

    emit(state.copyWith(prefsTheme: ThemeMode.system));
  }
}

//***** Cubit state
class PrefsThemeAppState extends Equatable {
  //
  final ThemeMode prefsTheme;

  const PrefsThemeAppState({required this.prefsTheme});

//  bool get isDarkTheme => prefsTheme == true;

  PrefsThemeAppState copyWith({ThemeMode? prefsTheme}) {
    return PrefsThemeAppState(prefsTheme: prefsTheme ?? this.prefsTheme);
  }

  @override
  List<Object?> get props => [prefsTheme];

  @override
  String toString() {
    return 'Theme: $prefsTheme';
  }
}
