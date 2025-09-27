import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/business_type.dart';
import '../../widgets/app_button.dart';
import 'signup_providers.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _formKey = GlobalKey<FormState>();
  bool _showTinField = true;

  // Helper method to show formatted error messages
  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 8),
      ),
    );
  }

  // Helper method to show success messages
  void _showSuccessMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Login',
          textColor: Colors.white,
          onPressed: () {
            try {
              context.go('/login');
            } catch (_) {
              Navigator.pop(context);
            }
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 4),
      ),
    );
  }

  // Phone controller and country dial code helpers
  late final TextEditingController _phoneController;

  final Map<String, String> _countryDialCodes = {
    'Rwanda': '+250',
    'Kenya': '+254',
    'Uganda': '+256',
    'Tanzania': '+255',
    'Burundi': '+257',
  };

  String _dialCodeForCountry(String country) {
    return _countryDialCodes[country] ?? '+250';
  }

  String _stripDialCode(String phone) {
    if (phone.isEmpty) return '';
    for (final code in _countryDialCodes.values) {
      if (phone.startsWith(code)) return phone.substring(code.length);
    }
    return phone;
  }

  String _ensurePhoneHasDialCode(String phone, String country) {
    final code = _dialCodeForCountry(country);
    final cleaned = phone.trim();
    if (cleaned.isEmpty) return code;
    // If phone already starts with a known code, return as-is
    for (final c in _countryDialCodes.values) {
      if (cleaned.startsWith(c)) return cleaned;
    }
    // Remove leading zero if present (local formats)
    var local = cleaned;
    if (local.startsWith('0')) local = local.substring(1);
    return '$code$local';
  }

  @override
  void initState() {
    super.initState();
    final state = ref.read(signupFormProvider);
    _phoneController = TextEditingController(
      text: _ensurePhoneHasDialCode(state.phoneNumber ?? '', state.country),
    );
    _phoneController.addListener(() {
      ref
          .read(signupFormProvider.notifier)
          .updatePhoneNumber(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formState = ref.watch(signupFormProvider);
    final businessTypes = ref.watch(businessTypesProvider);
    final countries = ref.watch(countriesProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height - 100,
            ),
            child: isSmallScreen
                ? _buildMobileLayout(formState, businessTypes, countries)
                : _buildDesktopLayout(
                    theme,
                    formState,
                    businessTypes,
                    countries,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    SignupFormState formState,
    List<BusinessType> businessTypes,
    List<String> countries,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeaderSection(),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildUsernameField(
                      value: formState.username,
                      isCheckingUsername: formState.isCheckingUsername,
                      isUsernameAvailable: formState.isUsernameAvailable,
                      onChanged: (value) => ref
                          .read(signupFormProvider.notifier)
                          .updateUsername(value),
                    ),
                    _buildInputField(
                      label: 'Full Name',
                      hint: 'First name, Last name',
                      icon: Icons.badge_outlined,
                      value: formState.fullName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        if (value.trim().split(' ').length < 2) {
                          return 'Please enter first and last name';
                        }
                        return null;
                      },
                      onChanged: (value) => ref
                          .read(signupFormProvider.notifier)
                          .updateFullName(value),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter your phone number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                        ),
                        validator: (value) {
                          final v = value ?? '';
                          if (v.isEmpty) return 'Phone number is required';
                          if (v.replaceAll(RegExp(r'[^0-9+]'), '').length < 9) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildDropdownField<BusinessType>(
                      label: 'Usage ',
                      hint: 'How you intend to use flipper',
                      icon: Icons.business_outlined,
                      value: formState.businessType,
                      items: businessTypes,
                      itemBuilder: (businessType) => businessType.typeName,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a business type';
                        }
                        return null;
                      },
                      onChanged: (BusinessType? value) {
                        if (value != null) {
                          ref
                              .read(signupFormProvider.notifier)
                              .updateBusinessType(value);
                          setState(() {
                            _showTinField = value.id != "2";
                          });
                        }
                      },
                    ),
                    if (_showTinField)
                      _buildInputField(
                        label: 'TIN Number',
                        hint: 'Enter TIN number',
                        icon: Icons.credit_card_outlined,
                        value: formState.tinNumber,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (_showTinField) {
                            if (value == null || value.isEmpty) {
                              return 'TIN number is required';
                            }
                            if (value.length < 9) {
                              return 'TIN number must be at least 9 characters';
                            }
                          }
                          return null;
                        },
                        onChanged: (value) => ref
                            .read(signupFormProvider.notifier)
                            .updateTinNumber(value),
                      ),
                    _buildDropdownField<String>(
                      label: 'Country',
                      hint: 'Select country',
                      icon: Icons.public_outlined,
                      value: formState.country,
                      items: countries,
                      itemBuilder: (country) => country,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a country';
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        if (value != null) {
                          // Update stored country
                          ref
                              .read(signupFormProvider.notifier)
                              .updateCountry(value);
                          // Re-prefix phone number with selected country's dial code
                          final newPhone = _ensurePhoneHasDialCode(
                            _stripDialCode(_phoneController.text),
                            value,
                          );
                          _phoneController.text = newPhone;
                        }
                      },
                    ),
                    _buildSubmitButton(formState.isSubmitting),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to login screen
                try {
                  context.go('/login');
                } catch (_) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Already have an account? Sign in',
                style: TextStyle(fontSize: 14, color: const Color(0xFF006AFE)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join Flipper and grow your business',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildUsernameField({
    required String value,
    required Function(String) onChanged,
    required bool isCheckingUsername,
    bool? isUsernameAvailable,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Username is required';
          }
          if (value.length < 4) {
            return 'Username must be at least 4 characters';
          }
          if (isUsernameAvailable == false) {
            return 'Username is not available';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Username',
          hintText: 'Enter your username',
          prefixIcon: const Icon(Icons.person_outline),
          suffixIcon: value.length >= 3
              ? _buildUsernameAvailabilityIcon(
                  isCheckingUsername,
                  isUsernameAvailable,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameAvailabilityIcon(bool isChecking, bool? isAvailable) {
    if (isChecking) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else if (isAvailable == true) {
      return const Icon(Icons.check_circle, color: Colors.green);
    } else if (isAvailable == false) {
      return const Icon(Icons.cancel, color: Colors.red);
    }
    return const SizedBox.shrink();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    required String value,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required IconData icon,
    required T? value,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return DropdownButtonFormField<T>(
            value: value,
            onChanged: onChanged,
            validator: validator,
            isExpanded: true, // Make dropdown expand to fill available width
            icon: const Icon(Icons.arrow_drop_down, size: 24),
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            menuMaxHeight: 300, // Limit the height of the dropdown menu
            // Reduce horizontal padding to give more room for text
            itemHeight: 48,
            alignment: AlignmentDirectional.centerStart,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10, // Reduced from 16 to give more room
              ),
            ),
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemBuilder(item),
                  overflow: TextOverflow
                      .ellipsis, // Handle overflow in dropdown items
                  maxLines: 1, // Ensure single line
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      height: 56,
      child: AppButton(
        label: 'Create Account',
        onPressed: isLoading
            ? null
            : () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Additional validation for username availability
                  final formState = ref.read(signupFormProvider);
                  if (formState.isUsernameAvailable != true) {
                    _showErrorMessage(
                      'Please choose a different username. The current one is not available or has not been verified.',
                    );
                    return;
                  }

                  final success = await ref
                      .read(signupFormProvider.notifier)
                      .submitForm();
                  if (success && mounted) {
                    _showSuccessMessage('Account created successfully!');
                    // Navigate to login or directly authenticate
                    try {
                      context.go('/login');
                    } catch (_) {
                      Navigator.pop(context);
                    }
                  } else if (mounted) {
                    // Show error message if signup failed
                    final errorMessage =
                        ref.read(signupFormProvider).errorMessage ??
                        'Failed to create account. Please try again.';

                    _showErrorMessage(errorMessage);
                  }
                }
              },
        variant: AppButtonVariant.primary,
        isLoading: isLoading,
      ),
    );
  }

  Widget _buildDesktopLayout(
    ThemeData theme,
    SignupFormState formState,
    List<BusinessType> businessTypes,
    List<String> countries,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          // Left side - decorative area (can be expanded with branding)
          Expanded(
            flex: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Brand logo or illustration could go here
                  Icon(
                    Icons.store_outlined,
                    size: 80,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Grow your business with Flipper',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Join thousands of businesses using Flipper to manage their operations efficiently',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right side - form
          Expanded(
            flex: 7,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create Account',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fill in the details to set up your business account',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildUsernameField(
                                    value: formState.username,
                                    isCheckingUsername:
                                        formState.isCheckingUsername,
                                    isUsernameAvailable:
                                        formState.isUsernameAvailable,
                                    onChanged: (value) => ref
                                        .read(signupFormProvider.notifier)
                                        .updateUsername(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildInputField(
                                    label: 'Full Name',
                                    hint: 'First name, Last name',
                                    icon: Icons.badge_outlined,
                                    value: formState.fullName,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Full name is required';
                                      }
                                      if (value.trim().split(' ').length < 2) {
                                        return 'Please enter first and last name';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) => ref
                                        .read(signupFormProvider.notifier)
                                        .updateFullName(value),
                                  ),
                                ),
                              ],
                            ),
                            // Add phone number field
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        hintText: 'Enter your phone number',
                                        prefixIcon: const Icon(
                                          Icons.phone_outlined,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 16,
                                            ),
                                      ),
                                      validator: (value) {
                                        final v = value ?? '';
<<<<<<< HEAD
                                        if (v.isEmpty) {
                                          return 'Phone number is required';
                                        }
=======
                                        if (v.isEmpty)
                                          return 'Phone number is required';
>>>>>>> main
                                        if (v
                                                .replaceAll(
                                                  RegExp(r'[^0-9+]'),
                                                  '',
                                                )
                                                .length <
                                            9) {
                                          return 'Please enter a valid phone number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdownField<String>(
                                    label: 'Country',
                                    hint: 'Select country',
                                    icon: Icons.public_outlined,
                                    value: formState.country,
                                    items: countries,
                                    itemBuilder: (country) => country,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a country';
                                      }
                                      return null;
                                    },
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        ref
                                            .read(signupFormProvider.notifier)
                                            .updateCountry(value);
                                        final newPhone =
                                            _ensurePhoneHasDialCode(
                                              _stripDialCode(
                                                _phoneController.text,
                                              ),
                                              value,
                                            );
                                        _phoneController.text = newPhone;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildDropdownField<BusinessType>(
                                    label: 'Business Type',
                                    hint: 'Select business type',
                                    icon: Icons.business_outlined,
                                    value: formState.businessType,
                                    items: businessTypes,
                                    itemBuilder: (businessType) =>
                                        businessType.typeName,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a business type';
                                      }
                                      return null;
                                    },
                                    onChanged: (BusinessType? value) {
                                      if (value != null) {
                                        ref
                                            .read(signupFormProvider.notifier)
                                            .updateBusinessType(value);
                                        setState(() {
                                          _showTinField = value.id != "2";
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _showTinField
                                      ? _buildInputField(
                                          label: 'TIN Number',
                                          hint: 'Enter TIN number',
                                          icon: Icons.credit_card_outlined,
                                          value: formState.tinNumber,
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (_showTinField) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'TIN number is required';
                                              }
                                              if (value.length < 9) {
                                                return 'TIN number must be at least 9 characters';
                                              }
                                            }
                                            return null;
                                          },
                                          onChanged: (value) => ref
                                              .read(signupFormProvider.notifier)
                                              .updateTinNumber(value),
                                        )
                                      : const SizedBox(), // Empty placeholder
                                ),
                              ],
                            ),
                            _buildSubmitButton(formState.isSubmitting),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  // Navigate to login screen
                                  try {
                                    context.go('/login');
                                  } catch (_) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  'Already have an account? Sign in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFF006AFE),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
