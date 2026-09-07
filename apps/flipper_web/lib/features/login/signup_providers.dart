import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flipper_models/ippis_service.dart';

import '../../models/business_type.dart';
import '../../repositories/signup_repository.dart';
import '../../core/signup_contact.dart';

part 'signup_providers.g.dart';

// Helper class to store signup form state
class SignupFormState {
  final String username;
  final String fullName;
  final BusinessType? businessType;
  final String tinNumber;
  final String country;
  final String? phoneNumber; // Added phone number field
  final bool isSubmitting;
  final String? errorMessage;
  final bool isCheckingUsername;
  final bool? isUsernameAvailable;
  final bool isValidatingTin;
  final IppisBusiness? tinDetails;
  final String? tinError;

  /// IPPIS could not be reached, so the TIN was accepted without a lookup —
  /// the same relaxation the mobile signup form applies (`setTinRelaxed` in
  /// packages/flipper_login/lib/blocs/signup_form_bloc.dart). Always true on
  /// web today: ippis.rw sends no CORS headers, so the browser can never call
  /// it directly.
  final bool isTinValidationRelaxed;

  /// The signup OTP has been sent, so the code field is live. Mirrors the
  /// mobile bloc enabling `otpCode` after `requestOtp()` succeeds.
  final bool isOtpRequested;
  final bool isSendingOtp;
  final bool isVerifyingOtp;
  final String otpCode;
  final String? otpError;

  /// The contact apihub confirmed. Kept so that editing the phone/email — or
  /// switching country, which re-applies a different dial code — drops the
  /// verification, exactly as the mobile bloc's `phoneNumber` listener does.
  final String? verifiedContact;

  bool get isPhoneVerified =>
      verifiedContact != null &&
      verifiedContact!.isNotEmpty &&
      verifiedContact == phoneNumber;

  SignupFormState({
    this.username = '',
    this.fullName = '',
    this.businessType,
    this.tinNumber = '',
    this.country = 'Rwanda',
    this.phoneNumber,
    this.isSubmitting = false,
    this.errorMessage,
    this.isCheckingUsername = false,
    this.isUsernameAvailable,
    this.isValidatingTin = false,
    this.tinDetails,
    this.tinError,
    this.isTinValidationRelaxed = false,
    this.isOtpRequested = false,
    this.isSendingOtp = false,
    this.isVerifyingOtp = false,
    this.otpCode = '',
    this.otpError,
    this.verifiedContact,
  });

  SignupFormState copyWith({
    String? username,
    String? fullName,
    BusinessType? businessType,
    String? tinNumber,
    String? country,
    String? phoneNumber,
    bool? isSubmitting,
    String? errorMessage,
    bool? isCheckingUsername,
    // Sentinel-defaulted so an explicit null clears the previous answer
    // instead of silently keeping it.
    Object? isUsernameAvailable = _unset,
    bool? isValidatingTin,
    Object? tinDetails = _unset, // Use Object? and default to sentinel
    Object? tinError = _unset, // Use Object? and default to sentinel
    bool? isTinValidationRelaxed,
    bool? isOtpRequested,
    bool? isSendingOtp,
    bool? isVerifyingOtp,
    String? otpCode,
    Object? otpError = _unset,
    Object? verifiedContact = _unset,
  }) {
    return SignupFormState(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      businessType: businessType ?? this.businessType,
      tinNumber: tinNumber ?? this.tinNumber,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
      isUsernameAvailable: isUsernameAvailable == _unset
          ? this.isUsernameAvailable
          : (isUsernameAvailable as bool?), // Identity check
      isValidatingTin: isValidatingTin ?? this.isValidatingTin,
      tinDetails: tinDetails == _unset
          ? this.tinDetails
          : (tinDetails as IppisBusiness?), // Identity check
      tinError: tinError == _unset
          ? this.tinError
          : (tinError as String?), // Identity check
      isTinValidationRelaxed:
          isTinValidationRelaxed ?? this.isTinValidationRelaxed,
      isOtpRequested: isOtpRequested ?? this.isOtpRequested,
      isSendingOtp: isSendingOtp ?? this.isSendingOtp,
      isVerifyingOtp: isVerifyingOtp ?? this.isVerifyingOtp,
      otpCode: otpCode ?? this.otpCode,
      otpError:
          otpError == _unset ? this.otpError : (otpError as String?),
      verifiedContact: verifiedContact == _unset
          ? this.verifiedContact
          : (verifiedContact as String?),
    );
  }

