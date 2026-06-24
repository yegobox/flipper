import 'dart:async';
import 'dart:developer';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_login/viewmodels/signup_viewmodel.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

/// Form bloc for handling signup form validation and submission
class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  static final RegExp EMAIL_REGEX = RegExp(r'^[^@\s]+@[^@\s]+\.[a-zA-Z]{2,}$');
  final username = TextFieldBloc<Object>(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final fullName = TextFieldBloc<Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final TextFieldBloc<Object> phoneNumber = TextFieldBloc<Object>(
    validators: [
      FieldBlocValidators.required,
      _validateContactInfo,
    ],
  );
  final otpCode = TextFieldBloc<Object>(
    validators: [
      FieldBlocValidators.required,
      _validateOtp,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  late final TextFieldBloc<Object> tinNumber = TextFieldBloc<Object>(
    validators: [
      FieldBlocValidators.required,
      _validateTinStatus,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  final _phoneVerificationField = TextFieldBloc<Object>(
    validators: [
      _validatePhoneNotVerified,
    ],
  );

  bool _isTinVerified = false;
  bool _isTinValidationRelaxed = false;
  bool _isPhoneVerified = false;
  bool _isVerifyingOtp = false;
  String? _otpVerificationError;
  String? _verifiedPhoneNumber; // Track the verified phone number
  String? _verifiedTinNumber; // Track the verified TIN number
  final _phoneVerifiedController = StreamController<bool>.broadcast();
  final _otpVerificationStatusController =
      StreamController<Map<String, dynamic>>.broadcast();

  final SignupViewModel signupViewModel;
  final countryName = SelectFieldBloc<String, String>(
    items: ['Zambia', 'Mozambique', 'Rwanda'],
    initialValue: 'Rwanda',
  );

  final businessTypes =
      SelectFieldBloc<BusinessType, Object>(name: 'businessType', validators: [
    FieldBlocValidators.required,
  ]);

  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);

    // Business types are now hardcoded to match flipper_web app
    // Set default to Individual after items are loaded
    // Business types are now generated from BusinessTypeEnum
    // Set default to Individual after items are loaded
    final businessTypeItems = BusinessTypeEnum.values
        .map((e) => BusinessType(id: e.id, typeName: e.typeName))
        .toList();
    businessTypes.updateItems(businessTypeItems);

    // Set Individual as the default
    final individualType = businessTypeItems.firstWhere(
      (type) => type.id == BusinessTypeEnum.INDIVIDUAL.id,
      orElse: () => businessTypeItems.first,
    );
    businessTypes.updateInitialValue(individualType);

    // Initially, tinNumber is not required for Individual
    tinNumber.updateValidators([]);

    // Initially hide OTP field until user requests OTP
    otpCode.updateValidators([FieldBlocValidators.required, _validateOtp]);
    otpCode.updateExtraData({'enabled': false}); // Disable initially

    addFieldBlocs(fieldBlocs: [
      username,
      fullName,
      phoneNumber,
      otpCode, // Add OTP field
      countryName,
      tinNumber,
      businessTypes,
      _phoneVerificationField // Add phone verification field
    ]);

    // Country dial-code is shown as a visual prefix chip in the UI.
    // The field stores only what the user typed (local digits or email).
    // _ensurePhoneHasDialCode is called at OTP-send / submit time to
    // prepend the correct country code before hitting the backend.

    // Listen to username and fullName streams to enable/disable phoneNumber
    void updatePhoneNumberEnabled() {
      final isEnabled = username.value.isNotEmpty && fullName.value.isNotEmpty;
      phoneNumber.updateExtraData({
        ...(phoneNumber.state.extraData as Map<String, dynamic>? ?? {}),
        'enabled': isEnabled,
      });
      if (!isEnabled && phoneNumber.value.isNotEmpty) {
        phoneNumber.updateValue('');
      }
    }

    // Initial check
    updatePhoneNumberEnabled();

    // Listen to each stream
    username.stream.listen((_) => updatePhoneNumberEnabled());
    fullName.stream.listen((_) => updatePhoneNumberEnabled());

    // Listen to business type changes to update tinNumber validation
    businessTypes.stream.listen((state) {
      if (state.value?.id == BusinessTypeEnum.INDIVIDUAL.id) {
        // Individual - no TIN required
        tinNumber.updateValidators([]);
      } else {
        // Other business types - TIN required
        tinNumber.updateValidators(
            [FieldBlocValidators.required, _validateTinStatus]);
      }
      tinNumber.validate();
    });

    // Listen to TIN changes to reset verification if it was verified but value changed
    tinNumber.stream.listen((state) {
      if ((_isTinVerified || _isTinValidationRelaxed) &&
          state.value != _verifiedTinNumber) {
        setTinVerified(false);
      }
    });

    // Listen to OTP changes to trigger verification when OTP is complete
    otpCode.stream.listen((state) {
      // Only trigger verification if OTP is 6 digits and field is valid
      if (state.value.length == 6 && state.isValid) {
        // Optionally trigger verification here if we want immediate feedback
        // For now, we'll rely on verification during form submission
      }
    });

    // Listen to phone number changes to reset verification status when field is cleared or changed
    phoneNumber.stream.listen((state) {
      if (_isPhoneVerified && state.value != _verifiedPhoneNumber) {
        // Reset phone verification status when phone number changes
        setPhoneVerified(false);
      }
    });

    username.addAsyncValidators([_checkUsername]);

    // Load business types from remote
    _loadBusinessTypes();
  }

  void _loadBusinessTypes() {
    ProxyService.app.getBusinessTypes().then((types) {
      if (types.isNotEmpty) {
        businessTypes.updateItems(types);

        // Try to maintain selection or default to Individual (id 2)
        // If current selection is valid in new list, keep it.
        // Otherwise default to Individual or first item.

        final currentId = businessTypes.value?.id;
        final targetId = currentId ?? BusinessTypeEnum.INDIVIDUAL.id;

        final matchingType = types.firstWhere((t) => t.id == targetId,
            orElse: () => types.firstWhere(
                (t) => t.id == BusinessTypeEnum.INDIVIDUAL.id,
                orElse: () => types.first));

        if (businessTypes.value != matchingType) {
          businessTypes.updateValue(matchingType);
        }
      }
    }).catchError((error, stackTrace) {
      // Silently handle the error to prevent unhandled Future exceptions
      // The existing enum-backed items will remain as fallback
      log('Error loading business types: $error',
          name: 'AsyncFieldValidationFormBloc');
    });
  }

  /// Validates that username is not too long
  static String? _min4Char(String? username) {
    if (username!.length > 11) {
      return 'Name is too long';
    }
    return null;
  }

  /// Validates phone number format or email format
  static String? _validateContactInfo(String? contact) {
    if (contact == null || contact.isEmpty) {
      return 'Phone number or email is required';
    }

    // Regex for phone number (optional +, 8-15 digits, spaces, hyphens, parentheses allowed)
    // Loosened to match the UI validation which is more permissive
    final phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{8,15}$');
    // Regex for email
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (phoneRegex.hasMatch(contact)) {
      return null; // Valid phone number
    }
    if (emailRegex.hasMatch(contact)) {
      return null; // Valid email
    }

    return 'Please enter a valid phone number or email address';
  }

  /// Checks if username is available
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

  /// Validates OTP format
  static String? _validateOtp(String? otp) {
    if (otp == null || otp.isEmpty) {
      return 'OTP is required';
    }

    if (otp.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  // Phone normalization logic
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

  /// Guard to prevent concurrent OTP requests from firing duplicate HTTP calls.
  bool _isRequestingOtp = false;

  /// Method to send OTP to the user's phone number or email
  Future<Map<String, dynamic>?> requestOtp() async {
    // Prevent duplicate in-flight requests
    if (_isRequestingOtp) {
      return null;
    }

    if (phoneNumber.value.isEmpty) {
      throw Exception('Phone number or email is required to send OTP');
    }

    // Check if it's an email
    final isEmail = EMAIL_REGEX.hasMatch(phoneNumber.value);

    String contactInfo = phoneNumber.value;
    if (!isEmail) {
      // It's a phone number, so normalize it
      contactInfo = _ensurePhoneHasDialCode(
          phoneNumber.value, countryName.value ?? 'Rwanda');
    }

    _isRequestingOtp = true;
    try {
      // Ensure user exists/is initialized first as required by backend
      // This hits /v2/api/user which is a prerequisite for OTP sending
      await ProxyService.strategy.sendLoginRequest(
        contactInfo,
        ProxyService.http,
        AppSecrets.apihubProd,
      );

      final result = await ProxyService.strategy.sendOtpForSignup(contactInfo);
      // Enable the OTP field after successful request
      otpCode.updateExtraData({'enabled': true});
      return result;
    } catch (e) {
      rethrow;
    } finally {
      _isRequestingOtp = false;
    }
  }

  /// Method to verify the OTP
  Future<bool> verifyOtp() async {
    if (otpCode.value.isEmpty) {
      throw Exception('OTP is required to verify');
    }

    final isEmail = EMAIL_REGEX.hasMatch(phoneNumber.value);
    String normalizedContact = phoneNumber.value;
    if (!isEmail) {
      normalizedContact = _ensurePhoneHasDialCode(
          phoneNumber.value, countryName.value ?? 'Rwanda');
    }

    try {
      final result = await ProxyService.strategy
          .verifyOtpForSignup(normalizedContact, otpCode.value);
      final isVerified = result['verified'] == true;

      if (isVerified) {
        setPhoneVerified(true); // Mark phone as verified when OTP is verified
      }

      return isVerified;
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  /// Method to manually verify OTP and update phone verification status
  Future<bool> manualVerifyOtp() async {
    if (otpCode.value.isEmpty) {
      return false;
    }

    // Set verification in progress
    _isVerifyingOtp = true;
    _otpVerificationError = null;
    _otpVerificationStatusController.add({
      'isVerifying': true,
      'isVerified': false,
      'error': null,
    });

    final isEmail = EMAIL_REGEX.hasMatch(phoneNumber.value);
    String normalizedContact = phoneNumber.value;
    if (!isEmail) {
      normalizedContact = _ensurePhoneHasDialCode(
          phoneNumber.value, countryName.value ?? 'Rwanda');
    }

    try {
      final result = await ProxyService.strategy
          .verifyOtpForSignup(normalizedContact, otpCode.value);
      final isVerified = result['verified'] == true;

      if (isVerified) {
        setPhoneVerified(true); // Mark phone as verified when OTP is verified
        _otpVerificationStatusController.add({
          'isVerifying': false,
          'isVerified': true,
          'error': null,
        });
      } else {
        // Reset phone verification status on failure so user can try again
        setPhoneVerified(false);
        _otpVerificationError = result['error'] ?? 'Verification failed';
        _otpVerificationStatusController.add({
          'isVerifying': false,
          'isVerified': false,
          'error': _otpVerificationError,
        });
      }

      return isVerified;
    } catch (e) {
      // Reset phone verification status on failure so user can try again
      setPhoneVerified(false);
      _otpVerificationError = e.toString();
      _otpVerificationStatusController.add({
        'isVerifying': false,
        'isVerified': false,
        'error': _otpVerificationError,
      });
      // Don't throw error, just return false if verification fails
      return false;
    } finally {
      _isVerifyingOtp = false;
    }
  }

  @override
  void onSubmitting() async {
    try {
      signupViewModel.startRegistering();

      final isOtpEnabled =
          (otpCode.state.extraData as Map<String, dynamic>?)?['enabled'] ==
              true;

      // If OTP field is enabled and has a value, verify it before proceeding
      if (isOtpEnabled && otpCode.value.isNotEmpty) {
        // Validate the OTP format first
        final otpError = _validateOtp(otpCode.value);
        if (otpError != null) {
          log('Invalid OTP format: $otpError',
              name: 'AsyncFieldValidationFormBloc');
          signupViewModel.stopRegistering();
          emitFailure(failureResponse: otpError);
          return;
        }

        // Verify the OTP with the backend
        try {
          final isVerified = await verifyOtp();
          if (!isVerified) {
            log('OTP verification failed',
                name: 'AsyncFieldValidationFormBloc');
            signupViewModel.stopRegistering();
            emitFailure(failureResponse: 'Invalid OTP. Please try again.');
            return;
          }
        } catch (e) {
          log('Error verifying OTP: $e', name: 'AsyncFieldValidationFormBloc');
          signupViewModel.stopRegistering();
          emitFailure(
              failureResponse: 'Failed to verify OTP. Please try again.');
          return;
        }
      } else if (isOtpEnabled && otpCode.value.isEmpty) {
        // OTP is required but not provided
        signupViewModel.stopRegistering();
        emitFailure(failureResponse: 'OTP is required to proceed with signup.');
        return;
      }

      // Transfer form values to view model
      signupViewModel.setName(name: username.value);
      signupViewModel.setFullName(name: fullName.value);
      // Only prepend dial code for phone numbers — emails must be passed as-is.
      final _isEmail = EMAIL_REGEX.hasMatch(phoneNumber.value);
      signupViewModel.setPhoneNumber(
        phoneNumber: _isEmail
            ? phoneNumber.value
            : _ensurePhoneHasDialCode(
                phoneNumber.value,
                countryName.value ?? 'Rwanda',
              ),
      );
      signupViewModel.setCountry(country: countryName.value ?? 'Rwanda');
      signupViewModel.tin = (tinNumber.value.isEmpty ||
              businessTypes.value?.id == BusinessTypeEnum.INDIVIDUAL.id)
          ? "999909695"
          : tinNumber.value;
      signupViewModel.businessType = businessTypes.value!;

      // Perform signup
      await signupViewModel.signup();

      // Signup completed successfully - navigate to startup view
      // The StartupViewModel will handle appInit() and proper navigation
      log('Signup completed successfully',
          name: 'AsyncFieldValidationFormBloc');

      final routerService = locator<RouterService>();
      routerService.navigateTo(StartUpViewRoute());

      emitSuccess();
      signupViewModel.stopRegistering(); // Ensure we stop the loading state
    } catch (e) {
      log('Error during signup: $e', name: 'AsyncFieldValidationFormBloc');
      signupViewModel.stopRegistering();
      emitFailure();
    }
  }

  String? _validateTinStatus(String? tin) {
    if (businessTypes.value?.id == BusinessTypeEnum.INDIVIDUAL.id) {
      return null; // Individual
    }
    if (_isTinValidationRelaxed) return null;
    if (_isTinVerified) return null;
    return 'Please validate TIN';
  }

  static String? _validatePhoneNotVerified(String? value) {
    return 'Phone number must be verified';
  }

  void setTinVerified(bool verified) {
    log('Setting TIN verified: $verified',
        name: 'AsyncFieldValidationFormBloc');
    _isTinVerified = verified;
    _isTinValidationRelaxed = false; // specific verification overrides relaxed
    _verifiedTinNumber = verified ? tinNumber.value : null;

    if (businessTypes.value?.id != BusinessTypeEnum.INDIVIDUAL.id) {
      if (verified) {
        // The TIN is verified, so we no longer need the status validator.
        tinNumber.updateValidators([FieldBlocValidators.required]);
      } else {
        // The TIN is not verified, so we need the status validator.
        tinNumber.updateValidators(
            [FieldBlocValidators.required, _validateTinStatus]);
      }
    }

    tinNumber.updateExtraData({
      ...tinNumber.state.extraData as Map<dynamic, dynamic>? ?? {},
      'verified': verified,
    });
    tinNumber.validate();
  }

  void setTinRelaxed(bool relaxed) {
    log('Setting TIN relaxed: $relaxed', name: 'AsyncFieldValidationFormBloc');
    _isTinValidationRelaxed = relaxed;
    // if relaxed, we don't strictly require verification, so we don't change _isTinVerified
    _verifiedTinNumber = relaxed ? tinNumber.value : null;

    if (businessTypes.value?.id != BusinessTypeEnum.INDIVIDUAL.id) {
      if (relaxed) {
        // Validation is relaxed, so we no longer need the status validator.
        tinNumber.updateValidators([FieldBlocValidators.required]);
      } else {
        // Validation is not relaxed, add back the status validator if not already verified.
        if (!_isTinVerified) {
          tinNumber.updateValidators(
              [FieldBlocValidators.required, _validateTinStatus]);
        }
      }
    }

    tinNumber.updateExtraData({
      ...tinNumber.state.extraData as Map<dynamic, dynamic>? ?? {},
      'verified': relaxed,
    });
    tinNumber.validate();
  }

  void setPhoneVerified(bool verified) {
    log('Setting Phone verified: $verified',
        name: 'AsyncFieldValidationFormBloc');
    _isPhoneVerified = verified;
    _verifiedPhoneNumber = verified ? phoneNumber.value : null;
    phoneNumber.updateExtraData({
      ...phoneNumber.state.extraData as Map<dynamic, dynamic>? ?? {},
      'verified': verified,
    });
    // Update the phone verification field validation
    if (verified) {
      _phoneVerificationField
          .updateValidators([]); // Remove validation requirement
    } else {
      _phoneVerificationField.updateValidators([_validatePhoneNotVerified]);
    }
    _phoneVerificationField.validate();
    _phoneVerifiedController.add(verified);
  }

  bool get isPhoneVerified => _isPhoneVerified;

  bool get isTinVerified => _isTinVerified || _isTinValidationRelaxed;

  Stream<bool> get isPhoneVerifiedStream => _phoneVerifiedController.stream;

  Stream<Map<String, dynamic>> get otpVerificationStatusStream =>
      _otpVerificationStatusController.stream;

  bool get isVerifyingOtp => _isVerifyingOtp;

  String? get otpVerificationError => _otpVerificationError;

  @override
  Future<void> close() async {
    await _phoneVerifiedController.close();
    await _otpVerificationStatusController.close();
    await _phoneVerificationField.close();
    await super.close();
  }
}
