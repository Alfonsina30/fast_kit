Este snippet proporciona una estructura robusta y reutilizable para cambiar el tema de la aplicación. Utiliza una clase para cambiar el aspecto de visual de la aplicación en base al tema oscuro o claro elegido por el usuario. 

### Cómo lo usarías en tu proyecto?

1. Define la clase **ThemeToggle** que va a tener toda la configuración del **ThemeData:** Copias y pegas la clase **ThemeToggle** en un archivo dart (theme_toggle.dart) e importas material.dart .

Nota: 💡La clase ThemeToggle solo proporciona la configuración para el tema claro o oscuro para los widgets: scaffoldBackgroundColor, appBarTheme, textTheme(displayLarge,  titleMedium), iconTheme y floatingActionButtonTheme. 

```dart
import 'package:flutter/material.dart';

class ThemeToggle {
  final bool state;
  const ThemeToggle({required this.state});

  static const primaryColor = Colors.deepOrange;

  ThemeData theme() {
    if (state) {
//**************************************************THEME DARK****************************************** */

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

1. Crear clase **CustomSharedPreference** para guardar en el dispositivo la preferencia del Theme Mode elegido por el usuario. 

Para este objetivo usaremos el plugin SharedPreference para almacenar de manera persistente datos simples, en este caso un dato booleano.

Al crear la clase, debes también instalar la dependencia de  SharedPreference  en el archivo pubspec.yaml de tu proyecto 

pubspec.yaml 

```dart
shared_preferences: ^2.5.3
```

custom_shared_preference.dart

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

1. Usa las clase **CustomSharedPreference** en tu lógica de negocio: En un Cubit, Bloc, o un simplemente StatefulWidget, usas las instancias de estas clases para manejar el estado de tus campos. 

Te muestro un ejemplo utilizando Cubit, si quieres utilizar este ejemplo tienes agregar esta dependencia a tu archivo pubspec.yaml

```dart

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
```

Implementación del ejemplo:

```dart
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

```

1. **Configuración Inicial en main.dart**

Para que el tema funcione en toda la app, necesitas envolver tu MaterialApp con BlocProvider y usar BlocBuilder para escuchar los cambios de estado.

```dart
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

```

1. **Widget para Cambiar el Tema de la aplicación** 

Crea un widget que al ser presionado por el usuario active el método changePrefsTheme() de tu Cubit. El widget que utilizaremos para esta acción será el FloatingActionButton. 

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