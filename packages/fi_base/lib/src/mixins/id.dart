import 'dart:math';

final _cachedIds = Expando<String>();

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
final _rnd = Random();

/// gets a random string for use with id fields.
String fiGetRandomString([int length = 16]) => String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
      ),
    );

/// A mixin that wraps around an id.
mixin FiIdMixin {
  /// An id for the field.
  String get id => _cachedIds[this] ??= fiGetRandomString();
}
