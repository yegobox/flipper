import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

class PhoneInputView extends StatefulWidget {
  final FirebaseAuth? auth;
  final String pickedCountryCode;
  final AuthAction? action;
  final Object flowKey;
  final SMSCodeRequestedCallback? onSMSCodeRequested;
  final PhoneNumberSubmitCallback? onSubmit;
  final WidgetBuilder? subtitleBuilder;
  final WidgetBuilder? footerBuilder;
  final MultiFactorSession? multiFactorSession;
  final PhoneMultiFactorInfo? mfaHint;

  const PhoneInputView({
    super.key,
    required this.flowKey,
    this.onSMSCodeRequested,
    this.auth,
    this.action,
    required this.pickedCountryCode,
    this.onSubmit,
    this.subtitleBuilder,
    this.footerBuilder,
    this.multiFactorSession,
    this.mfaHint,
  });

  @override
  State<PhoneInputView> createState() => _PhoneInputViewState();
}

class _PhoneInputViewState extends State<PhoneInputView> {
  final phoneInputKey = GlobalKey<PhoneInputState>();
  bool isLoading = false;

  PhoneNumberSubmitCallback onSubmit(PhoneAuthController ctrl) =>
      (String phoneNumber) {
        if (widget.onSubmit != null) {
          widget.onSubmit!(phoneNumber);
        } else {
          ctrl.acceptPhoneNumber(
            phoneNumber,
            widget.multiFactorSession,
          );
        }
      };

  void _next(PhoneAuthController ctrl) {
    final number = PhoneInput.getPhoneNumber(phoneInputKey);
    if (number != null) {
      setState(() => isLoading = true);
      onSubmit(ctrl)(number);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = FirebaseUILocalizations.labelsOf(context);
    final theme = Theme.of(context);

    return AuthFlowBuilder<PhoneAuthController>(
      flowKey: widget.flowKey,
      action: widget.action,
      auth: widget.auth,
      listener: (oldState, newState, controller) {
        if (newState is SMSCodeRequested) {
          setState(() => isLoading = false);
          final cb = widget.onSMSCodeRequested ??
              FirebaseUIAction.ofType<SMSCodeRequestedAction>(context)
                  ?.callback;

          cb?.call(
            context,
            widget.action,
            widget.flowKey,
            PhoneInput.getPhoneNumber(phoneInputKey)!,
          );
        }

        if (newState is SignedIn) {
          setState(() => isLoading = true);
        }

        if (newState is AuthFailed) {
          setState(() => isLoading = false);
        }
      },
      builder: (context, state, ctrl, child) {
        var inputCountryCode = widget.pickedCountryCode;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localization.phoneVerificationViewTitleText,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (widget.subtitleBuilder != null)
                widget.subtitleBuilder!(context),
              if (state is AwaitingPhoneNumber ||
                  state is SMSCodeRequested) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: PhoneInput(
                    initialCountryCode: inputCountryCode,
                    onSubmit: onSubmit(ctrl),
                    key: phoneInputKey,
                  ),
                ),
                const SizedBox(height: 24),
                FlipperButton(
                  color: theme.primaryColor,
                  text: isLoading
                      ? 'Please wait...'
                      : localization.verifyPhoneNumberButtonText,
                  onPressed: isLoading ? null : () => _next(ctrl),
                  isLoading: isLoading,
                ),
              ],
              if (state is AuthFailed) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ErrorText(
                    exception: state.exception,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (widget.footerBuilder != null) widget.footerBuilder!(context),
            ],
          ),
        );
      },
    );
  }
}
