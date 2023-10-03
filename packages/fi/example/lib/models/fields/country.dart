import 'package:fi_base/fi_base.dart';

enum CountriesEnum {
  a,
  b,
  c,
}

const countriesPostalCodeMap = <CountriesEnum, String>{
  CountriesEnum.a: '123',
  CountriesEnum.b: '456',
  CountriesEnum.c: '321',
};

class CountryFieldState extends FiStateBase<CountriesEnum?, FiRequiredError>
    with FiCopyWithMixin<CountriesEnum?, FiRequiredError, CountryFieldState> {
  const CountryFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const CountryFieldState.pure(super.value, {super.id}) : super.pure();
  const CountryFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(CountriesEnum? value) => value?.name;
  static CountriesEnum? valueFromJson(Object? src) {
    final srcStr = src as String?;
    if (srcStr == null) {
      return null;
    }
    return CountriesEnum.values.byName(srcStr);
  }

  factory CountryFieldState.fromParsed(FiSerializedState parsed) =>
      CountryFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory CountryFieldState.fromJson(Map<String, dynamic> src) =>
      CountryFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  FiValidator<CountriesEnum?, FiRequiredError>? get validator =>
      const FiRequiredValidator();

  @override
  CountryFieldState copyWithAll({
    required String id,
    required bool isPure,
    required CountriesEnum? value,
    required CountriesEnum? originalValue,
  }) {
    return CountryFieldState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}
