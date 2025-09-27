import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Phone controller and country dial code helpers
  late final TextEditingController _phoneController;

  final Map<String, String> _countryDialCodes = {
    'Rwanda': '+250',
    'Zambia': '+260',
    'Mozambique': '+258',
  };

  String _dialCodeForCountry(String country) {
    return _countryDialCodes[country] ?? '+250';
  }

  String _stripDialCode(String phone) {
    if (phone.isEmpty) return '';
    for (final code in _countryDialCodes.values) {
      if (phone.startsWith(code)) return phone.substring(code.length);
    }
    return phone;
  }

  String _ensurePhoneHasDialCode(String phone, String country) {
    final code = _dialCodeForCountry(country);
    final cleaned = phone.trim();
    if (cleaned.isEmpty) return code;
    // If phone already starts with a known code, return as-is
    for (final c in _countryDialCodes.values) {
      if (cleaned.startsWith(c)) return cleaned;
    }
    // Remove leading zero if present (local formats)
    var local = cleaned;
    if (local.startsWith('0')) local = local.substring(1);
    return '$code$local';
  }

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: _ensurePhoneHasDialCode('', widget.countryNm ?? 'Rwanda'),
    );
    _phoneController.addListener(() {
      // Update the form bloc field when controller changes
      final formBloc = context.read<AsyncFieldValidationFormBloc>();
      formBloc.phoneNumber.updateValue(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
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
              final formBloc = context.read<AsyncFieldValidationFormBloc>();

              // Listen to country changes to update phone dial code
              formBloc.countryName.stream.listen((state) {
                if (state.value != null) {
                  final newPhone = _ensurePhoneHasDialCode(
                    _stripDialCode(_phoneController.text),
                    state.value!,
                  );
                  _phoneController.text = newPhone;
                }
              });

              return Scaffold(
                backgroundColor: const Color(0xFFF7FAFC),
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
                                  borderRadius: BorderRadius.circular(16),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: TextFormField(
                                          controller: _phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number',
                                            hintText: 'Enter your phone number',
                                            prefixIcon: const Icon(
                                                Icons.phone_outlined),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                          ),
                                          validator: (value) {
                                            final v = value ?? '';
                                            if (v.isEmpty)
                                              return 'Phone number is required';
                                            if (v
                                                    .replaceAll(
                                                        RegExp(r'[^0-9+]'), '')
                                                    .length <
                                                9) {
                                              return 'Please enter a valid phone number';
                                            }
                                            return null;
                                          },
                                        ),
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
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: const Color(0xFF1A1F36),
                                            ),
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
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              color: const Color(0xFF1A1F36),
                                            ),
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
                                child: Text(
                                  'Already have an account? Sign in',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF006AFE),
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
