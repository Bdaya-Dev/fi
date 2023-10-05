import 'package:fi_base/fi_base.dart';

///
class FiRequiredFieldState<T> extends FiStateBase<T, FiRequiredError>
    with FiCopyWithMixin<T, FiRequiredError, FiRequiredFieldState<T>> {
  ///
  const FiRequiredFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const FiRequiredFieldState.pure(super.value, {super.id}) : super.pure();
  const FiRequiredFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  // @override
  // Object? valueToJson(T value) => value;
  // static T valueFromJson(Object? src) => src as T;

  factory FiRequiredFieldState.fromParsed(
    FiSerializedState parsed, {
    T Function(dynamic value)? valueFromJson,
  }) =>
      FiRequiredFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson == null
            ? parsed.originalValue as T
            : valueFromJson(parsed.originalValue),
        value: valueFromJson == null
            ? parsed.value as T
            : valueFromJson(parsed.value),
      );

  factory FiRequiredFieldState.fromJson(
    Map<String, dynamic> src, {
    T Function(dynamic value)? valueFromJson,
  }) =>
      FiRequiredFieldState.fromParsed(
        FiSerializedState.fromJson(src),
        valueFromJson: valueFromJson,
      );

  @override
  FiValidator<T, FiRequiredError>? get validator => FiRequiredValidator<T>();

  @override
  FiRequiredFieldState<T> copyWithAll({
    required String id,
    required bool isPure,
    required T value,
    required T originalValue,
  }) {
    return FiRequiredFieldState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}
