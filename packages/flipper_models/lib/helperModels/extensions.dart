import 'dart:math';

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

extension DateTimeExtensions on DateTime? {
  bool isNewDateCompareTo(DateTime? other) {
    if (this == null || other == null) return false;
    return this!.compareTo(other) > 0;
  }
}

extension ColorExtension on Color {
  String toHex({bool includeAlpha = false}) {
    final alphaHex =
        includeAlpha ? alpha.toRadixString(16).padLeft(2, '0') : '';
    return '#$alphaHex${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }
}

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

extension StringExtensions on String {
  /// Extracts the part of the string before the first '(' and the number after the first '(' and before the first ')'.
  ///
  /// For example:
  ///   'Product Name (123)' -> 'Product Name, 123'
  ///   'Product Name' -> 'Product Name, '
  ///
  /// Returns a string with the name and number separated by a comma and a space.
  String extractNameAndNumber() {
    String name = split('(')[0];
    String number = '';

    if (contains('(')) {
      number = split('(')[1].split(')')[0];
    }

    return '$name $number'; // Concatenate name and number with a comma and space
  }
}

extension CurrencyFormatExtension on num {
  String toRwf({String? symbol}) {
    final numberFormat = NumberFormat.currency(
      locale: 'en',
      symbol: symbol ?? 'RWF ',
      decimalDigits: 2,
    );

    // Check if the number is 0 or 0.0
    if (this == 0 || this == 0.0) {
      return symbol ?? 'RWF';
    }

    return numberFormat.format(this);
  }
}

extension DoubleExtension on double {
  double toPrecision(int fractionDigits) {
    final factor = pow(10, fractionDigits);
    return (this * factor).round() / factor;
  }
}

extension DateOnly on DateTime {
  String get formattedDate {
    final localDate = this.toLocal();
    return "${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}";
  }
}

extension TimeOnly on DateTime {
  String get formattedTime {
    final localDate = this.toLocal();
    return "${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}:${localDate.second.toString().padLeft(2, '0')}";
  }
}

extension DateTimeToDateTimeString on DateTime {
  String toDateTimeString() {
    final localDateTime = this.toLocal();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm:ss');
    final dateString = dateFormat.format(localDateTime);
    final timeString = timeFormat.format(localDateTime);
    return '$dateString $timeString';
  }
}

extension StringToDashedString on String {
  String toDashedString() {
    if (isEmpty) {
      return '';
    }
    var x = 0;
    final dashesInternalData = {2, 3, 4, 12, 6, 7};
    final replacedInternalData = splitMapJoin(RegExp('....'),
        onNonMatch: (s) => dashesInternalData.contains(x++) ? '-' : '');
    return replacedInternalData;
  }
}

extension RealmEJsonConverterExtension on EJsonValue {
  /// Converts Realm EJson values to their corresponding Dart types and swaps 'id' and 'serverId'.
  ///
  /// **Usage:**
  ///
  /// ```dart
  /// final myObject = realm.find<MyObject>('someObjectId')!;
  /// final jsonObject = myObject.toEJson();
  /// final convertedJson = jsonObject.convertRealmValues();
  /// ```
  dynamic toFlipperJson() {
    return _convertValue(this);
  }

  dynamic _convertValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return _convertMap(value);
    } else if (value is List) {
      return value.map((item) => _convertValue(item)).toList();
    } else if (value is ObjectId) {
      return value.hexString;
    } else if (value is DateTime) {
      return value.toIso8601String();
    }
    return value;
  }

  Map<String, dynamic> _convertMap(Map<String, dynamic> map) {
    final convertedMap = <String, dynamic>{};
    map.forEach((key, value) {
      if (value is Map<String, dynamic> && value.length == 1) {
        final innerKey = value.keys.first;
        final innerValue = value[innerKey];
        switch (innerKey) {
          case '\$numberInt':
          case '\$numberLong':
            convertedMap[key] = int.parse(innerValue);
            break;
          case '\$numberDouble':
            convertedMap[key] = double.parse(innerValue);
            break;
          case '\$date':
            if (innerValue is Map && innerValue.containsKey('\$numberLong')) {
              convertedMap[key] = DateTime.fromMillisecondsSinceEpoch(
                int.parse(innerValue['\$numberLong']),
                isUtc: true,
              ).toIso8601String();
            } else {
              convertedMap[key] = innerValue;
            }
            break;
          case '\$oid':
            convertedMap[key] = innerValue;
            break;
          default:
            convertedMap[key] = _convertValue(value);
        }
      } else {
        convertedMap[key] = _convertValue(value);
      }
    });

    // Swap 'id' and 'serverId' if both exist
    if (convertedMap.containsKey('id') &&
        convertedMap.containsKey('serverId')) {
      final temp = convertedMap['id'];
      convertedMap['id'] = convertedMap['serverId'];
      convertedMap['serverId'] = temp;
    }
    

    return convertedMap;
  }
}

extension AccessInnerController on Widget {
  Widget eligibleToSee(WidgetRef ref, List<String> accessLevels) {
    return Consumer(
      builder: (context, ref, child) {
        for (final level in accessLevels) {
          final hasAccess = ref.watch(featureAccessLevelProvider(level));
          if (hasAccess) return this;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

extension AccessControlWidget on Widget {
  Widget shouldSeeTheApp(WidgetRef ref, String featureName) {
    return Consumer(
      builder: (context, ref, child) {
        final hasAccess = ref.watch(featureAccessProvider(featureName));
        return hasAccess ? this : SizedBox.shrink();
      },
    );
  }
}

extension PercentageFormatter on double {
  String toFormattedPercentage() {
    final formatter = NumberFormat.percentPattern();
    return formatter.format(this / 100); // Divide by 100 before formatting
  }
}

extension StringExtension on String {
  String toFlipperEmail() {
    if (this.contains('@')) {
      return this;
    }
    // return a defaul email
    return 'yegobox@gmail.com';
    // return this.replaceFirst('+', '') + '@flipper.rw';
  }
}
