import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import '../../../../firebase_options.dart';
import '../../../form_validation/form_validation_files.dart';
import '../../firebase_auth_files.dart';

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

  /// customizable validation and multi-language list. You check the error messages from the UI without touching the core logic.

  String? _displayErrorEmail(ErrorInput? error) {
    switch (error) {
      case ErrorInput.empty:
        return 'The field is required';

      case ErrorInput.invalid:
        return "Email must contains letters, \nnumbers and character @ ? _ - ! ? , .";

      default:
        return null;
    }
  }

  String? _displayErrorPassword(ErrorInput? error) {
    switch (error) {
      case ErrorInput.empty:
        return 'This field cannot be empty.';
      case ErrorInput.invalid:
        return '''Password must contains: 6 character (letters, at least one number or special characters)''';
      default:
        return null;
    }
  }

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
          padding: const EdgeInsets.all(15.0),
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
                        // needs to create a new "dirty" instance that validates the value
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
                        errorText: _displayErrorEmail(email.error),
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
                      obscureText: true,
                      onChanged: (value) {
                        // When the user input the new value to the TextFormField,
                        // needs to create a new "dirty" instance that validates the value
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
                            _displayErrorPassword(password.error) ?? '',
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

                      // Hide the keyboard before validating or making the request
                      FocusScope.of(context).unfocus();

                      // 1. created the new instance of EmailInput and PasswordInput in local variables.
                      final newEmail = EmailInput.dirty(value: email.value);
                      final newPassword =
                          PasswordInput.dirty(value: password.value);

                      // 2. updated the status so that the UI displays any errors (if any).
                      setState(() {
                        email = newEmail;
                        password = newPassword;
                      });

                      if (newEmail.isValid &&
                          newPassword.isValid &&
                          name.text.isNotEmpty) {
                        //
                        setState(() => _isLoading = true);

                        //  3. CreateUserWithEmailRepository returns a clean (UserCredential? user, String? error).
                        //This removes the responsibility for exception handling from the UI, keeping the code clean and free of try-catch blocks in the view.
                        final repository = AuthRepositoryImpl(
                            firebaseAuthService: FirebaseAuthServiceImpl(
                                firebaseAuth: FirebaseAuth.instance));

                        final result = await repository.createUser(
                            name: name.text,
                            email: email.value,
                            password: password.value);

                        setState(() => _isLoading = false);

                        if (context.mounted && result.user != null) {
                          //-- navigate if user is not null
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const MyHomePage()));
                        } else {
                          //-- show error to UI
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.error.toString())),
                            );
                          }
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
