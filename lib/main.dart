import 'package:fast_kit/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/firebase_auth/firebase_auth_files.dart';
import 'modules/firebase_auth/presentation/bloc/auth_cubit.dart';
import 'modules/form_validation/form_validation_files.dart';
import 'modules/theme_toggle/theme_toggle_files.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      create: (context) => AuthCubit(
          repository: AuthRepositoryImpl(
              firebaseAuthService: FirebaseAuthServiceImpl(
                  firebaseAuth: FirebaseAuth.instance))),
      child: BlocProvider(
          create: (context) => PrefsThemeAppCubit(
              preference: CustomSharedPreference(), initialTheme: initialTheme),
          child: BlocBuilder<PrefsThemeAppCubit, PrefsThemeAppState>(
              builder: (context, state) {
            //
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: state.prefsTheme,
              darkTheme: ThemeToggle(isDarkMode: true).theme(),

              ///--- call ThemeToggle class that handler theme mode
              ///-- Use the Cubit State for determine the app theme mode
              theme: ThemeToggle(isDarkMode: false).theme(),
              home: ModulesScreen(),
            );
          })),
    );
  }
}

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorText = Colors.white;
    final icon = Icons.arrow_forward_ios_outlined;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Modules',
          style: TextStyle(color: colorText),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'FORM VALIDATION',
              style: TextStyle(color: colorText),
            ),
            trailing: Icon(icon),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
          ),
          ListTile(
            title: Text(
              'FIREBASE AUTHENTICATION',
              style: TextStyle(color: colorText),
            ),
            trailing: Icon(icon),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterUserScreen()));
            },
          ),
          ListTile(
            title: Text(
              'THEME TOGGLE',
              style: TextStyle(color: colorText),
            ),
            trailing: Icon(icon),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThemeToggleScreen()));
            },
          )
        ],
      ),
    );
  }
}
