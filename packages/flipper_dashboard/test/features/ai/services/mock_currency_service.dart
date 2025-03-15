import 'package:flipper_dashboard/features/ai/services/currency_service.dart';

class MockCurrencyService implements CurrencyService {
  final String defaultCurrencyCode;

  MockCurrencyService({this.defaultCurrencyCode = 'RWF'});

  @override
  String getDefaultCurrency() => defaultCurrencyCode;

  @override
  String formatCurrencyValue(double value, {String? currency}) {
    final currencyCode = currency ?? defaultCurrencyCode;
    final formattedValue = value >= 1000000
        ? '${(value / 1000000).toStringAsFixed(2)}M'
        : value >= 1000
            ? '${(value / 1000).toStringAsFixed(2)}K'
            : value.toStringAsFixed(2);
    return '$currencyCode $formattedValue';
  }
}
