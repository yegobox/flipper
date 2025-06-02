import 'package:flutter/material.dart';

/// A utility class that provides currency options for the system
class CurrencyOptions {
  /// Returns a list of DropdownMenuItem widgets for all supported currencies
  static List<DropdownMenuItem<String>> getCurrencyOptions() {
    return [
      // African Currencies
      const DropdownMenuItem(value: 'RWF', child: Text('RWF (Rwandan Franc)')),
      const DropdownMenuItem(
          value: 'KES', child: Text('KES (Kenyan Shilling)')),
      const DropdownMenuItem(
          value: 'UGX', child: Text('UGX (Ugandan Shilling)')),
      const DropdownMenuItem(
          value: 'TZS', child: Text('TZS (Tanzanian Shilling)')),
      const DropdownMenuItem(value: 'ETB', child: Text('ETB (Ethiopian Birr)')),
      const DropdownMenuItem(value: 'NGN', child: Text('NGN (Nigerian Naira)')),
      const DropdownMenuItem(
          value: 'ZAR', child: Text('ZAR (South African Rand)')),
      const DropdownMenuItem(value: 'GHS', child: Text('GHS (Ghanaian Cedi)')),
      const DropdownMenuItem(
          value: 'MAD', child: Text('MAD (Moroccan Dirham)')),
      const DropdownMenuItem(value: 'EGP', child: Text('EGP (Egyptian Pound)')),
      const DropdownMenuItem(value: 'DZD', child: Text('DZD (Algerian Dinar)')),
      const DropdownMenuItem(
          value: 'XOF', child: Text('XOF (CFA Franc BCEAO)')),
      const DropdownMenuItem(value: 'XAF', child: Text('XAF (CFA Franc BEAC)')),
      const DropdownMenuItem(
          value: 'MUR', child: Text('MUR (Mauritian Rupee)')),
      const DropdownMenuItem(value: 'BWP', child: Text('BWP (Botswanan Pula)')),
      const DropdownMenuItem(
          value: 'NAD', child: Text('NAD (Namibian Dollar)')),

      // Major International Currencies
      const DropdownMenuItem(value: 'USD', child: Text('USD (US Dollar)')),
      const DropdownMenuItem(value: 'EUR', child: Text('EUR (Euro)')),
      const DropdownMenuItem(value: 'GBP', child: Text('GBP (British Pound)')),
      const DropdownMenuItem(value: 'JPY', child: Text('JPY (Japanese Yen)')),
      const DropdownMenuItem(value: 'CNY', child: Text('CNY (Chinese Yuan)')),
      const DropdownMenuItem(
          value: 'CAD', child: Text('CAD (Canadian Dollar)')),
      const DropdownMenuItem(
          value: 'AUD', child: Text('AUD (Australian Dollar)')),
      const DropdownMenuItem(value: 'CHF', child: Text('CHF (Swiss Franc)')),
      const DropdownMenuItem(
          value: 'NZD', child: Text('NZD (New Zealand Dollar)')),
      const DropdownMenuItem(
          value: 'HKD', child: Text('HKD (Hong Kong Dollar)')),
      const DropdownMenuItem(value: 'SEK', child: Text('SEK (Swedish Krona)')),
      const DropdownMenuItem(
          value: 'NOK', child: Text('NOK (Norwegian Krone)')),
      const DropdownMenuItem(value: 'DKK', child: Text('DKK (Danish Krone)')),

      // Middle Eastern Currencies
      const DropdownMenuItem(value: 'AED', child: Text('AED (UAE Dirham)')),
      const DropdownMenuItem(value: 'SAR', child: Text('SAR (Saudi Riyal)')),
      const DropdownMenuItem(value: 'QAR', child: Text('QAR (Qatari Riyal)')),
      const DropdownMenuItem(value: 'KWD', child: Text('KWD (Kuwaiti Dinar)')),
      const DropdownMenuItem(value: 'BHD', child: Text('BHD (Bahraini Dinar)')),
      const DropdownMenuItem(value: 'OMR', child: Text('OMR (Omani Rial)')),
      const DropdownMenuItem(value: 'ILS', child: Text('ILS (Israeli Shekel)')),
      const DropdownMenuItem(
          value: 'JOD', child: Text('JOD (Jordanian Dinar)')),

      // Asian Currencies
      const DropdownMenuItem(value: 'INR', child: Text('INR (Indian Rupee)')),
      const DropdownMenuItem(
          value: 'PKR', child: Text('PKR (Pakistani Rupee)')),
      const DropdownMenuItem(
          value: 'BDT', child: Text('BDT (Bangladeshi Taka)')),
      const DropdownMenuItem(
          value: 'SGD', child: Text('SGD (Singapore Dollar)')),
      const DropdownMenuItem(
          value: 'MYR', child: Text('MYR (Malaysian Ringgit)')),
      const DropdownMenuItem(
          value: 'IDR', child: Text('IDR (Indonesian Rupiah)')),
      const DropdownMenuItem(
          value: 'PHP', child: Text('PHP (Philippine Peso)')),
      const DropdownMenuItem(value: 'THB', child: Text('THB (Thai Baht)')),
      const DropdownMenuItem(
          value: 'VND', child: Text('VND (Vietnamese Dong)')),
      const DropdownMenuItem(
          value: 'KRW', child: Text('KRW (South Korean Won)')),
      const DropdownMenuItem(
          value: 'TWD', child: Text('TWD (New Taiwan Dollar)')),
      const DropdownMenuItem(
          value: 'LKR', child: Text('LKR (Sri Lankan Rupee)')),
      const DropdownMenuItem(value: 'NPR', child: Text('NPR (Nepalese Rupee)')),

      // Latin American Currencies
      const DropdownMenuItem(value: 'BRL', child: Text('BRL (Brazilian Real)')),
      const DropdownMenuItem(value: 'MXN', child: Text('MXN (Mexican Peso)')),
      const DropdownMenuItem(value: 'ARS', child: Text('ARS (Argentine Peso)')),
      const DropdownMenuItem(value: 'COP', child: Text('COP (Colombian Peso)')),
      const DropdownMenuItem(value: 'CLP', child: Text('CLP (Chilean Peso)')),
      const DropdownMenuItem(value: 'PEN', child: Text('PEN (Peruvian Sol)')),
      const DropdownMenuItem(value: 'UYU', child: Text('UYU (Uruguayan Peso)')),
      const DropdownMenuItem(
          value: 'BOB', child: Text('BOB (Bolivian Boliviano)')),
      const DropdownMenuItem(
          value: 'VES', child: Text('VES (Venezuelan Bolívar)')),

      // Eastern European Currencies
      const DropdownMenuItem(value: 'RUB', child: Text('RUB (Russian Ruble)')),
      const DropdownMenuItem(value: 'PLN', child: Text('PLN (Polish Złoty)')),
      const DropdownMenuItem(value: 'CZK', child: Text('CZK (Czech Koruna)')),
      const DropdownMenuItem(
          value: 'HUF', child: Text('HUF (Hungarian Forint)')),
      const DropdownMenuItem(value: 'RON', child: Text('RON (Romanian Leu)')),
      const DropdownMenuItem(value: 'BGN', child: Text('BGN (Bulgarian Lev)')),
      const DropdownMenuItem(value: 'TRY', child: Text('TRY (Turkish Lira)')),
      const DropdownMenuItem(
          value: 'UAH', child: Text('UAH (Ukrainian Hryvnia)')),
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
