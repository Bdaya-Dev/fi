/// Mixin that wraps around the [isPure] property.
mixin FiIsPureMixin {
  /// true if this value is the pure (initial) value.
  bool get isPure;
}

///
extension FiIsPureMixinExtensions on FiIsPureMixin {
  /// the opposite of [isPure].
  bool get isDirty => !isPure;
}
