import 'dart:convert';

import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

/// `data.type` of a "Today's goal" push from data-connector
/// (`src/engagement/scheduler.rs`).
const kEngagementFcmType = 'engagement';

/// Payload for the local notification that shows an engagement push while
/// the app is open, so a tap on either kind routes the same way.
String engagementNotificationPayload(String? action) =>
    jsonEncode({'type': kEngagementFcmType, 'action': action});

/// What a tap on a goal push opens.
///
/// `new_sale` — the POS, to record the sale the push asked for. `goal` — the
/// app itself: it opens on the dashboard, where the goal card is.
/// `sms_review` — the bank & MoMo SMS review sheet, when a paired SMS Bridge
/// phone forwarded new ones (data-connector `src/api/sms_bridge.rs`); its
/// handler lives in flipper_dashboard and is added with
/// [registerEngagementActionHandler].
typedef EngagementNavigate = void Function(String action);

/// Push action for new bank & MoMo SMS waiting for review.
const kSmsReviewEngagementAction = 'sms_review';

final Map<String, void Function()> _actionHandlers = {};

/// Lets a package this one cannot import open its own screen for [action].
/// A later registration for the same action replaces the earlier one.
void registerEngagementActionHandler(String action, void Function() handler) {
  _actionHandlers[action] = handler;
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
  if (action == 'new_sale') {
    locator<RouterService>().navigateTo(CheckOutRoute(isBigScreen: false));
  }
}
