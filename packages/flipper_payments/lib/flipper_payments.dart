/// Subscriptions and collections, shared by every Flipper app.
///
/// One implementation of the MTN MoMo and Dodo card rails, the plan catalogue,
/// entitlement, and the paywall UI — so POS, Books and HR bill the same way,
/// against the same host, with the same guarantees. Before this package,
/// `flipper_hr` carried a second MoMo client with no pre-approval mandate and a
/// different base URL.
///
/// Wiring for a host app, both optional:
///
/// ```dart
/// setDefaultPaymentsHttpClient(myAdapter);   // else a plain package:http client
/// setPaymentsBaseUrlResolver(() async => …); // else kPaymentsApiBaseUrl
/// setPaymentsLogSink((level, message) => …); // else debugPrint in debug
/// ```
library;

// ── plumbing the host may replace ──
export 'src/http/payments_http_client.dart';
export 'src/logging.dart';
export 'src/payments_api.dart';

// ── rails ──
export 'src/payment_rail.dart';
export 'src/momo/momo_client.dart';
export 'src/momo/momo_collection.dart';
export 'src/momo/momo_models.dart';
export 'src/momo/momo_msisdn.dart';
export 'src/momo/momo_subscription.dart';
export 'src/dodo/dodo_availability.dart';
export 'src/dodo/dodo_client.dart';
export 'src/dodo/dodo_models.dart';
export 'src/dodo/dodo_subscription.dart';

// ── catalogue ──
export 'src/catalog/billing_cadence.dart';
export 'src/catalog/subscription_plan.dart';
export 'src/catalog/subscription_plan_template.dart';

// ── presentation ──
export 'src/ui/payment_format.dart';
export 'src/ui/payment_tokens.dart';
export 'src/ui/payment_typography.dart';
export 'src/ui/widgets/payment_widgets.dart';
