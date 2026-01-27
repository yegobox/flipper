import 'package:flipper_services/momo_ussd_service.dart';

void main() {
  // Test the specific phone number mentioned in the issue
  String phoneNumber = '0783054874';
  bool isValid = MomoUssdService.isValidPhoneNumber(phoneNumber);
  
  print('Phone number: $phoneNumber');
  print('Is valid: $isValid');
  
  // Test other valid formats
  List<String> validNumbers = [
    '0788123456',
    '0791234567',
    '0731234567',
    '0721234567',
    '+250788123456',
    '250788123456',
    '788123456',
  ];
  
  print('\nTesting valid numbers:');
  for (String num in validNumbers) {
    bool result = MomoUssdService.isValidPhoneNumber(num);
    print('$num: $result');
  }
  
  // Test invalid numbers
  List<String> invalidNumbers = [
    '0751234567', // Invalid prefix
    '078812345',  // Too short
    '07881234567', // Too long
    'abc1234567', // Non-numeric
  ];
  
  print('\nTesting invalid numbers:');
  for (String num in invalidNumbers) {
    bool result = MomoUssdService.isValidPhoneNumber(num);
    print('$num: $result');
  }
  
  // Test USSD code generation
  print('\nTesting USSD code generation:');
  String ussdCode = MomoUssdService.generatePhonePaymentCode('0783054874', 1000);
  print('Generated USSD for 0783054874: $ussdCode');
}