import 'package:fast_kit/theme_toggle/theme_toggle.dart';
import 'package:fast_kit/theme_toggle/theme_toggle_impl/custom_shared_preference.dart';
import 'package:fast_kit/theme_toggle/theme_toggle_impl/prefs_theme_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrefsThemeAppCubit(
        preference: CustomSharedPreference(),
        // get the user preference theme when the app is open.
        // and change the CubitState that will be listened from the application pages
      )..getPrefsTheme(),
      child: BlocBuilder<PrefsThemeAppCubit, PrefsThemeAppState>(
        builder: (context, state) {
          ///-- Use the CubitState for determine the app theme mode

          return MaterialApp(
            debugShowCheckedModeBanner: false,

            ///--- call ThemeToggle class that handler theme mode
            ///-- Use the Cubit State for determine the app theme mode
            theme: ThemeToggle(state: state.prefsTheme).theme(),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        //! connected with themedata
        title: Text(
          'My App',
          //! connected with themedata
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: Text(
          'Theme Toggle!',
          //! connected with themedata
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /// Call the method of cubit [PrefsThemeAppCubit] for change the CubitState and store in
          // SharedPreference the app theme mode selected
          //
          context.read<PrefsThemeAppCubit>().changePrefsTheme();
        },
        child: Icon(
          /// Listen the current CubitState [PrefsThemeAppCubit] to display different icons
          context.watch<PrefsThemeAppCubit>().state.isDarkTheme
              ? Icons.wb_sunny
              : Icons.nightlight_round,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
