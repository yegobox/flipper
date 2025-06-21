import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'phone_auth_state.dart';

/// UI component for OTP verification
class VerificationUI extends StatelessWidget {
  final PhoneAuthState state;
  final ColorScheme colorScheme;
  final Animation<double> fadeAnimation;
  final Function() onVerifyCode;
  final Function() onResendCode;
  final Function() onChangePhoneNumber;

  const VerificationUI({
    Key? key,
    required this.state,
    required this.colorScheme,
    required this.fadeAnimation,
    required this.onVerifyCode,
    required this.onResendCode,
    required this.onChangePhoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.ease,
        child: Column(
          key: const ValueKey('verification_ui'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Illustration
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Image.asset(
                package: 'flipper_login',
                'assets/flipper_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.sms_outlined,
                  size: 80,
                  color: colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'Verification Code',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle with phone number
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Enter the 6-digit code sent to '),
                  TextSpan(
                    text:
                        '${state.selectedCountryCode} ${state.phoneController.text}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // PIN Code Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(16),
                  fieldHeight: 56,
                  fieldWidth: 44,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey.shade100,
                  selectedFillColor: colorScheme.primary.withOpacity(0.07),
                  activeColor: colorScheme.primary,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: colorScheme.primary,
                  fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 2),
                ),
                animationDuration: const Duration(milliseconds: 350),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                onCompleted: (v) {
                  state.smsCode = v;
                  onVerifyCode();
                },
                onChanged: (value) {
                  state.smsCode = value;
                },
              ),
            ),

            const SizedBox(height: 24),

            // Resend code timer or expiration notice
            Align(
              alignment: Alignment.center,
              child: state.otpExpired
                  ? TextButton(
                      onPressed: onResendCode,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'Code Expired - Tap to Resend',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : state.canResend
                      ? TextButton(
                          onPressed: onResendCode,
                          child: Text(
                            'Resend Code',
                            style: GoogleFonts.poppins(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: 'Resend code in '),
                              TextSpan(
                                text: '${state.timerSeconds} seconds',
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),

            const SizedBox(height: 40),

            // Verify Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.ease,
              height: 56,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
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
                onPressed: state.isLoading ? null : onVerifyCode,
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
                          Text('Verifying...',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      )
                    : Text('Verify Code',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 24),

            // Change number option
            Center(
              child: TextButton.icon(
                onPressed: state.isLoading ? null : onChangePhoneNumber,
                icon: Icon(Icons.edit, size: 18, color: colorScheme.primary),
                label: Text(
                  'Change Phone Number',
                  style: GoogleFonts.poppins(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
