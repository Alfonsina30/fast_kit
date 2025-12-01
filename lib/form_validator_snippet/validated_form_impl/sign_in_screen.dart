import 'package:flutter/material.dart';

/*
# fast_kit

# READ ME 'VALIDATED_FORM'

This snippet provides a robust and reusable framework for validating form fields in Dart/Flutter. It uses 
an abstract class to handle state (clean/dirty) and validation, making it easy to create extending classes 
for use with custom fields like emails, passwords, etc.

Classes that extend InputsSign must implement validation logic specific 
to their data type (e.g., email, password, username, etc.). This allows you to maintain a consistent structure 
throughout your code.

Let's look at an example of how the flow works:

1. The user types something into the text field.

2. Your Cubit or Bloc, provider, or simply a variable using setState() receives the new value.

3. You call the constructor named EmailInput.dirty.

4. Inside EmailInput.dirty, a static method (_validate) is called, which executes the validation logic for the value, for example, email.

5. The result of `_validate` (the error or `null`) is passed to the `super.dirty` constructor of the abstract class.

6. The abstract class `ValidateForm` stores this result in the `_error` property.

7. From that point on, every time you access `isValid` or `displayError`, the class simply returns its existing state.

### **How ​​would you use it in your project?**

1. **Define the abstract class**: Copy and paste the `ValidateForm` class into a Dart file (`validate_form.dart`).
*/

//--- An abstract class to handle state (clean/dirty) and validation
//--- ValidateForm<T, E>  use generic type that wiil be determined on the extended class

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

/*

2. **Create a class for each field and override the validator and displayError methods.**

For each form field you need, create a new class that extends ValidateForm. For example:

- class Email extends ValidateForm, for email validation.

- class Password extends ValidateForm, for password validation.

- class Username extends ValidateForm, for username validation.

This example shows the implementation for validating the email field.

**Some explanations:**

- **Error status (_error)**: The abstract class has a private property _error that stores the validation result.

- **Constructors**: The dirty constructor requires the error (E? error) as an argument. 
The class that extends it (EmailInput.dirty) is responsible for calculating the error and passing it.

- **Getter Methods**: The `error` and `isValid` getters simply return the state stored in the `_error` property.

- **Private Method**: `_validate` validates the form input and passes the new value to the `_error` property if an error occurs; otherwise, the value will be `null`.
*/

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

/*
3. **Use classes in your business logic**: 
In a Cubit, Bloc, or simply a StatefulWidget, you use instances of these classes to manage the state of your fields.

# Example using a StatefulWidget

*/

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
