import 'package:flutter/widgets.dart';

/// Default grace for [awaitFrameOrSkip]: long enough to order a repaint before
/// a toast, short enough that nobody waits on it.
const Duration kFrameSyncGrace = Duration(milliseconds: 500);

/// Awaits [frame], giving up after [timeout] instead of waiting forever.
///
/// `WidgetsBinding.instance.endOfFrame` only completes when a frame is actually
/// produced. A backgrounded or occluded window produces none — so awaiting it
/// on the sale-completion path stalled everything after it: the success toast,
/// releasing the Pay spinner, clearing the completion lock, and the return that
/// [PreviewSaleButton] is waiting on. The cart was cleared and the receipt
/// printed, and the button span forever.
///
/// Frame ordering is cosmetic. Completing a sale is not, and must never be
/// gated on the window being visible.
Future<void> awaitFrameOrSkip(
  Future<void> frame, {
  Duration timeout = kFrameSyncGrace,
}) {
  return frame.timeout(timeout, onTimeout: () {});
}

/// [awaitFrameOrSkip] for the next real frame.
Future<void> awaitNextFrameOrSkip({Duration timeout = kFrameSyncGrace}) =>
    awaitFrameOrSkip(WidgetsBinding.instance.endOfFrame, timeout: timeout);