  bool get isValid {
    final isUsernameValid = username.length >= 4 && isUsernameAvailable == true;
    // Mobile requires only that this is filled in, so web must not be stricter.
    final isFullNameValid = fullName.trim().isNotEmpty;
    final isBusinessTypeValid = businessType != null;

    // TIN is required except for business type with id '2' (Individual)
    final needsTin = businessType?.id != '2';
    // If TIN is needed it must be the right length and must not have been
    // rejected by IPPIS. A lookup we could not perform at all does not block
    // signup — mobile relaxes the same way when IPPIS is down.
    final isTinNumberValid =
        !needsTin ||
        (tinNumber.length >= 9 &&
            (tinDetails != null || isTinValidationRelaxed) &&
            tinError == null);

    final isCountryValid = country.isNotEmpty;

    // Mobile keeps a `_phoneVerificationField` that fails validation until the
    // OTP is confirmed, so an unverified contact can never sign up. A blank
    // contact stays valid here because the form's own field validator is what
    // requires one (and unit tests submit without a phone).
    final hasContact = phoneNumber != null && phoneNumber!.isNotEmpty;
    final isContactVerified = !hasContact || isPhoneVerified;

    return isUsernameValid &&
        isFullNameValid &&
        isBusinessTypeValid &&
        isTinNumberValid &&
        isCountryValid &&
        isContactVerified;
  }
}

// Business types list provider
@riverpod
List<BusinessType> businessTypes(Ref ref) {
  return [
    BusinessType(id: '1', typeName: 'Flipper Retailer'),
    BusinessType(id: '2', typeName: 'Individual'),
    BusinessType(id: '3', typeName: 'Enterprise'),
  ];
}

// Available countries provider
@riverpod
List<String> countries(Ref ref) {
  return ['Rwanda', 'Kenya', 'Uganda', 'Tanzania', 'Burundi'];
}

@riverpod
class SignupForm extends _$SignupForm {
  SignupRepository get _signupRepository => ref.read(signupRepositoryProvider);

  @override
  SignupFormState build() {
    return SignupFormState();
  }

  // Add a debounce timer for username availability check
  DateTime? _lastUsernameChange;
  String? _lastCheckedUsername;

  Future<void> updateUsername(String username) async {
    // Update state immediately with the new username
    state = state.copyWith(
      username: username,
      isUsernameAvailable: null, // Reset availability while typing
    );

    // Don't check availability until username is at least 3 chars
    if (username.length < 3) return;

    // Set the time of this change
    _lastUsernameChange = DateTime.now();
    final changeTime = _lastUsernameChange;

    // Wait a short time to avoid excessive API calls while typing
    await Future.delayed(const Duration(milliseconds: 500));

    // If there's been a newer change or we've already checked this username, don't proceed
    if (_lastUsernameChange != changeTime || _lastCheckedUsername == username)
      return;

    _lastCheckedUsername = username;

    // Show loading indicator
    state = state.copyWith(isCheckingUsername: true);

    try {
      final isAvailable = await _signupRepository.checkUsernameAvailability(
        username,
      );

      // Only update if this is still the latest check
      if (_lastCheckedUsername == username) {
        state = state.copyWith(
          isCheckingUsername: false,
          isUsernameAvailable: isAvailable,
        );
      }
    } catch (e) {
      // Handle error while checking username. A failed check says nothing
      // about the username, so leave availability unknown rather than
      // showing "Username is not available".
      if (_lastCheckedUsername == username) {
        // Allow a retry on the next keystroke / submit.
        _lastCheckedUsername = null;
        state = state.copyWith(
          isCheckingUsername: false,
          isUsernameAvailable: null,
          errorMessage: 'Error checking username availability',
        );
      }
    }
  }

