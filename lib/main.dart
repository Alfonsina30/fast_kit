import 'package:fast_kit/form_validator_snippet/my_form_cubit.dart';
import 'package:fast_kit/form_validator_snippet/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: BlocProvider(
        create: (context) => MyFormCubit(),
        child: SignInScreen(),
      ),
    );
  }
}

