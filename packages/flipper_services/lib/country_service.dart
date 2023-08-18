import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocode/geocode.dart';

abstract class Country {
  Future<String?> getCountryName();
}

class UnSupportedCountry implements Country {
  @override
  Future<String?> getCountryName() async {
    return 'Rwanda';
  }
}

class CountryService implements Country {
  @override
  Future<String?> getCountryName() async {
    try {
      GeoCode geoCode = GeoCode();
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        return 'Rwanda';
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');

      Address address = await geoCode.reverseGeocoding(
          latitude: position.latitude, longitude: position.longitude);
      return address.countryName;
    } catch (Exception) {
      return 'Rwanda';
    }
  }
}
