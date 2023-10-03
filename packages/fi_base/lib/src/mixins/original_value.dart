import 'package:fi_base/fi_base.dart';

/// Mixin that wraps around the [originalValue].
mixin FiOriginalValueMixin<T> {
  /// The original value.
  ///
  /// if this field has `isDirty == true`, this is the original value,
  /// that should be assigned to make this field pure again.
  ///
  /// but if `isPure == true`, this is the same as
  /// the [FiValueMixin.value].
  T get originalValue;
}
