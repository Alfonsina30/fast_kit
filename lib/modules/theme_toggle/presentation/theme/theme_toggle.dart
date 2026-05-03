import 'package:flutter/material.dart';

class ThemeToggle {
  final bool isDarkMode;
  const ThemeToggle({required this.isDarkMode});

  static const primaryColor = Colors.deepOrange;

  ThemeData theme() {
    //
    if (isDarkMode) {
//**************************************************THEME DARK****************************************** */
      return ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(
              primary: primaryColor, brightness: Brightness.dark),
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white)),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            titleMedium: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  iconColor: WidgetStatePropertyAll(primaryColor)
                  )),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: primaryColor));
    }
    //
//*********************************************THEME LIGHT********************************************* */

    else {
      return ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
              primary: primaryColor, brightness: Brightness.light),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black)),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
            titleMedium: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black))),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: primaryColor));
    }
  }
}
