import 'package:flipper_payments/src/custom/custom_payment_client.dart';
import 'package:flipper_payments/src/custom/custom_payment_models.dart';
import 'package:flipper_payments/src/logging.dart';

/// Polls a custom payment until it settles, fails, or the caller gives up.
///
/// Modelled on [DodoCardCheckout.awaitEntitlement]: bounded, cancellable, and
/// tolerant of a poll that throws (a blip must not abandon a payment the
/// customer is in the middle of). For card payments every
/// [forceSyncEveryNthPoll]th poll asks the connector to re-read Dodo, which
/// covers a webhook that is slow to land.
class CustomPaymentWatcher {
  const CustomPaymentWatcher(this._client);

  final CustomPaymentClient _client;

  static const Duration defaultTimeout = Duration(minutes: 10);
  static const Duration defaultPollInterval = Duration(seconds: 5);
  static const int forceSyncEveryNthPoll = 3;

  Future<CustomPaymentView?> awaitSettlement(
    String id, {
    required CustomPaymentRail rail,
    Duration timeout = defaultTimeout,
    Duration pollInterval = defaultPollInterval,
    void Function(CustomPaymentView view)? onStatus,
    bool Function()? isCancelled,
  }) async {
    final deadline = DateTime.now().add(timeout);
    CustomPaymentView? last;
    var attempt = 0;

    while (DateTime.now().isBefore(deadline)) {
      if (isCancelled?.call() == true) return last;

      attempt++;
      final sync = rail.isCard && attempt % forceSyncEveryNthPoll == 0;
      final view = await _safeStatus(id, sync: sync);
      if (view != null) {
        last = view;
        onStatus?.call(view);
        if (view.isTerminal) {
          payLogInfo(
            'Custom payment $id ${view.status.wireValue} after $attempt polls',
          );
          return view;
        }
      }
      await Future<void>.delayed(pollInterval);
    }

    payLogWarning('Custom payment $id: gave up after $timeout');
    return last;
  }

  Future<CustomPaymentView?> _safeStatus(
    String id, {
    required bool sync,
  }) async {
    try {
      return await _client.status(id, sync: sync);
    } on CustomPaymentException catch (e) {
      // An auth failure will not fix itself by polling harder.
      if (e.isUnauthorised) rethrow;
      payLogWarning('Custom payment $id: poll failed (${e.displayMessage})');
      return null;
    } catch (e) {
      payLogWarning('Custom payment $id: poll failed ($e)');
      return null;
    }
  }
}
