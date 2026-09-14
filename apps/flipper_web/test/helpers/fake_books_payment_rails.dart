import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/billing/data/books_payment_rails.dart';

/// Scripted rails: the MoMo verdicts and card statuses a test wants the
/// gateway to hand back, in order, with every call recorded.
class FakeBooksPaymentRails implements BooksPaymentRails {
  FakeBooksPaymentRails({
    this.momoOutcome = MomoSubscriptionOutcome.charged,
    this.momoReference = 'mtn-ref',
    this.momoMessage,
    List<MomoPaymentStatus> momoStatuses = const [],
    this.cardOutcome = DodoCheckoutOutcome.awaitingPayment,
    this.cardLink = 'https://checkout.dodo.test/abc',
    List<DodoSubscriptionStatus?> cardStatuses = const [],
    this.cardAvailable = true,
    this.isCardTestMode = true,
  })  : _momoStatuses = List.of(momoStatuses),
        _cardStatuses = List.of(cardStatuses);

  MomoSubscriptionOutcome momoOutcome;
  String? momoReference;
  String? momoMessage;
  final List<MomoPaymentStatus> _momoStatuses;

  DodoCheckoutOutcome cardOutcome;
  String? cardLink;
  final List<DodoSubscriptionStatus?> _cardStatuses;

  bool cardAvailable;

  @override
  bool isCardTestMode;

  /// Makes [chargeMomo] throw.
  Object? chargeError;

  /// Makes every [momoStatus] read throw (a blinking connection).
  Object? statusError;

  int chargeCalls = 0;
  int statusCalls = 0;
  int startCardCalls = 0;
  int awaitCardCalls = 0;
  String? lastReturnUrl;
  String? lastEmail;
  int? lastAmount;
  String? lastPlanId;

  /// Runs on settlement reads, so a test can flip the plan row paid the
  /// moment the gateway says SUCCESSFUL — as data-connector does.
  void Function()? onSuccessfulStatus;

  @override
  Future<MomoSubscriptionResult> chargeMomo({
    required String phoneNumber,
    required int amount,
    required String planId,
    required String businessId,
    String? branchId,
    int? validitySeconds,
    void Function(MomoMandate mandate)? onMandate,
  }) async {
    chargeCalls++;
    lastAmount = amount;
    lastPlanId = planId;
    final error = chargeError;
    if (error != null) throw error;
    onMandate?.call(
      const MomoMandate(
        state: MomoMandateState.awaitingApproval,
        nextAction: 'approve_preapproval_on_phone',
      ),
    );
    return MomoSubscriptionResult(
      outcome: momoOutcome,
      mandate: const MomoMandate(state: MomoMandateState.active),
      reference:
          momoOutcome == MomoSubscriptionOutcome.charged ? momoReference : null,
      message: momoMessage,
    );
  }

  @override
  Future<MomoSettlement> momoStatus(String reference, {String? branchId}) async {
    statusCalls++;
    final error = statusError;
    if (error != null) throw error;
    final status = _momoStatuses.isEmpty
        ? MomoPaymentStatus.pending
        : _momoStatuses.removeAt(0);
    if (status == MomoPaymentStatus.successful) onSuccessfulStatus?.call();
    return MomoSettlement(reference: reference, status: status);
  }

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
  }) async {
    startCardCalls++;
    lastReturnUrl = returnUrl;
    lastEmail = email;
    lastPlanId = planId;
    return DodoCheckoutResult(
      outcome: cardOutcome,
      planId: planId,
      checkout: DodoCheckout(paymentLink: cardLink),
      launched: cardOutcome != DodoCheckoutOutcome.couldNotOpenLink,
    );
  }

  @override
  Future<DodoSubscriptionStatus?> awaitCardEntitlement(
    String planId, {
    required Duration timeout,
    Duration pollInterval = Duration.zero,
    void Function(DodoSubscriptionStatus status)? onStatus,
    bool Function()? isCancelled,
  }) async {
    awaitCardCalls++;
    if (_cardStatuses.isEmpty) return null;
    final status = _cardStatuses.removeAt(0);
    if (status != null) onStatus?.call(status);
    return status;
  }

  @override
  Future<bool> isCardAvailable() async => cardAvailable;
}

DodoSubscriptionStatus entitledCardStatus(String planId) =>
    DodoSubscriptionStatus(
      dodoSubscriptionId: 'sub_1',
      status: 'active',
      entitled: true,
      nextAction: DodoNextAction.none,
      checkout: const DodoCheckout(),
      planId: planId,
    );

DodoSubscriptionStatus declinedCardStatus(String planId) =>
    DodoSubscriptionStatus(
      dodoSubscriptionId: 'sub_1',
      status: 'on_hold',
      entitled: false,
      nextAction: DodoNextAction.updatePaymentMethod,
      checkout: const DodoCheckout(paymentLink: 'https://dodo.test/fix-card'),
      planId: planId,
    );
