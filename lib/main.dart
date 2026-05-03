import 'package:fast_kit/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/firebase_auth/firebase_auth_files.dart';
import 'modules/form_validation/form_validation_files.dart';
import 'modules/theme_toggle/theme_toggle_files.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
            home: SnippetsScreen(),
          );
        }));
  }
}

class SnippetsScreen extends StatelessWidget {
  const SnippetsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorText = Colors.deepOrange.shade100;
    final icon = Icons.arrow_forward_ios_outlined;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Snippets',
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
