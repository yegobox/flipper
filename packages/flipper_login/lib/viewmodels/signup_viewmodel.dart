import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_services/proxy.dart';

/// View model for handling signup business logic
class SignupViewModel extends BaseViewModel {
  BuildContext? context;
  bool registerStart = false;
  String? name;
  String? fullName;
  String? country;
  String? tin;
  BusinessType? businessType;

  /// Start the registration process
  void startRegistering() {
    registerStart = true;
    notifyListeners();
  }

  /// Stop the registration process
  void stopRegistering() {
    registerStart = false;
    notifyListeners();
  }

  /// Set the username
  void setName({required String name}) {
    this.name = name;
  }

  /// Set the full name
  void setFullName({required String name}) {
    this.fullName = name;
  }

  /// Set the country
  void setCountry({required String country}) {
    this.country = country;
  }

  /// Set the phone number
  void setPhoneNumber({required String phoneNumber}) {
    // Store phone number in ProxyService box or use it directly in signup
    if (phoneNumber.isNotEmpty) {
      ProxyService.box.writeString(key: 'userPhone', value: phoneNumber);
    }
  }

  /// Register device location
  void registerLocation() {
    // Implementation for location registration
  }

  /// Perform signup
  Future<void> signup() async {
    String? phoneNumber = ProxyService.box.getUserPhone();

    try {
      // Create business map with all required fields
      final Map<String, dynamic> businessMap = {
        'name': name ?? '',
        'fullName': fullName ?? '',
        'country': country ?? '',
        'tinNumber': tin ?? '',
        'type': BusinessTypeEnum.fromId(businessType?.id ?? '1').name,
        'phoneNumber': phoneNumber ?? '',
        'currency': 'RWF',
        'longitude': 1,
        'latitude': 1,
        'bhfid': '00',
        'businessTypeId': int.tryParse(businessType?.id ?? '1') ?? 1,
        // userId is intentionally omitted here; the server assigns it and
        // CoreSync.signup → login → sendLoginRequest saves it to box + Ditto.
      };

      // Signup logic implementation with correct signature.
      // CoreSync.signup() internally calls login() which calls sendLoginRequest().
      // sendLoginRequest() stores userId in ProxyService.box AND saves user_access
      // to Ditto, so we do NOT need a separate sendLoginRequest call here.
      await ProxyService.strategy.signup(
        business: businessMap,
        flipperHttpClient: ProxyService.http,
      );
    } catch (e) {
      rethrow;
    }
  }
}
