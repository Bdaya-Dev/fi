import 'package:fi_base/src/validator.dart';

/// An error signaling a field is required.
class FiRequiredError {
  ///
  const FiRequiredError();

  @override
  String toString() {
    return 'This field is required.';
  }
}

/// An error signaling a field is required.
class FiGenericRequiredError<T> extends FiRequiredError {
  /// Creates An error signaling a field is required.
  const FiGenericRequiredError(this.value);

  /// The validated value.
  final T value;
}

/// Validates that a value is required.
///
/// An error is returned in the following cases:
/// - if value is `null`.
/// - if value is an empty string.
/// - if value is an empty iterable.
/// - if value is an empty map.
class FiRequiredValidator<T> extends FiValidator<T, FiGenericRequiredError<T>> {
  ///
  const FiRequiredValidator();
  @override
  FiGenericRequiredError<T>? validate(T value) {
    if (value == null) {
      return FiGenericRequiredError(value);
    }
    if (value is String && value.isEmpty) {
      return FiGenericRequiredError(value);
    }
    if (value is Iterable && value.isEmpty) {
      return FiGenericRequiredError(value);
    }
    if (value is Map && value.isEmpty) {
      return FiGenericRequiredError(value);
    }
    return null;
  }
}
