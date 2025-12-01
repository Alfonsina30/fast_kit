 # fast_kit

# READ ME 'FIREBASE_AUTH_SERVICE'

This snippet provides a robust and reusable codice for using Firebase Authentication in your Flutter app, including the implementation for:

- Registration and Login with email and password.

- User Logout.

- Resetting the user's login password.

- Error Handling.

# Step 1: Firebase Configuration
Access Firebase with your Google Account:

Create the project in the Firebase Console. This project can have the same name as your application.

Install the required command-line tools.

Note: If you use macOS or Linux, the following link provides the step-by-step guide to install the Firebase CLI:

https://firebase.google.com/docs/cli?hl=es-419#setup_update_cli

Step-by-step to install the Firebase CLI on Windows:

Install the Firebase CLI. In my case, I used the npm option.

You can use npm (Node Package Manager) to install the Firebase CLI through these steps:

Install Node.js with nvm-windows (Node Version Manager). When you do this, the npm command-line tools will automatically be installed.

NOTE 💡 Firebase CLI requires Node.js 18.0.0 or later. Some Firebase features may require specific Node.js versions, so check the getting started page for each product for their specific Node.js requirements.

Execute the following command to install Firebase CLI via npm: npm install -g firebase-tools

This makes the firebase command globally available. The CLI allows you to connect your local folder with the Firebase project in the cloud. Additionally, it helps you configure which services you will use and creates crucial configuration files (firebase.json and .firebaserc).

Install the FlutterFire CLI:

To install the FlutterFire CLI, execute the following command from any directory: dart pub global activate flutterfire_cli

The FlutterFire CLI is a very useful auxiliary tool created specifically to facilitate the configuration and connection of Firebase with a Flutter application that supports multiple platforms (Android, iOS, Web, etc.).

Its main function is automation:

Configuration Generation: It allows you to run the flutterfire configure command (once the CLI is installed), which automatically:

Generates the firebase_options.dart file containing all the specific configuration (API keys, app IDs, etc.) for each platform of your project.

Downloads and places the native configuration files (GoogleService-Info.plist for iOS/macOS and google-services.json for Android) in the correct locations.

# Step 2: Initialize Firebase in your Application
Access Firebase from your Flutter project directory in the VS Code terminal, using your Google Account, by executing the following command: firebase login

From your Flutter project directory, execute the following command to install the core plugin: flutter pub add firebase_core

The firebase_core package is the "core" or the foundation of the Firebase connection.

Without firebase_core, no other Firebase package (firebase_auth, cloud_firestore, etc.) will work.

From your Flutter project directory, execute the following command to link the project created in the Firebase console and your Flutter project, and to ensure that your Flutter application's Firebase configuration is up-to-date: flutterfire configure

Select the project already created in the Firebase console.

Choose which platform (android, ios, macos, web, linux) the configuration will support.

In the lib/main.dart file, import the Firebase Core plugin and the configuration file generated previously:

```dart

//Flutter import
import 'package:flutter/material.dart';

//-- Firebase import
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// o 
import 'package:fast_kit/firebase_options.dart';

```

Additionally, in the lib/main.dart file, initialize Firebase using the DefaultFirebaseOptions object imported from the configuration file:

```dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
```

Recreate the Flutter application:


```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: Center(
        child: Text("Firebase Authentication"),
      ),
    );
  }
}
```

Execute: flutter run


# Step 3: Add Firebase Plugins to the Flutter App
Access Firebase in your Flutter application through the different Firebase Flutter plugins. There is one plugin for each Firebase product (e.g., Cloud Firestore, Authentication, Analytics, etc.).

💡In our case, we are going to add the plugin for authentication.

From your Flutter project directory, run this command: flutter pub add firebase_auth

From your Flutter project directory, run this command: flutterfire configure

Running this command ensures that your Flutter application's Firebase configuration is up-to-date and, for Crashlytics and Performance Monitoring on Android, it adds the necessary Gradle plugins to your application.

Finally, rebuild your Flutter project: flutter run

