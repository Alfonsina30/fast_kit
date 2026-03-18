# FIREBASE_AUTH_SERVICE

This module provides a robust and reusable codice for using Firebase Authentication in your Flutter app, including the implementation for:

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

In your project, create the file `auth_firebase_service.dart`

# Step 6: Use the classes in your business logic: In a Cubit, Bloc, or simply a StatefulWidget, you use the AuthFirebaseServiceImpl methods to handle:

- Registration and login with email and password.

- User logout.

- Resetting the user's login password.

# Example using StatefulWidget for a user registration screen.

This module uses the validation utilities centralized in the form_validation module to ensure a to separate architecture 

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../../firebase_options.dart';
import '../../form_validation/form_validation_impl/email_input.dart';
import '../../form_validation/form_validation_impl/password_input.dart';
import '../../form_validation/form_validation_impl/utils/error_input.dart';
import '../firebase_auth_service.dart';

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

                      UserCredential? user;

                      try {
                        // 1. We created the new versions in local variables.
                        final newEmail = EmailInput.dirty(value: email.value);
                        final newPassword =
                            PasswordInput.dirty(value: password.value);

                        // 2. We updated the status so that the UI displays any errors (if any).
                        setState(() {
                          email = newEmail;
                          password = newPassword;
                        });

                        if (newEmail.isValid &&
                            newPassword.isValid &&
                            name.text.isNotEmpty) {
                          setState(() => _isLoading = true);

                          user = await FirebaseAuthService(
                                  firebaseAuth: FirebaseAuth.instance)
                              .createUserWithEmailAndPassword(
                                  name: name.text,
                                  email: email.value,
                                  password: password.value);

                          //Navigate
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

```
