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
  static Widget buildSubmitButton(
      AsyncFieldValidationFormBloc formBloc, bool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      height: 52,
      child: BlocBuilder<AsyncFieldValidationFormBloc,
          FormBlocState<String, String>>(
        bloc: formBloc,
        builder: (context, state) {
          // Check if the form is valid AND all required fields have been validated
          // Note: state.isValid() sometimes reports false if there are hidden fields
          // with validation errors or if async validation hasn't finished.

          // Additional validation checks for specific fields
          final isUsernameValid = formBloc.username.value.isNotEmpty &&
              formBloc.username.state.isValid;
          final isFullNameValid = formBloc.fullName.value.isNotEmpty &&
              formBloc.fullName.state.isValid;
          final isPhoneValid = formBloc.phoneNumber.value.isNotEmpty &&
              formBloc.phoneNumber.state.isValid;
          final isBusinessTypeValid = formBloc.businessTypes.value != null &&
              formBloc.businessTypes.state.isValid;

          // Crucial: check if phone is verified via the OTP flow
          // The BLoC manages this state explicitly.
          final isPhoneVerified = formBloc.isPhoneVerified;

          // Check if OTP is enabled and if so, it must be valid
          final isOtpEnabled = (formBloc.otpCode.state.extraData
                  as Map<String, dynamic>?)?['enabled'] ==
              true;
          final isOtpValid = !isOtpEnabled ||
              (formBloc.otpCode.value.isNotEmpty &&
                  formBloc.otpCode.state.isValid);

          // Check if TIN is required and valid (for non-individual business types)
          final isTinRequired = formBloc.businessTypes.value?.id != "2";
          // TIN validation passes if: not required (individual), or validated successfully
          final isTinValid = !isTinRequired || formBloc.tinNumber.state.isValid;

          // Overall validity depends on all required validations passing
          // We prioritize our explicit checks over state.isValid() if needed,
          // but usually state.isValid() should reflect these.
          final isValid = isUsernameValid &&
              isFullNameValid &&
              isPhoneValid &&
              isBusinessTypeValid &&
              isPhoneVerified &&
              isOtpValid &&
              isTinValid;

          return ElevatedButton(
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
          );
        },
      ),
    );
  }
}
