import 'package:fi_base/fi_base.dart';

/// Mixin on [FiErrorMixin] and [FiIsPureMixin], for conditional
/// display of errors.
mixin FiDisplayErrorMixin<E> on FiErrorMixin<E>, FiIsPureMixin {
  /// The error only if the current field is dirty.
  E? get displayError => isPure ? null : error;
}

///
extension FiStateListValueDisplayErrorExtensions<EItem>
    on FiValueMixin<Iterable<FiDisplayErrorMixin<EItem>>> {
  /// Returns the fields, each mapped to its [FiDisplayErrorMixin.displayError].
  ///
  /// Valid entries are removed.
  List<EItem> displayErrors() {
    return value.map((e) => e.displayError).whereType<EItem>().toList();
  }
}

///
extension FiStateListValueExtensions<TItem>
    on FiValueMixin<Iterable<FiValueMixin<TItem>>> {
  /// Returns a map of the fields, each mapped to its own value.
  ///
  /// if [validOnly] is true (default), it will remove invalid entries.
  List<TItem> values({
    bool validOnly = true,
  }) {
    var src = value;
    if (validOnly) {
      src = src.where(
        (element) => switch (element) {
          FiErrorMixin(:final error) => error == null,
          _ => true
        },
      );
    }
    return src.map((entry) => entry.value).toList();
  }
}

///
extension FiStateGroupErrorExtensions<TKey, EItem>
    on FiValueMixin<Map<TKey, FiErrorMixin<EItem>>> {
  /// Returns a map of the fields, each mapped to its
  /// [FiErrorMixin.error].
  ///
  /// Fields with no errors are omitted.
  Map<TKey, EItem> errors() {
    return Map.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key, e.value.error))
          .where((element) => element.value != null),
    ).cast<TKey, EItem>();
  }
}

///
extension FiStateGroupValueDisplayErrorExtensions<TKey, EItem>
    on FiValueMixin<Map<TKey, FiDisplayErrorMixin<EItem>>> {
  /// Returns a map of the fields, each mapped to its
  /// [FiDisplayErrorMixin.displayError].
  ///
  /// Fields with no display errors are omitted.
  Map<TKey, EItem> displayErrors() {
    return Map.fromEntries(
      value.entries
          .map((e) => MapEntry(e.key, e.value.displayError))
          .where((element) => element.value != null),
    ).cast<TKey, EItem>();
  }
}

///
extension FiStateGroupValueExtensions<TKey, TItem,
    Z extends FiValueMixin<TItem>> on FiValueMixin<Map<TKey, Z>> {
  /// Returns a map of the fields, each mapped to its own value.
  ///
  /// if [validOnly] is true (default), it will remove invalid entries.
  Map<TKey, TItem> values({
    bool validOnly = true,
  }) {
    var src = value.entries;
    if (validOnly) {
      src = src.where((element) {
        return switch (element.value) {
          FiErrorMixin(:final error) => error == null,
          _ => true
        };
      });
    }
    return Map.fromEntries(
      src.map((entry) => MapEntry(entry.key, entry.value.value)),
    );
  }
}
