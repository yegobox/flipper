import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';

/// A utility class that provides currency options for the system
class CurrencyOptions {
  /// Returns a list of DropdownMenuItem widgets for all supported currencies,
  /// labelled `CODE (Localized name)`. The item value stays the ISO code.
  static List<DropdownMenuItem<String>> getCurrencyOptions(
    FlipperAppLocalizations l10n,
  ) {
    return [
      for (final code in getCurrencyCodes())
        DropdownMenuItem(
          value: code,
          child: Text('$code (${l10n.configCurrencyName(code)})'),
        ),
    ];
  }

  /// Returns a list of currency codes
  static List<String> getCurrencyCodes() {
    return [
      // African
      'RWF', 'KES', 'UGX', 'TZS', 'ETB', 'NGN', 'ZAR', 'GHS', 'MAD', 'EGP',
      'DZD',
      'XOF', 'XAF', 'MUR', 'BWP', 'NAD',

      // International
      'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'CAD', 'AUD', 'CHF', 'NZD', 'HKD',
      'SEK',
      'NOK', 'DKK',

      // Middle Eastern
      'AED', 'SAR', 'QAR', 'KWD', 'BHD', 'OMR', 'ILS', 'JOD',

      // Asian
      'INR', 'PKR', 'BDT', 'SGD', 'MYR', 'IDR', 'PHP', 'THB', 'VND', 'KRW',
      'TWD',
      'LKR', 'NPR',

      // Latin American
      'BRL', 'MXN', 'ARS', 'COP', 'CLP', 'PEN', 'UYU', 'BOB', 'VES',

      // Eastern European
      'RUB', 'PLN', 'CZK', 'HUF', 'RON', 'BGN', 'TRY', 'UAH',
    ];
  }

  /// Returns the symbol for a given currency code
  static String getSymbolForCurrency(String currencyCode) {
    final Map<String, String> symbols = {
      // African
      'RWF': 'RF',
      'KES': 'KSh',
      'UGX': 'USh',
      'TZS': 'TSh',
      'ETB': 'Br',
      'NGN': '₦',
      'ZAR': 'R',
      'GHS': 'GH₵',
      'MAD': 'د.م.',
      'EGP': 'E£',
      'DZD': 'د.ج',
      'XOF': 'CFA',
      'XAF': 'FCFA',
      'MUR': '₨',
      'BWP': 'P',
      'NAD': 'N\$',

      // International
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'Fr',
      'NZD': 'NZ\$',
      'HKD': 'HK\$',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',

      // Middle Eastern
      'AED': 'د.إ',
      'SAR': '﷼',
      'QAR': 'ر.ق',
      'KWD': 'د.ك',
      'BHD': '.د.ب',
      'OMR': 'ر.ع.',
      'ILS': '₪',
      'JOD': 'د.ا',

      // Asian
      'INR': '₹',
      'PKR': '₨',
      'BDT': '৳',
      'SGD': 'S\$',
      'MYR': 'RM',
      'IDR': 'Rp',
      'PHP': '₱',
      'THB': '฿',
      'VND': '₫',
      'KRW': '₩',
      'TWD': 'NT\$',
      'LKR': 'Rs',
      'NPR': 'रू',

      // Latin American
      'BRL': 'R\$',
      'MXN': '\$',
      'ARS': '\$',
      'COP': '\$',
      'CLP': '\$',
      'PEN': 'S/',
      'UYU': '\$U',
      'BOB': 'Bs',
      'VES': 'Bs.S',

      // Eastern European
      'RUB': '₽',
      'PLN': 'zł',
      'CZK': 'Kč',
      'HUF': 'Ft',
      'RON': 'lei',
      'BGN': 'лв',
      'TRY': '₺',
      'UAH': '₴',
    };

    return symbols[currencyCode] ?? currencyCode;
  }
}
