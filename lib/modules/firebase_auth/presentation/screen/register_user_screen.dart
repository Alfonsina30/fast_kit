import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../firebase_options.dart';
import '../../../form_validation/form_validation_files.dart';
import '../../firebase_auth_files.dart';
import '../bloc/auth_cubit.dart';

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
    return BlocProvider(
      create: (context) => AuthCubit(
          repository: AuthRepositoryImpl(
              firebaseAuthService: FirebaseAuthServiceImpl(
                  firebaseAuth: FirebaseAuth.instance))),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
          home: RegisterUserScreen()),
    );
  }
}

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController name = TextEditingController();
  EmailInput email = EmailInput.pure();
  PasswordInput password = PasswordInput.pure();

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
    final color = Colors.grey.shade900;
    final borderColor = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.transparent));

    //--  We use BlocListener to handle side effects (Navigation and Alerts)
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) => const MyHomePage()));
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(children: [
                const SizedBox(height: 60),
                const Center(
                    child: Text('Join us today',
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
                const SizedBox(height: 30),
                const Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
                const SizedBox(height: 70),
                FocusScope(
                  child: Column(
                    spacing: 30,
                    children: [
                      //-- NAME FIELD
                      TextFormField(
                        controller: name,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.white),
                          focusedErrorBorder: borderColor,
                          errorBorder: borderColor,
                          focusedBorder: borderColor,
                          focusColor: color,
                          enabledBorder: borderColor,
                          errorStyle: const TextStyle(fontSize: 15),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      //-- EMAIL FIELD
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          setState(() {
                            email = EmailInput.dirty(value: value);
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.white),
                          focusedErrorBorder: borderColor,
                          errorBorder: borderColor,
                          focusedBorder: borderColor,
                          focusColor: color,
                          enabledBorder: borderColor,
                          errorText: _displayErrorEmail(email.error),
                          errorStyle: const TextStyle(fontSize: 15),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      //-- PASSWORD FIELD
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            password = PasswordInput.dirty(value: value);
                          });
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.grey.shade900,
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.white),
                          focusedErrorBorder: borderColor,
                          errorBorder: borderColor,
                          focusedBorder: borderColor,
                          focusColor: color,
                          enabledBorder: borderColor,
                          error: SizedBox(
                            height: 40,
                            child: Text(
                              _displayErrorPassword(password.error) ?? '',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          errorStyle: const TextStyle(fontSize: 15),
                          prefixIcon: const Icon(
                            Icons.password,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),

                //! We wrap the button with BlocBuilder to mutate the UI according to the state (Loading / Normal)
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    //
                    final cubitLoading = state is AuthLoading;

                    if (cubitLoading) {
                      return const Padding(
                          padding: EdgeInsets.all(26),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Colors.deepOrange,
                            ),
                          ));
                    }

                    return SizedBox(
                      width: 250,
                      child: FilledButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          // ---1. Local instances to force visual error rendering if the field is empty
                          final newEmail = EmailInput.dirty(value: email.value);
                          final newPassword =
                              PasswordInput.dirty(value: password.value);

                          setState(() {
                            email = newEmail;
                            password = newPassword;
                          });

                          // 2. Flawless synchronous validation before firing to the server
                          if (newEmail.isValid &&
                              newPassword.isValid &&
                              name.text.isNotEmpty) {
                                
                            // 3. Trigger the Cubit to handle the registration flow through the Repository and Firebase service. 
                            // The UI will reactively update based on the new state. Delegate the authentication process to the Cubit. 
                            // This encapsulates the Repository and Firebase logic, keeping the UI agnostics and reactive to state changes.
                            context.read<AuthCubit>().registerUser(
                                  name: name.text,
                                  email: email.value,
                                  password: password.value,
                                );
                          }
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.black),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        child: const Text('Register user'),
                      ),
                    );
                  },
                ),
              ]),
            ),
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
        iconTheme: IconThemeData(color: Colors.transparent),
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
