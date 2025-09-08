import 'package:fast_kit/form_validator_snippet/my_form_cubit.dart';
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

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) { 
    final color = Colors.grey.shade900;

    final borderColor = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              //
              Text('Welcome back ',
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text('It\'s good to have you here again',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
              //

              SizedBox(
                height: 100,
              ),

              Center(
                  child: Text(
                'SignIn',
                style: TextStyle(
                    fontSize: 29,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 20,
              ),

              ///
              //

              FocusScope(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: context.read<MyFormCubit>().onEmailChanged,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: Colors.grey.shade900,
                    filled: true,
                    hintStyle: TextStyle(color: Colors.white),
                    focusedErrorBorder: borderColor,
                    errorBorder: borderColor,
                    focusedBorder: borderColor,
                    focusColor: color,
                    enabledBorder: borderColor,
                    errorText:
                        context.watch<MyFormCubit>().state.email.displayError,
                    errorStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.deepOrange,
                      size: Theme.of(context).iconTheme.size,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 80),
              //
              Center(
                child: ElevatedButton(
                  child: Text('SignIn'),
                  onPressed: () => context.read<MyFormCubit>().signInButton(),
                ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
