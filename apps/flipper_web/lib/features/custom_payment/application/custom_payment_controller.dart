import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_web/features/custom_payment/application/custom_payment_providers.dart';
import 'package:flipper_web/features/custom_payment/data/custom_payment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where one negotiated payment has got to.
enum CustomPaymentStage {
  idle,

  /// Asking the connector to retire the old arrangement and start collecting.
  submitting,

  /// MoMo: the customer has a prompt on their handset.
  awaitingApproval,

  /// Card: a checkout link exists; waiting for the customer to pay it.
  awaitingCheckout,

  /// Money in; the plan is advanced. Reference ids are on [CustomPaymentState.view].
  settled,
  failed,

  /// Still unresolved when the poll window closed.
  timedOut,
}

class CustomPaymentState {
  const CustomPaymentState({
    this.stage = CustomPaymentStage.idle,
    this.view,
    this.message,
    this.inFlight,
  });

  final CustomPaymentStage stage;

  /// The connector's latest view of the payment, once one exists.
  final CustomPaymentView? view;

  /// What to tell staff — an error while failed, progress otherwise.
  final String? message;

  /// On a conflict: the payment already collecting from this business.
  final CustomPaymentView? inFlight;

  bool get isBusy =>
      stage == CustomPaymentStage.submitting ||
      stage == CustomPaymentStage.awaitingApproval ||
      stage == CustomPaymentStage.awaitingCheckout;

  bool get isSettled => stage == CustomPaymentStage.settled;

  String? get checkoutLink => view?.paymentLink;

  CustomPaymentState copyWith({
    CustomPaymentStage? stage,
    CustomPaymentView? view,
    String? message,
    CustomPaymentView? inFlight,
    bool clearMessage = false,
  }) {
    return CustomPaymentState(
      stage: stage ?? this.stage,
      view: view ?? this.view,
      message: clearMessage ? null : (message ?? this.message),
      inFlight: inFlight ?? this.inFlight,
    );
  }
}

/// Drives one negotiated payment: submit, then poll until the connector gives
/// a verdict or the window closes.
class CustomPaymentController extends Notifier<CustomPaymentState> {
  bool _disposed = false;

  @override
  CustomPaymentState build() {
    ref.onDispose(() => _disposed = true);
    return const CustomPaymentState();
  }

  /// Writes only while alive. Leaving the page mid-poll disposes this
  /// notifier; the charge continues server-side and the reference row keeps
  /// the outcome.
  void _set(CustomPaymentState next) {
    if (_disposed) return;
    state = next;
  }

  void reset() => _set(const CustomPaymentState());

  Future<void> submit(CustomPaymentDraft draft) async {
    if (state.isBusy) return;

    // Read every provider before the first await: `ref` is unusable once the
    // page is disposed mid-payment, and the poll must still finish cleanly.
    final api = ref.read(customPaymentApiProvider);
    final pollInterval = ref.read(customPaymentPollIntervalProvider);
    final timeout = ref.read(customPaymentPollTimeoutProvider);

    if (api == null) {
      _set(
        const CustomPaymentState(
          stage: CustomPaymentStage.failed,
          message: 'This account is not authorised for staff payments.',
        ),
      );
      return;
    }
    if (draft.rail.isMomo && !MomoMsisdn.isPlausible(draft.phoneNumber ?? '')) {
      _set(
        const CustomPaymentState(
          stage: CustomPaymentStage.failed,
          message: 'Enter a valid Mobile Money number, e.g. 0788123456.',
        ),
      );
      return;
    }
    if (draft.amountRwf <= 0) {
      _set(
        const CustomPaymentState(
          stage: CustomPaymentStage.failed,
          message: 'Enter the agreed amount in RWF.',
        ),
      );
      return;
    }

    _set(
      const CustomPaymentState(
        stage: CustomPaymentStage.submitting,
        message: 'Starting the payment…',
      ),
    );

    final CustomPaymentView started;
    try {
      started = await api.create(draft);
    } on CustomPaymentException catch (e) {
      _set(
        CustomPaymentState(
          stage: CustomPaymentStage.failed,
          message: e.displayMessage,
          inFlight: e.inFlight,
        ),
      );
      return;
    } catch (e) {
      _set(
        CustomPaymentState(
          stage: CustomPaymentStage.failed,
          message: 'Could not start the payment: ${_describe(e)}',
        ),
      );
      return;
    }

    _apply(started);
    if (started.isTerminal) return;

    final CustomPaymentView? last;
    try {
      last = await api.awaitSettlement(
        started.id,
        rail: draft.rail,
        timeout: timeout,
        pollInterval: pollInterval,
        onStatus: _apply,
        isCancelled: () => _disposed,
      );
    } on CustomPaymentException catch (e) {
      _set(
        state.copyWith(
          stage: CustomPaymentStage.failed,
          message: e.displayMessage,
        ),
      );
      return;
    }
    if (_disposed) return;

    if (last == null || !last.isTerminal) {
      _set(
        state.copyWith(
          stage: CustomPaymentStage.timedOut,
          message: draft.rail.isCard
              ? 'No payment yet. Send the link again or check the reference '
                    'later — a payment made after this closes still counts.'
              : 'No approval yet. The customer may still approve; check the '
                    'reference later or start again.',
        ),
      );
    }
  }

  /// Re-read a payment that timed out, in case it settled since.
  Future<void> checkAgain() async {
    final id = state.view?.id;
    final api = ref.read(customPaymentApiProvider);
    if (id == null || api == null) return;
    try {
      _apply(await api.status(id, sync: state.view?.rail.isCard ?? false));
    } on CustomPaymentException catch (e) {
      _set(state.copyWith(message: e.displayMessage));
    }
  }

  void _apply(CustomPaymentView view) {
    final (CustomPaymentStage stage, String message) = switch (view.status) {
      CustomPaymentStatus.settled => (
        CustomPaymentStage.settled,
        'Paid. The plan is active and the negotiated price is now its '
            'recurring price.',
      ),
      CustomPaymentStatus.failed => (
        CustomPaymentStage.failed,
        view.message ?? 'The payment did not go through.',
      ),
      CustomPaymentStatus.expired => (
        CustomPaymentStage.failed,
        view.message ?? 'The payment link expired before it was paid.',
      ),
      CustomPaymentStatus.awaitingApproval => (
        CustomPaymentStage.awaitingApproval,
        'Ask the customer to approve the Mobile Money request on their phone.',
      ),
      CustomPaymentStatus.awaitingCheckout => (
        CustomPaymentStage.awaitingCheckout,
        'Send the customer the payment link and wait for them to pay.',
      ),
      _ => (
        view.rail.isCard
            ? CustomPaymentStage.awaitingCheckout
            : CustomPaymentStage.awaitingApproval,
        'Waiting for the payment to settle…',
      ),
    };
    _set(CustomPaymentState(stage: stage, view: view, message: message));
  }

  static String _describe(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

final customPaymentControllerProvider =
    NotifierProvider<CustomPaymentController, CustomPaymentState>(
      CustomPaymentController.new,
    );
