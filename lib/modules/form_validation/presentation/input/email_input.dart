import '../../domain/base/form_validation.dart';
import '../../domain/enum/error_input.dart';

/// The super.dirty of the EmailInput constructor takes two arguments:
/// the value (value) and the validation result (_validate(value)). The result of the _validate(value)
/// call (which will be an error or null) is passed to the abstract class, which stores it internally.
/// Using a static method (_validate) is a common convention to keep validation logic separate from the
/// instance state, making the code clearer and easier to test independently.

/// --- Example of a class using the improved abstract class
class EmailInput extends FormValidation<String, ErrorInput?> {
  const EmailInput.pure() : super.pure('', null); //invoked dad constructor
  EmailInput.dirty({required String value})
      : super.dirty(value, _validate(value));

  static final _emailRegExp = RegExp(r'^[a-zA-Z0-9@?_!.-]+$');

  static ErrorInput? _validate(value) {
    if (!_emailRegExp.hasMatch(value) && value.isNotEmpty) {
      return ErrorInput.invalid;
    }
    if (value.isEmpty) {
      return ErrorInput.empty;
    }
    return null;
  }

  @override
  ErrorInput? validator(value) => _validate(value);

  @override
  String toString() {
    return value;
  }
}
