import 'package:flutter/material.dart';
import 'email_input.dart';
import 'password_input.dart';

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
  Email email = Email.pure();
  Password password = Password.pure();

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

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // When the user input the new value to the TextFormField,
                  // need create a new "dirty" instance that validates the value
                  setState(() {
                    email = Email.dirty(value: value);
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: color,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.white),
                  focusedErrorBorder: borderColor,
                  errorBorder: borderColor,
                  focusedBorder: borderColor,
                  focusColor: color,
                  enabledBorder: borderColor,
                  errorText:
                      //-- listen the new state of input and take its the value of displayError
                      email.displayError,
                  errorStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.deepOrange,
                    size: Theme.of(context).iconTheme.size,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              ///
              //

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // When the user input the new value to the TextFormField,
                  // need create a new "dirty" instance that validates the value
                  setState(() {
                    password = Password.dirty(value: value);
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: color,
                  filled: true,
                  hintStyle: TextStyle(color: Colors.white),
                  focusedErrorBorder: borderColor,
                  errorBorder: borderColor,
                  focusedBorder: borderColor,
                  focusColor: color,
                  enabledBorder: borderColor,
                  errorText:
                      //-- listen the new state of input and take its the value of displayError
                      password.displayError,
                  errorStyle: TextStyle(fontSize: 15),
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.deepOrange,
                    size: Theme.of(context).iconTheme.size,
                  ),
                ),
              ),

              SizedBox(height: 80),
              //
              Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                        textStyle: WidgetStatePropertyAll(TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                    onPressed: () {
                      // When the user tap button send, need to recheck the value of the input.
                      setState(() {
                        email = Email.dirty(value: email.value);
                        password = Password.dirty(value: password.value);
                      });

                      //--- Navigate----
                    },
                    child: Text('SignIn'),
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
