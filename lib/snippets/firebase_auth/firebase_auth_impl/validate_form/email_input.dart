import 'validate_form.dart';
import 'validation_error.dart';

/// The super.dirty constructor takes two arguments:
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value)
/// call (which will be an error or null) is passed to the abstract class, which stores it internally.
/// Using a static method (_validate) is a common convention to keep validation logic separate from the
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class EmailInput extends ValidatedForm<String, ValidationError> {
  const EmailInput.pure() : super.pure('', ValidationError.empty);

  EmailInput.dirty({required String value})
      : super.dirty(value, _validate(value));

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
