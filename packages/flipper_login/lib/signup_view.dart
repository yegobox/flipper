import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                                      components.SignupComponents
                                          .buildDropdownField<BusinessType>(
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
                                      _buildSubmitButton(
                                          formBloc, model.registerStart),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  // TODO: Add navigation to login page
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
}
