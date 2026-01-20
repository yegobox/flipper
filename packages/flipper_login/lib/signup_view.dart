import 'dart:async';

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
import 'package:flutter/services.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

class SignUpView extends StatefulHookConsumerWidget {
  const SignUpView({Key? key, this.countryNm = "Rwanda"}) : super(key: key);
  final String? countryNm;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class PhoneValidationRule {
  final String dialCode;
  final List<int> localLengths;

  PhoneValidationRule({required this.dialCode, required this.localLengths});
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool _showTinField = false;
  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  String? _lastSubmittedOtp;
  final _formKey = GlobalKey<FormState>();
  StreamSubscription? _otpVerificationSubscription; // State-level field

  static final Map<String, PhoneValidationRule> _phoneValidationRules = {
    'Rwanda': PhoneValidationRule(dialCode: '+250', localLengths: [9]),
    'Zambia': PhoneValidationRule(dialCode: '+260', localLengths: [9]),
    'Mozambique': PhoneValidationRule(dialCode: '+258', localLengths: [9]),
  };

  @override
  void initState() {
    super.initState();
    // Remove the listener setup from here - we'll set it up after the provider is available
  }

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(value);
  }

  static bool _isValidPhoneNumber(String value, String country) {
    if (value.isEmpty) {
      return false;
    }
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check against all known rules if number starts with '+'
    if (value.startsWith('+')) {
      for (final rule in _phoneValidationRules.values) {
        if (value.startsWith(rule.dialCode)) {
          // Dynamically compute valid total lengths
          final dialCodeDigits =
              rule.dialCode.replaceAll(RegExp(r'\D'), '').length;
          final validTotalLengths =
              rule.localLengths.map((len) => dialCodeDigits + len);
          return validTotalLengths.contains(digitsOnly.length);
        }
      }
      return false; // Starts with '+' but not a known dial code
    }

    // If no '+', assume it's a local number for the currently selected country
    final currentRule = _phoneValidationRules[country];
    if (currentRule == null) return false; // Should not happen

    return currentRule.localLengths.contains(digitsOnly.length);
  }

