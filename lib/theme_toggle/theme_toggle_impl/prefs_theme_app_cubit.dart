import 'package:equatable/equatable.dart';
import 'package:fast_kit/theme_toggle/theme_toggle_impl/custom_shared_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrefsThemeAppCubit extends Cubit<PrefsThemeAppState> {
  final CustomSharedPreference preference;

  PrefsThemeAppCubit({required this.preference})
      : super(const PrefsThemeAppState(prefsTheme: true)) {
    //true is darkTheme --- false is lightTheme
  }

  void getPrefsTheme() async {
    ///-- read the theme selected by user
    final prefs = await preference.readPreferenceTheme();

    ///-- if the user has not yet chosen a theme, the default theme is dark
    emit(state.copyWith(prefsTheme: prefs ?? true));
  }

  void changePrefsTheme() async {
    emit(state.copyWith(prefsTheme: !state.prefsTheme));

    //-- after change the CubitState save on shared preference the theme mode selected
    await preference.savePreferenceTheme(state.prefsTheme);
  }

  Future<void> removePrefsTheme() async {
    //-- can be use if user signOut session app

    await preference.deletePreferenceTheme();

    emit(state.copyWith(prefsTheme: true));
  }
}
//***** Cubit state
class PrefsThemeAppState extends Equatable {
  //
  final bool prefsTheme;
  const PrefsThemeAppState({required this.prefsTheme});

  bool get isDarkTheme => prefsTheme == true;

  PrefsThemeAppState copyWith({bool? prefsTheme}) {
    return PrefsThemeAppState(prefsTheme: prefsTheme ?? this.prefsTheme);
  }

  @override
  List<Object?> get props => [prefsTheme];

  @override
  String toString() {
    return 'Theme: $prefsTheme';
  }
}
