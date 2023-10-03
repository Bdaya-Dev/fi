import 'package:example/models/fields/address.dart';
import 'package:fi_base/fi_base.dart';

class UserAddressFieldStateList
    extends FiStateBase<List<UserAddressFieldState>, FiLengthError>
    with
        FiCopyWithMixin<List<UserAddressFieldState>, FiLengthError,
            UserAddressFieldStateList> {
  const UserAddressFieldStateList({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const UserAddressFieldStateList.pure(super.value, {super.id}) : super.pure();
  const UserAddressFieldStateList.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(List<UserAddressFieldState> value) =>
      value.map((e) => e.toJson()).toList();
  static List<UserAddressFieldState> valueFromJson(Object? src) => (src as List)
      .cast<Map<String, dynamic>>()
      .map(UserAddressFieldState.fromJson)
      .toList();

  factory UserAddressFieldStateList.fromParsed(FiSerializedState parsed) =>
      UserAddressFieldStateList(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory UserAddressFieldStateList.fromJson(Map<String, dynamic> src) =>
      UserAddressFieldStateList.fromParsed(FiSerializedState.fromJson(src));

  @override
  FiValidator<List<UserAddressFieldState>, FiLengthError>? get validator =>
      const FiListLengthValidator(minLength: 1);

  @override
  UserAddressFieldStateList copyWithAll({
    required String id,
    required bool isPure,
    required List<UserAddressFieldState> value,
    required List<UserAddressFieldState> originalValue,
  }) {
    return UserAddressFieldStateList(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}
