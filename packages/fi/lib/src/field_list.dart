import 'package:fi_base/fi_base.dart';
import 'package:flutter/widgets.dart';

///
typedef FiGenericWidgetBuilder<TItem> = Iterable<Widget> Function(
  BuildContext context,
  List<TItem> allItems,
  void Function(List<TItem> newValue) change,
  String? errorText,
);

///
class FiFormFieldList<TItem> extends FormField<List<TItem>> {
  ///
  FiFormFieldList({
    required FiStateMixin<List<TItem>, FiLengthError> state,
    required Widget Function(
      BuildContext context,
      int index,
      TItem item,
      List<TItem> allItems,
      void Function(List<TItem> newValue) change,
      String? errorText,
    ) itemBuilder,
    Key? key,
    super.autovalidateMode,
    super.enabled,
    super.onSaved,
    FormFieldValidator<List<TItem>>? validator,
    Iterable<Widget> Function(BuildContext context, String error)? errorBuilder,
    FiGenericWidgetBuilder<TItem>? footerBuilder,
    FiGenericWidgetBuilder<TItem>? headerBuilder,
    void Function(List<TItem> value)? onChanged,
    Widget Function(BuildContext context, List<Widget> children)?
        containerBuilder,
  }) : super(
          key: key ?? Key(state.id),
          initialValue: state.value,
          restorationId: state.id,
          validator: validator ??
              (state.validator == null
                  ? null
                  : (value) => state.validator!.validate(value!)?.toString()),
          builder: (field) {
            void change(List<TItem> newValue) {
              field.didChange(newValue);
              onChanged?.call(newValue);
            }

            final fieldValue = field.value!;
            final children = <Widget>[
              ...?headerBuilder?.call(
                field.context,
                fieldValue,
                change,
                field.errorText,
              ),
              if (field.hasError)
                ...?errorBuilder?.call(field.context, field.errorText!),
              for (final (index, x) in fieldValue.indexed)
                itemBuilder(
                  field.context,
                  index,
                  x,
                  fieldValue,
                  change,
                  field.errorText,
                ),
              ...?footerBuilder?.call(
                field.context,
                fieldValue,
                change,
                field.errorText,
              ),
            ];
            return containerBuilder?.call(field.context, children) ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                );
          },
        );
}
