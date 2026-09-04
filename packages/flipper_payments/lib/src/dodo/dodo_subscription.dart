import 'dart:async';

import 'package:flipper_payments/src/logging.dart';
import 'package:flipper_payments/src/dodo/dodo_client.dart';
import 'package:flipper_payments/src/dodo/dodo_models.dart';
import 'package:url_launcher/url_launcher.dart';

/// How a card checkout attempt ended.
enum DodoCheckoutOutcome {
  /// The subscription is active (or inside a period already paid for). Let the
  /// customer into the app.
  entitled,

  /// The link opened and we are waiting for Dodo. Poll, or let the customer
  /// come back to it.
  awaitingPayment,

  /// We had a link and could not open it — no browser, or the platform refused.
  /// **Nothing has been charged**; the customer can be offered Mobile Money.
  couldNotOpenLink,

  /// The renewal failed and Dodo wants a fresh card. The link attached is the
  /// documented way out: Dodo collects the outstanding dues from the new card.
  needsPaymentMethod,

  /// Terminal — cancelled, expired, or failed. Start again.
  resubscribeRequired,
}

/// The end of one card checkout attempt.
class DodoCheckoutResult {
  const DodoCheckoutResult({
    required this.outcome,
    required this.planId,
    this.start,
    this.status,
    this.checkout,
    this.message,
    this.launched = false,
  });

  final DodoCheckoutOutcome outcome;
  final String planId;

  /// The start call's reply, when this attempt made one.
  final DodoStartResult? start;

  /// The latest status read, when this attempt made one.
  final DodoSubscriptionStatus? status;

  /// The page the customer was (or should be) sent to.
  final DodoCheckout? checkout;

  final String? message;

  /// True when a browser was actually opened.
  final bool launched;

  bool get isEntitled => outcome == DodoCheckoutOutcome.entitled;

  /// True when the customer still has something to do on Dodo's page.
  bool get needsCustomerAction =>
      outcome == DodoCheckoutOutcome.awaitingPayment ||
      outcome == DodoCheckoutOutcome.needsPaymentMethod;

  @override
  String toString() =>
      'DodoCheckoutResult(${outcome.name}, plan=$planId, launched=$launched)';
}

/// Signature of the "open this URL" step, so tests never touch url_launcher.
typedef DodoLinkOpener = Future<bool> Function(Uri url);

/// Drives the card rail end to end: start the subscription, open Dodo's hosted
/// checkout, then wait for the money to land.
///
/// The shape is the inverse of [MomoSubscriptionCharger] and the difference is
/// worth stating, because it is the reason the two rails cannot share code:
/// with MoMo *we* push a debit and poll MTN for a verdict, so consent has to be
/// established before any money moves. With Dodo the customer pays on a page
/// Dodo owns, so the consent, the card, and the mandate are all Dodo's — there
/// is nothing to pre-approve and nothing to charge. Our whole job is to hand
/// over the right link and then find out what happened.
class DodoCardCheckout {
  DodoCardCheckout(this._client, {DodoLinkOpener? openLink})
      : _openLink = openLink ?? _launchExternal;

  final DodoClient _client;
  final DodoLinkOpener _openLink;

  /// How long to keep asking after the browser opened. Generous on purpose: a
  /// customer entering card details on a phone, possibly through a 3-D Secure
  /// step, is not done in thirty seconds.
  static const Duration defaultTimeout = Duration(minutes: 10);

  /// How often to read the connector's view. This is a cheap local read — the
  /// webhook is what makes it move.
  static const Duration defaultPollInterval = Duration(seconds: 5);

  /// Every Nth poll forces a read-through to Dodo instead.
  ///
  /// Webhooks are primary and near-instant; this is the safety net for one that
  /// never arrives, which would otherwise leave a customer who *has* paid
  /// staring at a spinner until the connector's own 15-minute sweep runs.
  static const int forceSyncEveryNthPoll = 4;

  static Future<bool> _launchExternal(Uri url) => launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

