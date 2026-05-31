// lib/features/auth/views/signup_screen.dart
import 'package:flipper_auth/features/auth/providers/auth_notifier.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refreshProgress);
    _emailController.addListener(_refreshProgress);
    _passwordController.addListener(_refreshProgress);
    _confirmPasswordController.addListener(_refreshProgress);
  }

  @override
  void dispose() {
    _nameController.removeListener(_refreshProgress);
    _emailController.removeListener(_refreshProgress);
    _passwordController.removeListener(_refreshProgress);
    _confirmPasswordController.removeListener(_refreshProgress);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _refreshProgress() {
    if (mounted) setState(() {});
  }

  int get _completedFields {
    final values = [
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
      _confirmPasswordController.text,
    ];
    return values.where((value) => value.isNotEmpty).length;
  }

  double get _progress => _completedFields / 4;

  int get _xp => _completedFields * 25;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      if (next.error != null) {
        showErrorNotification(context, next.error!);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 38),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SignupHeader(xp: _xp),
                          const SizedBox(height: 20),
                          FlipperProgressRewardCard(
                            progress: _progress,
                            points: _xp,
                          ),
                          const SizedBox(height: 20),
                          FlipperOnboardingPanel(
                            children: [
                              Text(
                                'Create your account',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: const Color(0xFF0B1220),
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start with the same secure signup flow, now tuned for a faster mobile setup.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF4A5567),
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 22),
                              _AuthInputField(
                                controller: _nameController,
                                label: 'Full name',
                                hintText: 'Enter your full name',
                                prefixIcon: Icons.person_outline_rounded,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              _AuthInputField(
                                controller: _emailController,
                                label: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              _AuthInputField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icons.lock_outline_rounded,
                                obscureText: !_isPasswordVisible,
                                suffixIcon: IconButton(
                                  tooltip: _isPasswordVisible
                                      ? 'Hide password'
                                      : 'Show password',
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: const Color(0xFF7E8AA0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                              _AuthInputField(
                                controller: _confirmPasswordController,
                                label: 'Confirm password',
                                hintText: 'Confirm your password',
                                prefixIcon: Icons.verified_user_outlined,
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 26),
                              FlipperGradientButton(
                                text: 'Create account',
                                icon: Icons.chevron_right_rounded,
                                isLoading: authState.isLoading,
                                onPressed:
                                    authState.isLoading ? null : _handleSignUp,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Already have an account? Sign in',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authNotifierProvider.notifier).signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );
    }
  }
}

class _SignupHeader extends StatelessWidget {
  final int xp;

  const _SignupHeader({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FlipperBrandBadge(size: 46),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flipper',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF0B1220),
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Text(
                'Business setup',
                style: TextStyle(
                  color: Color(0xFF7E8AA0),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        FlipperRewardChip(points: xp),
      ],
    );
  }
}

class _AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AuthInputField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4A5567),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFAEB8CA)),
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF7E8AA0)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF7F9FE),
            border: _border(const Color(0xFFD6DEEA)),
            enabledBorder: _border(const Color(0xFFD6DEEA)),
            focusedBorder: _border(const Color(0xFF2563EB), width: 1.6),
            errorBorder: _border(FlipperColors.error),
            focusedErrorBorder: _border(FlipperColors.error, width: 1.6),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: Corners.s12Border,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
