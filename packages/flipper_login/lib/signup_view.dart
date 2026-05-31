import 'dart:async';

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/business_type.dart';
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
  int _signupStep = 0;
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
      onViewModelReady: (model) async {
        await ProxyService.box.clear();
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
                  final message = state.failureResponse ??
                      'An error occurred during signup';
                  final isOtpError = message.toLowerCase().contains('otp') ||
                      message.toLowerCase().contains('expired') ||
                      message.toLowerCase().contains('invalid');

                  if (isOtpError) {
                    // Show a snackbar with a "Resend OTP" action so the user
                    // can immediately get a fresh code without hunting for the button.
                    showErrorNotification(
                      context,
                      'OTP expired or invalid. Please request a new code.',
                      duration: const Duration(seconds: 8),
                      actionLabel: 'Resend OTP',
                      onAction: () async {
                        try {
                          await formBloc.requestOtp();
                          if (!context.mounted) return;
                          showSuccessNotification(
                              context, 'New OTP sent successfully!');
                        } catch (e) {
                          if (!context.mounted) return;
                          showErrorNotification(
                              context, 'Failed to resend OTP: $e');
                        }
                      },
                    );
                  } else {
                    showErrorNotification(context, message);
                  }
                },
                child: Builder(builder: (context) {
                  final size = MediaQuery.sizeOf(context);
                  final isMobileLayout =
                      size.shortestSide < 600 || size.width <= 820;
                  final maxWidth = isMobileLayout ? 430.0 : 520.0;
                  final horizontalPadding = isMobileLayout ? 22.0 : 32.0;

                  return Scaffold(
                    backgroundColor: const Color(0xFFF5F8FD),
                    body: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            isMobileLayout ? 18 : 28,
                            horizontalPadding,
                            28,
                          ),
                          child: Form(
                            key: _formKey,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _SignupStepHeader(
                                    step: _signupStep,
                                    xp: _signupXp(formBloc),
                                    onBack: _handleSignupBack,
                                  ),
                                  const SizedBox(height: 22),
                                  _SignupRewardBanner(
                                    xp: _signupXp(formBloc),
                                  ),
                                  const SizedBox(height: 34),
                                  _SignupStepIntro(step: _signupStep),
                                  const SizedBox(height: 22),
                                  if (_signupStep == 0) ...[
                                    components.SignupComponents.buildInputField(
                                      fieldBloc: formBloc.username,
                                      label: 'Username',
                                      icon: Icons.person_outline,
                                      hint: 'Enter your username',
                                    ),
                                    components.SignupComponents.buildInputField(
                                      fieldBloc: formBloc.fullName,
                                      label: 'Full Name',
                                      icon: Icons.badge_outlined,
                                      hint: 'First name, Last name',
                                    ),
                                  ] else if (_signupStep == 1) ...[
                                    components.SignupComponents.buildInputField(
                                      fieldBloc: formBloc.phoneNumber,
                                      label: 'Phone / Email',
                                      icon: Icons.phone_outlined,
                                      hint: '783054874 or your@email.com',
                                      keyboardType: TextInputType.text,
                                      // Dial-code prefix chip — shows when input is a phone number,
                                      // hides automatically when the user types "@" (email mode).
                                      prefix: BlocBuilder<
                                          SelectFieldBloc<String, String>,
                                          SelectFieldBlocState<String, String>>(
                                        bloc: formBloc.countryName,
                                        builder: (context, countryState) {
                                          final country =
                                              countryState.value ?? 'Rwanda';
                                          final dialCode =
                                              _phoneValidationRules[country]
                                                      ?.dialCode ??
                                                  '+250';
                                          return BlocBuilder<TextFieldBloc,
                                              TextFieldBlocState>(
                                            bloc: formBloc.phoneNumber,
                                            builder: (context, phoneState) {
                                              final isEmail = phoneState.value
                                                  .contains('@');
                                              if (isEmail)
                                                return const SizedBox.shrink();
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF4F46E5)
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  dialCode,
                                                  style: const TextStyle(
                                                    color: Color(0xFF4F46E5),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
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
                                            builder: (context, statusSnapshot) {
                                              final statusData =
                                                  statusSnapshot.data!;
                                              final isVerifying =
                                                  statusData['isVerifying'] ??
                                                      false;
                                              final bool isVerified =
                                                  (statusData['isVerified'] ??
                                                          false) &&
                                                      (phoneState.extraData
                                                              is Map &&
                                                          (phoneState.extraData
                                                                      as Map)[
                                                                  'verified'] ==
                                                              true);
                                              final error = statusData['error'];

                                              final String phoneValue =
                                                  phoneState.value;
                                              final phoneHasValue =
                                                  phoneValue.isNotEmpty;

                                              final bool isValidEmailOrPhone =
                                                  _isValidPhoneNumber(
                                                          phoneValue,
                                                          formBloc.countryName
                                                                  .value ??
                                                              'Rwanda') ||
                                                      _isValidEmail(phoneValue);

                                              final bool canSend =
                                                  !isVerified &&
                                                      isValidEmailOrPhone &&
                                                      !_isSendingOtp;

                                              if (isVerifying) {
                                                // Show loading indicator during verification
                                                return Padding(
                                                  padding: const EdgeInsets.all(
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
                                                        const Color(0xFF4F46E5),
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
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF4F46E5),
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
                                                                        0xFF4F46E5)),
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
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        const Color(0xFF4F46E5),
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
                                                                        0xFF4F46E5)),
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
                                          );
                                        },
                                      ),
                                      showCompleteState: false,
                                    ),
                                    BlocBuilder<TextFieldBloc,
                                        TextFieldBlocState>(
                                      bloc: formBloc.otpCode,
                                      builder: (context, state) {
                                        final isEnabled = (state.extraData
                                                    as Map<String, dynamic>?)?[
                                                'enabled'] ==
                                            true;
                                        if (isEnabled) {
                                          return components.SignupComponents
                                              .buildInputField(
                                            fieldBloc: formBloc.otpCode,
                                            label: 'OTP Code',
                                            icon: Icons.lock_outlined,
                                            hint: 'Enter the 6-digit OTP',
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            showCompleteState: false,
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
                                              if (!formBloc.isPhoneVerified) {
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

                                                  if (!status['isVerifying']) {
                                                    setState(() {
                                                      _isVerifyingOtp = false;
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
                                  ] else ...[
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
                                        print(
                                          'Usage changed: ${value?.typeName} (id: ${value?.id})',
                                        );
                                        formBloc.businessTypes
                                            .updateValue(value);
                                        setState(() {
                                          _showTinField = value?.id != "2";
                                        });
                                      },
                                    ),
                                    if (_showTinField)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: TinInputField(
                                          tinNumberBloc: formBloc.tinNumber,
                                          formBloc: formBloc,
                                          onValidationResult:
                                              (isValid, isRelaxed) {
                                            if (isRelaxed) {
                                              formBloc.setTinRelaxed(true);
                                            } else if (isValid) {
                                              formBloc.setTinVerified(true);
                                            } else {
                                              formBloc.setTinVerified(false);
                                            }
                                            setState(() {});
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
                                    BlocBuilder<AsyncFieldValidationFormBloc,
                                        FormBlocState>(
                                      builder: (context, state) {
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                  SizedBox(height: isMobileLayout ? 72 : 96),
                                  _SignupFooter(
                                    step: _signupStep,
                                    formBloc: formBloc,
                                    isLoading: model.registerStart,
                                    onBack: _handleSignupBack,
                                    onContinue: () =>
                                        _handleSignupContinue(formBloc),
                                  ),
                                  const SizedBox(height: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }

  int _signupXp(AsyncFieldValidationFormBloc formBloc) {
    var xp = 0;
    if (formBloc.username.value.trim().length >= 3) xp += 25;
    if (formBloc.fullName.value.trim().length >= 3) xp += 25;
    if (formBloc.phoneNumber.value.trim().length >= 5) xp += 25;
    if (formBloc.isPhoneVerified) xp += 50;
    if (formBloc.businessTypes.value != null) xp += 25;
    return xp.clamp(0, 150);
  }

  bool _isStepValid(AsyncFieldValidationFormBloc formBloc) {
    switch (_signupStep) {
      case 0:
        return formBloc.username.value.trim().isNotEmpty &&
            formBloc.fullName.value.trim().isNotEmpty &&
            !formBloc.username.state.hasError &&
            !formBloc.fullName.state.hasError;
      case 1:
        return formBloc.phoneNumber.value.trim().isNotEmpty &&
            (formBloc.isPhoneVerified ||
                ((formBloc.otpCode.state.extraData is Map &&
                        (formBloc.otpCode.state.extraData as Map)['enabled'] ==
                            true) &&
                    formBloc.otpCode.value.trim().isNotEmpty &&
                    !formBloc.otpCode.state.hasError));
      case 2:
        return formBloc.businessTypes.value != null &&
            formBloc.countryName.value != null;
      default:
        return false;
    }
  }

  void _handleSignupBack() {
    if (_signupStep == 0) {
      locator<RouterService>().back();
      return;
    }
    setState(() => _signupStep -= 1);
  }

  void _handleSignupContinue(AsyncFieldValidationFormBloc formBloc) {
    if (!_isStepValid(formBloc)) return;
    if (_signupStep < 2) {
      setState(() => _signupStep += 1);
      return;
    }
    formBloc.submit();
  }
}

class _SignupStepHeader extends StatelessWidget {
  final int step;
  final int xp;
  final VoidCallback onBack;

  const _SignupStepHeader({
    required this.step,
    required this.xp,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['Identity', 'Verify', 'Business'];

    return Row(
      children: [
        _SignupBackButton(onPressed: onBack),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    labels[step],
                    style: const TextStyle(
                      color: Color(0xFF4A5567),
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Step ${step + 1} of 3',
                    style: const TextStyle(
                      color: Color(0xFF7E8AA0),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (step + 1) / 3,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE6ECF5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        FlipperRewardChip(points: xp),
      ],
    );
  }
}

class _SignupBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _SignupBackButton({required this.onPressed});

  @override
  State<_SignupBackButton> createState() => _SignupBackButtonState();
}

class _SignupBackButtonState extends State<_SignupBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? .92 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 0,
          shadowColor: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onPressed,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE6ECF5)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF102040).withValues(alpha: .08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF4A5567),
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupRewardBanner extends StatelessWidget {
  final int xp;

  const _SignupRewardBanner({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EC),
        borderRadius: Corners.s16Border,
        border: Border.all(color: const Color(0xFFFFD99A)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB82E), Color(0xFFFF8A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: Corners.s12Border,
            ),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Finish setup to unlock 500 points',
                  style: TextStyle(
                    color: Color(0xFF0B1220),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Spend points on lower fees & premium reports',
                  style: TextStyle(
                    color: Color(0xFF4A5567),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: xp / 150,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFEEDDBB),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFF8A00),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$xp/150',
            style: const TextStyle(
              color: Color(0xFFFF8000),
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignupStepIntro extends StatelessWidget {
  final int step;

  const _SignupStepIntro({required this.step});

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Who are you?',
      'How do we reach you?',
      'Tell us about your shop',
    ];
    final descriptions = [
      'This is how you’ll sign in and how teammates find you.',
      'We’ll send a one-time code to verify it’s really you.',
      'We’ll tailor Flipper to how you sell.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titles[step],
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF0B1220),
                fontWeight: FontWeight.w900,
                height: 1.05,
              ),
        ),
        const SizedBox(height: 14),
        Text(
          descriptions[step],
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF4A5567),
                height: 1.42,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _SignupFooter extends StatelessWidget {
  final int step;
  final AsyncFieldValidationFormBloc formBloc;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const _SignupFooter({
    required this.step,
    required this.formBloc,
    required this.isLoading,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
      bloc: formBloc.username,
      builder: (context, _) {
        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
          bloc: formBloc.fullName,
          builder: (context, _) {
            return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
              bloc: formBloc.phoneNumber,
              builder: (context, _) {
                return BlocBuilder<SelectFieldBloc, SelectFieldBlocState>(
                  bloc: formBloc.businessTypes,
                  builder: (context, _) {
                    final enabled = _enabledForStep();
                    return Column(
                      children: [
                        FlipperGradientButton(
                          text: step < 2
                              ? 'Continue'
                              : 'Create account · claim 500 pts',
                          icon: step < 2
                              ? Icons.chevron_right_rounded
                              : Icons.emoji_events_outlined,
                          isLoading: isLoading,
                          onPressed: enabled ? onContinue : null,
                        ),
                        const SizedBox(height: 14),
                        const Text.rich(
                          TextSpan(
                            text: 'By continuing you agree to Flipper’s ',
                            children: [
                              TextSpan(
                                text: 'Terms',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(text: ' & '),
                              TextSpan(
                                text: 'Privacy',
                                style: TextStyle(
                                  color: Color(0xFF4F46E5),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF7E8AA0),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  bool _enabledForStep() {
    if (step == 0) {
      return formBloc.username.value.trim().isNotEmpty &&
          formBloc.fullName.value.trim().isNotEmpty &&
          !formBloc.username.state.hasError &&
          !formBloc.fullName.state.hasError;
    }
    if (step == 1) {
      return formBloc.phoneNumber.value.trim().isNotEmpty;
    }
    return formBloc.businessTypes.value != null && !isLoading;
  }
}
