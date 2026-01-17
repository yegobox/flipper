import 'dart:async';

import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:rxdart/rxdart.dart';

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

class _SignUpViewState extends ConsumerState<SignUpView> {
  bool _showTinField = false;
  bool _isSendingOtp = false;
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

  bool _isValidEmail(String value) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value);
  }

  bool _isValidPhoneNumber(String value) {
    // If the value is empty, it's not valid
    if (value.isEmpty) {
      return false;
    }

    // Extract just the numeric part
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Define expected total digits for each country (dial code + local number)
    // Rwanda: +250 (3 digits) + 9 digits = 12 total
    // Zambia: +260 (3 digits) + 9 digits = 12 total
    // Mozambique: +258 (3 digits) + 9 digits = 12 total
    final expectedDigits = 12;

    // Check if the value starts with a dial code
    if (value.startsWith('+')) {
      // For international format, check if we have exactly the expected number of digits
      return digitsOnly.length == expectedDigits;
    }

    // For local format (without dial code)
    if (value.startsWith('0')) {
      // Local format with leading zero: should be 10 digits (0 + 9 digits)
      return digitsOnly.length == 10;
    } else {
      // Local format without leading zero (9 digits) OR
      // full number with country code but without '+' (12 digits)
      return digitsOnly.length == 9 || digitsOnly.length == expectedDigits;
    }
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
                                          suffix: StreamBuilder(
                                            stream: Rx.combineLatest2(
                                              formBloc
                                                  .otpVerificationStatusStream
                                                  .startWith({
                                                'isVerifying': false,
                                                'isVerified':
                                                    formBloc.isPhoneVerified,
                                                'error': null
                                              }),
                                              formBloc.phoneNumber.stream,
                                              (statusData, phoneState) => {
                                                'status': statusData,
                                                'phone': phoneState
                                              },
                                            ),
                                            builder:
                                                (context, combinedSnapshot) {
                                              // Extract status data from combined snapshot
                                              final combinedData =
                                                  combinedSnapshot.data ?? {};
                                              final statusData =
                                                  combinedData['status']
                                                      as Map<String, dynamic>?;
                                              final phoneState =
                                                  combinedData['phone']
                                                      as TextFieldBlocState?;

                                              // Get current verification status
                                              final isVerifying =
                                                  statusData?['isVerifying'] ??
                                                      false;

                                              // Extract phone value from the state
                                              final String phoneValue =
                                                  phoneState?.value ?? '';
                                              final phoneHasValue =
                                                  phoneValue.isNotEmpty;

                                              final isVerified = phoneHasValue
                                                  ? (statusData?[
                                                          'isVerified'] ??
                                                      formBloc.isPhoneVerified)
                                                  : false;
                                              final error =
                                                  statusData?['error'];

                                              // Check if phone field has sufficient content (not just dial code)
                                              final bool isValidEmailOrPhone =
                                                  _isValidPhoneNumber(
                                                          phoneValue) ||
                                                      _isValidEmail(phoneValue);

                                              // Debug logging
                                              print(
                                                  'DEBUG: phoneValue = "$phoneValue"');
                                              print(
                                                  'DEBUG: isValidPhone = ${_isValidPhoneNumber(phoneValue)}');
                                              print(
                                                  'DEBUG: isValidEmail = ${_isValidEmail(phoneValue)}');
                                              print(
                                                  'DEBUG: isValidEmailOrPhone = $isValidEmailOrPhone');
                                              print(
                                                  'DEBUG: isVerified = $isVerified');
                                              print(
                                                  'DEBUG: _isSendingOtp = $_isSendingOtp');

                                              final bool canSend =
                                                  !isVerified &&
                                                      isValidEmailOrPhone &&
                                                      !_isSendingOtp;

                                              print(
                                                  'DEBUG: canSend = $canSend');

                                              if (isVerifying) {
                                                // Show loading indicator during verification
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0),
                                                  child: SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        const Color(0xFF0078D4),
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
                                                            showSuccessNotification(
                                                                context,
                                                                'OTP resent successfully!');
                                                          } catch (e) {
                                                            showErrorNotification(
                                                                context,
                                                                'Failed to resend OTP: ${e.toString()}');
                                                          } finally {
                                                            setState(() {
                                                              _isSendingOtp =
                                                                  false;
                                                            });
                                                          }
                                                        }
                                                      : null,
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF0078D4),
                                                    disabledForegroundColor:
                                                        Colors.grey,
                                                    padding: const EdgeInsets
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
                                                            showSuccessNotification(
                                                                context,
                                                                'OTP sent successfully!');
                                                          } catch (e) {
                                                            showErrorNotification(
                                                                context,
                                                                'Failed to send OTP: ${e.toString()}');
                                                          } finally {
                                                            setState(() {
                                                              _isSendingOtp =
                                                                  false;
                                                            });
                                                          }
                                                        }
                                                      : null,
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF0078D4),
                                                    disabledForegroundColor:
                                                        Colors.grey,
                                                    padding: const EdgeInsets
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
                                                      : const Text('Send Code',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                );
                                              }
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
                                                  // Only verify if not already verified
                                                  if (!formBloc
                                                      .isPhoneVerified) {
                                                    // Listen to verification status to show notifications
                                                    final verificationStream =
                                                        formBloc
                                                            .otpVerificationStatusStream;
                                                    StreamSubscription?
                                                        subscription;
                                                    subscription =
                                                        verificationStream
                                                            .listen((status) {
                                                      if (!status[
                                                          'isVerifying']) {
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
                                                        subscription?.cancel();
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
