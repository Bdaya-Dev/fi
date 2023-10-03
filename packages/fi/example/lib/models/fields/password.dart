import 'package:fi_base/fi_base.dart';

abstract final class PasswordValidationError {
  const PasswordValidationError();
}

final class PasswordValidationErrorInvalid extends PasswordValidationError {
  const PasswordValidationErrorInvalid();

  @override
  String toString() {
    return '''Password must be at least 8 characters and contain at least one letter and number''';
  }
}

final class PasswordValidationErrorEmpty extends PasswordValidationError {
  const PasswordValidationErrorEmpty();

  @override
  String toString() {
    return 'Please enter a password';
  }
}

class PasswordValidator extends FiValidator<String?, PasswordValidationError> {
  const PasswordValidator();

  static final _passwordRegex =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validate(String? value) {
    if (value == null || value.isEmpty) {
      return const PasswordValidationErrorEmpty();
    } else if (!_passwordRegex.hasMatch(value)) {
      return const PasswordValidationErrorInvalid();
    }

    return null;
  }
}

class PasswordFieldState extends FiStateBase<String?, PasswordValidationError>
    with FiCopyWithMixin<String?, PasswordValidationError, PasswordFieldState> {
  const PasswordFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const PasswordFieldState.pure(super.value, {super.id}) : super.pure();
  const PasswordFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(String? value) => value;
  static String? valueFromJson(Object? src) => src as String?;

  factory PasswordFieldState.fromParsed(FiSerializedState parsed) =>
      PasswordFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory PasswordFieldState.fromJson(Map<String, dynamic> src) =>
      PasswordFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  FiValidator<String?, PasswordValidationError>? get validator =>
      const PasswordValidator();

  @override
  PasswordFieldState copyWithAll({
    required String id,
    required bool isPure,
    required String? value,
    required String? originalValue,
  }) {
    return PasswordFieldState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}
