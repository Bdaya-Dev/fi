// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values, cascade_invocations, lines_longer_than_80_chars
import 'package:fi_base/fi_base.dart';
import 'package:test/test.dart';

import 'models/name.dart';
import 'models/samples.dart';

void main() {
  group('FiState', () {
    group('Group', () {
      test('basic', () {
        final x = FiStateGroup<int, String, PhoneNumberErrors, String>.pure(
          const {
            12: FiState.pure(
              '',
              validator: FiValidator.constant(PhoneNumberErrors.required),
            ),
            5: FiState.dirty(
              'asd',
              originalValue: '',
              validator:
                  FiValidator.constant(PhoneNumberErrors.invalidCountryCode),
            ),
            3: FiState.dirty(
              '+2010012345678',
              originalValue: 'a',
            ),
          },
        );

        expect(x.errors(), hasLength(2));
        expect(
          x.displayErrors(),
          containsPair(5, PhoneNumberErrors.invalidCountryCode),
        );
        final aggregate = x.aggregateStates();
        expect(aggregate, x.value.values);
      });
      group('String', () {});
    });
    group('List', () {});
    group('Mixed', () {});
  });

  group('UserRegisterModel', () {
    final initialFieldsMatcher = allOf(hasLength(5));
    final initialAggregateStatesMatcher = allOf(hasLength(5));
    final initialAggregateErrorsMatcher = [
      isA<NameErrors>().having(
        (p0) => p0,
        'name',
        NameErrors.required,
      ),
      isA<FiLengthError>()
          .having((p0) => p0.length, 'length', isZero)
          .having((p0) => p0.minLength, 'minLength', 2)
          .having((p0) => p0.maxLength, 'maxLength', 5),
    ];
    final initialAggregateDisplayErrorsMatcher = allOf(hasLength(0));

    void expectInitial(UserRegisterModel model) {
      expect(model.fields, initialFieldsMatcher);
      expect(model.aggregateStates(), initialAggregateStatesMatcher);
      expect(
        model.aggregateErrors(),
        initialAggregateErrorsMatcher,
      );
      expect(
        model.aggregateDisplayErrors(),
        initialAggregateDisplayErrorsMatcher,
      );
    }

    test('initial', () {
      final model = UserRegisterModel();

      expectInitial(model);
    });

    test('assignments', () {
      final model = UserRegisterModel();
      model.addNewAddress();
      model.arbitrary = model.arbitrary.add(
        'something',
        FiState<dynamic, void>.pure(10),
      );
      final aggregateAfter = model.aggregateStates();
      expect(model.fields, hasLength(5));
      expect(
        aggregateAfter,
        hasLength(
          5 /*fields*/ +
              1 /*the added address*/ +
              2 /*nested fields in the added address*/ +
              1 /* arbitrary */,
        ),
      );

      final lengthErrorMatcher = isA<FiLengthError>()
          .having((p0) => p0.length, 'length', 1)
          .having((p0) => p0.minLength, 'minLength', 2)
          .having((p0) => p0.maxLength, 'maxLength', 5);

      expect(
        model.aggregateErrors(),
        [
          isA<NameErrors>().having(
            (p0) => p0,
            'name',
            NameErrors.required,
          ),
          lengthErrorMatcher,
          isA<FiGenericRequiredError<String?>>().having(
            (p0) => p0.value,
            'value',
            null,
          ),
        ],
      );
      expect(
        model.aggregateDisplayErrors(),
        contains(lengthErrorMatcher),
      );

      model.clearAddresses();
      model.arbitrary = model.arbitrary.clear();
      expectInitial(model);
    });
  });
}
