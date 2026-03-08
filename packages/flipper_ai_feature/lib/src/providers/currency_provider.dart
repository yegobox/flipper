import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/currency_service.dart';

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return ProxyCurrencyService();
});
