import 'package:example/models/fields/country.dart';
import 'package:example/models/fields/text.dart';
import 'package:fi_base/fi_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

// enum UserAddressError {
//   countryPostalCodeMismatch,
// }

class UserAddressError {
  const UserAddressError();
}

class UserAddressErrorCountryPostalCodeMismatch extends UserAddressError {
  final CountriesEnum country;
  final String postalCode;
  final String validPostalCodePrefix;

  const UserAddressErrorCountryPostalCodeMismatch({
    required this.country,
    required this.postalCode,
    required this.validPostalCodePrefix,
  });

  @override
  String toString() {
    return 'The country (${country.name}) MUST have postal codes starting with '
        '($validPostalCodePrefix), input was: $postalCode';
  }
}

class UserAddressValidator extends FiValidator<UserAddress, UserAddressError> {
  const UserAddressValidator();
  @override
  UserAddressError? validate(UserAddress value) {
    final postalCode = value.postalCode.value;
    final country = value.country.value;
    if (postalCode == null || country == null || postalCode.isEmpty) {
      return null;
    }
    final validPostalCodePrefix = countriesPostalCodeMap[country];
    if (validPostalCodePrefix == null) {
      return null;
    }
    if (!postalCode.startsWith(validPostalCodePrefix)) {
      return UserAddressErrorCountryPostalCodeMismatch(
        country: country,
        postalCode: postalCode,
        validPostalCodePrefix: validPostalCodePrefix,
      );
    }
    return null;
  }
}

class UserAddressFieldState extends FiStateBase<UserAddress, UserAddressError>
    with FiCopyWithMixin<UserAddress, UserAddressError, UserAddressFieldState> {
  const UserAddressFieldState({
    required super.id,
    required super.value,
    required super.isPure,
    required super.originalValue,
  });
  const UserAddressFieldState.pure(super.value, {super.id}) : super.pure();
  const UserAddressFieldState.dirty(
    super.value, {
    required super.originalValue,
    super.id,
  }) : super.dirty();

  @override
  Object? valueToJson(UserAddress value) => value.toJson();
  static UserAddress valueFromJson(Object? src) =>
      UserAddress.fromJson(src as Map<String, dynamic>);

  factory UserAddressFieldState.fromParsed(FiSerializedState parsed) =>
      UserAddressFieldState(
        id: parsed.id,
        isPure: parsed.isPure,
        originalValue: valueFromJson(parsed.originalValue),
        value: valueFromJson(parsed.value),
      );

  factory UserAddressFieldState.fromJson(Map<String, dynamic> src) =>
      UserAddressFieldState.fromParsed(FiSerializedState.fromJson(src));

  @override
  bool valueEquals(UserAddress v1, UserAddress v2) {
    return v1 == v2;
  }

  @override
  int valueHashCode(UserAddress v) {
    return v.hashCode;
  }

  @override
  FiValidator<UserAddress, UserAddressError>? get validator =>
      const UserAddressValidator();

  @override
  UserAddressFieldState copyWithAll({
    required String id,
    required bool isPure,
    required UserAddress value,
    required UserAddress originalValue,
  }) {
    return UserAddressFieldState(
      id: id,
      value: value,
      isPure: isPure,
      originalValue: originalValue,
    );
  }
}

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  explicitToJson: true,
)
class UserAddress with FiAggregator {
  static const kCountry = 'country';
  static const defaultCountry = CountryFieldState.pure(
    null,
    id: kCountry,
  );

  static const kPostalCode = 'postalCode';
  static const defaultPostalCode = StringFieldState.pure(
    null,
    id: kPostalCode,
  );

  static const kFullAddress = 'fullAddress';
  static const defaultFullAddress = RequiredStringFieldState.pure(
    null,
    id: kFullAddress,
  );

  UserAddress({
    CountryFieldState? country,
    RequiredStringFieldState? fullAddress,
    StringFieldState? postalCode,
  })  : country = country ?? defaultCountry,
        fullAddress = fullAddress ?? defaultFullAddress,
        postalCode = postalCode ?? defaultPostalCode;

  @JsonKey(name: kCountry)
  CountryFieldState country;
  @JsonKey(name: kFullAddress)
  RequiredStringFieldState fullAddress;
  @JsonKey(name: kPostalCode)
  StringFieldState postalCode;

  Map<String, dynamic> toJson() {
    return _$UserAddressToJson(this);
  }

  factory UserAddress.fromJson(Map<String, dynamic> src) {
    return _$UserAddressFromJson(src);
  }

  @override
  Iterable<FiStateMixin> get fields => [country, fullAddress, postalCode];
}
