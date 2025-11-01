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
                fontSize: 30, fontWeight: FontWeight.bold, 
                color: primaryColor),
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
