import 'package:fi_base/fi_base.dart';

/// The default serialization function for any object.
/// simply returns the object itself.
Object? fiDefaultSerializationFunction(Object? src) => src;

/// id
const kId = 'id';

/// originalValue
const kOriginalValue = 'originalValue';

/// value
const kValue = 'value';

/// isPure
const kIsPure = 'isPure';

/// Mixin that wraps an equality function.
mixin FiSerializableMixin<T> on FiValueMixin<T> {
  ///
  Object? Function(T src)? get getValueToJson;
}

/// Represents an arbitrary serialized state.
class FiSerializedState
    with
        FiIdMixin,
        FiValueMixin<Object?>,
        FiOriginalValueMixin<Object?>,
        FiIsPureMixin {
  FiSerializedState._({
    required this.id,
    required this.isPure,
    required this.value,
    required this.originalValue,
    required this.source,
  });

  /// Creates an FiSerializedState from json.
  factory FiSerializedState.fromJson(Map<String, dynamic> src) {
    return FiSerializedState._(
      source: src,
      id: src[kId] as String,
      isPure: src[kIsPure] as bool,
      originalValue: src[kOriginalValue],
      value: src[kValue],
    );
  }

  @override
  final String id;
  @override
  final bool isPure;
  @override
  final Object? value;
  @override
  final Object? originalValue;

  /// The source json.
  final Map<String, dynamic> source;
}
