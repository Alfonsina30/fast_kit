
# VALIDATED_FORM

This snippet provides a robust and reusable framework for validating form fields in Dart/Flutter. It uses
an abstract class to handle state (clean/dirty) and validation, making it easy to create extending classes
for use with custom fields like emails, passwords, etc.

Classes that extend ValidateForm must implement validation logic specific to their data type (e.g., email, password, username, etc.). This allows you to maintain a consistent structure throughout your code.

Let's look at an example of how the flow works:

1. The user types something into the text field.

2. Your Cubit or Bloc, Provider, or simply a variable using setState() receives the new value.

3. You call the constructor named EmailInput.dirty.

4. Inside EmailInput.dirty, a static method (\_validate) is called, which executes the validation logic for the value, for example, email.

5. The result of `_validate` (the error or `null`) is passed to the `super.dirty` constructor of the abstract class.

6. The abstract class `ValidateForm` stores this result in the `_error` property.

7. From that point on, every time you access `isValid` or `displayError`, the class simply returns its existing state.

### **How ​​would you use it in your project?**

# 1. Define the abstract class:

Copy and paste the `ValidateForm` class into a Dart file (`validate_form.dart`).

# 2. Create a class for each field and override the validator and displayError methods:

For each form field you need, create a new class that extends ValidateForm. For example:

- class Email extends ValidateForm, for email validation.

- class Password extends ValidateForm, for password validation.

- class Username extends ValidateForm, for username validation.

This example shows the implementation for validating the email field.

**Some explanations:**

- **Error status (\_error)**: The abstract class has a private property \_error that stores the validation result.

- **Constructors**: The dirty constructor requires the error (E? error) as an argument.
  The class that extends it (Email.dirty) is responsible for calculating the error and passing it.

- **Getter Methods**: The `error` and `isValid` getters simply return the state stored in the `_error` property.

- **Private Method**: `_validate` validates the form input and passes the new value to the `_error` property if an error occurs; otherwise, the value will be `null`.

# 3. Use classes in your business logic:

In a Cubit, Bloc, or simply a StatefulWidget, you use instances of these classes to manage the state of your fields.

**Example using a StatefulWidget**

````dart
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

              ///
              //

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
                  errorText: email.displayError,
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

              ///
              //

              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  // When the user input the new value to the TextFormField,
                  // need create a new "dirty" instance that validates the value
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
                      password.displayError ?? '',
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
                      // When the user tap button send, need to recheck the value of the input.
                      setState(() {
                        email = EmailInput.dirty(value: email.value);
                        password = PasswordInput.dirty(value: password.value);
                      });

                      //--- Navigate----
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

````
