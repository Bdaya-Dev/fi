// cspell: disable
import 'dart:convert';
import 'dart:math';

import 'package:fi/fi.dart';
import 'package:fi_base/fi_base.dart';
import 'package:flutter/material.dart';

import 'models/fields/_exports.dart';
import 'models/register_user.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FormPage(),
    ),
  );
}

class FormPage extends StatefulWidget {
  FormPage({
    super.key,
    Random? seed,
  }) : seed = seed ?? Random();

  final Random seed;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late RegisterUserModel _state;
  int stateVersion = 0;
  late var _key = GlobalObjectKey<FormState>(stateVersion);

  late final TextEditingController _jsonRepController;

  static const successSnackBar = SnackBar(
    content: Text('Submitted successfully! 🎉'),
  );
  static const failureSnackBar = SnackBar(
    content: Text('Something went wrong... 🚨'),
  );

  Future<void> _onSubmit() async {
    if (!_key.currentState!.validate()) return;

    setState(() {
      _state.status = FiSubmissionStatus.inProgress;
    });

    try {
      await _submitForm();
      _state.status = FiSubmissionStatus.success;
    } catch (_) {
      _state.status = FiSubmissionStatus.failure;
    }

    if (!mounted) return;

    setState(() {});

    FocusScope.of(context)
      ..nextFocus()
      ..unfocus();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _state.status.isSuccess ? successSnackBar : failureSnackBar,
      );
  }

  Future<void> _submitForm() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    // if (widget.seed.nextInt(2) == 0) throw Exception();
  }

  void _resetForm(RegisterUserModel model) {
    setState(() {
      _state = model;
      stateVersion++;
      _key = GlobalObjectKey(stateVersion);
    });

    /// validate the input initially.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _key.currentState!.validate();
    });
  }

  void _loadFromJson() {
    final json = _jsonRepController.text;
    try {
      final src = jsonDecode(json);
      final parsed = RegisterUserModel.fromJson(src);

      _resetForm(parsed);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(failureSnackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    _state = RegisterUserModel();
    _jsonRepController = TextEditingController();
    // validate initially.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _key.currentState?.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _key,
          child: ListView(
            children: [
              TextFormField(
                key: Key(_state.email.id),
                initialValue: _state.email.value,
                onChanged: (value) {
                  setState(() {
                    _state.email = _state.email.assign(value);
                  });
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'Email',
                  helperText: 'A valid email e.g. joe.doe@gmail.com',
                ),
                validator: (value) =>
                    _state.email.validator?.call(value ?? '')?.toString(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                key: Key(_state.password.id),
                initialValue: _state.password.value,
                onChanged: (value) {
                  setState(() {
                    _state.password = _state.password.assign(value);
                  });
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  helperText:
                      'At least 8 characters including one letter and number',
                  helperMaxLines: 2,
                  labelText: 'Password',
                  errorMaxLines: 2,
                ),
                validator: (value) =>
                    _state.password.validator?.call(value ?? '')?.toString(),
                obscureText: true,
                textInputAction: TextInputAction.done,
              ),
              const Divider(),
              FiFormFieldList<PhoneFieldState>(
                state: _state.phoneNumbers,
                headerBuilder: (context, allItems, change, errorText) sync* {
                  yield Text(
                    'Phone Numbers',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                  yield const Divider();
                },
                onChanged: (value) {
                  setState(() {
                    _state.phoneNumbers = _state.phoneNumbers.assign(value);
                  });
                },
                errorBuilder: (context, error) sync* {
                  yield Text(
                    error,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  );
                  yield const Divider();
                },
                itemBuilder:
                    (context, index, item, allItems, change, errorText) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            change(allItems.toList()..removeAt(index)),
                        icon: const Icon(Icons.delete),
                      ),
                      Expanded(
                        child: TextFormField(
                          key: Key(item.id),
                          initialValue: item.value,
                          decoration: InputDecoration(
                            labelText: 'Phone ${index + 1} [${item.id}]',
                          ),
                          onChanged: (value) {
                            change(
                              allItems.updateAt(
                                index,
                                (oldItem) => oldItem.assign(value),
                              ),
                            );
                          },
                          validator: (value) =>
                              item.validator?.call(value)?.toString(),
                        ),
                      ),
                    ],
                  );
                },
                footerBuilder: (context, allItems, change, errorText) sync* {
                  yield ButtonBar(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          change([
                            ...allItems,
                            PhoneFieldState.pure(
                              null,
                              id: fiGetRandomString(),
                            ),
                          ]);
                        },
                        icon: const Icon(Icons.add_ic_call),
                        label: const Text('Add phone'),
                      )
                    ],
                  );
                },
              ),
              const Divider(),
              FiFormFieldList<UserAddressFieldState>(
                state: _state.addresses,
                headerBuilder: (context, allItems, change, errorText) sync* {
                  yield Text(
                    'Addresses',
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                  yield const Divider();
                },
                onChanged: (value) {
                  setState(() {
                    _state.addresses = _state.addresses.assign(value);
                  });
                },
                errorBuilder: (context, error) sync* {
                  yield Text(
                    error,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  );
                  yield const Divider();
                },
                itemBuilder:
                    (context, index, item, allItems, change, errorText) {
                  return _AddressWidget(
                    delete: () {
                      change(allItems.toList()..removeAt(index));
                    },
                    index: index,
                    setState: (p0) {
                      change(allItems.updateAt(index, (old) => old.assign(p0)));
                    },
                    state: item,
                  );
                },
                footerBuilder: (context, allItems, change, errorText) sync* {
                  yield ButtonBar(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          change([
                            ...allItems,
                            RegisterUserModel.defaultAddress(),
                          ]);
                        },
                        icon: const Icon(Icons.add_location),
                        label: const Text('Add Address'),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              if (_state.status.isInProgress)
                const Center(child: CircularProgressIndicator())
              else
                FutureBuilder(
                    future: Future.wait([
                      Future.microtask(() => _state.aggregateErrors()),
                      Future.microtask(() => _state.aggregateIsPure()),
                    ]),
                    builder: (context, snapshot) {
                      final data = snapshot.data;

                      final errors =
                          data == null ? null : data[0] as List<Object>;
                      final isPure = data == null ? null : data[1] as bool;
                      return ButtonBar(
                        children: [
                          Builder(builder: (context) {
                            Widget child = ElevatedButton.icon(
                              icon: const Icon(Icons.restore),
                              onPressed: isPure == true
                                  ? null
                                  : () => _resetForm(RegisterUserModel()),
                              label: const Text('Reset'),
                            );
                            final tooltipMessages = <String>[
                              if (isPure == true)
                                'All form controls are already pure.'
                            ];

                            if (tooltipMessages.isNotEmpty) {
                              child = Tooltip(
                                message: tooltipMessages.join('\n'),
                                child: child,
                              );
                            }
                            return child;
                          }),
                          Builder(
                            builder: (context) {
                              Widget child = ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                onPressed: errors == null ||
                                        errors.isNotEmpty ||
                                        (isPure == true)
                                    ? null
                                    : _onSubmit,
                                label: const Text('Submit'),
                              );
                              final tooltipMessages = <String>[
                                if (errors != null && errors.isNotEmpty)
                                  ...errors.map((e) => e.toString()),
                                if (isPure == true)
                                  'All form controls are already pure.'
                              ];

                              if (tooltipMessages.isNotEmpty) {
                                child = Tooltip(
                                  message: tooltipMessages.join('\n'),
                                  child: child,
                                );
                              }
                              return child;
                            },
                          ),
                        ],
                      );
                    }),
              const Divider(),
              Text(
                'Json representation',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SelectableText(jsonEncode(_state.toJson())),
              const Divider(),
              TextField(
                controller: _jsonRepController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'From json',
                  border: OutlineInputBorder(),
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadFromJson,
                    icon: const Icon(Icons.upload),
                    label: const Text('Load From Json'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    required this.state,
    required this.index,
    required this.setState,
    required this.delete,
  });

  final int index;
  final UserAddressFieldState state;
  final void Function(UserAddress) setState;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    final stateValue = state.value;
    return FormField<UserAddress>(
      key: Key(state.id),
      initialValue: stateValue,
      validator: (value) =>
          value == null ? null : state.validator?.call(value)?.toString(),
      builder: (field) {
        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: delete,
                  icon: const Icon(Icons.delete),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("User address $index [${state.id}]"),
                      const Divider(),
                      if (field.hasError) ...[
                        Text(
                          field.errorText!,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        const Divider(),
                      ],
                      TextFormField(
                        key: Key(state.id + UserAddress.kFullAddress),
                        initialValue: stateValue.fullAddress.value,
                        onChanged: (value) {
                          stateValue.fullAddress =
                              stateValue.fullAddress.assign(value);
                          field.didChange(stateValue);
                          setState(stateValue);
                        },
                        validator: (value) => stateValue.fullAddress.validator
                            ?.validate(value)
                            ?.toString(),
                        decoration:
                            const InputDecoration(labelText: 'Full Address'),
                      ),
                      TextFormField(
                        key: Key(state.id + UserAddress.kPostalCode),
                        initialValue: stateValue.postalCode.value,
                        onChanged: (value) {
                          stateValue.postalCode =
                              stateValue.postalCode.assign(value);
                          field.didChange(stateValue);
                          setState(stateValue);
                        },
                        decoration:
                            const InputDecoration(labelText: 'Postal code'),
                      ),
                      DropdownButtonFormField<CountriesEnum>(
                        key: Key(state.id + UserAddress.kCountry),
                        value: stateValue.country.value,
                        items: CountriesEnum.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          stateValue.country = stateValue.country.assign(value);
                          field.didChange(stateValue);
                          setState(stateValue);
                        },
                        validator: (value) => stateValue.country.validator
                            ?.validate(value)
                            ?.toString(),
                        decoration: const InputDecoration(labelText: 'Country'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
