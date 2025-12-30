import 'dart:developer';
import 'dart:convert';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_login/viewmodels/signup_viewmodel.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

/// Form bloc for handling signup form validation and submission
class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final username = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _min4Char,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final fullName = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  final phoneNumber = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _validateContactInfo,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );
  late final TextFieldBloc<String> tinNumber = TextFieldBloc<String>(
    validators: [
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  final SignupViewModel signupViewModel;
  final countryName = SelectFieldBloc<String, String>(
    items: ['Zambia', 'Mozambique', 'Rwanda'],
    initialValue: 'Rwanda',
  );

  final businessTypes =
      SelectFieldBloc<BusinessType, Object>(name: 'businessType', validators: [
    FieldBlocValidators.required,
  ]);

  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);

    // Business types are now hardcoded to match flipper_web app
    // Set default to Individual after items are loaded
    final businessTypeItems = BusinessType.fromJsonList(jsonEncode([
      {"id": "1", "typeName": "Flipper Retailer"},
      {"id": "2", "typeName": "Individual"},
      {"id": "3", "typeName": "Enterprise"},
    ]));
    businessTypes.updateItems(businessTypeItems);

    // Set Individual as the default
    final individualType = businessTypeItems.firstWhere(
      (type) => type.id == "2",
      orElse: () => businessTypeItems.first,
    );
    businessTypes.updateInitialValue(individualType);

    // Initially, tinNumber is not required for Individual
    tinNumber.updateValidators([]);

    addFieldBlocs(fieldBlocs: [
      username,
      fullName,
      phoneNumber,
      countryName,
      tinNumber,
      businessTypes
    ]);

    // Listen to business type changes to update tinNumber validation
    businessTypes.stream.listen((state) {
      if (state.value?.id == "2") {
        // Individual - no TIN required
        tinNumber.updateValidators([]);
      } else {
        // Other business types - TIN required
        tinNumber.updateValidators([FieldBlocValidators.required]);
      }
    });

    username.addAsyncValidators([_checkUsername]);
  }

  /// Validates that username is not too long
  static String? _min4Char(String? username) {
    if (username!.length > 11) {
      return 'Name is too long';
    }
    return null;
  }

  /// Validates phone number format or email format
  static String? _validateContactInfo(String? contact) {
    if (contact == null || contact.isEmpty) {
      return 'Phone number or email is required';
    }

    // Regex for phone number (starts with +, 8-15 digits, spaces, hyphens, parentheses allowed)
    final phoneRegex = RegExp(r'^\+[0-9\s\-\(\)]{8,15}$');
    // Regex for email
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (phoneRegex.hasMatch(contact)) {
      return null; // Valid phone number
    }
    if (emailRegex.hasMatch(contact)) {
      return null; // Valid email
    }

    return 'Please enter a valid phone number (e.g., +250...) or email address';
  }

  /// Checks if username is available
  Future<String?> _checkUsername(String? username) async {
    try {
      if (username == null) {
        return "Username/business name is required";
      }
      int status = await ProxyService.strategy.userNameAvailable(
          name: username, flipperHttpClient: ProxyService.http);

      if (status == 200) {
        return 'That username is already taken';
      }

      return null;
    } catch (e) {
      return 'Name Search not available';
    }
  }

  @override
  void onSubmitting() async {
    try {
      signupViewModel.startRegistering();

      // Transfer form values to view model
      signupViewModel.setName(name: username.value);
      signupViewModel.setFullName(name: fullName.value);
      signupViewModel.setPhoneNumber(phoneNumber: phoneNumber.value);
      signupViewModel.setCountry(country: countryName.value ?? 'Rwanda');
      signupViewModel.tin =
          (tinNumber.value.isEmpty || businessTypes.value?.id == "2")
              ? "999909695"
              : tinNumber.value;
      signupViewModel.businessType = businessTypes.value!;

      // Perform signup
      await signupViewModel.signup();

      // Signup completed successfully - navigate to startup view
      // The StartupViewModel will handle appInit() and proper navigation
      log('Signup completed successfully',
          name: 'AsyncFieldValidationFormBloc');

      final routerService = locator<RouterService>();
      routerService.navigateTo(StartUpViewRoute());

      emitSuccess();
      signupViewModel.stopRegistering(); // Ensure we stop the loading state
    } catch (e) {
      log('Error during signup: $e', name: 'AsyncFieldValidationFormBloc');
      signupViewModel.stopRegistering();
      emitFailure();
    }
  }
}