  /// Starts the subscription and opens the checkout page.
  ///
  /// Does **not** wait for payment — call [awaitEntitlement] for that, so the
  /// screen can show a "finish on the payment page" state in between.
  ///
  /// Safe to call twice: the connector returns the pending subscription's
  /// existing link rather than creating a second one, so a double tap cannot
  /// put two subscriptions on the customer's card.
  Future<DodoCheckoutResult> start({
    required String businessId,
    String? planId,
    String? branchId,
    String? planTemplateId,
    String? selectedPlan,
    List<String> addons = const [],
    bool isYearlyPlan = false,
    String? email,
    String? customerName,
    String? phoneNumber,
    String? country,
    int? additionalDevices,
    Map<String, String>? metadata,
    bool openCheckout = true,
  }) async {
    final result = await _client.startSubscription(
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
      metadata: metadata,
    );

    // Switch on `next_action`, never on `status`: the connector promises the
    // action set is stable while Dodo's statuses are not.
    switch (result.nextAction) {
      case DodoNextAction.resubscribe:
        return DodoCheckoutResult(
          outcome: DodoCheckoutOutcome.resubscribeRequired,
          planId: result.planId,
          start: result,
          message: 'This subscription has ended. Choose a plan to start again.',
        );

      case DodoNextAction.openPaymentLink:
      case DodoNextAction.updatePaymentMethod:
        final needsCard = result.nextAction == DodoNextAction.updatePaymentMethod;
        if (!result.checkout.hasLink) {
          // The connector said "open a link" and sent none. Never reported as a
          // charge failure: the subscription exists upstream.
          return DodoCheckoutResult(
            outcome: needsCard
                ? DodoCheckoutOutcome.needsPaymentMethod
                : DodoCheckoutOutcome.awaitingPayment,
            planId: result.planId,
            start: result,
            message: 'The payment page is not ready yet. Try again in a moment.',
          );
        }
        if (!openCheckout) {
          return DodoCheckoutResult(
            outcome: needsCard
                ? DodoCheckoutOutcome.needsPaymentMethod
                : DodoCheckoutOutcome.awaitingPayment,
            planId: result.planId,
            start: result,
            checkout: result.checkout,
          );
        }
        final launched = await _open(result.checkout.paymentLink!);
        return DodoCheckoutResult(
          outcome: launched
              ? (needsCard
                  ? DodoCheckoutOutcome.needsPaymentMethod
                  : DodoCheckoutOutcome.awaitingPayment)
              : DodoCheckoutOutcome.couldNotOpenLink,
          planId: result.planId,
          start: result,
          checkout: result.checkout,
          launched: launched,
          message: launched
              ? null
              : 'Could not open the payment page on this device. Copy the link, '
                  'or pay with Mobile Money instead.',
        );

      case DodoNextAction.none:
      case DodoNextAction.awaitingActivation:
      case DodoNextAction.unknown:
        // `none` right after a start means the subscription is already good —
        // a re-subscribe onto an active plan, typically. Confirm rather than
        // assume, so we never wave someone through on a status we misread.
        final status = await _safeStatus(result.planId);
        if (status?.entitled == true) {
          return DodoCheckoutResult(
            outcome: DodoCheckoutOutcome.entitled,
            planId: result.planId,
            start: result,
            status: status,
          );
        }
        return DodoCheckoutResult(
          outcome: DodoCheckoutOutcome.awaitingPayment,
          planId: result.planId,
          start: result,
          status: status,
          checkout: result.checkout.hasLink ? result.checkout : null,
        );
    }
  }

  /// Opens a fresh card link for a subscription Dodo has put `on_hold`.
  ///
  /// Dodo collects the outstanding dues from the new card, so this — not a new
  /// subscription — is how a failed renewal is recovered.
  Future<DodoCheckoutResult> openPaymentMethodUpdate(String planId) async {
    final checkout = await _client.updatePaymentMethod(planId);
    final launched = await _open(checkout.paymentLink!);
    return DodoCheckoutResult(
      outcome: launched
          ? DodoCheckoutOutcome.needsPaymentMethod
          : DodoCheckoutOutcome.couldNotOpenLink,
      planId: planId,
      checkout: checkout,
      launched: launched,
      message: launched
          ? null
          : 'Could not open the payment page on this device.',
    );
  }

