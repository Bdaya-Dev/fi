import 'package:fi_base/fi_base.dart';

/// Mixin that wraps a FiValidator.
mixin FiValidatorContainerMixin<T, E> {
  /// The validator.
  FiValidator<T, E>? get validator;
}
