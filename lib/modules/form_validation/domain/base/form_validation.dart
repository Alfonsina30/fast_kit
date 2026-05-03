//--- An abstract class to handle state (clean/dirty) and validation
//--- FormValidation<T, E>  use generic type that will be determined on the extended class

abstract class FormValidation<T, E> {
  final T value;
  final bool isPure;
  //property for know error of input
  final E? _error;

  const FormValidation._({
    required this.value,
    this.isPure = true,
    E? error,
  }) : _error = error;

  ///---- Constructors for handle state clean and dirty
  const FormValidation.pure(T value, E? error)
      : this._(value: value, isPure: true, error: error);
  const FormValidation.dirty(T value, E? error)
      : this._(value: value, isPure: false, error: error);

  E? validator(T value);

  /// --- Public getter to get the error
  E? get error => _error;

  /// --- Public getter to check for validity
  bool get isValid => _error == null;
}
