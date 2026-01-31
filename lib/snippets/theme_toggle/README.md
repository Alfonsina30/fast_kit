
# THEME TOGGLE

This snippet provides a robust and reusable structure for changing the application's theme. It uses a class to change the application's visual appearance based on the user's chosen light or dark theme.

# How would you use it in your project?

# 1. Define the **ThemeToggle** class, which will hold all the **ThemeData** settings:

Copy and paste the **ThemeToggle** class into a Dart file (theme_toggle.dart) and import material.dart.

Note: 💡The ThemeToggle class only provides the light or dark theme settings for the following widgets: OutlinedButton.icon, scaffoldBackgroundColor, appBarTheme, textTheme(displayLarge, titleMedium), iconTheme, and floatingActionButtonTheme.

# 2. Create a **CustomSharedPreference** class to save the user's chosen Theme Mode preference on the device.

For this purpose, we will use the SharedPreference plugin to persistently store simple data, in this case, a boolean value.

When creating the class, you must also install the SharedPreference dependency in your project's pubspec.yaml file:

```pubspec.yaml

shared_preferences: ^2.5.3

```

# 3. Use the **CustomSharedPreference** class in your business logic: In a Cubit, Bloc, or even a simple StatefulWidget, you use instances of these classes to manage the state of your fields.

Here's an example using Cubit; if you want to use this example, you need to add this dependency to your pubspec.yaml file.

```pubspec.yaml

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7

```

4. **Initial Setup in main.dart**

For the theme to work throughout the app, you need to wrap your MaterialApp with BlocProvider and use BlocBuilder to listen for state changes.

```dart
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
        builder: (context, state) {
          ///-- Use the CubitState for determine the app theme mode
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.prefsTheme,
            darkTheme: ThemeToggle(isDarkMode: true).theme(),

            ///--- call ThemeToggle class that handler theme mode
            ///-- Use the Cubit State for determine the app theme mode
            theme: ThemeToggle(isDarkMode: false).theme(),
            
            home: ThemeToggleScreen(),
          );
        },
      ),
    );
  }
}

```

5. **Widget to Change the Application Theme**

Create a widget that, when pressed by the user, change the state of Cubit.

```dart
//


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

```
