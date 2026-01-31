import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme_toggle.dart';
import 'custom_shared_preference.dart';
import 'prefs_theme_app_cubit.dart';

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
        builder: (context, themeMode) {
          ///-- Use the CubitState for determine the app theme mode
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode.prefsTheme,

            ///--- call ThemeToggle class that handler theme mode
            ///-- Use the Cubit State for determine the app theme mode
            darkTheme: ThemeToggle(isDarkMode: true).theme(),
            theme: ThemeToggle(isDarkMode: false).theme(),
            home: ThemeToggleScreen(),
          );
        },
      ),
    );
  }
}

class ThemeToggleScreen extends StatelessWidget {
  const ThemeToggleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My App',
          //! connected with themedata
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Theme Toggle!',
              //! connected with themedata
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
              onPressed: () {
                context.read<PrefsThemeAppCubit>().changetoSystemMode();
              },
              label: Text('System mode'),
              icon: Icon(
                Icons.settings,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                context.read<PrefsThemeAppCubit>().changeToDarkMode();
              },
              label: Text('Dark mode'),
              icon: Icon(Icons.nightlight_round),
            ),
            OutlinedButton.icon(
              onPressed: () {
                context.read<PrefsThemeAppCubit>().changeToLightMode();
              },
              label: Text('Light mode'),
              icon: Icon(Icons.wb_sunny),
            ),
          ],
        ),
      ),
    );
  }
}
