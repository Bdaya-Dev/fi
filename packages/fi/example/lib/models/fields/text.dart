import 'package:fi_base/fi_base.dart';

class RequiredStringFieldState extends FiStateBase<String?, FiRequiredError>
    with FiCopyWithMixin<String?, FiRequiredError, RequiredStringFieldState> {
  const RequiredStringFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const RequiredStringFieldState.pure(super.value, {super.id}) : super.pure();
  const RequiredStringFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(String? value) => value;
  static String? valueFromJson(Object? src) => src as String?;

  factory RequiredStringFieldState.fromParsed(FiSerializedState parsed) =>
      RequiredStringFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory RequiredStringFieldState.fromJson(Map<String, dynamic> src) =>
      RequiredStringFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  FiValidator<String?, FiRequiredError>? get validator =>
      const FiRequiredValidator();

  @override
  RequiredStringFieldState copyWithAll({
    required String id,
    required bool isPure,
    required String? value,
    required String? originalValue,
  }) {
    return RequiredStringFieldState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}

typedef StringFieldState = FiState<String?, dynamic>;
