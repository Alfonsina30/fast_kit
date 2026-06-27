part of 'prefs_theme_app_cubit.dart';

class PrefsThemeAppState extends Equatable {
  //
  final ThemeMode prefsTheme;

  const PrefsThemeAppState({required this.prefsTheme});

  PrefsThemeAppState copyWith({ThemeMode? prefsTheme}) {
    return PrefsThemeAppState(prefsTheme: prefsTheme ?? this.prefsTheme);
  }

  @override
  List<Object?> get props => [prefsTheme];

  @override
  String toString() {
    return 'prefsTheme: $prefsTheme';
  }
}