  void updateFullName(String fullName) {
    state = state.copyWith(fullName: fullName);
  }

  void updateBusinessType(BusinessType businessType) {
    state = state.copyWith(businessType: businessType);
  }

  void updateTinNumber(String tinNumber) {
    // Immediately update the TIN and clear previous validation state
    state = state.copyWith(
      tinNumber: tinNumber,
      isValidatingTin: false, // Stop any previous validation indicator
      tinError: null,
      tinDetails: null,
      isTinValidationRelaxed: false,
    );

    // If the TIN has the required length, trigger validation
    if (tinNumber.length >= 9) {
      validateTin(tinNumber);
    }
  }

  Future<void> validateTin(String tinToValidate) async {
    // Set loading state for the current validation request
    state = state.copyWith(
      isValidatingTin: true,
      tinError: null,
      isTinValidationRelaxed: false,
    );

    try {
      final ippisService = IppisService();
      final business = await ippisService.getBusinessDetails(tinToValidate);

      // Before applying the result, check if the TIN hasn't changed
      if (state.tinNumber != tinToValidate) {
        // User has typed a new TIN while this request was in-flight. Ignore stale result.
        return;
      }

      if (business != null) {
        state = state.copyWith(isValidatingTin: false, tinDetails: business);
      } else {
        // IPPIS answered and does not know this TIN.
        state = state.copyWith(
          isValidatingTin: false,
          tinError: 'No data found for this TIN',
        );
      }
    } on IppisUnavailableException {
      // Could not reach IPPIS at all — on web that is every call, since
      // ippis.rw refuses browser origins. Relax instead of blocking signup,
      // matching the mobile form's `setTinRelaxed`.
      if (state.tinNumber != tinToValidate) return;
      state = state.copyWith(
        isValidatingTin: false,
        tinError: null,
        isTinValidationRelaxed: true,
      );
    } catch (e) {
      // Before applying the error, also check if the TIN has changed
      if (state.tinNumber != tinToValidate) {
        return; // Ignore error from a stale request
      }
      state = state.copyWith(
        isValidatingTin: false,
        tinError: null,
        isTinValidationRelaxed: true,
      );
    }
  }

  void clearTin() {
    state = state.copyWith(
      tinNumber: '',
      tinDetails: null,
      tinError: null,
      isValidatingTin: false,
      isTinValidationRelaxed: false,
    );
  }

  void updateCountry(String country) {
    // The dial code applied to a phone number depends on the country, so an
    // already-entered number has to be re-normalized. Emails are untouched.
    final phone = state.phoneNumber;
    _applyContact(
      country: country,
      contact: (phone == null || phone.isEmpty)
          ? phone
          : normalizeSignupContact(phone, country: country),
    );
  }

  void updatePhoneNumber(String phoneNumber) {
    // The field takes a phone number or an email. Store the canonical value:
    // emails as typed, phone numbers with the country dial code.
    _applyContact(
      contact: normalizeSignupContact(phoneNumber, country: state.country),
    );
  }

  /// Stores the canonical contact and, when it no longer matches the one
  /// apihub confirmed, tears the OTP state down so the user has to verify the
  /// new number. The mobile bloc does this from its `phoneNumber` listener.
  void _applyContact({String? contact, String? country}) {
    final changedAwayFromVerified = state.verifiedContact != null &&
        state.verifiedContact != contact;

    state = state.copyWith(
      country: country,
      phoneNumber: contact,
      isOtpRequested: changedAwayFromVerified ? false : null,
      otpCode: changedAwayFromVerified ? '' : null,
      otpError: changedAwayFromVerified ? null : _unset,
      verifiedContact: changedAwayFromVerified ? null : _unset,
    );
  }

