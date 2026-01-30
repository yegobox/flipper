import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_models/helperModels/talker.dart';

/// Enum for MoMo payment types
enum MomoPaymentType {
  /// Payment to a phone number
  phoneNumber,

  /// Payment using a MoMo code
  momoCode,
}

/// Service for generating MoMo USSD codes and handling phone dialing
///
/// This service provides utilities for:
/// - Generating USSD dial strings for MTN MoMo payments
/// - Dialing USSD codes using the system phone dialer
/// - Validating phone numbers and MoMo codes
class MomoUssdService {
  /// USSD base code for MTN Rwanda
  static const String _mtnBaseCode = '*182';

  /// Service code for phone number payments
  static const String _phonePaymentService = '1*1';

  /// Service code for MoMo code payments
  static const String _momoCodeService = '8*1';

  /// Generate USSD dial string for phone number payment
  ///
  /// Format: *182*1*1*{phone}*{amount}#
  ///
  /// [phoneNumber] - The recipient's phone number (with or without country code)
  /// [amount] - The payment amount
  ///
  /// Returns the complete USSD string ready for dialing
  static String generatePhonePaymentCode(String phoneNumber, double amount) {
    final cleanPhone = cleanPhoneNumber(phoneNumber);
    final formattedAmount = _formatAmount(amount);
    return '$_mtnBaseCode*$_phonePaymentService*$cleanPhone*$formattedAmount#';
  }

  /// Generate USSD dial string for MoMo code payment
  ///
  /// Format: *182*8*1*{code}*{amount}#
  ///
  /// [momoCode] - The MoMo payment code
  /// [amount] - The payment amount
  ///
  /// Returns the complete USSD string ready for dialing
  static String generateMomoCodePayment(String momoCode, double amount) {
    final cleanCode = momoCode.trim();
    final formattedAmount = _formatAmount(amount);
    return '$_mtnBaseCode*$_momoCodeService*$cleanCode*$formattedAmount#';
  }

  /// Dial the USSD code using the system phone dialer
  ///
  /// [ussdCode] - The USSD code to dial (e.g., *182*1*1*0788123456*5000#)
  ///
  /// Returns true if the dialer was launched successfully, false otherwise
  static Future<bool> dialUssdCode(String ussdCode) async {
    try {
      // Encode the USSD code for use in tel: URI
      // The # character needs to be encoded as %23
      final encodedCode = Uri.encodeComponent(ussdCode);
      final uri = Uri.parse('tel:$encodedCode');

      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(uri);
        talker.info('MomoUssdService: Dialed USSD code: $ussdCode');
        return launched;
      } else {
        talker.warning('MomoUssdService: Cannot launch dialer for: $ussdCode');
        return false;
      }
    } catch (e, s) {
      talker.error('MomoUssdService: Error dialing USSD code: $e');
      talker.error(s);
      return false;
    }
  }

  /// Validate if the phone number is in a valid format
  ///
  /// Accepts Rwandan phone numbers in various formats:
  /// - 0788123456 (local format)
  /// - 788123456 (without leading zero)
  /// - +250788123456 (with country code)
  /// - 250788123456 (with country code, no plus)
  ///
  /// Returns true if the phone number is valid
  static bool isValidPhoneNumber(String phone) {
    if (phone.isEmpty) return false;

    final validationFormat = _extractValidationFormat(phone);

    // Rwandan phone numbers should be 9 digits after removing country code
    // Valid prefixes: 78, 79, 73, 72 (MTN, Airtel)
    final rwandaPattern = RegExp(r'^7[2389]\d{7}$');

    return rwandaPattern.hasMatch(validationFormat);
  }

  /// Validate if the MoMo code is in a valid format
  ///
  /// MoMo codes are typically 6-10 digit numeric codes
  ///
  /// Returns true if the code is valid
  static bool isValidMomoCode(String code) {
    if (code.isEmpty) return false;

    final cleanCode = code.trim();

    // MoMo codes are numeric and typically 6-10 digits
    final codePattern = RegExp(r'^\d{6,10}$');

    return codePattern.hasMatch(cleanCode);
  }

  /// Clean and normalize a phone number for display and USSD dialing
  ///
  /// Removes country code, spaces, and special characters, then formats to local format
  /// Examples:
  /// - "+250 783 054 874" -> "0783054874"
  /// - "+2507830 54 874" -> "0783054874"
  /// - "783054874" -> "0783054874"
  /// - "0783054874" -> "0783054874"
  ///
  /// Returns the normalized phone number in local format (10 digits starting with 0)
  static String cleanPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\+\.]'), '');

    // Remove country code if present (250)
    if (cleaned.startsWith('250')) {
      cleaned = cleaned.substring(3);
    }

    // Ensure it has a leading zero if it's a mobile number (9 digits + 0 = 10 digits)
    // Mobile numbers in Rwanda are 10 digits starting with 07...
    if (cleaned.length == 9 &&
        (cleaned.startsWith('7') || cleaned.startsWith('8'))) {
      cleaned = '0$cleaned';
    }

    return cleaned;
  }

  /// Extract the 9-digit format for validation purposes
  ///
  /// This removes the leading zero from 07xxxxxxx format to get 7xxxxxxx format
  /// Used specifically for validation against the regex pattern
  static String _extractValidationFormat(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\+\.]'), '');

    // Remove country code if present (250)
    if (cleaned.startsWith('250')) {
      cleaned = cleaned.substring(3);
    }

    // Remove leading zero if we have a 10-digit number starting with 07 or 08
    // This converts 07xxxxxxx format to 7xxxxxxx format for validation
    if (cleaned.length == 10 && cleaned.startsWith('07')) {
      cleaned = cleaned.substring(1);
    } else if (cleaned.length == 10 && cleaned.startsWith('08')) {
      cleaned = cleaned.substring(1);
    }

    return cleaned;
  }

  /// Format amount for USSD code
  ///
  /// Removes decimal places for whole numbers
  static String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    // For non-integer amounts, truncate instead of rounding to avoid overcharging
    return amount.truncate().toString();
  }

  /// Get a display-friendly version of the USSD code
  ///
  /// This is useful for showing the user what will be dialed
  static String getDisplayCode(String ussdCode) {
    return ussdCode;
  }

  /// Parse the transaction type from the cashbook context
  ///
  /// [isIncome] - True for Cash In (receiving money), false for Cash Out (sending money)
  static String getTransactionDescription(bool isIncome) {
    return isIncome ? 'MoMo Cash In' : 'MoMo Cash Out';
  }
}
