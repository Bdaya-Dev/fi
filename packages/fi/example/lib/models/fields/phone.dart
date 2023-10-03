import 'package:fi_base/fi_base.dart';

abstract final class PhoneValidationError {
  const PhoneValidationError();
}

final class PhoneValidationErrorInvalid extends PhoneValidationError {
  const PhoneValidationErrorInvalid();
  @override
  String toString() {
    return '''Phone must be at least 3 characters''';
  }
}

final class PhoneValidationErrorEmpty extends PhoneValidationError {
  const PhoneValidationErrorEmpty();
  @override
  String toString() {
    return 'Please enter a phone number';
  }
}

class PhoneValidator extends FiValidator<String?, PhoneValidationError> {
  const PhoneValidator();

  @override
  PhoneValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return const PhoneValidationErrorEmpty();
    } else if (value.length < 3) {
      return const PhoneValidationErrorInvalid();
    }
    return null;
  }
}

class PhoneFieldState extends FiStateBase<String?, PhoneValidationError>
    with FiCopyWithMixin<String?, PhoneValidationError, PhoneFieldState> {
  const PhoneFieldState({
    required super.id,
    required super.isPure,
    required super.originalValue,
    required super.value,
  });
  const PhoneFieldState.pure(super.value, {super.id}) : super.pure();
  const PhoneFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  String? valueToJson(String? value) {
    return value;
  }

  factory PhoneFieldState.fromParsed(FiSerializedState parsed) =>
      PhoneFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: parsed.originalValue as String?,
        value: parsed.value as String?,
      );

  factory PhoneFieldState.fromJson(Map<String, dynamic> src) =>
      PhoneFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  PhoneFieldState copyWithAll({
    required String id,
    required bool isPure,
    required String? value,
    required String? originalValue,
  }) {
    return PhoneFieldState(
      id: id,
      isPure: isPure,
      originalValue: originalValue,
      value: value,
    );
  }
}

class PhoneFieldStateList
    extends FiStateBase<List<PhoneFieldState>, FiLengthError>
    with
        FiCopyWithMixin<List<PhoneFieldState>, FiLengthError,
            PhoneFieldStateList> {
  const PhoneFieldStateList({
    required super.id,
    required super.isPure,
    required super.originalValue,
    required super.value,
  });
  const PhoneFieldStateList.pure(super.value, {super.id}) : super.pure();
  const PhoneFieldStateList.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(List<PhoneFieldState> value) {
    return value.map((e) => e.toJson()).toList();
  }

  static List<PhoneFieldState> valueFromJson(Object? json) {
    return (json as Iterable?)
            ?.whereType<Map<String, dynamic>>()
            .map(PhoneFieldState.fromJson)
            .toList() ??
        [];
  }

  @override
  FiValidator<List<PhoneFieldState>, FiLengthError>? get validator =>
      const FiListLengthValidator(
        minLength: 1,
        maxLength: 3,
      );

  factory PhoneFieldStateList.fromParsed(FiSerializedState parsed) =>
      PhoneFieldStateList(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory PhoneFieldStateList.fromJson(Map<String, dynamic> src) =>
      PhoneFieldStateList.fromParsed(FiSerializedState.fromJson(src));

  @override
  PhoneFieldStateList copyWithAll({
    required String id,
    required bool isPure,
    required List<PhoneFieldState> value,
    required List<PhoneFieldState> originalValue,
  }) =>
      PhoneFieldStateList(
        id: id,
        isPure: isPure,
        originalValue: originalValue,
        value: value,
      );
}
