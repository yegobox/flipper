import 'package:flipper_services/proxy.dart';

abstract class CurrencyService {
  String getDefaultCurrency();
  String formatCurrencyValue(double value, {String? currency});
}

class ProxyCurrencyService implements CurrencyService {
  @override
  String getDefaultCurrency() => ProxyService.box.defaultCurrency();

  @override
  String formatCurrencyValue(double value, {String? currency}) {
    final currencyCode = currency ?? getDefaultCurrency();
    final formattedValue = value >= 1000000
        ? '${(value / 1000000).toStringAsFixed(2)}M'
        : value >= 1000
            ? '${(value / 1000).toStringAsFixed(2)}K'
            : value.toStringAsFixed(2);
    return '$currencyCode $formattedValue';
  }
}
