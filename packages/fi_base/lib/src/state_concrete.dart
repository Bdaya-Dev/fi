// ignore_for_file: sort_constructors_first

import 'package:fi_base/fi_base.dart';
import 'package:meta/meta.dart';

///
@immutable
final class FiState<T, E> extends FiStateBase<T, E>
    with FiCopyWithMixin<T, E, FiState<T, E>> {
  /// constructor used for the `copyWith*` methods.
  const FiState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
    required this.validator,
    required this.valueEqualsFunction,
    required this.valueHashCodeFunction,
    required this.serializeValueFunction,
  });

  /// Creates a pure [FiState].
  const FiState.pure(
    super.value, {
    this.validator,
    this.valueEqualsFunction = fiDefaultEquals,
    this.valueHashCodeFunction = fiDefaultHashCode,
    this.serializeValueFunction = fiDefaultSerializationFunction,
    super.id,
  }) : super.pure();

  /// Creates a dirty [FiState].
  const FiState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
    this.validator,
    this.valueEqualsFunction = fiDefaultEquals,
    this.valueHashCodeFunction = fiDefaultHashCode,
    this.serializeValueFunction = fiDefaultSerializationFunction,
  }) : super.dirty();

  /// Deserializes an [FiState] from json.
  factory FiState.fromJsonAndDefault(
    Map<String, dynamic> src, {
    required FiState<T, E> other,
    T Function(Object value)? deserializeValue,
  }) {
    return FiState.fromJson(
      src,
      deserializeValue: deserializeValue,
      validator: other.validator,
      valueEquals: other.getValueEquals,
      valueHashCode: other.getValueHashCode,
      serializeValue: other.serializeValueFunction,
    );
  }

  /// Deserialize [FiState] from [FiSerializedState].
  factory FiState.fromParsed(
    FiSerializedState parsed, {
    FiValidator<T, E>? validator,
    bool Function(T, T)? valueEquals = fiDefaultEquals,
    int Function(T)? valueHashCode = fiDefaultHashCode,
    dynamic Function(T value)? serializeValue,
    T Function(Object value)? deserializeValue,
  }) {
    final id = parsed.id;
    final valueRaw = parsed.value;
    final originalValueRaw = parsed.originalValue;

    final value = valueRaw == null
        ? null
        : deserializeValue == null
            ? valueRaw as T
            : deserializeValue(valueRaw);

    final originalValue = originalValueRaw == null
        ? null
        : deserializeValue == null
            ? originalValueRaw as T
            : deserializeValue(originalValueRaw);

    final isPure = parsed.isPure;
    if (value is! T) {
      throw ArgumentError(
        'Failed to deserialize value of type ${value.runtimeType} to type $T',
      );
    }
    if (originalValue is! T) {
      throw ArgumentError(
        'Failed to deserialize originalValue of type '
        '${originalValue.runtimeType} to type $T',
      );
    }
    return FiState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
      validator: validator,
      valueEqualsFunction: valueEquals,
      valueHashCodeFunction: valueHashCode,
      serializeValueFunction: serializeValue,
    );
  }

  /// Deserialize [FiState] from json.
  factory FiState.fromJson(
    Map<String, dynamic> src, {
    FiValidator<T, E>? validator,
    bool Function(T, T)? valueEquals = fiDefaultEquals,
    int Function(T)? valueHashCode = fiDefaultHashCode,
    dynamic Function(T value)? serializeValue,
    T Function(Object value)? deserializeValue,
  }) {
    final parsed = FiSerializedState.fromJson(src);
    return FiState.fromParsed(
      parsed,
      deserializeValue: deserializeValue,
      serializeValue: serializeValue,
      validator: validator,
      valueEquals: valueEquals,
      valueHashCode: valueHashCode,
    );
  }

  ///
  @override
  final FiValidator<T, E>? validator;

  ///
  final FiEqualityCheckFunction<T>? valueEqualsFunction;

  ///
  final FiHashCodeFunction<T>? valueHashCodeFunction;

  ///
  final dynamic Function(T value)? serializeValueFunction;

  @override
  bool get supportSerialization => serializeValueFunction != null;
  @override
  bool get supportEquality =>
      valueEqualsFunction != null && valueHashCodeFunction != null;

  @override
  dynamic valueToJson(T value) {
    if (serializeValueFunction == null) {
      return value;
    }
    return serializeValueFunction!(value);
  }

  @override
  bool valueEquals(T v1, T v2) {
    if (valueEqualsFunction == null) {
      throw UnimplementedError();
    }
    return valueEqualsFunction!(v1, v2);
  }

  @override
  int valueHashCode(T v) {
    if (valueHashCodeFunction == null) {
      throw UnimplementedError();
    }
    return valueHashCodeFunction!(v);
  }

  @override
  FiState<T, E> copyWithAll({
    required String id,
    required bool isPure,
    required T value,
    required T originalValue,
  }) =>
      FiState(
        id: id,
        value: value,
        isPure: isPure,
        originalValue: originalValue,
        validator: validator,
        valueEqualsFunction: valueEqualsFunction,
        valueHashCodeFunction: valueHashCodeFunction,
        serializeValueFunction: serializeValueFunction,
      );

  /// Copies the field state and replaces the equality check function.
  FiState<T, E> copyWithEquality({
    required FiEqualityCheckFunction<T>? valueEquals,
    required FiHashCodeFunction<T>? valueHashCode,
  }) =>
      FiState(
        valueEqualsFunction: valueEquals,
        valueHashCodeFunction: valueHashCode,
        serializeValueFunction: serializeValueFunction,
        value: value,
        isPure: isPure,
        validator: validator,
        originalValue: originalValue,
        id: id,
      );

  /// Copies the field state and replaces the equality check function.
  FiState<T, E> copyWithSerialization(
    dynamic Function(T value)? serializeValue,
  ) =>
      FiState(
        serializeValueFunction: serializeValue,
        valueEqualsFunction: valueEqualsFunction,
        valueHashCodeFunction: valueHashCodeFunction,
        value: value,
        isPure: isPure,
        validator: validator,
        originalValue: originalValue,
        id: id,
      );

  /// Copies the state replacing the validator.
  FiState<T, E> copyWithValidator(FiValidator<T, E>? validator) {
    return FiState(
      validator: validator,
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
      valueEqualsFunction: valueEqualsFunction,
      valueHashCodeFunction: valueHashCodeFunction,
      serializeValueFunction: serializeValueFunction,
    );
  }
}
