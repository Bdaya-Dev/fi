// ignore_for_file: type_annotate_public_apis

import 'package:fi_base/fi_base.dart';

class UserAddressError {}

typedef UserAddressState = FiState<UserAddress, UserAddressError>;

class UserAddress with FiAggregator {
  UserAddress();

  var fullAddress = const FiState<String?, FiRequiredError>.pure(
    null,
    validator: FiRequiredValidator(),
  );

  var city = const FiState<String?, void>.pure(null);

  @override
  Iterable<FiStateMixin<dynamic, dynamic>> get fields sync* {
    yield fullAddress;
    yield city;
  }
}

class UserAddressValidator extends FiValidator<UserAddress, UserAddressError> {
  const UserAddressValidator();

  @override
  UserAddressError? validate(UserAddress value) {
    return null;
  }
}
