import 'dart:developer';
import 'dart:convert';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_login/viewmodels/signup_viewmodel.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/locator.dart' as loc;

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

  final businessTypes = SelectFieldBloc<BusinessType, Object>(
      name: 'businessType',
      items: BusinessType.fromJsonList(jsonEncode([
        {"id": "1", "typeName": "Flipper Retailer"},
      ])),
      validators: [
        FieldBlocValidators.required,
      ]);

  AsyncFieldValidationFormBloc(
      {required this.signupViewModel, required String country}) {
    countryName.updateInitialValue(country);

    // Load business types from API
    ProxyService.strategy.businessTypes().then((data) {
      log(data.toString(), name: 'AsyncFieldValidationFormBloc');
      businessTypes.updateItems(data);
    }).catchError((error) {
      log(error, name: 'AsyncFieldValidationFormBloc');
    });

    addFieldBlocs(fieldBlocs: [
      username,
      fullName,
      countryName,
      tinNumber,
      businessTypes
    ]);

    username.addAsyncValidators([_checkUsername]);
  }

  /// Validates that username is not too long
  static String? _min4Char(String? username) {
    if (username!.length > 11) {
      return 'Name is too long';
    }
    return null;
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
      signupViewModel.setCountry(country: countryName.value ?? 'Rwanda');
      signupViewModel.tin =
          tinNumber.value.isEmpty ? "999909695" : tinNumber.value;
      signupViewModel.businessType = businessTypes.value!;

      // Perform signup
      await signupViewModel.signup();

      // The signup method in CoreSync already handles login and navigation
      // We just need to ensure the loading state is stopped
      log('Signup completed successfully',
          name: 'AsyncFieldValidationFormBloc');

      loc.getIt<AppService>().appInit();
      // If we're still on this screen, navigate to the app
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
