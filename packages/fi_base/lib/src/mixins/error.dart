import 'value.dart';

/// Mixin that wraps around the error.
mixin FiErrorMixin<E> {
  /// The current error.
  ///
  /// `null` means there is no error, and the form is valid.
  E? get error;
}

/// Extensions on [FiErrorWrapperMixinExt].
extension FiErrorWrapperMixinExt<E> on FiErrorMixin<E> {
  /// whether there is an [error] or not.
  bool get isValid => error == null;

  /// the opposite of [isValid].
  bool get isNotValid => !isValid;
}

///
extension FiStateListErrorExtensions<EItem>
    on FiValueMixin<Iterable<FiErrorMixin<EItem>>> {
  /// Return the fields, each mapped to its [FiErrorMixin.error].
  ///
  /// Valid entries are removed.
  List<EItem> errors() {
    return value.map((e) => e.error).whereType<EItem>().toList();
  }
}
