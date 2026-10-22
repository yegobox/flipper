import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/widgets.dart' show WidgetsBinding;

/// `data.type` of a "Today's goal" push from data-connector
/// (`src/engagement/scheduler.rs`).
const kEngagementFcmType = 'engagement';

/// Payload for the local notification that shows an engagement push while
/// the app is open, so a tap on either kind routes the same way.
String engagementNotificationPayload(String? action) =>
    jsonEncode({'type': kEngagementFcmType, 'action': action});

/// The action in an [engagementNotificationPayload], or `null` for any other
/// payload.
String? engagementActionFromPayload(String? payload) {
  if (payload == null || payload.isEmpty) return null;
  try {
    final decoded = jsonDecode(payload);
    if (decoded is Map && decoded['type'] == kEngagementFcmType) {
      final action = decoded['action']?.toString();
      return action == null || action.isEmpty ? null : action;
    }
  } catch (_) {}
  return null;
}

/// What a tap on a goal push opens.
///
/// `new_sale` — the POS, to record the sale the push asked for. `goal` — the
/// app itself: it opens on the dashboard, where the goal card is.
/// `sms_review` — the bank & MoMo SMS review sheet, when a paired SMS Bridge
/// phone forwarded new ones (data-connector `src/api/sms_bridge.rs`). Both
/// handlers live in flipper_dashboard and are added with
/// [registerEngagementActionHandler] by the home that can open them.
typedef EngagementNavigate = void Function(String action);

/// Push action for new bank & MoMo SMS waiting for review.
const kSmsReviewEngagementAction = 'sms_review';

/// Push action asking for a sale to be recorded: opens the POS.
const kNewSaleEngagementAction = 'new_sale';

final Map<String, void Function()> _actionHandlers = {};

/// A tap that arrived before its screen could open: on a cold start the push
/// is read while the app is still starting, long before the dashboard (or
/// the personal shell) registers its handler. Kept for [kPendingEngagementTtl]
/// so an old tap never opens a sheet much later.
String? _pendingAction;
DateTime? _pendingAt;

const Duration kPendingEngagementTtl = Duration(minutes: 2);

@visibleForTesting
DateTime Function() engagementClock = DateTime.now;

/// Runs a queued handler once the screen that registered it has drawn.
@visibleForTesting
void Function(void Function() run) engagementAfterFrame = (run) =>
    WidgetsBinding.instance.addPostFrameCallback((_) => run());

/// Whether the tap that launched the app has been claimed this process.
bool _launchTapClaimed = false;

@visibleForTesting
void resetEngagementActions() {
  _actionHandlers.clear();
  _pendingAction = null;
  _pendingAt = null;
  _launchTapClaimed = false;
}

/// `true` the first time it is called in this process, `false` after.
///
/// The notification that launched the app stays readable for the whole
/// process, and the reader runs more than once (`NotificationManager.create`
/// at boot and again lazily), so without this one tap was routed again
/// mid-session. Same idea as the FCM tap listeners' guard.
bool claimLaunchEngagementTap() {
  if (_launchTapClaimed) return false;
  _launchTapClaimed = true;
  return true;
}

/// Removes [handler] for [action] when it is still the registered one, so a
/// home that is gone stops answering taps (a later home's handler stays).
void unregisterEngagementActionHandler(String action, void Function() handler) {
  if (identical(_actionHandlers[action], handler)) {
    _actionHandlers.remove(action);
  }
}

/// Lets a package this one cannot import open its own screen for [action].
/// A later registration for the same action replaces the earlier one. A tap
/// for [action] that is still waiting runs now.
void registerEngagementActionHandler(String action, void Function() handler) {
  _actionHandlers[action] = handler;
  if (_pendingAction != action) return;
  final at = _pendingAt;
  _pendingAction = null;
  _pendingAt = null;
  if (at == null || engagementClock().difference(at) > kPendingEngagementTtl) {
    return;
  }
  engagementAfterFrame(handler);
}

void openEngagementAction(String? action, {EngagementNavigate? navigate}) {
  if (action == null || action.isEmpty) return;
  if (navigate != null) {
    navigate(action);
    return;
  }
  final handler = _actionHandlers[action];
  if (handler != null) {
    handler();
    return;
  }
  // No home that can open it yet (cold start, still on the splash screen):
  // wait for one. `new_sale` included: pushing the POS before the router has
  // a home either failed or was swept away when startup cleared the stack.
  _pendingAction = action;
  _pendingAt = engagementClock();
}
