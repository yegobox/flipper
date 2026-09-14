import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/application/books_billing_providers.dart';
import 'package:flipper_web/features/billing/data/books_payment_rails.dart';
import 'package:flipper_web/features/billing/data/books_plan_repository.dart';
import 'package:flipper_web/features/billing/data/books_return_url.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where one subscription purchase has got to.
enum BooksPaymentStage {
  idle,

  /// Pricing the plan and writing the plan row.
  preparing,

  /// The MoMo push is out; the payer has to approve it on their handset.
  awaitingApproval,

  /// The card checkout is open in another tab; waiting on Dodo.
  awaitingCheckout,

  /// Settled, and the plan is paid.
  confirmed,
  failed,

  /// Still unresolved when the poll window closed.
  timedOut,
}

class BooksPaymentState {
  const BooksPaymentState({
    this.stage = BooksPaymentStage.idle,
    this.rail,
    this.planId,
    this.reference,
    this.amountRwf = 0,
    this.message,
    this.checkoutLink,
  });

  final BooksPaymentStage stage;
  final PaymentRail? rail;
  final String? planId;

  /// MTN's reference for the request-to-pay, once one went out.
  final String? reference;
  final int amountRwf;

  /// What to tell the user — an error while failed, progress otherwise.
  final String? message;

  /// The card checkout page, kept so a closed tab can be reopened.
  final String? checkoutLink;

  bool get isBusy =>
      stage == BooksPaymentStage.preparing ||
      stage == BooksPaymentStage.awaitingApproval ||
      stage == BooksPaymentStage.awaitingCheckout;

  bool get isConfirmed => stage == BooksPaymentStage.confirmed;

  BooksPaymentState copyWith({
    BooksPaymentStage? stage,
    PaymentRail? rail,
    String? planId,
    String? reference,
    int? amountRwf,
    String? message,
    String? checkoutLink,
    bool clearMessage = false,
  }) {
    return BooksPaymentState(
      stage: stage ?? this.stage,
      rail: rail ?? this.rail,
      planId: planId ?? this.planId,
      reference: reference ?? this.reference,
      amountRwf: amountRwf ?? this.amountRwf,
      message: clearMessage ? null : (message ?? this.message),
      checkoutLink: checkoutLink ?? this.checkoutLink,
    );
  }
}

/// What the customer picked on the paywall.
class BooksPlanSelection {
  const BooksPlanSelection({
    required this.template,
    required this.cadence,
    this.addonSlugs = const [],
    this.additionalDevices = 0,
    this.existing,
  });

  final SubscriptionPlanTemplate template;
  final BillingCadence cadence;
  final List<String> addonSlugs;
  final int additionalDevices;

  /// The row already on the business, so a renewal keeps its id.
  final Plan? existing;

  /// Whole francs, priced exactly as the mobile app prices the same pick.
  int get totalRwf => template
      .calculateTotalFor(cadence: cadence, selectedAddonSlugs: addonSlugs)
      .round();

  /// Add-on display names — what mobile stores in `addons.addon_name`.
  List<String> get addonNames => [
        for (final addon in template.addons)
          if (addonSlugs.contains(addon.slug)) addon.name,
      ];

  BooksPlanDraft toDraft({
    required String businessId,
    String? branchId,
    required String paymentMethod,
    String? phoneNumber,
  }) {
    return BooksPlanDraft(
      businessId: businessId,
      branchId: branchId,
      selectedPlan: template.name,
      planTemplateId: template.id,
      additionalDevices: additionalDevices,
      cadence: cadence,
      totalPrice: totalRwf,
      paymentMethod: paymentMethod,
      addonNames: addonNames,
      phoneNumber: phoneNumber,
      existing: existing,
    );
  }
}

/// Drives one subscription purchase on either rail: write the plan row, take
/// the money, then wait until the gateway gives a verdict or the window closes.
///
/// The mobile app does the same in `PaymentHandler`; this is that logic on
/// Riverpod, writing the same row, so the phone honours a payment made here.
class BooksSubscriptionController extends Notifier<BooksPaymentState> {
  bool _disposed = false;

  /// Pre-approval validity: the plan period plus a buffer for billing to run
  /// before the mandate lapses. Short in debug so a test cycle is quick.
  static int validitySecondsFor(BillingCadence cadence) {
    if (kDebugMode) return 120;
    const secondsPerDay = 86400;
    const billingBufferDays = 15;
    return (cadence.periodDays + billingBufferDays) * secondsPerDay;
  }

