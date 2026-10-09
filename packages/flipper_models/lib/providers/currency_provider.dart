import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ISO code of the business currency (e.g. `RWF`), for labelling amounts.
///
/// Widgets watch this instead of reading `ProxyService.box` directly, so tests
/// can override it. Not keepAlive: the box value can change after a business
/// switch, and a kept-alive read would latch the first one.
final defaultCurrencyProvider = Provider.autoDispose<String>(
  (ref) => ProxyService.box.defaultCurrency(),
);
