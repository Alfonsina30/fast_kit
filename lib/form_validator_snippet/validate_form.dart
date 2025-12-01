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
