import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../firebase_options.dart';
import '../firebase_auth_service.dart';
import 'validate_form/email_input.dart';
import 'validate_form/password_input.dart';

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
  EmailInput email = EmailInput.pure();
  PasswordInput password = PasswordInput.pure();

  bool _isLoading = false;

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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 60,
              ),

              Center(
                  child: Text('Join us today',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),

              const SizedBox(
                height: 30,
              ),

              Text(
                'Create Account',
                style: TextStyle(color: Colors.white, fontSize: 23),
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
                          email = EmailInput.dirty(value: value);
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
                          password = PasswordInput.dirty(value: value);
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
                        error: SizedBox(
                          height: 40,
                          child: Text(
                            password.displayError ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
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

              if (_isLoading)
                Padding(
                    padding: EdgeInsets.all(26),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.deepOrange,
                      ),
                    ))
              else
                SizedBox(
                  width: 250,
                  child: FilledButton(
                    onPressed: () async {
                      if (_isLoading) return;

                      UserCredential? user;

                      setState(() => _isLoading = true);

                      try {
                        //
                        if (name.text.isNotEmpty &&
                            email.isValid &&
                            password.isValid) {
                          //
                          user = await FirebaseAuthService(
                                  firebaseAuth: FirebaseAuth.instance)
                              .createUserWithEmailAndPassword(
                                  name: name.text,
                                  email: email.value,
                                  password: password.value);
                        }
                      } catch (e) {
                        debugPrint('Error $e');

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Error del canal nativo: ${e.toString()}')),
                          );
                        }
                      } finally {
                        //

                        //
                        if (context.mounted && user != null) {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MyHomePage()));
                        }
                      }
                    },
                    style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                        backgroundColor: WidgetStatePropertyAll(Colors.white)),
                    child: Text('Register user'),
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Firebase Authentication',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
