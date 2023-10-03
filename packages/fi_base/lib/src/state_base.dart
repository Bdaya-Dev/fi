import 'package:fi_base/fi_base.dart';
import 'package:meta/meta.dart';

///
@immutable
abstract class FiStateBase<T, E>
    with
        FiIdMixin,
        FiValueMixin<T>,
        FiErrorMixin<E>,
        FiIsPureMixin,
        FiDisplayErrorMixin<E>,
        FiOriginalValueMixin<T>,
        FiEquatableMixin<T>,
        FiValidatorContainerMixin<T, E>,
        // most important!
        FiStateMixin<T, E>,
        FiSerializableMixin<T>,
        FiAggregator {
  /// used in `copyWith*`/`fromJson` functions.
  const FiStateBase({
    required this.value,
    required this.isPure,
    required this.originalValue,
    required String id,
  }) : _id = id;

  /// Creates a pure state.
  const FiStateBase.pure(
    this.value, {
    String? id,
  })  : isPure = true,
        originalValue = value,
        _id = id;

  /// Creates a pure state.
  const FiStateBase.dirty(
    this.value, {
    required this.originalValue,
    String? id,
  })  : isPure = false,
        _id = id;

  final String? _id;
  @override
  String get id => _id ?? super.id;

  @override
  E? get error => validator?.validate(value);

  @override
  final T value;

  @override
  final bool isPure;

  @override
  final T originalValue;

  /// if `true` (default), values are compared according to [valueEquals]
  /// and [valueHashCode].
  ///
  /// if `false`, all values are considered NOT equal.
  bool get supportEquality => true;

  /// The function that does equality checking.
  ///
  /// if this is null, no equality checking is done,
  /// and all instances are considered unequal.
  bool valueEquals(T v1, T v2) => fiDefaultEquals(v1, v2);

  /// Calculates hashCode from an object.
  int valueHashCode(T v) => fiDefaultHashCode(v);

  ///
  bool get supportSerialization => true;

  ///
  Object? valueToJson(T value) => fiDefaultSerializationFunction(value);

  @override
  @nonVirtual
  Object? Function(T src)? get getValueToJson =>
      supportSerialization ? valueToJson : null;

  @override
  FiValidator<T, E>? get validator => null;

  @override
  @nonVirtual
  FiEqualityCheckFunction<T>? get getValueEquals =>
      supportEquality ? valueEquals : null;

  @override
  @nonVirtual
  FiHashCodeFunction<T>? get getValueHashCode =>
      supportEquality ? valueHashCode : null;

  /// Converts the state to json if it supports serialization.
  @nonVirtual
  Map<String, dynamic> toJson() {
    return {
      kId: id,
      kValue: getValueToJson == null ? value : getValueToJson!.call(value),
      kOriginalValue: getValueToJson == null
          ? originalValue
          : getValueToJson!.call(originalValue),
      kIsPure: isPure,
    };
  }

  @override
  Iterable<FiStateMixin<dynamic, dynamic>> get fields sync* {
    final value = this.value;
    if (value is Iterable) {
      yield* value.whereType<FiStateMixin<dynamic, dynamic>>();
    } else if (value is Map) {
      yield* value.values.whereType<FiStateMixin<dynamic, dynamic>>();
    } else if (value is FiStateMixin) {
      yield value;
    }
  }
}
