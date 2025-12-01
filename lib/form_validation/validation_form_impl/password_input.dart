

import '../validate_form.dart';
import 'utils/validation_error.dart';

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
