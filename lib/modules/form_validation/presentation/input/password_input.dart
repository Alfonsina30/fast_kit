import '../../domain/base/form_validation.dart';
import '../../domain/enum/error_input.dart';

/// --- Example of a class using the improved abstract class
class PasswordInput extends FormValidation<String, ErrorInput> {
  const PasswordInput.pure() : super.pure('', null);

  PasswordInput.dirty({required String value})
      : super.dirty(value, _validate(value));

  /// simple regex for password validation
  static RegExp passwordRegex = RegExp(
      r'^(?!^[0-9]*$)(?!^[a-zA-Z!@#$%^&*()_+=<>?]*$)^([a-zA-Z@#$%^&*_+<>?0-9]{6,15})$');

  static ErrorInput? _validate(value) {
    if (!passwordRegex.hasMatch(value) && value.isNotEmpty) {
      return ErrorInput.invalid;
    }

    if (value.isEmpty) {
      return ErrorInput.empty;
    }
    return null;
  }

  @override
  String toString() {
    return 'Password: $value';
  }

  @override
  ErrorInput? validator(String value) => _validate(value);
}
