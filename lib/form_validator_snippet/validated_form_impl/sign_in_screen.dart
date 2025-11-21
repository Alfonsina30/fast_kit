import 'package:flutter/material.dart';


abstract class ValidateForm<T, E> {
  final T value;
  final bool isPure;
  //property for know error of input
  final E? _error;

  const ValidateForm._({
    required this.value,
    this.isPure = true,
    E? error,
  }) : _error = error;

  ///---- Constructors for handle state clean and dirty
  const ValidateForm.pure(T value, E? error)
      : this._(value: value, isPure: true, error: error);
  const ValidateForm.dirty(T value, E? error)
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

enum ValidationError { empty, invalid }

/// The super.dirty of the EmailInput constructor takes two arguments:
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value)
/// call (which will be an error or null) is passed to the abstract class, which stores it internally.
/// Using a static method (_validate) is a common convention to keep validation logic separate from the
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class Email extends ValidateForm<String, ValidationError?> {
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
class Password extends ValidateForm<String, ValidationError> {
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

