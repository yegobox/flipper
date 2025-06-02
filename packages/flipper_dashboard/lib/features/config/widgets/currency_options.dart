import 'package:flutter/material.dart';

/// A utility class that provides currency options for the system
class CurrencyOptions {
  /// Returns a list of DropdownMenuItem widgets for all supported currencies
  static List<DropdownMenuItem<String>> getCurrencyOptions() {
    return [
      // African Currencies
      const DropdownMenuItem(value: 'RWF', child: Text('RWF (Rwandan Franc)')),
      const DropdownMenuItem(value: 'KES', child: Text('KES (Kenyan Shilling)')),
      const DropdownMenuItem(value: 'UGX', child: Text('UGX (Ugandan Shilling)')),
      const DropdownMenuItem(value: 'TZS', child: Text('TZS (Tanzanian Shilling)')),
      const DropdownMenuItem(value: 'ETB', child: Text('ETB (Ethiopian Birr)')),
      const DropdownMenuItem(value: 'NGN', child: Text('NGN (Nigerian Naira)')),
      const DropdownMenuItem(value: 'ZAR', child: Text('ZAR (South African Rand)')),
      const DropdownMenuItem(value: 'GHS', child: Text('GHS (Ghanaian Cedi)')),
      
      // Major International Currencies
      const DropdownMenuItem(value: 'USD', child: Text('USD (US Dollar)')),
      const DropdownMenuItem(value: 'EUR', child: Text('EUR (Euro)')),
      const DropdownMenuItem(value: 'GBP', child: Text('GBP (British Pound)')),
      const DropdownMenuItem(value: 'JPY', child: Text('JPY (Japanese Yen)')),
      const DropdownMenuItem(value: 'CNY', child: Text('CNY (Chinese Yuan)')),
      const DropdownMenuItem(value: 'CAD', child: Text('CAD (Canadian Dollar)')),
      const DropdownMenuItem(value: 'AUD', child: Text('AUD (Australian Dollar)')),
      
      // Middle Eastern Currencies
      const DropdownMenuItem(value: 'AED', child: Text('AED (UAE Dirham)')),
      const DropdownMenuItem(value: 'SAR', child: Text('SAR (Saudi Riyal)')),
      
      // Asian Currencies
      const DropdownMenuItem(value: 'INR', child: Text('INR (Indian Rupee)')),
      const DropdownMenuItem(value: 'PKR', child: Text('PKR (Pakistani Rupee)')),
      const DropdownMenuItem(value: 'BDT', child: Text('BDT (Bangladeshi Taka)')),
      const DropdownMenuItem(value: 'SGD', child: Text('SGD (Singapore Dollar)')),
      const DropdownMenuItem(value: 'MYR', child: Text('MYR (Malaysian Ringgit)')),
      
      // Latin American Currencies
      const DropdownMenuItem(value: 'BRL', child: Text('BRL (Brazilian Real)')),
      const DropdownMenuItem(value: 'MXN', child: Text('MXN (Mexican Peso)')),
      const DropdownMenuItem(value: 'ARS', child: Text('ARS (Argentine Peso)')),
      const DropdownMenuItem(value: 'COP', child: Text('COP (Colombian Peso)')),
    ];
  }

  /// Returns a list of currency codes
  static List<String> getCurrencyCodes() {
    return [
      'RWF', 'KES', 'UGX', 'TZS', 'ETB', 'NGN', 'ZAR', 'GHS',  // African
      'USD', 'EUR', 'GBP', 'JPY', 'CNY', 'CAD', 'AUD',         // International
      'AED', 'SAR',                                            // Middle Eastern
      'INR', 'PKR', 'BDT', 'SGD', 'MYR',                       // Asian
      'BRL', 'MXN', 'ARS', 'COP',                              // Latin American
    ];
  }

  /// Returns the symbol for a given currency code
  static String getSymbolForCurrency(String currencyCode) {
    final Map<String, String> symbols = {
      'RWF': 'RF',
      'KES': 'KSh',
      'UGX': 'USh',
      'TZS': 'TSh',
      'ETB': 'Br',
      'NGN': '₦',
      'ZAR': 'R',
      'GHS': 'GH₵',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'AED': 'د.إ',
      'SAR': '﷼',
      'INR': '₹',
      'PKR': '₨',
      'BDT': '৳',
      'SGD': 'S\$',
      'MYR': 'RM',
      'BRL': 'R\$',
      'MXN': '\$',
      'ARS': '\$',
      'COP': '\$',
    };
    
    return symbols[currencyCode] ?? currencyCode;
  }
}