  @override
  BooksPaymentState build() {
    ref.onDispose(() => _disposed = true);
    return const BooksPaymentState();
  }

  /// Writes only while alive. Leaving the paywall mid-poll disposes this
  /// notifier; the charge continues server-side and the next entitlement read
  /// finds it settled.
  void _set(BooksPaymentState next) {
    if (_disposed) return;
    state = next;
  }

  void reset() => _set(const BooksPaymentState());

  // ── Mobile Money ──────────────────────────────────────────────────────────

  Future<void> payWithMomo({
    required Business business,
    String? branchId,
    required BooksPlanSelection selection,
    required String phoneNumber,
  }) async {
    if (state.isBusy) return;

    if (!MomoMsisdn.isPlausible(phoneNumber)) {
      _set(
        const BooksPaymentState(
          stage: BooksPaymentStage.failed,
          rail: PaymentRail.mtnMomo,
          message: 'Enter a valid Mobile Money number, e.g. 0788123456.',
        ),
      );
      return;
    }

    final amount = selection.totalRwf;
    _set(
      BooksPaymentState(
        stage: BooksPaymentStage.preparing,
        rail: PaymentRail.mtnMomo,
        amountRwf: amount,
        message: 'Preparing your subscription…',
      ),
    );

    // Read every provider before the first await: `ref` is unusable once the
    // paywall is disposed mid-payment, and the charge must still finish.
    final repo = ref.read(booksPlanRepositoryProvider);
    final rails = ref.read(booksPaymentRailsProvider);

    // Row before request, as on mobile: the backend prices the pre-approval
    // from the plan it finds, so the row has to say the right amount first.
    final Plan plan;
    try {
      plan = await repo.savePlan(
            selection.toDraft(
              businessId: business.id,
              branchId: branchId,
              paymentMethod: PaymentRail.mtnMomo.wireValue,
              phoneNumber: phoneNumber,
            ),
          );
    } catch (e) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'Could not save the subscription: ${_describe(e)}',
        ),
      );
      return;
    }

    final planId = plan.id;
    if (planId == null || planId.isEmpty) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'This subscription has no plan id yet, so it cannot be '
              'charged safely. Reload and try again.',
        ),
      );
      return;
    }

    _set(
      state.copyWith(
        planId: planId,
        message: 'Sending the request to your phone…',
      ),
    );

    final MomoSubscriptionResult result;
    try {
      result = await rails.chargeMomo(
            phoneNumber: phoneNumber,
            amount: amount,
            planId: planId,
            businessId: business.id,
            branchId: branchId,
            validitySeconds: validitySecondsFor(selection.cadence),
            onMandate: (mandate) {
              if (mandate.needsPayerAction || mandate.isAwaitingApproval) {
                _set(
                  state.copyWith(
                    message: 'Approve the Mobile Money request on your phone.',
                  ),
                );
              }
            },
          );
    } on MomoException catch (e) {
      _set(state.copyWith(stage: BooksPaymentStage.failed, message: e.message));
      return;
    } on MomoUnavailable catch (e) {
      _set(state.copyWith(stage: BooksPaymentStage.failed, message: e.message));
      return;
    } catch (e) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'The payment could not be started: ${_describe(e)}',
        ),
      );
      return;
    }

    switch (result.outcome) {
      case MomoSubscriptionOutcome.preapprovalRefused:
        // The payer said no. Nothing was debited, and nothing will be.
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            message: result.message ??
                'Mobile Money consent was declined, so nothing was charged.',
          ),
        );
        return;
      case MomoSubscriptionOutcome.chargeRejected:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            message: result.message ?? 'The payment could not be started.',
          ),
        );
        return;
      case MomoSubscriptionOutcome.charged:
        break;
    }

    final reference = result.reference;
    if (reference == null || reference.isEmpty) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'The gateway accepted the payment but returned no '
              'reference to track it. Check your phone, then try again.',
        ),
      );
      return;
    }

    _set(
      state.copyWith(
        stage: BooksPaymentStage.awaitingApproval,
        reference: reference,
        message: 'Approve the Mobile Money request on your phone.',
      ),
    );

    if (_disposed) return;
    await _pollMomo(
      repo: repo,
      rails: rails,
      businessId: business.id,
      branchId: branchId,
      planId: planId,
      reference: reference,
    );
  }

  Future<void> _pollMomo({
    required BooksPlanRepository repo,
    required BooksPaymentRails rails,
    required String businessId,
    String? branchId,
    required String planId,
    required String reference,
  }) async {
    final interval = ref.read(booksMomoPollIntervalProvider);
    final deadline = DateTime.now().add(ref.read(booksMomoPollTimeoutProvider));

    while (!_disposed && DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);
      if (_disposed) return;

      MomoSettlement settlement;
      try {
        settlement = await rails.momoStatus(reference, branchId: branchId);
      } catch (_) {
        // A failed *read* is not a failed payment — the connection may simply
        // have blinked. Keep polling until the deadline.
        continue;
      }
      if (_disposed) return;

      // A pending status can still carry an explanation, and when it does it
      // is usually the reason no prompt will ever arrive. Keep polling, but
      // stop hiding it.
      final reason = settlement.reason?.trim();
      if (settlement.isPending && reason != null && reason.isNotEmpty) {
        _set(state.copyWith(message: reason));
      }

      if (settlement.isSuccessful) {
        // Nudge the backend to settle the plan row now rather than on its
        // next sweep, then re-read entitlement so Books opens on this device.
        await repo.finalizeOnSuccess(planId: planId, reference: reference);
        await _refreshAccess(businessId);
        _set(
          state.copyWith(
            stage: BooksPaymentStage.confirmed,
            message: 'Payment received. Your subscription is active.',
          ),
        );
        return;
      }

      if (settlement.isFailed) {
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            message: reason == null || reason.isEmpty
                ? 'The payment was not completed on your phone.'
                : reason,
          ),
        );
        return;
      }
    }

    if (_disposed) return;
    _set(
      state.copyWith(
        stage: BooksPaymentStage.timedOut,
        message: 'We have not had a verdict from Mobile Money yet. If you '
            'approved the request, Books will open shortly — check again in '
            'a moment.',
      ),
    );
  }

  // ── Card ──────────────────────────────────────────────────────────────────

  Future<void> payWithCard({
    required Business business,
    String? branchId,
    required BooksPlanSelection selection,
    required String email,
    String? phoneNumber,
  }) async {
    if (state.isBusy) return;

    // Dodo needs an address to create the customer and send invoices to; the
    // connector fails without one, so catch it here with something actionable.
    final resolvedEmail = email.trim();
    if (resolvedEmail.isEmpty || !resolvedEmail.contains('@')) {
      _set(
        const BooksPaymentState(
          stage: BooksPaymentStage.failed,
          rail: PaymentRail.card,
          message: 'Card payment needs an email address for the receipt.',
        ),
      );
      return;
    }

    final amount = selection.totalRwf;
    _set(
      BooksPaymentState(
        stage: BooksPaymentStage.preparing,
        rail: PaymentRail.card,
        amountRwf: amount,
        message: 'Preparing your subscription…',
      ),
    );

    final repo = ref.read(booksPlanRepositoryProvider);
    final rails = ref.read(booksPaymentRailsProvider);

    // Row before request, as on the MoMo rail: if the start call or the tab
    // hand-off dies, the plan already records which rail was chosen.
    final Plan plan;
    try {
      plan = await repo.savePlan(
            selection.toDraft(
              businessId: business.id,
              branchId: branchId,
              paymentMethod: PaymentRail.card.wireValue,
              phoneNumber: phoneNumber,
            ),
          );
    } catch (e) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'Could not save the subscription: ${_describe(e)}',
        ),
      );
      return;
    }

    final planId = plan.id;
    if (planId == null || planId.isEmpty) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'This subscription has no plan id yet, so it cannot be '
              'paid safely. Reload and try again.',
        ),
      );
      return;
    }

    _set(state.copyWith(planId: planId, message: 'Opening the payment page…'));

    final DodoCheckoutResult result;
    try {
      result = await rails.startCard(
            businessId: business.id,
            planId: planId,
            branchId: branchId,
            planTemplateId: selection.template.id,
            selectedPlan: selection.template.name,
            addons: selection.addonNames,
            isYearlyPlan: selection.cadence.isYearly,
            email: resolvedEmail,
            customerName: business.name,
            phoneNumber: _firstNonEmpty([phoneNumber, business.phoneNumber]),
            country: _firstNonEmpty([business.country]),
            additionalDevices: selection.additionalDevices,
            returnUrl: booksSubscribeReturnUrl(planId),
          );
    } catch (e) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'The card payment could not be started: ${_describe(e)}',
        ),
      );
      return;
    }

    if (_disposed) return;
    final link = result.checkout?.paymentLink;
    switch (result.outcome) {
      case DodoCheckoutOutcome.entitled:
        await _refreshAccess(business.id);
        _set(
          state.copyWith(
            stage: BooksPaymentStage.confirmed,
            message: 'This subscription is already active.',
          ),
        );
        return;
      case DodoCheckoutOutcome.couldNotOpenLink:
        // Nothing was charged. Offer the link rather than saying "failed".
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            checkoutLink: link,
            message: result.message ??
                'Could not open the card payment page in this browser.',
          ),
        );
        return;
      case DodoCheckoutOutcome.resubscribeRequired:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            message: result.message ??
                'This subscription has ended. Choose a plan to start again.',
          ),
        );
        return;
      case DodoCheckoutOutcome.awaitingPayment:
      case DodoCheckoutOutcome.needsPaymentMethod:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.awaitingCheckout,
            checkoutLink: link,
            message: 'Finish the payment on the page that just opened. Books '
                'unlocks here as soon as the card is charged.',
          ),
        );
        await _awaitCard(businessId: business.id, planId: planId);
    }
  }

  /// Picks up a card payment started earlier — the tab Dodo redirected back
  /// to, or a paywall reopened while the checkout was still pending.
  Future<void> resumeCard({
    required String businessId,
    required String planId,
  }) async {
    if (state.isBusy) return;
    _set(
      BooksPaymentState(
        stage: BooksPaymentStage.awaitingCheckout,
        rail: PaymentRail.card,
        planId: planId,
        message: 'Checking on your card payment…',
      ),
    );
    await _awaitCard(businessId: businessId, planId: planId);
  }

  Future<void> _awaitCard({
    required String businessId,
    required String planId,
  }) async {
    final rails = ref.read(booksPaymentRailsProvider);
    final timeout = ref.read(booksCardPollTimeoutProvider);
    final DodoSubscriptionStatus? status;
    try {
      status = await rails.awaitCardEntitlement(
            planId,
            timeout: timeout,
            isCancelled: () => _disposed,
          );
    } catch (e) {
      _set(
        state.copyWith(
          stage: BooksPaymentStage.failed,
          message: 'Could not check the card payment: ${_describe(e)}',
        ),
      );
      return;
    }
    if (_disposed) return;

    if (status?.entitled == true) {
      await _refreshAccess(businessId);
      _set(
        state.copyWith(
          stage: BooksPaymentStage.confirmed,
          message: 'Payment received. Your subscription is active.',
        ),
      );
      return;
    }

    switch (DodoCardCheckout.outcomeFor(status)) {
      case DodoCheckoutOutcome.needsPaymentMethod:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            checkoutLink: status?.checkout.paymentLink ?? state.checkoutLink,
            message: 'The card was declined. Open the payment page again to '
                'use a different card.',
          ),
        );
      case DodoCheckoutOutcome.resubscribeRequired:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.failed,
            message: 'This subscription has ended. Choose a plan to start again.',
          ),
        );
      case DodoCheckoutOutcome.entitled:
      case DodoCheckoutOutcome.awaitingPayment:
      case DodoCheckoutOutcome.couldNotOpenLink:
        _set(
          state.copyWith(
            stage: BooksPaymentStage.timedOut,
            message: 'We have not heard back about the card payment yet. If '
                'you completed it, Books will open shortly — check again in '
                'a moment.',
          ),
        );
    }
  }

  // ── shared ────────────────────────────────────────────────────────────────

  /// Re-reads entitlement for [businessId] and waits for the new value, so the
  /// screen that follows a payment is never rendered against the pre-payment
  /// answer.
  Future<void> _refreshAccess(String businessId) async {
    // A disposed notifier has no ref to invalidate through; the gate re-reads
    // entitlement itself when it next builds.
    if (_disposed) return;
    ref.invalidate(booksAccessStateProvider(businessId));
    try {
      await ref.read(booksAccessStateProvider(businessId).future);
    } catch (_) {
      // The paywall's own retry covers this; a failed refresh must not turn a
      // settled payment into an error.
    }
  }

  static String _describe(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  static String? _firstNonEmpty(List<String?> candidates) {
    for (final candidate in candidates) {
      final trimmed = candidate?.trim();
      if (trimmed != null && trimmed.isNotEmpty && trimmed != 'null') {
        return trimmed;
      }
    }
    return null;
  }
}

final booksSubscriptionControllerProvider =
    NotifierProvider<BooksSubscriptionController, BooksPaymentState>(
  BooksSubscriptionController.new,
  isAutoDispose: true,
);
