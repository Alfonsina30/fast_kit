# fast_kit

# READ ME 'VALIDATED_FORM'

Este snippet proporciona una estructura robusta y reutilizable para la validación de campos de formularios en Dart/Flutter. Utiliza una clase abstracta para manejar el estado (puro/sucio) y la validación, facilitando la creación de clases que extiendan para utilizar en campos personalizados como correos, contraseñas, etc.

Las clases que extienden de InputsSign deben implementar la lógica de validación específica para su tipo de dato (ej. correo, contraseña, nombre de usuario, etc). Esto te permite mantener una estructura consistente en todo tu código.

Veamos un ejemplo de cómo funciona el flujo:

1. El usuario escribe algo en el campo de texto.
2. Tu Cubit o Bloc, provider o simplemente una variable con el setState() recibe el nuevo valor.
3. Llamas al constructor con nombre EmailInput.dirty.
4. Dentro de EmailInput.dirty, se llama a un método estático (_validate) que ejecuta la lógica de validación del value, por ejemplo, correo.
5. El resultado de _validate (el error o null) se pasa al constructor super.dirty de la clase abstracta.
6. La clase abstracta InputsSign almacena ese resultado en la propiedad _error.
7. A partir de ese momento, cada vez que accedas a isValid o displayError, la clase simplemente devuelve el estado que ya tiene. 

### **Cómo lo usarías en tu proyecto?**

1. **Define la clase abstracta**: Copias y pegas la clase InputsSign en un archivo dart (inputs_sign.dart).

```dart
//--- An abstract class to handle state (clean/dirty) and validation
//--- InputsSign<T, E>  use generic type that wiil be determined on the extended class

abstract class ValidatedForm<T, E> {
  final T value;
  final bool isPure;
  //property for know error of input
  final E? _error;

  const InputsSign._({
    required this.value,
    this.isPure = true,
    E? error,
  }) : _error = error;

  ///---- Constructors for handle state clean and dirty  
  const InputsSign.pure(T value, E? error)
      : this._(value: value, isPure: true, error: error);
  const InputsSign.dirty(T value, E? error)
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

1. **Crea una clase para cada campo y sobreescribe los mètodos** validator  **y** displayError.

 Por cada campo de formulario que necesites, creas una nueva clase que extienda InputsSign. Por ejemplo:

- class Email extends InputsSign, para la validación de correos.
- class Password extends InputsSign, para la validación de contraseñas.
- class Username extends  InputsSign, para la validación de nombres de usuario.

En este ejemplo te muestro la implementación para validar el campo de email. 

**Algunas explicaciones:**

- **Estado del error (_error)**: La clase abstracta tiene una propiedad privada _error que almacena el resultado de la validación.
- **Constructores**: El constructor dirty requiere el error (E? error) como argumento. La clase que lo extienda (EmailInput.dirty) es responsable de calcular el error y pasarlo.
- **Métodos get**: Los getters error e isValid simplemente devuelven el estado almacenado en la propiedad _error.
- **Método privado**:  _validate realiza la validación de la entrada del formulario y le pasa el nuevo valor a la propiedad _error en caso de que tenga un error, de lo contrario el valor será null.

```dart
import 'package:fast_kit/form_validator_snippet/validated_form.dart';

enum EmailValidationError { empty, invalid }

