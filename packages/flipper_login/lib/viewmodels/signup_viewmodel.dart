import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
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

  /// Register device location
  void registerLocation() {
    // Implementation for location registration
  }

  /// Perform signup
  Future<void> signup() async {
    try {
      // Create business map with all required fields
      final Map<String, dynamic> businessMap = {
        'name': name ?? '',
        'fullName': fullName ?? '',
        'country': country ?? '',
        'tin': tin ?? '',
        'businessType': businessType?.id ?? '',
      };
      
      // Signup logic implementation with correct signature
      await ProxyService.strategy.signup(
        business: businessMap,
        flipperHttpClient: ProxyService.http,
      );
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
