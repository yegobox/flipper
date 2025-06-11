import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'phone_auth_state.dart';

/// UI component for phone number input
class PhoneInputUI extends StatelessWidget {
  final PhoneAuthState state;
  final ColorScheme colorScheme;
  final FirebaseUILocalizations l;
  final Function(BuildContext, String) onVerifyPhone;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder? footerBuilder;

  const PhoneInputUI({
    Key? key,
    required this.state,
    required this.colorScheme,
    required this.l,
    required this.onVerifyPhone,
    this.subtitleBuilder,
    this.footerBuilder,
  }) : super(key: key);

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (!RegExp(r'^\d{8,15}$')
        .hasMatch(value.replaceAll(RegExp(r'[^\d]'), ''))) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('phone_input'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo or illustration
        Container(
          height: 120,
          alignment: Alignment.center,
          child: Image.asset(
            package: 'flipper_login',
            'assets/flipper_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.phone_android,
              size: 80,
              color: colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Title
        Text(
          'Phone Verification',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(height: 12),

        // Subtitle
        Text(
          'We\'ll send a verification code to your phone number to verify your identity.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),

        if (subtitleBuilder != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              child: subtitleBuilder!(context),
            ),
          ),

        const SizedBox(height: 40),

        // Phone Input
        Form(
          key: state.formKey,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.ease,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 32,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  // Country code picker
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CountryCodePicker(
                        onChanged: (CountryCode code) {
                          state.selectedCountryCode = code.dialCode ?? '';
                        },
                        initialSelection: 'RW', // Rwanda
                        favorite: const ['RW'],
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                        padding: EdgeInsets.zero,
                        flagWidth: 28,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Vertical divider
                  Container(
                    height: 32,
                    width: 1.4,
                    color: Colors.grey.withOpacity(0.18),
                  ),
                  // Phone number field
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Focus(
                        child: TextFormField(
                          controller: state.phoneController,
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '783054874 (without leading 0)',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.withOpacity(0.5),
                              fontSize: 15,
                            ),
                            labelStyle: GoogleFonts.poppins(
                              color: colorScheme.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            helperStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.18),
                                width: 1.2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 18),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Continue Button
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.ease,
          height: 56,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return colorScheme.primary.withOpacity(0.5);
                }
                return colorScheme.primary;
              }),
              elevation: WidgetStateProperty.all(6),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              overlayColor: WidgetStateProperty.all(
                  colorScheme.primary.withOpacity(0.08)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: state.isLoading
                ? null
                : () {
                    print('Continue button pressed');
                    print('Phone number: ${state.phoneController.text}');
                    print('Country code: ${state.selectedCountryCode}');
                    onVerifyPhone(context, state.phoneController.text);
                  },
            child: state.isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text('Sending code...',
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  )
                : Text('Continue',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600)),
          ),
        ),

        const SizedBox(height: 24),

        // Terms and conditions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: 'By continuing, you agree to our ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Terms of Service
                    },
                ),
                const TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Privacy Policy
                    },
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        if (footerBuilder != null) footerBuilder!(context),
      ],
    );
  }
}
