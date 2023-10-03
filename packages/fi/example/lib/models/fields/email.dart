import 'package:fi_base/fi_base.dart';

abstract final class EmailValidationError {
  const EmailValidationError();
}

final class EmailValidationErrorInvalid extends EmailValidationError {
  const EmailValidationErrorInvalid();
  @override
  String toString() {
    return '''Email is invalid''';
  }
}

final class EmailValidationErrorEmpty extends EmailValidationError {
  const EmailValidationErrorEmpty();

  @override
  String toString() {
    return 'Email is Required';
  }
}

class EmailValidator extends FiValidator<String?, EmailValidationError> {
  const EmailValidator();
  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );
  @override
  EmailValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return const EmailValidationErrorEmpty();
    } else if (!_emailRegExp.hasMatch(value)) {
      return const EmailValidationErrorInvalid();
    }

    return null;
  }
}

class EmailFieldState extends FiStateBase<String?, EmailValidationError>
    with FiCopyWithMixin<String?, EmailValidationError, EmailFieldState> {
  const EmailFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const EmailFieldState.pure(super.value, {super.id}) : super.pure();
  const EmailFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(String? value) => value;
  static String? valueFromJson(Object? src) => src as String?;

  factory EmailFieldState.fromParsed(FiSerializedState parsed) =>
      EmailFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory EmailFieldState.fromJson(Map<String, dynamic> src) =>
      EmailFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  FiValidator<String?, EmailValidationError>? get validator =>
      const EmailValidator();

  @override
  EmailFieldState copyWithAll({
    required String id,
    required bool isPure,
    required String? value,
    required String? originalValue,
  }) =>
      EmailFieldState(
        id: id,
        value: value,
        isPure: isPure,
        originalValue: originalValue,
      );
}
