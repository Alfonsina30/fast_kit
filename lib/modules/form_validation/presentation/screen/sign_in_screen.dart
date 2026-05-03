import 'package:flutter/material.dart';
import '../../form_validation_files.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //
  EmailInput email = EmailInput.pure();
  PasswordInput password = PasswordInput.pure();

  String? _displayErrorEmail(ErrorInput? error) {
    switch (error) {
      case ErrorInput.empty:
        return 'The field is required';

      case ErrorInput.invalid:
        return "Email must contain letters, \nnumbers and character @ ? _ - ! ? , .";

      default:
        return null;
    }
  }

  String? _displayErrorPassword(ErrorInput? error) {
    switch (error) {
      case ErrorInput.empty:
        return 'This field cannot be empty.';
      case ErrorInput.invalid:
        return '''Password must contain: 6 character (letters, at least one number or special characters)''';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backGroundColor = Colors.white;
    final colorInputField = Colors.grey.shade100;
    final errorColor = Colors.red;
    final primaryColor = Colors.blue;
    final textColor = Colors.black;

    final borderColor = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent));

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              //
              Text('Welcome back ',
                  style: TextStyle(
                      fontSize: 25,
                      color: textColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text('It\'s good to have you here again',
                  style: TextStyle(fontSize: 17, color: textColor)),
              //

              SizedBox(
                height: 70,
              ),

              Center(
                  child: Text(
                'Sign In',
                style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                    fontWeight: FontWeight.normal),
              )),
              const SizedBox(
                height: 40,
              ),

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = EmailInput.dirty(value: value);
                  });
                },
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: textColor),
                  errorText: _displayErrorEmail(email.error),
                  fillColor: colorInputField,
                  filled: true,
                  focusedErrorBorder: borderColor,
                  errorBorder: borderColor,
                  focusedBorder: borderColor,
                  focusColor: colorInputField,
                  enabledBorder: borderColor,
                  errorStyle: TextStyle(fontSize: 15, color: errorColor),
                  prefixIcon: Icon(
                    Icons.email,
                    color: primaryColor,
                    size: Theme.of(context).iconTheme.size,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) {
                  // When the user input the new value to the TextFormField,
                  // needs to create a new "dirty" instance that validates the value
                  setState(() {
                    password = PasswordInput.dirty(value: value);
                  });
                },
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: colorInputField,
                  filled: true,
                  hintStyle: TextStyle(color: textColor),
                  focusedErrorBorder: borderColor,
                  errorBorder: borderColor,
                  focusedBorder: borderColor,
                  focusColor: colorInputField,
                  enabledBorder: borderColor,
                  //-- listen the new state of input and take its the value of displayError
                  errorStyle: TextStyle(fontSize: 13),
                  error: SizedBox(
                    height: 40,
                    child: Text(
                      _displayErrorPassword(password.error) ?? '',
                      style: TextStyle(color: errorColor),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.password,
                    color: primaryColor,
                    size: Theme.of(context).iconTheme.size,
                  ),
                ),
              ),

              SizedBox(height: 40),
              //
              Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                        textStyle: WidgetStatePropertyAll(TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                    onPressed: () {
                      // 1. create the new versions in local variables.
                      final newEmail = EmailInput.dirty(value: email.value);
                      final newPassword =
                          PasswordInput.dirty(value: password.value);

                      // 2. update the status so that the UI displays any errors (if any).
                      setState(() {
                        email = newEmail;
                        password = newPassword;
                      });

                      if (newEmail.isValid && newPassword.isValid) {
                        //Navigate
                      }
                    },
                    child: Text('Login'),
                  ),
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
