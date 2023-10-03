// ignore_for_file: avoid_redundant_argument_values, type_annotate_public_apis

import 'package:fi_base/fi_base.dart';

import 'address.dart';
import 'name.dart';

enum PhoneNumberErrors {
  required,
  invalidCountryCode,
  invalidLength,
}

typedef UserRegisterState = FiState<UserRegisterModel, void>;

///
class UserRegisterModel with FiAggregator {
  UserRegisterModel();

  var fullName = const FiState<String, NameErrors>.pure(
    '',
    validator: NameValidator(isRequired: true),
  );

  var firstName = const FiState<String, NameErrors>.pure(
    '',
    validator: NameValidator(isRequired: false),
  );

  var lastName = const FiState<String, NameErrors>.pure(
    '',
    validator: NameValidator(isRequired: false),
  );

  var addresses =
      const FiStateList<UserAddress, UserAddressError, FiLengthError>.pure(
    [],
    validator: FiListLengthValidator(
      minLength: 2,
      maxLength: 5,
    ),
  );

  void clearAddresses() {
    // this will change addresses to become pure again, since the new value
    // will be equal to the original value.
    addresses = addresses.clear();
  }

  void insertNewAddressAt(int index) {
    addresses = addresses.insertAt(
      index,
      UserAddressState.pure(
        UserAddress(),
        validator: const UserAddressValidator(),
      ),
    );
  }

  void addNewAddress() {
    addresses = addresses.add(
      UserAddressState.pure(
        UserAddress(),
        validator: const UserAddressValidator(),
      ),
    );
  }

  void removeAddressAt(int index) {
    addresses = addresses.removeAt(index);
  }

  void updateAddressAt(int index, UserAddress Function(UserAddress) func) {
    // addresses = addresses.updateAt(index, (oldItem) => ,);
    addresses.update(
      (oldValue) => oldValue.updateAt(
        index,
        (old) => old.update(func),
      ),
    );
  }

  var arbitrary = const FiStateGroupStringDynamic<void>.pure({});

  @override
  Iterable<FiState<dynamic, dynamic>> get fields => [
        fullName,
        firstName,
        lastName,
        addresses,
        arbitrary,
      ];
}