  @override
  void dispose() {
    _otpVerificationSubscription?.cancel(); // Cancel subscription in dispose
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

              return FormBlocListener<AsyncFieldValidationFormBloc, String,
                  String>(
                formBloc: formBloc,
                onSubmitting: (context, state) {
                  // Show loading indicator if needed
                },
                onSuccess: (context, state) {
                  // Success is handled by navigation in the bloc
                },
                onFailure: (context, state) {
                  // Show error notification
                  showErrorNotification(
                    context,
                    state.failureResponse ?? 'An error occurred during signup',
                  );
                },
                child: Scaffold(
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
                                components.SignupComponents
                                    .buildHeaderSection(),
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
                                          label: 'Phone Number or Email',
                                          icon: Icons.phone_outlined,
                                          hint: 'Enter your phone or email',
                                          keyboardType: TextInputType.text,
                                          suffix: BlocBuilder<TextFieldBloc,
                                              TextFieldBlocState>(
                                            bloc: formBloc.phoneNumber,
                                            builder: (context, phoneState) {
                                              return StreamBuilder<
                                                  Map<String, dynamic>>(
                                                stream: formBloc
                                                    .otpVerificationStatusStream,
                                                initialData: {
                                                  'isVerifying': false,
                                                  'isVerified':
                                                      formBloc.isPhoneVerified,
                                                  'error': null
                                                },
                                                builder:
                                                    (context, statusSnapshot) {
                                                  final statusData =
                                                      statusSnapshot.data!;
                                                  final isVerifying =
                                                      statusData[
                                                              'isVerifying'] ??
                                                          false;
                                                  final isVerified = statusData[
                                                          'isVerified'] ??
                                                      false;
                                                  final error =
                                                      statusData['error'];

                                                  final String phoneValue =
                                                      phoneState.value;
                                                  final phoneHasValue =
                                                      phoneValue.isNotEmpty;

                                                  final bool
                                                      isValidEmailOrPhone =
                                                      _isValidPhoneNumber(
                                                              phoneValue,
                                                              formBloc.countryName
                                                                      .value ??
                                                                  'Rwanda') ||
                                                          _isValidEmail(
                                                              phoneValue);

                                                  final bool canSend =
                                                      !isVerified &&
                                                          isValidEmailOrPhone &&
                                                          !_isSendingOtp;

                                                  if (isVerifying) {
                                                    // Show loading indicator during verification
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            const Color(
                                                                0xFF0078D4),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else if (error != null &&
                                                      phoneHasValue) {
                                                    // Show "Resend Code" button when verification fails and phone has a value
                                                    return TextButton(
                                                      onPressed: canSend
                                                          ? () async {
                                                              setState(() {
                                                                _isSendingOtp =
                                                                    true;
                                                              });
                                                              try {
                                                                await formBloc
                                                                    .requestOtp();
                                                                if (!mounted)
                                                                  return;
                                                                showSuccessNotification(
                                                                    context,
                                                                    'OTP resent successfully!');
                                                              } catch (e) {
                                                                if (!mounted)
                                                                  return;
                                                                showErrorNotification(
                                                                    context,
                                                                    'Failed to resend OTP: ${e.toString()}');
                                                              } finally {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    _isSendingOtp =
                                                                        false;
                                                                  });
                                                                }
                                                              }
                                                            }
                                                          : null,
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            const Color(
                                                                0xFF0078D4),
                                                        disabledForegroundColor:
                                                            Colors.grey,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      child: _isSendingOtp
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Color(
                                                                            0xFF0078D4)),
                                                              ),
                                                            )
                                                          : const Text('Resend',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                    );
                                                  } else if (isVerified &&
                                                      phoneHasValue) {
                                                    // Show checkmark when phone is verified
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      child: Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        size: 24,
                                                      ),
                                                    );
                                                  } else {
                                                    // Show "Send Code" button when not verified
                                                    return TextButton(
                                                      onPressed: canSend
                                                          ? () async {
                                                              setState(() {
                                                                _isSendingOtp =
                                                                    true;
                                                              });
                                                              try {
                                                                await formBloc
                                                                    .requestOtp();
                                                                if (!mounted)
                                                                  return;
                                                                showSuccessNotification(
                                                                    context,
                                                                    'OTP sent successfully!');
                                                              } catch (e) {
                                                                if (!mounted)
                                                                  return;
                                                                showErrorNotification(
                                                                    context,
                                                                    'Failed to send OTP: ${e.toString()}');
                                                              } finally {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    _isSendingOtp =
                                                                        false;
                                                                  });
                                                                }
                                                              }
                                                            }
                                                          : null,
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            const Color(
                                                                0xFF0078D4),
                                                        disabledForegroundColor:
                                                            Colors.grey,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 16),
                                                      ),
                                                      child: _isSendingOtp
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Color(
                                                                            0xFF0078D4)),
                                                              ),
                                                            )
                                                          : const Text(
                                                              'Send Code',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        BlocBuilder<TextFieldBloc,
                                            TextFieldBlocState>(
                                          bloc: formBloc.otpCode,
                                          builder: (context, state) {
                                            final isEnabled = (state.extraData
                                                        as Map<String,
                                                            dynamic>?)?[
                                                    'enabled'] ==
                                                true;
                                            if (isEnabled) {
                                              return components.SignupComponents
                                                  .buildInputField(
                                                fieldBloc: formBloc.otpCode,
                                                label: 'OTP Code',
                                                icon: Icons.lock_outlined,
                                                hint: 'Enter the 6-digit OTP',
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      6),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        // Add a listener to trigger OTP verification when OTP is complete
                                        StreamBuilder<TextFieldBlocState>(
                                          stream: formBloc.otpCode.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final state = snapshot.data!;
                                              // Trigger verification when OTP reaches 6 digits
                                              if (state.value.length == 6 &&
                                                  state.isValid) {
                                                // Use a post-frame callback to ensure UI updates happen first
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  if (!mounted)
                                                    return; // Add mounted check here

                                                  // Guard against re-triggering verification for the same OTP
                                                  if (_isVerifyingOtp ||
                                                      state.value ==
                                                          _lastSubmittedOtp) {
                                                    return;
                                                  }

                                                  // Only verify if not already verified
                                                  if (!formBloc
                                                      .isPhoneVerified) {
                                                    setState(() {
                                                      _isVerifyingOtp = true;
                                                      _lastSubmittedOtp =
                                                          state.value;
                                                    });

                                                    // Cancel any existing subscription to prevent leaks
                                                    _otpVerificationSubscription
                                                        ?.cancel();

                                                    // Listen to verification status to show notifications
                                                    _otpVerificationSubscription =
                                                        formBloc
                                                            .otpVerificationStatusStream
                                                            .listen((status) {
                                                      // Ensure the widget is still mounted before updating UI
                                                      if (!mounted) {
                                                        _otpVerificationSubscription
                                                            ?.cancel(); // Cancel if widget is no longer mounted
                                                        return;
                                                      }

                                                      if (!status[
                                                          'isVerifying']) {
                                                        setState(() {
                                                          _isVerifyingOtp =
                                                              false;
                                                        });

                                                        if (status['error'] !=
                                                            null) {
                                                          // Show error notification when verification fails
                                                          showErrorNotification(
                                                              context,
                                                              status['error']);
                                                        } else if (status[
                                                            'isVerified']) {
                                                          // Show success notification when verification succeeds
                                                          showSuccessNotification(
                                                              context,
                                                              'Phone number verified successfully!');
                                                        }
                                                        // Cancel subscription after handling the result
                                                        _otpVerificationSubscription
                                                            ?.cancel();
                                                      }
                                                    });

                                                    formBloc.manualVerifyOtp();
                                                  }
                                                });
                                              }
                                            }
                                            return const SizedBox.shrink();
                                          },
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
                                              onValidationResult:
                                                  (isValid, isRelaxed) {
                                                if (isRelaxed) {
                                                  formBloc.setTinRelaxed(true);
                                                } else if (isValid) {
                                                  formBloc.setTinVerified(true);
                                                } else {
                                                  formBloc
                                                      .setTinVerified(false);
                                                }
                                              },
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
