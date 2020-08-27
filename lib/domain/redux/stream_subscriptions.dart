import 'dart:async';

import 'package:flipper/model/fuser.dart';

// App user
StreamSubscription<FUser> userUpdateSubscription;
// List of users of the current selected group
StreamSubscription<List<FUser>> groupUsersSubscription;

/// Cancels all active subscriptions
///
/// Called on successful logout.
cancelAllSubscriptions() {
  userUpdateSubscription?.cancel();
}
