/// {@template Fi_input_validator}
/// A class that wraps a validator function.
/// {@endtemplate}
abstract class FiValidator<T, E> {
  /// {@macro Fi_input}
  const FiValidator();

  /// Creates a [FiValidator] that always returns no error.
  const factory FiValidator.none() = _FiInputValidatorConstant<T, E>.none;

  /// Creates a [FiValidator] from a function.
  const factory FiValidator.function(
    E? Function(T value) function,
  ) = _FiInputValidatorFunction<T, E>;

  /// Creates a [FiValidator] that always returns a specific error.
  const factory FiValidator.constant(E? error) =
      _FiInputValidatorConstant<T, E>;

  /// A function that must return a validation error if the provided
  /// [value] is invalid and `null` otherwise.
  E? validate(T value);

  /// A convenience method for calling [validate].
  E? call(T value) {
    return validate(value);
  }
}

class _FiInputValidatorFunction<T, E> extends FiValidator<T, E> {
  const _FiInputValidatorFunction(this.validatorFunction);
  final E? Function(T value) validatorFunction;
  @override
  E? validate(T value) {
    return validatorFunction(value);
  }
}

class _FiInputValidatorConstant<T, E> extends FiValidator<T, E> {
  const _FiInputValidatorConstant(this.error);
  const _FiInputValidatorConstant.none() : error = null;

  final E? error;

  @override
  E? validate(T value) => error;
}

// /// {@template FiInputGroupDelegateValidator}
// /// A validator for Delegated [FiStateGroup]s,
// /// which delegates the validation to its children.
// /// {@endtemplate}
// class FiStateGroupDelegatingValidator<TKey, TItem, EItem>
//     extends FiValidator<Map<TKey, FiState<TItem, EItem>>, Map<TKey, EItem>> {
//   /// {@macro FiInputGroupDelegateValidator}
//   const FiStateGroupDelegatingValidator();
//   @override
//   Map<TKey, EItem>? validate(Map<TKey, FiState<TItem, EItem>> value) {
//     final mapped = Map.fromEntries(
//       value.entries
//           .map(
//             (entry) => MapEntry(
//               entry.key,
//               entry.value.error,
//             ),
//           )
//           .where((element) => element.value != null),
//     ).cast<TKey, EItem>();
//     if (mapped.isEmpty) {
//       return null;
//     }
//     return mapped;
//   }
// }

// /// {@template FiInputGroupDelegateValidator}
// /// A validator for Delegated [FiStateGroup]s,
// /// which delegates the validation to its children.
// /// {@endtemplate}
// class FiStateListDelegatingValidator<TItem, EItem>
//     extends FiValidator<List<FiState<TItem, EItem>>, List<EItem>> {
//   /// {@macro FiInputGroupDelegateValidator}
//   const FiStateListDelegatingValidator();
//   @override
//   List<EItem>? validate(List<FiState<TItem, EItem>> value) {
//     final mapped = value
//         .map(
//           (entry) => entry.error,
//         )
//         .whereType<EItem>()
//         .toList();
//     if (mapped.isEmpty) {
//       return null;
//     }
//     return mapped;
//   }
// }
