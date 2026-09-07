import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/business_type.dart';
import '../../core/signup_contact.dart';
import 'signup_providers.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _formKey = GlobalKey<FormState>();
  bool _showTinField = true;

  late final TextEditingController _phoneController;
  late final TextEditingController _tinController;
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(signupFormProvider);
    // Holds only what the user types: the local phone digits, or a full email.
    // The dial code is rendered as a prefix instead of being baked into the
    // text, so an email can be typed into the same field.
    _phoneController = TextEditingController(
      text: localPhonePart(state.phoneNumber ?? ''),
    );
    _phoneController.addListener(() {
      ref.read(signupFormProvider.notifier).updatePhoneNumber(_phoneController.text);
    });
    _tinController = TextEditingController(text: state.tinNumber);
    _tinController.addListener(() {
      if (_tinController.text != ref.read(signupFormProvider).tinNumber) {
        ref.read(signupFormProvider.notifier).updateTinNumber(_tinController.text);
      }
    });
    // The notifier verifies as soon as the code is 6 digits long, the way the
    // mobile form auto-submits a complete OTP.
    _otpController = TextEditingController(text: state.otpCode);
    _otpController.addListener(() {
      if (_otpController.text != ref.read(signupFormProvider).otpCode) {
        ref.read(signupFormProvider.notifier).updateOtpCode(_otpController.text);
      }
    });
  }

  ScaffoldMessengerState? _messenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Held so dispose() can clear our snackbars without a BuildContext lookup.
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    // The messenger lives above the router, so anything still showing would
    // follow the user onto the next screen — a "Code sent to …" from signup
    // was surviving all the way onto the sign-in page.
    _messenger?.clearSnackBars();
    _phoneController.dispose();
    _tinController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    // Replace whatever is showing. Queued snackbars play one after another,
    // which reads as one message that will not go away.
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SITokens.danger,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// [offerSignIn] adds the "Sign in" shortcut. Only the account-created
  /// message wants it — offering it on "Code sent to …" invited the user to
  /// abandon a signup they were halfway through.
  void _showSuccess(String message, {bool offerSignIn = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: SITokens.win,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        duration: const Duration(seconds: 4),
        action: offerSignIn
            ? SnackBarAction(
                label: 'Sign in',
                textColor: Colors.white,
                onPressed: () {
                  try {
                    context.go('/login');
                  } catch (_) {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
      ),
    );
  }

  // Progress computed from form state.
  int _completedCount(SignupFormState s) {
    int count = 0;
    if (s.username.length >= 4 && s.isUsernameAvailable == true) count++;
    if (s.fullName.trim().isNotEmpty) count++;
    if (s.isPhoneVerified) count++;
    if (s.businessType != null) count++;
    if (_showTinField && (s.tinDetails != null || s.isTinValidationRelaxed)) {
      count++;
    }
    if (s.country.isNotEmpty) count++;
    return count;
  }

  int _totalFields() => _showTinField ? 6 : 5;

  @override
  Widget build(BuildContext context) {
    final formState  = ref.watch(signupFormProvider);
    final bizTypes   = ref.watch(businessTypesProvider);
    final countries  = ref.watch(countriesProvider);

    final completed = _completedCount(formState);
    final total     = _totalFields();
    final progress  = completed / total;
    final xp        = completed * (100 ~/ total);

    return Scaffold(
      backgroundColor: SITokens.surface2,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= SITokens.desktopBreakpoint) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _buildFormColumn(
                      formState: formState,
                      bizTypes: bizTypes,
                      countries: countries,
                      progress: progress,
                      xp: xp,
                      compact: false,
                    ),
                  ),
                  const Expanded(child: BrandPanel()),
                ],
              );
            }
            return _buildFormColumn(
              formState: formState,
              bizTypes: bizTypes,
              countries: countries,
              progress: progress,
              xp: xp,
              compact: true,
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormColumn({
    required SignupFormState formState,
    required List<BusinessType> bizTypes,
    required List<String> countries,
    required double progress,
    required int xp,
    required bool compact,
  }) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        compact ? 22 : 48,
        compact ? 10 : 40,
        compact ? 22 : 48,
        28,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: compact ? double.infinity : 460),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    const FlipperBrandBadge(size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flipper',
                            style:
                                Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: SITokens.ink1,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                          Text(
                            'Business setup',
                            style: context.siText(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: SITokens.ink3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FlipperRewardChip(points: xp),
                  ],
                ),
                const SizedBox(height: 20),
                FlipperProgressRewardCard(progress: progress, points: xp),
                const SizedBox(height: 20),
                FlipperOnboardingPanel(
                  padding: const EdgeInsets.all(22),
                  children: [
                    Text(
                      'Create your account',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: SITokens.ink1,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Set up your Flipper business account to get started.',
                      style: context.siText(
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: SITokens.ink2,
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Username
                    _FieldLabel(label: 'Username'),
                    _buildUsernameField(formState),
                    const SizedBox(height: 18),

                    // Full name
                    _FieldLabel(label: 'Full name'),
                    _buildInputField(
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.badge_outlined,
                      initialValue: formState.fullName,
                      validator: (v) {
                        // Mobile only requires this to be non-empty
                        // (FieldBlocValidators.required). Demanding two words
                        // rejected perfectly real single names and gave no hint
                        // that a space was what it wanted.
                        if (v == null || v.trim().isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                      onChanged: (v) => ref
                          .read(signupFormProvider.notifier)
                          .updateFullName(v),
                    ),
                    const SizedBox(height: 18),

                    // Phone
                    _FieldLabel(label: 'Phone / Email'),
                    _buildPhoneField(formState),
                    _buildOtpSection(formState),
                    const SizedBox(height: 18),

                    // Business type
                    _FieldLabel(label: 'Usage'),
                    _buildDropdown<BusinessType>(
                      hintText: 'How you intend to use Flipper',
                      prefixIcon: Icons.business_outlined,
                      value: formState.businessType,
                      items: bizTypes,
                      itemLabel: (t) => t.typeName,
                      validator: (v) =>
                          v == null ? 'Please select a business type' : null,
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(signupFormProvider.notifier)
                              .updateBusinessType(v);
                          setState(() { _showTinField = v.id != '2'; });
                        }
                      },
                    ),
                    const SizedBox(height: 18),

                    // TIN (conditional)
                    if (_showTinField) ...[
                      _FieldLabel(label: 'TIN Number'),
                      _buildTinField(formState),
                      if (formState.tinDetails != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Business: ${formState.tinDetails!.taxPayerName}',
                            style: context.siText(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: SITokens.win,
                            ),
                          ),
                        ),
                      if (formState.tinError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            formState.tinError!,
                            style: context.siText(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: SITokens.danger,
                            ),
                          ),
                        ),
                      // Mobile shows "Service Unavailable: Validation skipped"
                      // and lets signup continue; say the same here rather
                      // than blocking on a lookup we could not perform.
                      if (formState.isTinValidationRelaxed)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'TIN lookup unavailable — validation skipped.',
                            style: context.siText(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: SITokens.ink3,
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),
                    ],

                    // Country
                    _FieldLabel(label: 'Country'),
                    _buildDropdown<String>(
                      hintText: 'Select your country',
                      prefixIcon: Icons.public_outlined,
                      value: formState.country,
                      items: countries,
                      itemLabel: (c) => c,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Please select a country' : null,
                      onChanged: (v) {
                        if (v != null) {
                          // The field keeps the local part; the notifier
                          // re-applies the new country's dial code.
                          ref.read(signupFormProvider.notifier).updateCountry(v);
                        }
                      },
                    ),
                    const SizedBox(height: 26),

                    FlipperGradientButton(
                      text: 'Create account',
                      icon: Icons.chevron_right_rounded,
                      isLoading: formState.isSubmitting,
                      onPressed: formState.isSubmitting ? null : _handleSubmit,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () {
                    try {
                      context.go('/login');
                    } catch (_) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Already have an account? Sign in',
                    style: context.siText(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: SITokens.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formState = ref.read(signupFormProvider);
    final contact = formState.phoneNumber;
    if (contact != null && contact.isNotEmpty && !formState.isPhoneVerified) {
      _showError(
        formState.isOtpRequested
            ? 'Enter the code we sent to $contact to continue.'
            : 'Verify $contact first — tap "Send code".',
      );
      return;
    }
    if (formState.isUsernameAvailable != true) {
      _showError(
        'Please choose a different username. The current one is not available or has not been verified.',
      );
      return;
    }

    final success = await ref.read(signupFormProvider.notifier).submitForm();
    if (!mounted) return;
    if (success) {
      _showSuccess('Account created successfully!', offerSignIn: true);
      try {
        context.go('/login');
      } catch (_) {
        Navigator.pop(context);
      }
    } else {
      final msg = ref.read(signupFormProvider).errorMessage ??
          'Failed to create account. Please try again.';
      _showError(msg);
    }
  }

  Widget _buildUsernameField(SignupFormState state) {
    return TextFormField(
      initialValue: state.username,
      onChanged: (v) =>
          ref.read(signupFormProvider.notifier).updateUsername(v),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Username is required';
        if (v.length < 4) return 'Username must be at least 4 characters';
        if (state.isUsernameAvailable == false) return 'Username is not available';
        return null;
      },
      decoration: siInputDecoration(
        hintText: 'Enter your username',
        prefixIcon: Icons.person_outline_rounded,
        suffixIcon: state.username.length >= 3
            ? _usernameIcon(state.isCheckingUsername, state.isUsernameAvailable)
            : null,
      ),
    );
  }

  Widget _usernameIcon(bool checking, bool? available) {
    if (checking) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    if (available == true) {
      return const Icon(Icons.check_circle, color: SITokens.win);
    }
    if (available == false) {
      return const Icon(Icons.cancel, color: SITokens.danger);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInputField({
    required String hintText,
    required IconData prefixIcon,
    String? initialValue,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      decoration: siInputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildPhoneField(SignupFormState state) {
    // Mirrors the mobile signup field: the dial-code chip shows while the input
    // is a phone number and disappears as soon as the user types '@'.
    final isEmail = looksLikeEmailContact(state.phoneNumber ?? '');
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.text,
      validator: (v) {
        final raw = (v ?? '').trim();
        if (raw.isEmpty) return 'Phone number or email is required';
        if (looksLikeEmailContact(raw)) {
          return isEmailContact(raw)
              ? null
              : 'Please enter a valid email address';
        }
        if (raw.replaceAll(RegExp(r'[^0-9+]'), '').length < 9) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
      decoration: siInputDecoration(
        hintText: '783054874 or your@email.com',
        prefixIcon: Icons.phone_outlined,
        suffixIcon: _buildOtpAction(state),
      ).copyWith(
        prefix: isEmail ? null : _DialCodeChip(code: signupDialCode(state.country)),
      ),
    );
  }

  /// Whether the contact currently typed is complete enough to send a code to,
  /// using the same rules as the field's own validator.
  bool _contactLooksSendable(SignupFormState state) {
    final raw = (state.phoneNumber ?? '').trim();
    if (raw.isEmpty) return false;
    if (looksLikeEmailContact(raw)) return isEmailContact(raw);
    return raw.replaceAll(RegExp(r'[^0-9]'), '').length >= 9;
  }

  /// The send / resend / verified affordance inside the contact field — the
  /// mobile form puts the same control in the same place.
  Widget? _buildOtpAction(SignupFormState state) {
    if (state.isPhoneVerified) {
      return const Icon(Icons.verified, color: SITokens.win);
    }
    if (state.isSendingOtp || state.isVerifyingOtp) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final canSend = _contactLooksSendable(state);
    return TextButton(
      onPressed: canSend ? _handleSendOtp : null,
      child: Text(
        state.isOtpRequested ? 'Resend' : 'Send code',
        style: context.siText(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: canSend ? SITokens.blue : SITokens.ink3,
        ),
      ),
    );
  }

  /// The 6-digit code field. Only appears once a code has been sent, and
  /// disappears again once the contact is verified.
  Widget _buildOtpSection(SignupFormState state) {
    if (state.isPhoneVerified) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          '${state.phoneNumber} verified.',
          style: context.siText(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: SITokens.win,
          ),
        ),
      );
    }

    if (!state.isOtpRequested) {
      if (state.otpError != null) {
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            state.otpError!,
            style: context.siText(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: SITokens.danger,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _FieldLabel(label: 'Verification code'),
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: siInputDecoration(
              hintText: 'Enter the 6-digit code',
              prefixIcon: Icons.lock_outline_rounded,
            ).copyWith(counterText: ''),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              state.otpError ?? 'We sent a code to ${state.phoneNumber}.',
              style: context.siText(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: state.otpError != null ? SITokens.danger : SITokens.ink3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendOtp() async {
    final sent = await ref.read(signupFormProvider.notifier).requestOtp();
    if (!mounted) return;
    final state = ref.read(signupFormProvider);
    if (sent) {
      _otpController.clear();
      _showSuccess('Code sent to ${state.phoneNumber}');
    } else {
      _showError(state.otpError ?? 'Failed to send the code.');
    }
  }

  Widget _buildTinField(SignupFormState state) {
    Widget? suffix;
    if (state.isValidatingTin) {
      suffix = const SizedBox(
        width: 20,
        height: 20,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (state.tinDetails != null) {
      suffix = IconButton(
        icon: const Icon(Icons.close, color: SITokens.ink3),
        onPressed: () {
          _tinController.text = '';
          ref.read(signupFormProvider.notifier).clearTin();
        },
      );
    } else if (state.tinError != null) {
      suffix = const Icon(Icons.cancel, color: SITokens.danger);
    } else if (state.isTinValidationRelaxed) {
      suffix = const Icon(Icons.help_outline, color: SITokens.ink3);
    }

    return _buildInputField(
      hintText: 'Enter TIN number',
      prefixIcon: Icons.credit_card_outlined,
      controller: _tinController,
      keyboardType: TextInputType.number,
      readOnly: state.tinDetails != null,
      suffixIcon: suffix,
      validator: (v) {
        if (_showTinField) {
          if (v == null || v.isEmpty) return 'TIN number is required';
          if (v.length < 9) return 'TIN number must be at least 9 digits';
        }
        return null;
      },
      onChanged: (v) =>
          ref.read(signupFormProvider.notifier).updateTinNumber(v),
    );
  }

  Widget _buildDropdown<T>({
    required String hintText,
    required IconData prefixIcon,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      validator: validator,
      // Without this the "Please select a business type" error painted by a
      // failed submit stays on screen after the user picks a value, until the
      // next submit re-runs the validators.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      isExpanded: true,
      menuMaxHeight: 300,
      itemHeight: 48,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: SITokens.ink3,
      ),
      decoration: siInputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Field label above input ───────────────────────────────────────────────────

/// Dial-code prefix shown inside the phone field, matching the chip the mobile
/// signup form renders. Hidden while the field holds an email.
class _DialCodeChip extends StatelessWidget {
  final String code;
  const _DialCodeChip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: SITokens.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: SITokens.blue,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF4A5567),
        ),
      ),
    );
  }
}
