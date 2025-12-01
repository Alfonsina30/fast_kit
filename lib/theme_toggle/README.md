This snippet provides a robust and reusable structure for changing the application's theme. It uses a class to change the application's visual appearance based on the user's chosen light or dark theme.

# How would you use it in your project?

1. Define the **ThemeToggle** class, which will hold all the **ThemeData** settings: Copy and paste the **ThemeToggle** class into a Dart file (theme_toggle.dart) and import material.dart.

Note: 💡The ThemeToggle class only provides the light or dark theme settings for the following widgets: scaffoldBackgroundColor, appBarTheme, textTheme(displayLarge, titleMedium), iconTheme, and floatingActionButtonTheme.

```dart
import 'package:flutter/material.dart';

class ThemeToggle {

  final bool state;
  const ThemeToggle({required this.state});

  static const primaryColor = Colors.deepOrange;

  ThemeData theme() {
    if (state) {
//**************************************************THEME DARK*********************************** */

      return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(color: Colors.black),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
            titleMedium: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: primaryColor));
    }
    //
//*********************************************THEME LIGHT********************************************* */

    else {
      return ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: Colors.white),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
            titleMedium: TextStyle(
                color: Colors.black, 
                fontSize: 22, 
                fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: primaryColor));
    }
  }
}

```
2. Create a **CustomSharedPreference** class to save the user's chosen Theme Mode preference on the device.

For this purpose, we will use the SharedPreference plugin to persistently store simple data, in this case, a boolean value.

When creating the class, you must also install the SharedPreference dependency in your project's pubspec.yaml file.

pubspec.yaml 

```dart
shared_preferences: ^2.5.3
```


theme_toggle_impl.dart

```dart
import 'package:shared_preferences/shared_preferences.dart';

class CustomSharedPreference {
   
  static Future<SharedPreferences> _initPreference() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return sharedPreferences;
  }

// methods that can be calling from business logic 
  Future<void> savePreferenceTheme(bool value) async {
    final prefs = await _initPreference();
    prefs.setBool('themeApp', value);
  }

  Future<bool?> readPreferenceTheme() async {
    final prefs = await _initPreference();
    final getPrefs = prefs.getBool('themeApp');
    return getPrefs;
  }

  Future<bool> deletePreferenceTheme() async {
    final prefs = await _initPreference();
    return prefs.remove('themeApp');
  }
}
```
3. Use the **CustomSharedPreference** class in your business logic: In a Cubit, Bloc, or even a simple StatefulWidget, you use instances of these classes to manage the state of your fields.

Here's an example using Cubit; if you want to use this example, you need to add this dependency to your pubspec.yaml file.

```dart

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
```

# Implementing the example:

```dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

class PrefsThemeAppCubit extends Cubit<PrefsThemeAppState> {
  //
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

```
4. **Initial Setup in main.dart**

For the theme to work throughout the app, you need to wrap your MaterialApp with BlocProvider and use BlocBuilder to listen for state changes.

```dart

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

```

5. **Widget to Change the Application Theme**

Create a widget that, when pressed by the user, activates the changePrefsTheme() method of your Cubit. The widget we will use for this action is the FloatingActionButton.

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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

```