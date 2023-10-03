import 'package:fi_base/fi_base.dart';

enum NameErrors {
  required,
  containsBad,
}

class NameValidator extends FiValidator<String, NameErrors> {
  const NameValidator({
    this.isRequired = true,
  });

  final bool isRequired;

  @override
  NameErrors? validate(String value) {
    if (value.isEmpty) {
      if (isRequired) {
        return NameErrors.required;
      }
    }
    if (value.contains('bad')) {
      return NameErrors.containsBad;
    }
    return null;
  }
}
