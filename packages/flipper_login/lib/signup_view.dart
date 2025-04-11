import 'dart:developer';
import 'dart:convert';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:overlay_support/overlay_support.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final fullName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final tinNumber = TextFieldBloc();

  final SignupViewModel signupViewModel;
  final countryName = SelectFieldBloc<String, String>(
    items: ['Zambia', 'Mozambique', 'Rwanda'],
    initialValue: 'Rwanda',
  );
  //// {"id": "2", "typeName": "Flipper Connecta"},
  final businessTypes = SelectFieldBloc<BusinessType, Object>(
      name: 'businessType',
      items: BusinessType.fromJsonList(jsonEncode([
        {"id": "1", "typeName": "Flipper Retailer"},
      ])),
      validators: [
        FieldBlocValidators.required,
      ]);
  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);
    ProxyService.strategy.businessTypes().then((data) {
      // Update the items of the SelectFieldBloc
      log(data.toString(), name: 'AsyncFieldValidationFormBloc');
      // remove Flipper Connecta from data
      businessTypes.updateItems(data);
    }).catchError((error) {
      // Handle the error
      log(error, name: 'AsyncFieldValidationFormBloc');
    });

    addFieldBlocs(fieldBlocs: [
      username,
      fullName,
      countryName,
      tinNumber,
      businessTypes
    ]);

    username.addAsyncValidators(
      [_checkUsername],
    );
  }

  static String? _min4Char(String? username) {
    if (username!.length > 11) {
      return 'Name is too long';
    }
    return null;
  }

  Future<String?> _checkUsername(String? username) async {
    try {
      if (username == null) {
        return "Username/business name is required";
      }
      int status = await ProxyService.strategy.userNameAvailable(
          name: username, flipperHttpClient: ProxyService.http);

      if (status == 200) {
        return 'That username is already taken';
      }

      return null;
    } catch (e) {
      return 'Name Search not available';
    }
  }

  @override
  void onSubmitting() async {
    try {
      signupViewModel.startRegistering();
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      signupViewModel.setName(name: username.value);
      signupViewModel.setFullName(name: fullName.value);
      signupViewModel.setCountry(country: countryName.value);
      signupViewModel.tin =
          tinNumber.value.isEmpty ? "999909695" : tinNumber.value;
      signupViewModel.businessType = businessTypes.value!;
      await signupViewModel.signup();

      // _routerService.navigateTo(StartUpViewRoute(invokeLogin: true));
      emitSuccess();
    } catch (e) {
      signupViewModel.stopRegistering();
      showSimpleNotification(
          const Text("Error while signing up try again later"),
          background: Colors.red,
          duration: Duration(seconds: 10),
          position: NotificationPosition.bottom);
      emitFailure();
    }
  }
}

class SignUpView extends StatefulHookConsumerWidget {
  const SignUpView({Key? key, this.countryNm = "Rwanda"}) : super(key: key);
  final String? countryNm;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool _showTinField = false;
  final _formKey = GlobalKey<FormState>();

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Image.asset(
            'assets/icon.png', // Make sure to add your logo
            height: 80,
          ),
        ),
        Text(
          'Create Your Account',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1F36),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Join Flipper to manage your business better',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF4F566B),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildInputField({
    required TextFieldBloc fieldBloc,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFieldBlocBuilder(
        textFieldBloc: fieldBloc,
        suffixButton: SuffixButton.asyncValidating,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF006AFE)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF006AFE), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required SelectFieldBloc<T, dynamic> fieldBloc,
    required String label,
    required IconData icon,
    required FieldItemBuilder<T> itemBuilder,
    Function(T?)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: DropdownFieldBlocBuilder<T>(
        showEmptyItem: false,
        selectFieldBloc: fieldBloc,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF006AFE)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF006AFE), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        itemBuilder: itemBuilder,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSubmitButton(
      AsyncFieldValidationFormBloc formBloc, bool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : formBloc.submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF006AFE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Create Account',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
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
                              _buildHeaderSection(),
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      _buildInputField(
                                        fieldBloc: formBloc.username,
                                        label: 'Username',
                                        icon: Icons.person_outline,
                                        hint: 'Enter your username',
                                      ),
                                      _buildInputField(
                                        fieldBloc: formBloc.fullName,
                                        label: 'Full Name',
                                        icon: Icons.badge_outlined,
                                        hint: 'First name, Last name',
                                      ),
                                      _buildDropdownField<BusinessType>(
                                        fieldBloc: formBloc.businessTypes,
                                        label: 'Business Type',
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
                                        _buildInputField(
                                          fieldBloc: formBloc.tinNumber,
                                          label: 'TIN Number',
                                          icon: Icons.numbers_outlined,
                                          keyboardType: TextInputType.number,
                                          hint: 'Enter your TIN number',
                                        ),
                                      _buildDropdownField<String>(
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
                                      _buildSubmitButton(
                                          formBloc, model.registerStart),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  // Add navigation to login page
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
