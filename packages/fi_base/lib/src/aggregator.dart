import 'package:fi_base/fi_base.dart';

import 'mixins/state.dart';

/// Mixin that is responsible for getting the fields an arbitrary class defines.
mixin FiAggregator {
  /// Gets the fields that this class directly defines.
  Iterable<FiStateMixin<dynamic, dynamic>> get fields;
}

///
extension FiAggregatorExt on FiAggregator {
  void _processValue(dynamic value, List<FiStateMixin<dynamic, dynamic>> res) {
    if (value is FiStateMixin) {
      res.add(value);
      _processValue(value, res);
    } else if (value is Iterable<FiStateMixin>) {
      res.addAll(value);
      for (final element in value) {
        _processValue(element.value, res);
      }
    } else if (value is Map<dynamic, FiStateMixin>) {
      res.addAll(value.values);
      for (final element in value.values) {
        _processValue(element.value, res);
      }
    }

    if (value is FiAggregator) {
      res.addAll(value.aggregateStates());
    } else if (value is Iterable<FiAggregator>) {
      for (final element in value) {
        res.addAll(element.aggregateStates());
      }
    } else if (value is Map<dynamic, FiAggregator>) {
      for (final element in value.values) {
        res.addAll(element.aggregateStates());
      }
    }
  }

  /// Does a deep aggregation of all nested states.
  List<FiStateMixin<dynamic, dynamic>> aggregateStates({
    bool includeSelf = false,
  }) {
    // start by adding all the direct fields
    final res = List<FiStateMixin<dynamic, dynamic>>.of(fields);
    // add self.
    if (includeSelf) {
      if (this is FiStateMixin) {
        res.add(this as FiStateMixin);
      }
    }

    for (final element in fields) {
      _processValue(element.value, res);
    }
    return res;
  }

  /// Does a deep aggregation of all nested states, and maps them to
  /// their relative errors.
  List<Object> aggregateErrors() {
    return aggregateStates()
        .map((e) => e.error)
        .where((element) => element != null)
        .cast<Object>()
        .toList();
  }

  /// Does a deep aggregation of all nested states, and maps them to
  /// their relative display errors.
  List<Object> aggregateDisplayErrors() {
    return aggregateStates()
        .map((e) => e.displayError)
        .where((element) => element != null)
        .cast<Object>()
        .toList();
  }

  /// Checks if every sub element is pure.
  bool aggregateIsPure() {
    return aggregateStates().every((element) => element.isPure);
  }
}
