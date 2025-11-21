import 'package:fast_kit/form_validator_snippet/validated_form.dart';


enum EmailValidationError { empty, invalid }


/// The super.dirty of the EmailInput constructor takes two arguments: 
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value) 
/// call (which will be an error or null) is passed to the abstract class, which stores it internally. 
/// Using a static method (_validate) is a common convention to keep validation logic separate from the 
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class Email extends ValidateForm<String, EmailValidationError> {
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
