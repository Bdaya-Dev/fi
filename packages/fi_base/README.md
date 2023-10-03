# Form Input (`fi`)

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Yet another package used to represent forms, this one was inspired by [formz](https://pub.dev/packages/formz), but it's full of features that you will love.

## Introduction

One of the most important aspects of building a frontend is handling user input, and when you have a page with lots of user inputs, you get a `Form`.

### What should a form do ?

A perfect form should have the following features:
- Reactive
  - Change the form value based on changes to the UI elements.
  - Change the UI elements based on changes to the form value.
- `Validate` form value against business rules (both `sync` or `async`) and output `errors`.
- `Serialize`/`Deserialize` form value to/from an arbitrary value (including `encryption` for sensitive data).
- Distinguish between pure and dirty states (a.k.a. `reset`).
  - This also requires that values are comparable and hashable.
- `add`/`remove` fields on the fly.
- `show` or `hide` certain fields based on the user's input.
- `Nesting` an arbitrary amount of levels, and `aggregating` the fields.
- Statically typed; the less dynamic you have, the better.
- Easily testable and mockable.
- Good UX
  - Fast.
  - Keyboard-navigable.
  - should have clear visual cues for all input fields.
  - Responsive.
  - Provide feedback.
  - Translated into multiple languages.
  - Accessibility.

### We help you build `The Perfect Form`™!

by using `package:fi` and its sub packages, you can implement all the features that make a perfect form.

## package:fi_base

This package is the base class that is used by all other `fi*` packages.

It's written in pure dart, has minimal dependencies, and defines all the necessary classes to represent an arbitrary form.

all classes defined by this library are prefixed with `Fi*`.

### FiState

The main class defined here is `FiState<T, TError>` which represents an immutable state of a form field that is able to store a `value` of type `T`, and an `error` of type `TError`.

You can also use `FiStateMixin<T, TError>` if you want to have your own concrete implementation with your own rules.

### FiValidator

`FiValidator<T, TError>` is a simple abstract class that contains a single method:
```dart
E? validate(T value);
```
It takes a value and outputs an error.

Returning `null` means there are no errors.

### Example usage

```dart
//declaration.
var fullAddress = const FiState<String?, FiRequiredError>.pure(
    null,
    validator: FiRequiredValidator(),
);
assert(fullAddress.isPure == true);
assert(fullAddress.value == null);
assert(fullAddress.error is FiRequiredError);

//mutation.
fullAddress = fullAddress.assign('my new address').
assert(fullAddress.isDirty == true);
assert(fullAddress.value == 'my new address');
assert(fullAddress.error == null);
```

### 

## Installation 💻

Install via `dart pub add`:

```sh
dart pub add fi_base
```

---

## Continuous Integration 🤖

this package comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
