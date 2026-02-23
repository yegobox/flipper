import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_login/blocs/signup_form_bloc.dart';

/// UI components for the signup view aligned with the app's standard design system.
class SignupComponents {
  // App's standard color palette
  static const Color primaryColor = Color(0xFF0078D4);
  static const Color accentColor = Color(0xFF0078D4);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color.fromRGBO(117, 117, 117, 1);
  static const Color errorColor = Colors.red;
  static const Color surfaceColor = Colors.white;

  /// Build the header section with the app's branding.
  static Widget buildHeaderSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
              Image.asset(
                'assets/flipper_logo.png',
                height: 60,
              ),
            ],
          ),
        ),
        const Text(
          'Join Flipper',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Text(
            'Start your journey with us today 🚀',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  /// Build a styled input field.
  static Widget buildInputField({
    required TextFieldBloc fieldBloc,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: BlocBuilder<TextFieldBloc, TextFieldBlocState>(
        bloc: fieldBloc,
        builder: (context, state) {
          final isEnabled = (state.extraData is Map &&
                  (state.extraData as Map).containsKey('enabled'))
              ? (state.extraData as Map)['enabled'] as bool
              : true;

          return TextFieldBlocBuilder(
            textFieldBloc: fieldBloc,
            isEnabled: isEnabled,
            suffixButton: suffix != null ? null : SuffixButton.asyncValidating,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              suffixIcon: suffix,
              labelText: label,
              hintText: hint,
              hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)),
              prefixIcon: Icon(icon, color: textSecondary, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: errorColor, width: 1),
              ),
              filled: true,
              fillColor: surfaceColor,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              labelStyle: const TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelStyle: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textPrimary,
            ),
          );
        },
      ),
    );
  }

  /// Build a styled dropdown field.
  static Widget buildDropdownField<T>({
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
          prefixIcon: Icon(icon, color: textSecondary, size: 22),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textSecondary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          filled: true,
          fillColor: surfaceColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        itemBuilder: itemBuilder,
        onChanged: onChanged,
      ),
    );
  }

  /// Build the submit button.
  /// Wraps in a BlocBuilder on [formBloc.username] so the button re-evaluates
  /// whenever the username async validation completes (e.g. after the user
  /// corrects a "too long" or "already taken" error).
  static Widget buildSubmitButton(
      AsyncFieldValidationFormBloc formBloc, bool isLoading) {
    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
      bloc: formBloc.username,
      builder: (context, usernameState) {
        // Rebuild whenever phone or TIN verification extraData changes too.
        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
          bloc: formBloc.phoneNumber,
          builder: (context, phoneState) {
            return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
              bloc: formBloc.tinNumber,
              builder: (context, tinState) {
                // Manual validity checks that are robust across UI states
                final hasUsername = usernameState.value.isNotEmpty;
                final isUsernameValid = hasUsername &&
                    !usernameState.isValidating &&
                    !usernameState.hasError;

                final hasFullName = formBloc.fullName.value.isNotEmpty;
                final hasPhone = phoneState.value.isNotEmpty;
                final hasBusinessType = formBloc.businessTypes.value != null;

                // Source verification status directly from extraData for maximum reactivity
                final isPhoneVerified = (phoneState.extraData is Map &&
                    (phoneState.extraData as Map)['verified'] == true);

                // Use the form bloc's getter which properly handles both strict and relaxed verification
                final isTinVerified = formBloc.isTinVerified;

                // Check if TIN is required and valid
                final selectedBusinessType = formBloc.businessTypes.value;
                final isTinRequired = selectedBusinessType != null &&
                    selectedBusinessType.id != "2";

                // If TIN is required, it must be filled and verified; if not required, it's automatically valid
                final isTinValid = !isTinRequired ||
                    (tinState.value.toString().isNotEmpty &&
                        isTinVerified &&
                        !tinState.hasError);

                // OTP field logic
                final isOtpEnabled = (formBloc.otpCode.state.extraData is Map &&
                    (formBloc.otpCode.state.extraData as Map)['enabled'] ==
                        true);
                final isOtpValid = isPhoneVerified ||
                    !isOtpEnabled ||
                    (formBloc.otpCode.value.isNotEmpty &&
                        !formBloc.otpCode.state.hasError);

                final isValid = isUsernameValid &&
                    hasFullName &&
                    hasPhone &&
                    isPhoneVerified &&
                    hasBusinessType &&
                    isOtpValid &&
                    isTinValid;

                // Debug log to help identify which condition is failing
                log(
                    'Signup Button Status: '
                    'isValid: $isValid, '
                    'isUsernameValid: $isUsernameValid (hasVal: $hasUsername, isValing: ${usernameState.isValidating}, err: ${usernameState.hasError}), '
                    'hasFullName: $hasFullName, '
                    'hasPhone: $hasPhone, '
                    'isPhoneVerified: $isPhoneVerified, '
                    'hasBusinessType: $hasBusinessType, '
                    'isOtpValid: $isOtpValid, '
                    'isTinValid: $isTinValid (isReq: $isTinRequired, hasVal: ${tinState.value.toString().isNotEmpty}, isVer: $isTinVerified, hasErr: ${tinState.hasError})',
                    name: 'SignupComponents');

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (isLoading || !isValid) ? null : formBloc.submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
