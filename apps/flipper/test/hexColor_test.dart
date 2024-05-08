import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidHexColor', () {
    test('returns true for valid 6-digit hex color code', () {
      expect(isValidHexColor('#FF00FF'), isTrue);
      expect(isValidHexColor('FF00FF'), isTrue);
    });

    test('returns true for valid 8-digit hex color code', () {
      expect(isValidHexColor('#0984e3'), isTrue);
      expect(isValidHexColor('FF00FF00'), isTrue);
    });

    test('returns false for invalid hex color code', () {
      expect(isValidHexColor('#GGGGGG'), isFalse);
      expect(isValidHexColor('GGGGGG'), isFalse);
      expect(isValidHexColor('#FF00FG'), isFalse);
      expect(isValidHexColor('FF00FG'), isFalse);
      expect(isValidHexColor('#FF00FF0'), isFalse);
      expect(isValidHexColor('FF00FF0'), isFalse);
      expect(isValidHexColor('#FF00FF000'), isFalse);
      expect(isValidHexColor('FF00FF000'), isFalse);
    });
  });

  group('getColorOrDefault', () {
    test('should create a Color from a valid 6-digit hex color code', () {
      final hexColor = HexColor('#FF00FF');
      expect(hexColor.value, equals(Color(0xFFFF00FF).value));
    });

    test('should create a Color from a valid 8-digit hex color code with alpha',
        () {
      final hexColor = HexColor('#80FF00FF');
      expect(hexColor.value, equals(Color(0x80FF00FF).value));
    });

    // test('should create a Color from a valid 3-digit hex color code', () {
    //   final hexColor = HexColor('#F0F');
    //   expect(hexColor.value, equals(Color(0xFFFF00FF).value));
    // });

    // test('should create a Color from a valid 4-digit hex color code with alpha',
    //     () {
    //   final hexColor = HexColor('#8F0F');
    //   expect(hexColor.value, equals(Color(0x88FF00FF).value));
    // });

    test('should create a Color from a valid hex color code without leading #',
        () {
      final hexColor = HexColor('FF00FF');
      expect(hexColor.value, equals(Color(0xFFFF00FF).value));
    });

    test('should create a Color from a valid hex color code with mixed case',
        () {
      final hexColor = HexColor('#fF00Ff');
      expect(hexColor.value, equals(Color(0xFFFF00FF).value));
    });

    // test('should throw an exception for invalid hex color codes', () {
    //   expect(() => HexColor('invalid'), throwsException);
    //   expect(() => HexColor('#'), throwsException);
    //   expect(() => HexColor('#GG00FF'), throwsException);
    //   expect(() => HexColor('#FF00F'), throwsException);
    // });
    test('should throw an exception for invalid hex color codes', () {
      expect(() => getColorOrDefault('invalid'), throwsException);
    });
  });
}
