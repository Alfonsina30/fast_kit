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
