import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

// Import our extracted components
import 'blocs/signup_form_bloc.dart';
import 'viewmodels/signup_viewmodel.dart';
import 'components/signup_components.dart' as components;
import 'components/tin_input_field.dart';

class SignUpView extends StatefulHookConsumerWidget {
  const SignUpView({Key? key, this.countryNm = "Rwanda"}) : super(key: key);
  final String? countryNm;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool _showTinField = false;
  final _formKey = GlobalKey<FormState>();
  bool _countryListenerSet = false;

  // Phone controller and country dial code helpers
  final Map<String, String> _countryDialCodes = {
    'Rwanda': '+250',
    'Zambia': '+260',
    'Mozambique': '+258',
  };

  String _dialCodeForCountry(String country) {
    return _countryDialCodes[country] ?? '+250';
  }

  String _ensurePhoneHasDialCode(String phone, String country) {
    final code = _dialCodeForCountry(country);
    final cleaned = phone.trim();
    if (cleaned.isEmpty) return code;
    // If phone already starts with the correct dial code for this country, return as-is
    if (cleaned.startsWith(code)) return cleaned;
    // If phone starts with any known dial code, replace it with the correct one
    for (final c in _countryDialCodes.values) {
      if (cleaned.startsWith(c)) {
        return code + cleaned.substring(c.length);
      }
    }
    // Remove leading zero if present (local formats) and prepend dial code
    var local = cleaned;
    if (local.startsWith('0')) local = local.substring(1);
    return '$code$local';
  }

  @override
  void initState() {
    super.initState();
    // Remove the listener setup from here - we'll set it up after the provider is available
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
      onViewModelReady: (model) {
        model.context = context;
        model.registerLocation();
      },
      viewModelBuilder: () => SignupViewModel(),
      builder: (context, model, child) {
        return BlocProvider(
          create: (context) => AsyncFieldValidationFormBloc(
            signupViewModel: model,
            country: widget.countryNm ?? "Rwanda",
          ),
          child: Builder(
            builder: (context) {
              final formBloc =
                  BlocProvider.of<AsyncFieldValidationFormBloc>(context);

              // Set initial phone value only if it's empty (first time setup)
              if (formBloc.phoneNumber.value.isEmpty) {
                formBloc.phoneNumber.updateValue(
                    _ensurePhoneHasDialCode('', widget.countryNm ?? 'Rwanda'));
              }

              // Set up country change listener only once
              if (!_countryListenerSet) {
                _countryListenerSet = true;
                formBloc.countryName.stream.listen((state) {
                  if (state.value != null) {
                    final currentPhone = formBloc.phoneNumber.value;
                    final newPhone = _ensurePhoneHasDialCode(
                      currentPhone,
                      state.value!,
                    );
                    // Only update if the dial code actually changed
                    if (newPhone != currentPhone) {
                      formBloc.phoneNumber.updateValue(newPhone);
                    }
                  }
                });
              }

              return Scaffold(
                backgroundColor: const Color(0xFFF5F7FA),
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 460),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              components.SignupComponents.buildHeaderSection(),
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      components.SignupComponents
                                          .buildInputField(
                                        fieldBloc: formBloc.username,
                                        label: 'Username',
                                        icon: Icons.person_outline,
                                        hint: 'Enter your username',
                                      ),
                                      components.SignupComponents
                                          .buildInputField(
                                        fieldBloc: formBloc.fullName,
                                        label: 'Full Name',
                                        icon: Icons.badge_outlined,
                                        hint: 'First name, Last name',
                                      ),
                                      components.SignupComponents
                                          .buildInputField(
                                        fieldBloc: formBloc.phoneNumber,
                                        label: 'Phone Number',
                                        icon: Icons.phone_outlined,
                                        hint: 'Enter your phone or email',
                                        keyboardType: TextInputType.text,
                                      ),
                                      components.SignupComponents
                                          .buildDropdownField<BusinessType>(
                                        fieldBloc: formBloc.businessTypes,
                                        label: 'Usage',
                                        icon: Icons.business_outlined,
                                        itemBuilder: (context, value) =>
                                            FieldItem(
                                          child: Text(
                                            value.typeName,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _showTinField = value?.id != "2";
                                          });
                                        },
                                      ),
                                      if (_showTinField)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: TinInputField(
                                            tinNumberBloc: formBloc.tinNumber,
                                          ),
                                        ),
                                      components.SignupComponents
                                          .buildDropdownField<String>(
                                        fieldBloc: formBloc.countryName,
                                        label: 'Country',
                                        icon: Icons.public_outlined,
                                        itemBuilder: (context, value) =>
                                            FieldItem(
                                          child: Text(
                                            value,
                                          ),
                                        ),
                                      ),
                                      components.SignupComponents
                                          .buildSubmitButton(
                                              formBloc, model.registerStart),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  locator<RouterService>()
                                      .navigateTo(PinLoginRoute());
                                },
                                child: const Text(
                                  'Already have an account? Sign in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF0078D4),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