/// The super.dirty of the EmailInput constructor takes two arguments: 
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value) 
/// call (which will be an error or null) is passed to the abstract class, which stores it internally. 
/// Using a static method (_validate) is a common convention to keep validation logic separate from the 
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class Email extends ValidatedForm<String, EmailValidationError?> {
  const Email.pure()
      : super.pure('', EmailValidationError.empty);

  Email.dirty({required String value}) : super.dirty(value, _validate(value));

  /// simple regex for email validation
  static RegExp emailRegex = RegExp(r'^[a-zA-Z0-9@?_!.-]+$');

  static EmailValidationError? _validate(value) {
    if (!emailRegex.hasMatch(value) && value.isNotEmpty) {
      return EmailValidationError.invalid;
    }

    if (value.isEmpty) {
      return EmailValidationError.empty;
    }
    return null;
  }

  @override
  EmailValidationError? validator(String value) => _validate(value);

  @override
  String? get displayError {
    if (isPure || isValid) {
      return null;
    }

    switch (error) {
      case EmailValidationError.empty:
        return 'This field cannot be empty.';
      case EmailValidationError.invalid:
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

```

1. **Usa las clases en tu lógica de negocio**: En un Cubit, Bloc, o un simplemente StatefulWidget, usas las instancias de estas clases para manejar el estado de tus campos. 

# Ejemplo utilizando StatefulWidget

```dart
import 'package:fast_kit/form_validator_snippet/email.dart';
import 'package:fast_kit/form_validator_snippet/my_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Email email = Email.pure();

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

              FocusScope(
                child: TextFormField(
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
              ),

              SizedBox(height: 80),
              //
              Center(
                child: ElevatedButton(
                  child: Text('SignIn'),
                  onPressed: () {
                    // When the user tap button send, need to recheck the value of the input.
                    setState(() {
                      email = Email.dirty(value: email.value);
                    });
                  },
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

```

# Ejemplo utilizando Cubit

Te muestro un ejemplo utilizando Cubit, si quieres utilizar este ejemplo tienes agregar esta dependencia a tu archivo pubspec.yaml

```dart

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
```

Implementaciòn del ejemplo:

```jsx

import 'package:equatable/equatable.dart';
import 'package:fast_kit/form_validator_snippet/email.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///-- From Cubit or state Management when user write to the new input to Text Field
///-- call the constructor dirty(value) for create a new instance of the class that extend of abstract class InputsSign<T, E>

class MyFormCubit extends Cubit<FormSignInState> {
  MyFormCubit() : super(FormSignInState(email: Email.pure()));

  void onEmailChanged(String value) {
    // When the user input the new value to the TextFormField,
    // need create a new "dirty" instance that validates the value
    final email = Email.dirty(value: value);
    emit(state.copyWith(email: email));
  }

  void signInButton() {
    // When the user tap button send, need to recheck the value of the input,
    // you create a new "dirty" instance that validates the value
    final email = Email.dirty(value: state.email.value);

    emit(state.copyWith(email: email));

    final isValid = state.email.isValid;

    if (!isValid) return;
    //--- do request for login
  }
}

class FormSignInState extends Equatable {
  final Email email;

  const FormSignInState({required this.email});

  FormSignInState copyWith({Email? email}) {
    return FormSignInState(email: email ?? this.email);
  }

  @override
  List<Object?> get props => [email];

  @override
  String toString() {
    return 'EMAIL: $email';
  }
}



```

Si queremos llamar el Cubit dentro de la Screen SignIn, por ejemplo: 

```dart

import 'package:fast_kit/form_validator_snippet/my_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      home: BlocProvider(
        create: (context) => MyFormCubit(),
        child: SignInScreen(),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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

              FocusScope(
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  // When the user input the new value to the TextFormField,
                  // need create a new "dirty" instance that validates the value
                  onChanged: context.read<MyFormCubit>().onEmailChanged,
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
                      // listen the new state of input and take its the value of displayError
                        context.watch<MyFormCubit>().state.email.displayError,
                    errorStyle: TextStyle(fontSize: 15),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.deepOrange,
                      size: Theme.of(context).iconTheme.size,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 80),
              //
              Center(
                child: ElevatedButton(
                  child: Text('SignIn'),
                  
                    // When the user tap button send, need to recheck the value of the input.
                  onPressed: () => context.read<MyFormCubit>().signInButton(),
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

```


# READ ME 'THEME_TOGGLE'

# READ ME 'FIREBASE_AUTH'