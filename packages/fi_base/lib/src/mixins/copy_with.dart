import 'package:fi_base/fi_base.dart';

/// contains helpers for copying a state.
mixin FiCopyWithMixin<T, E, TState extends FiCopyWithMixin<T, E, TState>>
    on FiValueMixin<T>, FiIsPureMixin, FiIdMixin, FiOriginalValueMixin<T> {
  /// Creates a new state that replaces the [id], [isPure], [value]
  /// and [originalValue] parameters.
  TState copyWithAll({
    required String id,
    required bool isPure,
    required T value,
    required T originalValue,
  });

  /// Copies the field state and optionally replaces its [id] or [isPure]
  /// parameters.
  ///
  /// see also:
  /// - [copyWithValue]
  /// - [copyWithOriginalValue]
  TState copyWith({
    bool? isPure,
    String? id,
  }) =>
      copyWithAll(
        id: id ?? this.id,
        isPure: isPure ?? this.isPure,
        value: value,
        originalValue: originalValue,
      );

  ///
  TState copyWithOriginalValue(T originalValue) => copyWithAll(
        id: id,
        isPure: isPure,
        value: value,
        originalValue: originalValue,
      );

  ///
  TState copyWithValue(T originalValue) => copyWithAll(
        id: id,
        isPure: isPure,
        value: value,
        originalValue: originalValue,
      );

  /// creates a new state, with its value set to the current [originalValue].
  /// and [isPure] set to true.
  TState reset() {
    return copyWithAll(
      isPure: true,
      originalValue: originalValue,
      value: originalValue,
      id: id,
    );
  }

  /// creates a new state, with the following changes:
  /// - first [newValue] is compared against [originalValue]; if they
  /// are different, [FiState.dirty] is called, and if they are the same
  /// (according to [FiEquatableMixin.getValueEquals]), [FiState.pure] is
  /// called.
  ///
  /// NOTE: setting [FiEquatableMixin.getValueEquals] = `null` always assumes
  /// the two values
  /// are different.
  TState assign(T newValue) {
    if (this case FiEquatableMixin(:final getValueEquals)) {
      if (getValueEquals?.call(newValue, originalValue) ?? false) {
        return copyWithAll(
          id: id,
          isPure: true,
          value: newValue,
          originalValue: originalValue,
        );
      }
    }

    return copyWithAll(
      id: id,
      isPure: false,
      value: newValue,
      originalValue: originalValue,
    );
  }

  /// An easier way for calling [assign] which takes a function from the user
  /// and passes the current value, the user should return the new value.
  TState update(T Function(T oldValue) func) => assign(func(value));

  /// Creates a new pure state, with its [originalValue] set to [value].
  TState currentAsPure() => copyWithAll(
        id: id,
        isPure: true,
        value: value,
        originalValue: value,
      );
}

///
extension FiStateSetExtensions<Z, E,
        TState extends FiCopyWithMixin<Set<Z>, E, TState>>
    on FiCopyWithMixin<Set<Z>, E, TState> {
  ///
  TState add(Z element) {
    return update((value) => value.toSet()..add(element));
  }

  ///
  TState addAll(Iterable<Z> element) {
    return update((value) => value.toSet()..addAll(element));
  }

  ///
  TState remove(Z element) {
    return update((value) => value.toSet()..remove(element));
  }

  ///
  TState clear() {
    return update((value) => {});
  }
}

///
extension FiStateMapExtensions<ZValue, ZKey, E,
        TState extends FiCopyWithMixin<Map<ZKey, ZValue>, E, TState>>
    on FiCopyWithMixin<Map<ZKey, ZValue>, E, TState> {
  ///
  TState add(ZKey key, ZValue value) {
    return update(
      (old) => {...old, key: value},
    );
  }

  ///
  TState addAll(Map<ZKey, ZValue> other) {
    return update((old) => {...old, ...other});
  }

  ///
  TState remove(ZKey key) {
    return update((old) => {...old}..remove(key));
  }

  ///
  TState clear() {
    return update((_) => {});
  }
}

///
extension FiStateOfListOfStateExtensions<
        TItem,
        EItem,
        E,
        TSubState extends FiCopyWithMixin<TItem, EItem, TSubState>,
        TState extends FiCopyWithMixin<List<TSubState>, E, TState>>
    on FiCopyWithMixin<List<TSubState>, E, TState> {
  /// this has a bug where TItem is not inferred https://github.com/dart-lang/sdk/issues/53671
  // TState updateAt(
  //   int index,
  //   TItem Function(TItem oldItem) func,
  // ) =>
  //     update(
  //       (value) {
  //         final res = value.toList();
  //         final old = res[index];
  //         res[index] = old.update(func);
  //         return res;
  //       },
  //     );
}

/// Extension on lists of states.
extension ListExt<T extends FiCopyWithMixin<dynamic, dynamic, T>> on List<T> {
  /// Creates a new list, with the state updated at a specific index.
  List<T> updateAt(int index, T Function(T old) func, {bool growable = false}) {
    final old = this[index];
    final n = func(old);
    final nList = toList(growable: growable);
    nList[index] = n;
    return nList;
  }
}

/// this has a bug where TItem is not inferred https://github.com/dart-lang/sdk/issues/53671
// extension FiListOfStateExtensions<TItem, EItem, E,
//         TSubState extends FiCopyWithMixin<TItem, EItem, TSubState>>
//     on List<TSubState> {
// List<TSubState> updateAt(
//   int index,
//   TItem Function(TItem oldItem) func,
// ) {
//   final res = toList();
//   final old = res[index];
//   res[index] = old.update(func);
//   return res;
// }

// List<TSubState> assignAt(
//   int index,
//   TItem newValue,
// ) {
//   final res = toList();
//   final old = res[index];
//   res[index] = old.assign(newValue);
//   return res;
// }
// }

///
extension FiStateOfListExtensions<Z, E,
        TState extends FiCopyWithMixin<List<Z>, E, TState>>
    on FiCopyWithMixin<List<Z>, E, TState> {
  ///
  TState add(Z element) {
    return update(
      (value) => value.toList()..add(element),
    );
  }

  ///
  TState addAll(Iterable<Z> element) {
    return update((value) => value.toList()..addAll(element));
  }

  ///
  TState remove(Z element) {
    return update((value) => value.toList()..remove(element));
  }

  ///
  TState clear() {
    return update((_) => []);
  }

  /// insert a new element at a specific index.
  TState insertAt(int index, Z element) {
    return update((value) => value.toList()..insert(index, element));
  }

  /// insert a new element at a specific index.
  TState removeAt(int index) {
    return update((value) => value.toList()..removeAt(index));
  }

  /// Gets an item in the list.
  Z operator [](int index) => value[index];

  /// insert a new element at a specific index.
  TState replaceAt(int index, Z element) {
    return update(
      (value) {
        final res = value.toList();
        res[index] = element;
        return res;
      },
    );
  }
}
