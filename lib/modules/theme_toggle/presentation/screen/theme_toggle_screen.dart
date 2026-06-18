import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme_toggle_files.dart';

void main() async {
  // 1. Initialize local storage and read the theme before rendering the UI
  final prefsService = CustomSharedPreference();

  final savedThemeStr = await prefsService.readPreferenceTheme();

//2. Convert the string to ThemeMode
  final initialTheme = (savedThemeStr != null)
      ? ThemeMode.values.byName(savedThemeStr)
      : ThemeMode.system;

// 3. Pass the initial theme directly to the widget tree
  runApp(MainApp(
    preference: prefsService,
    initialTheme: initialTheme,
  ));
}

class MainApp extends StatelessWidget {
  final CustomSharedPreference preference;
  final ThemeMode initialTheme;

  const MainApp({
    super.key,
    required this.preference,
    required this.initialTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrefsThemeAppCubit(
          preference: CustomSharedPreference(), initialTheme: initialTheme),
      // get the user preference theme when the app is open.
      // and change the CubitState that will be listened from the application pages

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
                context
                    .read<PrefsThemeAppCubit>()
                    .changeThemeMode(ThemeMode.system);
              },
              label: Text('System mode'),
              icon: Icon(
                Icons.settings,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                context
                    .read<PrefsThemeAppCubit>()
                    .changeThemeMode(ThemeMode.dark);
              },
              label: Text('Dark mode'),
              icon: Icon(Icons.nightlight_round),
            ),
            OutlinedButton.icon(
              onPressed: () {
                context
                    .read<PrefsThemeAppCubit>()
                    .changeThemeMode(ThemeMode.light);
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
