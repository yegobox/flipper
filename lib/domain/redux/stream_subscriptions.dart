import 'dart:async';

import 'package:flipper/model/user.dart';


// App user
StreamSubscription<User> userUpdateSubscription;
// List of users of the current selected group
StreamSubscription<List<User>> groupUsersSubscription;


/// Cancels all active subscriptions
///
/// Called on successful logout.
cancelAllSubscriptions() {
  userUpdateSubscription?.cancel();
}