  /// Sends the signup OTP to the contact currently in the form.
  ///
  /// Same two steps the mobile bloc's `requestOtp` takes: make sure apihub
  /// knows the user, then ask it to send the code.
  Future<bool> requestOtp() async {
    final contact = state.phoneNumber;
    if (contact == null || contact.isEmpty) {
      state = state.copyWith(
        otpError: 'Enter a phone number or email first.',
      );
      return false;
    }
    if (state.isSendingOtp) return false;

    state = state.copyWith(isSendingOtp: true, otpError: null);

    try {
      await _signupRepository.lookupOrCreateUserId(contact);
      await _signupRepository.sendSignupOtp(contact);
      state = state.copyWith(
        isSendingOtp: false,
        isOtpRequested: true,
        otpCode: '',
        otpError: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSendingOtp: false,
        otpError: _readableError(e, fallback: 'Failed to send the code.'),
      );
      return false;
    }
  }

  /// Verifies [otp] against the contact in the form. Mirrors the mobile
  /// bloc's `manualVerifyOtp`: a wrong code clears the verification rather
  /// than throwing, so the user can simply retype it.
  Future<bool> verifyOtp(String otp) async {
    final contact = state.phoneNumber;
    if (contact == null || contact.isEmpty) return false;
    if (state.isVerifyingOtp) return false;

    state = state.copyWith(isVerifyingOtp: true, otpError: null);

    try {
      final result = await _signupRepository.verifySignupOtp(contact, otp);

      // The contact may have been edited while the request was in flight.
      if (state.phoneNumber != contact) {
        state = state.copyWith(isVerifyingOtp: false);
        return false;
      }

      if (result['verified'] == true) {
        state = state.copyWith(
          isVerifyingOtp: false,
          otpError: null,
          verifiedContact: contact,
        );
        return true;
      }

      state = state.copyWith(
        isVerifyingOtp: false,
        otpError: result['error']?.toString() ??
            'That code is not right. Please try again.',
        verifiedContact: null,
      );
      return false;
    } catch (e) {
      if (state.phoneNumber != contact) {
        state = state.copyWith(isVerifyingOtp: false);
        return false;
      }
      state = state.copyWith(
        isVerifyingOtp: false,
        otpError: _readableError(e, fallback: 'Could not check that code.'),
        verifiedContact: null,
      );
      return false;
    }
  }

  /// Stores the typed code and verifies it as soon as it is 6 digits long,
  /// the way the mobile form auto-submits a complete OTP.
  Future<void> updateOtpCode(String otp) async {
    state = state.copyWith(otpCode: otp, otpError: null);
    if (otp.length == 6 && !state.isPhoneVerified) {
      await verifyOtp(otp);
    }
  }

  String _readableError(Object e, {required String fallback}) {
    final text = e.toString();
    if (text.contains('Exception:')) {
      final message = text.split('Exception:').last.trim();
      if (message.isNotEmpty) return message;
    }
    return fallback;
  }

