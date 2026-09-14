import 'package:flipper_payments/flipper_payments.dart';
import 'package:url_launcher/url_launcher.dart';

/// The two ways a Books subscription gets paid, behind one seam so the
/// controller can be tested without a gateway.
///
/// Thin on purpose: every method maps to one `flipper_payments` call. The
/// mobile app drives the same rails through `PaymentHandler`, which cannot be
/// imported here (it sits above flipper_web in the dependency graph).
abstract class BooksPaymentRails {
  /// Establishes Mobile Money consent, then pushes the debit.
  Future<MomoSubscriptionResult> chargeMomo({
    required String phoneNumber,
    required int amount,
    required String planId,
    required String businessId,
    String? branchId,
    int? validitySeconds,
    void Function(MomoMandate mandate)? onMandate,
  });

  /// One read of the request-to-pay. On data-connector the read itself
  /// settles the plan row when MTN reports success.
  Future<MomoSettlement> momoStatus(String reference, {String? branchId});

  /// Starts the card subscription and opens Dodo's hosted checkout.
  Future<DodoCheckoutResult> startCard({
    required String businessId,
    required String planId,
    String? branchId,
    String? planTemplateId,
    required String selectedPlan,
    List<String> addons = const [],
    bool isYearlyPlan = false,
    required String email,
    String? customerName,
    String? phoneNumber,
    String? country,
    int? additionalDevices,
    String? returnUrl,
  });

  /// Polls until the card subscription is entitled, stops, or times out.
  Future<DodoSubscriptionStatus?> awaitCardEntitlement(
    String planId, {
    required Duration timeout,
    Duration pollInterval,
    void Function(DodoSubscriptionStatus status)? onStatus,
    bool Function()? isCancelled,
  });

  /// Whether this build can sell a card subscription at all.
  Future<bool> isCardAvailable();

  /// True when card payments hit Dodo's test account (debug builds).
  bool get isCardTestMode;
}

/// [BooksPaymentRails] over `flipper_payments`, against the shared connector.
///
/// Uses the package's default HTTP client and base URL: flipper_web registers
/// no host plumbing, which is the intended configuration for Books and HR.
class FlipperPaymentsRails implements BooksPaymentRails {
  FlipperPaymentsRails({
    PaymentsHttpClient? httpClient,
    DodoLinkOpener? openLink,
  })  : _http = httpClient ?? defaultPaymentsHttpClient,
        _openLink = openLink ?? openCheckoutInNewTab;

  final PaymentsHttpClient _http;
  final DodoLinkOpener _openLink;

  MomoClient get _momo => MomoClient(_http);
  DodoClient get _dodo => DodoClient(_http);

  /// Opens Dodo's page in a new tab so the paywall tab keeps polling and is
  /// still there to land on when Dodo redirects back.
  static Future<bool> openCheckoutInNewTab(Uri url) => launchUrl(
        url,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );

  @override
  Future<MomoSubscriptionResult> chargeMomo({
    required String phoneNumber,
    required int amount,
    required String planId,
    required String businessId,
    String? branchId,
    int? validitySeconds,
    void Function(MomoMandate mandate)? onMandate,
  }) {
    return MomoSubscriptionCharger(_momo).charge(
      phoneNumber: phoneNumber,
      amount: amount,
      planId: planId,
      businessId: businessId,
      branchId: branchId,
      validitySeconds: validitySeconds,
      onMandate: onMandate,
    );
  }

  @override
  Future<MomoSettlement> momoStatus(String reference, {String? branchId}) =>
      _momo.requestToPayStatus(reference, branchId: branchId);

  @override
  Future<DodoCheckoutResult> startCard({
    required String businessId,
    required String planId,
    String? branchId,
    String? planTemplateId,
    required String selectedPlan,
    List<String> addons = const [],
    bool isYearlyPlan = false,
    required String email,
    String? customerName,
    String? phoneNumber,
    String? country,
    int? additionalDevices,
    String? returnUrl,
  }) {
    return DodoCardCheckout(_dodo, openLink: _openLink).start(
      businessId: businessId,
      planId: planId,
      branchId: branchId,
      planTemplateId: planTemplateId,
      selectedPlan: selectedPlan,
      addons: addons,
      isYearlyPlan: isYearlyPlan,
      email: email,
      customerName: customerName,
      phoneNumber: phoneNumber,
      country: country,
      additionalDevices: additionalDevices,
      returnUrl: returnUrl,
    );
  }

  @override
  Future<DodoSubscriptionStatus?> awaitCardEntitlement(
    String planId, {
    required Duration timeout,
    Duration pollInterval = DodoCardCheckout.defaultPollInterval,
    void Function(DodoSubscriptionStatus status)? onStatus,
    bool Function()? isCancelled,
  }) {
    return DodoCardCheckout(_dodo, openLink: _openLink).awaitEntitlement(
      planId,
      timeout: timeout,
      pollInterval: pollInterval,
      onStatus: onStatus,
      isCancelled: isCancelled,
    );
  }

  @override
  Future<bool> isCardAvailable() => isCardPaymentAvailable();

  @override
  bool get isCardTestMode => dodoBuildMode == 'test';
}
