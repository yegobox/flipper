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
typedef EngagementNavigate = void Function(String action);

void openEngagementAction(String? action, {EngagementNavigate? navigate}) {
  if (action == null || action.isEmpty) return;
  if (navigate != null) {
    navigate(action);
    return;
  }
  if (action == 'new_sale') {
    locator<RouterService>().navigateTo(CheckOutRoute(isBigScreen: false));
  }
}
