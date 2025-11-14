import 'package:fast_kit/firebase_auth/firebase_auth_service_impl.dart';
import 'package:fast_kit/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        home: MainApp());
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //

  final name = TextEditingController();
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
                      final user = await FirebaseAuthServiceImpl(
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

//---------------------------------------------- VALIDATE FORM --------------------------------------------

enum ValidationError { empty, invalid }

/// The super.dirty constructor takes two arguments:
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value)
/// call (which will be an error or null) is passed to the abstract class, which stores it internally.
/// Using a static method (_validate) is a common convention to keep validation logic separate from the
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class Email extends ValidatedForm<String, ValidationError> {
  const Email.pure() : super.pure('', ValidationError.empty);

  Email.dirty({required String value}) : super.dirty(value, _validate(value));

  /// simple regex for email validation
  static RegExp emailRegex = RegExp(r'^[a-zA-Z0-9@?_!.-]+$');

  static ValidationError? _validate(value) {
    if (!emailRegex.hasMatch(value) && value.isNotEmpty) {
      return ValidationError.invalid;
    }

    if (value.isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }

  @override
  ValidationError? validator(String value) => _validate(value);

  @override
  String? get displayError {
    if (isPure || isValid) {
      return null;
    }

    switch (error) {
      case ValidationError.empty:
        return 'This field cannot be empty.';
      case ValidationError.invalid:
        return 'Please enter a valid email address.';
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'Email: $value';
  }
}

/// --- Example of a class using the improved abstract class
class Password extends ValidatedForm<String, ValidationError> {
  const Password.pure() : super.pure('', ValidationError.empty);

  Password.dirty({required String value})
      : super.dirty(value, _validate(value));

  /// simple regex for password validation
  static RegExp passwordRegex = RegExp(
      r'^(?!^[0-9]*$)(?!^[a-zA-Z!@#$%^&*()_+=<>?]*$)^([a-zA-Z@#$%^&*_+<>?0-9]{6,15})$');

  static ValidationError? _validate(value) {
    if (!passwordRegex.hasMatch(value) && value.isNotEmpty) {
      return ValidationError.invalid;
    }

    if (value.isEmpty) {
      return ValidationError.empty;
    }
    return null;
  }

  @override
  ValidationError? validator(String value) => _validate(value);

  @override
  String? get displayError {
    if (isPure || isValid) {
      return null;
    }

    switch (error) {
      case ValidationError.empty:
        return 'This field cannot be empty.';
      case ValidationError.invalid:
        return '''Password must contains:
    6 character (letters, at least one number and special characters)\n  
    ''';
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'Password: $value';
  }
}

//--- An abstract class to handle state (clean/dirty) and validation
//--- InputsSign<T, E>  use generic type that wiil be determined on the extended class

abstract class ValidatedForm<T, E> {
  final T value;
  final bool isPure;
  //property for know error of input
  final E? _error;

  const ValidatedForm._({
    required this.value,
    this.isPure = true,
    E? error,
  }) : _error = error;

  ///---- Constructors for handle state clean and dirty
  const ValidatedForm.pure(T value, E? error)
      : this._(value: value, isPure: true, error: error);
  const ValidatedForm.dirty(T value, E? error)
      : this._(value: value, isPure: false, error: error);

  ///---- Handle the validation logic. This method can be used directly for unit testing,
  ///--- to validate an input without needing to instantiate the entire class.
  E? validator(T value);

  /// --- Public getter to get the error
  E? get error => _error;

  /// --- Public getter to check for validity
  bool get isValid => _error == null;

  /// --- Public getter to get a user-friendly error message from the error type E
  String? get displayError;
}
