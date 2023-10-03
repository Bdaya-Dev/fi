// cspell: disable
import 'package:json_annotation/json_annotation.dart';
import 'fields/_exports.dart';
import 'package:fi_base/fi_base.dart';

part 'register_user.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
  explicitToJson: true,
)
class RegisterUserModel with FiAggregator {
  static const kemail = 'email';
  static const defaultEmail = EmailFieldState.pure(
    null,
    id: kemail,
  );

  static const kpassword = 'password';
  static const defaultPassword = PasswordFieldState.pure(
    null,
    id: kpassword,
  );

  static const kphoneNumbers = 'phoneNumbers';
  static const defaultPhoneNumbers = PhoneFieldStateList.pure(
    [],
    id: kphoneNumbers,
  );

  static const kaddresses = 'addresses';
  static const defaultAddresses = UserAddressFieldStateList.pure(
    [],
    id: kaddresses,
  );

  static UserAddressFieldState defaultAddress() => UserAddressFieldState.pure(
        UserAddress(),
        id: fiGetRandomString(),
      );

  static PhoneFieldState defaultPhoneNumber() => PhoneFieldState.pure(
        null,
        id: fiGetRandomString(),
      );

  RegisterUserModel({
    EmailFieldState? email,
    PasswordFieldState? password,
    PhoneFieldStateList? phoneNumbers,
    UserAddressFieldStateList? addresses,
    this.status = FiSubmissionStatus.initial,
  })  : email = email ?? defaultEmail,
        password = password ?? defaultPassword,
        addresses = addresses ?? defaultAddresses,
        phoneNumbers = phoneNumbers ?? defaultPhoneNumbers;

  @JsonKey(name: kemail)
  EmailFieldState email;
  @JsonKey(name: kpassword)
  PasswordFieldState password;
  @JsonKey(name: kphoneNumbers)
  PhoneFieldStateList phoneNumbers;
  @JsonKey(name: kaddresses)
  UserAddressFieldStateList addresses;

  @JsonKey(includeToJson: false, includeFromJson: false)
  FiSubmissionStatus status;

  @override
  Iterable<FiStateMixin> get fields => [
        email,
        password,
        phoneNumbers,
        addresses,
      ];

  Map<String, dynamic> toJson() => _$RegisterUserModelToJson(this);

  factory RegisterUserModel.fromJson(Map<String, dynamic> src) =>
      _$RegisterUserModelFromJson(src);

  void saveCurrentAsPure() {
    email = email.currentAsPure();
    password = password.currentAsPure();
    phoneNumbers = phoneNumbers.currentAsPure();
    addresses = addresses.currentAsPure();
  }
}
