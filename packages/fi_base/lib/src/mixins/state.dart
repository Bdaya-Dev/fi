import 'package:fi_base/fi_base.dart';

/// Mixin that combines all the mixins used in FiState.
mixin FiStateMixin<T, E>
    on
        FiIdMixin,
        FiValueMixin<T>,
        FiErrorMixin<E>,
        FiIsPureMixin,
        FiDisplayErrorMixin<E>,
        FiOriginalValueMixin<T>,
        FiEquatableMixin<T>,
        FiValidatorContainerMixin<T, E> {
  @override
  bool operator ==(Object? other) =>
      other is FiStateMixin<T, E> &&
      (getValueEquals?.call(value, other.value) ?? false) &&
      isPure == other.isPure;

  @override
  int get hashCode => Object.hash(getValueHashCode?.call(value), isPure);
}