  /// Opens a checkout link that already exists.
  ///
  /// For a screen offering "reopen the payment page": the customer closed the
  /// browser tab, and the *same* link is what should come back — a fresh start
  /// would be safe but pointless, and this needs no round trip.
  Future<bool> openPaymentLink(String link) => _open(link);

  /// Polls until the subscription is entitled, reaches a verdict, or times out.
  ///
  /// [onStatus] fires on every read so a screen can narrate progress. Returns
  /// the last status seen; `null` only when nothing could be read at all.
  ///
  /// A read that throws does **not** end the wait: a connector blip while the
  /// customer is on Dodo's page says nothing about whether they paid.
  Future<DodoSubscriptionStatus?> awaitEntitlement(
    String planId, {
    Duration timeout = defaultTimeout,
    Duration pollInterval = defaultPollInterval,
    void Function(DodoSubscriptionStatus status)? onStatus,
    bool Function()? isCancelled,
  }) async {
    final deadline = DateTime.now().add(timeout);
    DodoSubscriptionStatus? last;
    var attempt = 0;

    while (DateTime.now().isBefore(deadline)) {
      if (isCancelled?.call() == true) return last;

      attempt++;
      final forceSync = attempt % forceSyncEveryNthPoll == 0;
      final status = await _safeStatus(planId, forceSync: forceSync);

      if (status != null) {
        last = status;
        onStatus?.call(status);
        if (status.entitled) {
          payLogInfo('Dodo: plan $planId is entitled after $attempt polls');
          return status;
        }
        if (status.nextAction == DodoNextAction.resubscribe ||
            status.nextAction == DodoNextAction.updatePaymentMethod) {
          payLogWarning(
            'Dodo: plan $planId stopped at ${status.status} '
            '(${status.nextAction.name})',
          );
          return status;
        }
      }

      await Future<void>.delayed(pollInterval);
    }

    payLogWarning('Dodo: gave up waiting on plan $planId after $timeout');
    return last;
  }

  /// Maps the last status onto an outcome, for a screen that polled itself.
  static DodoCheckoutOutcome outcomeFor(DodoSubscriptionStatus? status) {
    if (status == null) return DodoCheckoutOutcome.awaitingPayment;
    if (status.entitled) return DodoCheckoutOutcome.entitled;
    return switch (status.nextAction) {
      DodoNextAction.resubscribe => DodoCheckoutOutcome.resubscribeRequired,
      DodoNextAction.updatePaymentMethod =>
        DodoCheckoutOutcome.needsPaymentMethod,
      _ => DodoCheckoutOutcome.awaitingPayment,
    };
  }

  Future<bool> _open(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) {
      payLogError('Dodo: unusable checkout link "$link"');
      return false;
    }
    try {
      final opened = await _openLink(uri);
      if (!opened) payLogWarning('Dodo: the platform refused to open $uri');
      return opened;
    } catch (e) {
      payLogError('Dodo: could not open the checkout page: $e');
      return false;
    }
  }

  /// A status read that never throws — see [awaitEntitlement].
  Future<DodoSubscriptionStatus?> _safeStatus(
    String planId, {
    bool forceSync = false,
  }) async {
    try {
      return forceSync
          ? await _client.syncSubscription(planId)
          : await _client.subscriptionForPlan(planId);
    } on DodoException catch (e) {
      // A forced sync 404s on a plan with no Dodo row yet; the plain read is
      // still worth trying before we call the poll a loss.
      if (forceSync) {
        payLogWarning('Dodo sync failed ($e); falling back to a plain read');
        return _safeStatus(planId);
      }
      payLogWarning('Dodo status read failed: $e');
      return null;
    } catch (e) {
      payLogWarning('Dodo status read failed: $e');
      return null;
    }
  }
}