NOTE 💡: In our project in VSCODE, a file with all the information about the app created in Firebase and connected to our app will be created in lib/firebase_options.dart.


# Step 4: Configure Authentication with Firebase to the Flutter App
After configuring Firebase in our Flutter project, we will follow these steps for authentication:

Go to the Firebase Console at: https://console.firebase.google.com

Choose the recently created project.

In the menu, go to Build / Authentication.

Tap on Sign-in method.

A list of login providers will open.

Choose the Email/Password option.

Tap on:

Button Enable

Button Save


# Step 5: Create File and Implement the Authentication Code in the Flutter App
In your project, create the file auth_firebase_service_impl.dart.

```dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  //
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService({required this.firebaseAuth});

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    //
    try {
      final userData = await firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userData.user != null) {
        return userData;
        //
      } else {
        throw HandleExceptionAuthService(
            messageError: 'user is currently signed out');
      }
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService(messageError: 'Error not controlled');
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      {required String name,
      required String email,
      required String password}) async {
    //
    try {
      final userData = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (userData.user != null) {
        return userData;
        //
      } else {
        throw HandleExceptionAuthService(
            messageError: 'User is currently signed out');
      }
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService(messageError: e.toString());
    }
  }

  Future<void> sendEmailCodeResetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
      throw HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService();
    }
  }

  Future<void> logOut() async {
    try {
      await firebaseAuth.signOut();
      //
    } on FirebaseAuthException catch (e) {
      HandleExceptionAuthService.handleFirebase(e);
    } catch (e) {
      throw HandleExceptionAuthService();
    }
  }
}

//! HANDLE EXCEPTION
class HandleExceptionAuthService {
  final String messageError;
  HandleExceptionAuthService(
      {this.messageError = 'An unknow exception occured'});
  //
  //! firebase
  factory HandleExceptionAuthService.handleFirebase(
      FirebaseAuthException exceptionFire) {
    final exception = exceptionFire.code;

    switch (exception) {
      case 'invalid-email' || 'auth/invalid-email':
        return HandleExceptionAuthService(
            messageError: 'Email address is not valid');
      case 'email-already-in-use':
        return HandleExceptionAuthService(messageError: 'Email already in use');
      case 'user-disabled':
        return HandleExceptionAuthService(
            messageError: ' The given email has been disabled');

      case 'user-not-found' || 'auth/user-not-found':
        return HandleExceptionAuthService(
            messageError: 'Does not user corresponding to the given email');
      case 'wrong-password':
        return HandleExceptionAuthService(
            messageError: 'The password is invalid');

      case 'too-many-requests':
        return HandleExceptionAuthService(
            messageError:
                'Was sent too many requests at the same time, for security the need to wait for some time');

      case 'INVALID_LOGIN_CREDENTIALS' || 'invalid-credential':
        return HandleExceptionAuthService(
            messageError: 'The credential is not valid');

      case 'expired-action-code':
        return HandleExceptionAuthService(messageError: 'The code has expired');

      case 'invalid-action-code':
        return HandleExceptionAuthService(
            messageError: 'The code is malformed or has already been used');

//**********use when user create account from google, facebook */
      case 'provider-already-linked':
        return HandleExceptionAuthService(
            messageError:
                'The Google Account has already been linked to the user.');

      case 'credential-already-in-use':
        return HandleExceptionAuthService(
            messageError:
                'The account corresponding to the credential already exists');

      default:
        return HandleExceptionAuthService();
    }
  }
}
```

Use the classes in your business logic: In a Cubit, Bloc, or simply a StatefulWidget, you use the AuthFirebaseServiceImpl methods to handle:

- Registration and login with email and password.

- User logout.

- Resetting the user's login password.

#  Example using StatefulWidget for a user registration screen. 

In this implementation of the code, it is also added to validate forms when a user registers before making the call to Firebase authentication.

```dart
import 'package:fast_kit/firebase_auth/firebase_auth_service.dart';
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
```
