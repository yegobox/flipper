import 'dart:developer';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_login/blocs/signup_form_bloc.dart';

/// UI components for the signup view aligned with the app's standard design system.
class SignupComponents {
  // App's standard color palette
  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color accentColor = Color(0xFF22D3EE);
  static const Color backgroundColor = Color(0xFFF5F8FD);
  static const Color textPrimary = Color(0xFF0B1220);
  static const Color textSecondary = Color(0xFF7E8AA0);
  static const Color errorColor = FlipperColors.error;
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
                  color: primaryColor.withValues(alpha: 0.1),
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
    Widget? prefix,
    bool showCompleteState = true,
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
          final isComplete = showCompleteState &&
              state.value.trim().isNotEmpty &&
              !state.hasError &&
              !state.isValidating;
          final borderColor =
              isComplete ? const Color(0xFFBFE6CF) : const Color(0xFFD6DEEA);

          return TextFieldBlocBuilder(
            textFieldBloc: fieldBloc,
            isEnabled: isEnabled,
            suffixButton: suffix != null || isComplete
                ? null
                : SuffixButton.asyncValidating,
            keyboardType: keyboardType ?? TextInputType.text,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              prefix: prefix,
              suffixIcon: suffix ??
                  (isComplete
                      ? const _FieldCompleteCheck()
                      : null),
              labelText: label,
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFAEB8CA)),
              prefixIcon: Icon(icon, color: textSecondary, size: 22),
              border: OutlineInputBorder(
                borderRadius: Corners.s12Border,
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: Corners.s12Border,
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: Corners.s12Border,
                borderSide: BorderSide(
                  color: isComplete ? const Color(0xFFBFE6CF) : primaryColor,
                  width: 1.8,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: Corners.s12Border,
                borderSide: const BorderSide(color: errorColor, width: 1),
              ),
              filled: true,
              fillColor:
                  isComplete ? const Color(0xFFFAFEFB) : const Color(0xFFF7F9FE),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              labelStyle: const TextStyle(
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelStyle: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
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
            borderRadius: Corners.s12Border,
            borderSide: const BorderSide(color: Color(0xFFD6DEEA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: Corners.s12Border,
            borderSide: const BorderSide(color: Color(0xFFD6DEEA)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: Corners.s12Border,
            borderSide: const BorderSide(color: primaryColor, width: 1.6),
          ),
          filled: true,
          fillColor: const Color(0xFFF7F9FE),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: const TextStyle(
            color: textSecondary,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        itemBuilder: itemBuilder,
        onChanged: onChanged,
      ),
    );
  }

  /// Build the submit button.
  /// Wraps in BlocBuilder on all relevant fields so the button re-evaluates
  /// whenever any field's state changes (username, fullName, phone, TIN, businessType, OTP).
  static Widget buildSubmitButton(
      AsyncFieldValidationFormBloc formBloc, bool isLoading) {
    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
      bloc: formBloc.username,
      builder: (context, usernameState) {
        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
          bloc: formBloc.fullName,
          builder: (context, fullNameState) {
            return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
              bloc: formBloc.phoneNumber,
              builder: (context, phoneState) {
                return BlocBuilder<SelectFieldBloc, SelectFieldBlocState>(
                  bloc: formBloc.businessTypes,
                  builder: (context, businessTypeState) {
                    return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
                      bloc: formBloc.otpCode,
                      builder: (context, otpState) {
                        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
                          bloc: formBloc.tinNumber,
                          builder: (context, tinState) {
                            // Manual validity checks that are robust across UI states
                            final hasUsername = usernameState.value.isNotEmpty;
                            final isUsernameValid = hasUsername &&
                                !usernameState.isValidating &&
                                !usernameState.hasError;

                            final hasFullName = fullNameState.value.isNotEmpty;
                            final hasPhone = phoneState.value.isNotEmpty;
                            final hasBusinessType =
                                businessTypeState.value != null;

                            // Source verification status directly from extraData for maximum reactivity
                            final isPhoneVerified =
                                (phoneState.extraData is Map &&
                                    (phoneState.extraData as Map)['verified'] ==
                                        true);

                            // Use the form bloc's getter which properly handles both strict and relaxed verification
                            final isTinVerified = formBloc.isTinVerified;

                            // Check if TIN is required and valid
                            final selectedBusinessType =
                                businessTypeState.value;
                            final isTinRequired =
                                selectedBusinessType != null &&
                                    selectedBusinessType.id != "2";

                            // If TIN is required, it must be filled and verified; if not required, it's automatically valid
                            final isTinValid = !isTinRequired ||
                                (tinState.value.toString().isNotEmpty &&
                                    isTinVerified &&
                                    !tinState.hasError);

                            // OTP field logic
                            final isOtpEnabled = (otpState.extraData is Map &&
                                (otpState.extraData as Map)['enabled'] == true);
                            final isOtpValid = isPhoneVerified ||
                                !isOtpEnabled ||
                                (otpState.value.isNotEmpty &&
                                    !otpState.hasError);

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

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: FlipperGradientButton(
                                text: 'Create account',
                                icon: Icons.person_add_alt_1_rounded,
                                isLoading: isLoading,
                                onPressed: (isLoading || !isValid)
                                    ? null
                                    : formBloc.submit,
                              ),
                            );
                          },
                        );
                      },
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
}

class _FieldCompleteCheck extends StatelessWidget {
  const _FieldCompleteCheck();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFF10B981),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 15,
          ),
        ),
      ),
    );
  }
}
