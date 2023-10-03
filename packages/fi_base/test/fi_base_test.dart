// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
import 'package:fi_base/fi_base.dart';
import 'package:test/test.dart';

void main() {
  group('FiState', () {
    group('pure', () {
      test('no error', () {
        const value = 'hi';
        final input = FiState<String, String>.pure(value);
        expect(input.value, value);
        expect(input.isPure, true);
        expect(input.isValid, true);
        expect(input.error, isNull);
        expect(input.displayError, isNull);
      });

      test('with error', () {
        const value = '';
        const emptyError = 'empty';
        final input = FiState<String, String>.pure(
          value,
          validator: FiValidator.constant(emptyError),
        );
        expect(input.value, value);
        expect(input.isPure, true);
        expect(input.isValid, false);
        expect(input.error, emptyError);
        expect(input.displayError, isNull);
      });
    });
    group('dirty', () {
      test('no error', () {
        const value = 'hi';
        final input = FiState<String, String>.dirty(
          value,
          originalValue: '',
        );
        expect(input.value, value);
        expect(input.isPure, isFalse);
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
        expect(input.displayError, isNull);
      });
      test('with error', () {
        const value = '';
        const emptyError = 'empty';
        final input = FiState<String, String>.dirty(
          value,
          originalValue: 'hello',
          validator: FiValidator.constant(emptyError),
        );
        expect(input.value, value);
        expect(input.isPure, isFalse);
        expect(input.isValid, isFalse);
        expect(input.error, emptyError);
        expect(input.displayError, emptyError);
      });
    });
  });
}
