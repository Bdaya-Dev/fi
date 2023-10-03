import 'package:fi_base/fi_base.dart';

///
class FiLengthError {
  ///
  const FiLengthError({
    required this.length,
    this.maxLength,
    this.minLength,
  });

  ///
  final int length;

  ///
  final int? maxLength;

  ///
  final int? minLength;

  @override
  String toString() {
    final sb = StringBuffer('Field must have');
    if (minLength != null) {
      sb.write(' at least $minLength items,');
    }
    if (maxLength != null) {
      sb.write(' at most $maxLength items,');
    }
    sb.write(' current length is: $length');
    return sb.toString();
  }
}

///
class FiListLengthValidator<TIterable extends Iterable<dynamic>>
    extends FiValidator<TIterable, FiLengthError> {
  ///
  const FiListLengthValidator({
    this.minLength,
    this.maxLength,
  });

  ///
  final int? minLength;

  ///
  final int? maxLength;

  @override
  FiLengthError? validate(TIterable value) {
    final count = value.length;
    final minLength = this.minLength;
    final maxLength = this.maxLength;
    if (minLength != null) {
      if (count < minLength) {
        return FiLengthError(
          length: count,
          maxLength: maxLength,
          minLength: minLength,
        );
      }
    }
    if (maxLength != null) {
      if (count > maxLength) {
        return FiLengthError(
          length: count,
          maxLength: maxLength,
          minLength: minLength,
        );
      }
    }
    return null;
  }
}

///
class FiMapLengthValidator<TMap extends Map<dynamic, dynamic>>
    extends FiValidator<TMap, FiLengthError> {
  ///
  const FiMapLengthValidator({
    this.minLength,
    this.maxLength,
  });

  ///
  final int? minLength;

  ///
  final int? maxLength;

  @override
  FiLengthError? validate(TMap value) {
    final count = value.length;
    final minLength = this.minLength;
    final maxLength = this.maxLength;
    if (minLength != null) {
      if (count < minLength) {
        return FiLengthError(
          length: count,
          maxLength: maxLength,
          minLength: minLength,
        );
      }
    }
    if (maxLength != null) {
      if (count > maxLength) {
        return FiLengthError(
          length: count,
          maxLength: maxLength,
          minLength: minLength,
        );
      }
    }
    return null;
  }
}
