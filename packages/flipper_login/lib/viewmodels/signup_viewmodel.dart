import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'dart:convert';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/secrets.dart';
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
    String? userId = ProxyService.box.getUserId();

    // If we don't have a userId, call v2/api/user to create/get user with phone number
    if (userId == null && phoneNumber != null && phoneNumber.isNotEmpty) {
      try {
        // Call v2/api/user endpoint to create or get user
        final response = await ProxyService.strategy.sendLoginRequest(
          phoneNumber,
          ProxyService.http,
          AppSecrets.apihubProdDomain,
        );

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final responseData = json.decode(response.body);
          if (responseData['id'] != null) {
            userId = responseData['id'] is String
                ? responseData['id']
                : responseData['id'] as int;
            // Store the userId for future use
            ProxyService.box.writeString(key: 'userId', value: userId!);
          }
        }
      } catch (e) {
        // If user creation fails, continue with existing flow for backward compatibility
        // The existing signup method will handle user creation
      }
    }

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
        'userId': userId,
      };

      // Signup logic implementation with correct signature
      await ProxyService.strategy.signup(
        business: businessMap,
        flipperHttpClient: ProxyService.http,
      );

      // After successfully creating the business, re-fetch the user data
      // to get the updated list of businesses and save it to Ditto.
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        final response = await ProxyService.strategy.sendLoginRequest(
          phoneNumber,
          ProxyService.http,
          AppSecrets.apihubProdDomain,
        );
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final responseData = json.decode(response.body);
          if (responseData['id'] != null) {
            userId = responseData['id'] is String
                ? responseData['id']
                : responseData['id'] as int;
            // Store the userId for future use
            ProxyService.box.writeString(key: 'userId', value: userId!);
            await ProxyService.http.post(
              Uri.parse('${AppSecrets.apihubProd}/v2/api/pin'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'phoneNumber': phoneNumber,
                'userId': userId,
                'branchId': responseData['businesses'][0]['branches'][0]['id'],
                'businessId': responseData['businesses'][0]['id'],
                'defaultApp': 1,
              }),
            );
          }
        }
      }
      // send pin for this user
    } catch (e) {
      showSimpleNotification(
        const Text("Error while signing up try again later"),
        background: Colors.red,
        duration: const Duration(seconds: 10),
        position: NotificationPosition.bottom,
      );
      rethrow;
    }
  }
}
