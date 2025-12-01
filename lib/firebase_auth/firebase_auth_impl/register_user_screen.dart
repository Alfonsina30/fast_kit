import 'package:fast_kit/firebase_auth/firebase_auth_service.dart';
import 'package:fast_kit/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'validate_form/email_input.dart';
import 'validate_form/password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
        home: RegisterUserScreen());
  }
}

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  //

  final TextEditingController name = TextEditingController();
  Email email = Email.pure();
  Password password = Password.pure();

  @override
  Widget build(BuildContext context) {
    //
    final color = Colors.grey.shade900;

    final borderColor = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),

              Center(
                  child: Text('Join us today',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),

              const SizedBox(
                height: 20,
              ),

              Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),

              const SizedBox(
                height: 70,
              ),

              FocusScope(
                child: Column(
                  spacing: 30,
                  children: [
                    //
                    //-- NAME FIELD
                    TextFormField(
                      controller: name,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        fillColor: Colors.grey.shade900,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.white),
                        focusedErrorBorder: borderColor,
                        errorBorder: borderColor,
                        focusedBorder: borderColor,
                        focusColor: color,
                        enabledBorder: borderColor,
                        errorStyle: TextStyle(fontSize: 15),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepOrange,
                          size: Theme.of(context).iconTheme.size,
                        ),
                      ),
                    ),
                    //
                    //-- EMAIL FIELD
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
                        fillColor: Colors.grey.shade900,
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

                    //-- PASSWORD FIELD
                    TextFormField(
                      keyboardType: TextInputType.text,
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
                        fillColor: Colors.grey.shade900,
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
                  ],
                ),
              ),

              SizedBox(height: 80),
              //
              Center(
                child: FilledButton(
                  child: Text('Register user'),
                  onPressed: () async {
                    //
                    if (name.text.isNotEmpty &&
                        email.isValid &&
                        password.isValid) {
                      //
                      final user = await FirebaseAuthService(
                              firebaseAuth: FirebaseAuth.instance)
                          .createUserWithEmailAndPassword(
                              name: name.text,
                              email: email.value,
                              password: password.value);

                      if (context.mounted && user.user != null) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const MyHomePage()));
                      }
                    }
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