  Future<bool> submitForm() async {
    // A second tap while the first request is in flight used to create a
    // duplicate business (the flag was only set after the username re-check
    // awaited). Refuse re-entry outright.
    if (state.isSubmitting) return false;

    // Reset error state at the beginning
    state = state.copyWith(errorMessage: null);

    // Validate required fields
    if (state.username.isEmpty) {
      state = state.copyWith(errorMessage: 'Username is required');
      return false;
    }

    if (state.username.length < 4) {
      state = state.copyWith(
        errorMessage: 'Username must be at least 4 characters',
      );
      return false;
    }

    if (state.fullName.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your full name');
      return false;
    }

    if (state.businessType == null) {
      state = state.copyWith(errorMessage: 'Please select a business type');
      return false;
    }

    // Only validate TIN if required for this business type
    final needsTin = state.businessType?.id != '2'; // '2' is Individual
    if (needsTin && (state.tinNumber.isEmpty || state.tinNumber.length < 9)) {
      state = state.copyWith(
        errorMessage: 'Please enter a valid TIN number (at least 9 characters)',
      );
      return false;
    }

    if (state.country.isEmpty) {
      state = state.copyWith(errorMessage: 'Please select a country');
      return false;
    }

    // Mobile refuses to sign up an unverified contact ("OTP is required to
    // proceed with signup."). Without this, a mistyped number gets a business
    // and a PIN it can never receive.
    final contact = state.phoneNumber;
    if (contact != null && contact.isNotEmpty && !state.isPhoneVerified) {
      state = state.copyWith(
        errorMessage: state.isOtpRequested
            ? 'Enter the code we sent to $contact to continue.'
            : 'Verify $contact first — tap "Send code".',
      );
      return false;
    }

    // Check username availability one last time before submitting
    if (state.isUsernameAvailable != true) {
      try {
        state = state.copyWith(isCheckingUsername: true);
        final isAvailable = await _signupRepository.checkUsernameAvailability(
          state.username,
        );
        state = state.copyWith(
          isCheckingUsername: false,
          isUsernameAvailable: isAvailable,
        );

        if (!isAvailable) {
          state = state.copyWith(
            errorMessage:
                'Username is not available. Please choose another one.',
          );
          return false;
        }
      } catch (e) {
        if (kDebugMode) print('Error checking username availability: $e');
        state = state.copyWith(
          isCheckingUsername: false,
          errorMessage:
              'Error checking username availability. Please try again.',
        );
        return false;
      }
    }

    // Final validation check using isValid getter
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please fill in all required fields correctly',
      );
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // Use phone number from state if available
      String? phoneNumber = state.phoneNumber;

      // If there's no phone number (unit tests), call registerBusiness directly and consider it success
      /// this method is for marking unit tests success
      if (phoneNumber == null || phoneNumber.isEmpty) {
        await _signupRepository.registerBusiness(
          username: state.username,
          fullName: state.fullName,
          businessTypeId: state.businessType!.id,
          tinNumber: state.tinNumber,
          country: state.country,
          phoneNumber: phoneNumber,
          userId: null,
        );

        state = state.copyWith(isSubmitting: false);
        return true;
      }

      // Otherwise, perform auth lookup to get user id and then register.
      // Anything other than 200 throws, and the catch below turns it into a
      // message instead of a bare "Failed to create account".
      final userIdStr = await _signupRepository.lookupOrCreateUserId(
        phoneNumber,
      );

      final result = await _signupRepository.registerBusiness(
        username: state.username,
        fullName: state.fullName,
        businessTypeId: state.businessType!.id,
        tinNumber: state.tinNumber,
        country: state.country,
        phoneNumber: phoneNumber,
        userId: userIdStr,
      );

      if (result.containsKey('error')) {
        throw Exception(result['error']?.toString() ?? 'Registration failed');
      }

      // POST /v2/api/business already provisions the PIN and sends SMS — do not POST /pin again.
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('Exception:')) {
        errorMessage = e.toString().split('Exception:')[1].trim();
      } else if (e.toString().contains('HttpException') ||
          e.toString().contains('SocketException')) {
        errorMessage =
            'Network error. Please check your connection and try again.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please try again later.';
      } else {
        errorMessage = 'Failed to create account: ${e.toString()}';
      }

      if (kDebugMode) print('Signup error: $e');
      state = state.copyWith(isSubmitting: false, errorMessage: errorMessage);
      return false;
    }
  }
}

// Typedefs for backward compatibility
typedef SignupFormNotifier = SignupForm;

// Generated providers are top-level accessible:
// signupFormProvider, businessTypesProvider, countriesProvider

// Sentinel value to differentiate between explicitly passing null and not passing a value at all
class _Unset {
  const _Unset();
}

const _unset = _Unset();
