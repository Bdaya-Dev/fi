import 'package:collection/collection.dart';
import 'package:fi_base/fi_base.dart';

/// Function signature for checking if two objects are equal.
typedef FiEqualityCheckFunction<T> = bool Function(T v1, T v2);

/// Function signature for calculating an object's hashCode.
typedef FiHashCodeFunction<T> = int Function(T v);

/// Default hashCode implementation for fi state.
int fiDefaultHashCode(Object? v) {
  const eq = DeepCollectionEquality();
  return eq.hash(v);
}

/// Default equality implementation for fi state.
bool fiDefaultEquals(Object? v1, Object? v2) {
  const eq = DeepCollectionEquality();
  return eq.equals(v1, v2);
}

/// Mixin that wraps an equality function.
mixin FiEquatableMixin<T> on FiValueMixin<T> {
  /// The function that does equality checking.
  ///
  /// if this is null, no equality checking is done,
  /// and all instances are considered unequal.
  FiEqualityCheckFunction<T>? get getValueEquals;

  /// Calculates hashCode from an object.
  FiHashCodeFunction<T>? get getValueHashCode;
}
