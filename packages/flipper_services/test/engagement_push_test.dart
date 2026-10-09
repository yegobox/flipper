import 'dart:convert';

import 'package:flipper_services/notifications/engagement_push.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the local notification payload carries the action', () {
    final payload = jsonDecode(engagementNotificationPayload('new_sale'));
    expect(payload, {'type': kEngagementFcmType, 'action': 'new_sale'});
  });

  test('a tap routes by action; nothing for an empty one', () {
    final opened = <String>[];
    openEngagementAction('new_sale', navigate: opened.add);
    openEngagementAction('goal', navigate: opened.add);
    openEngagementAction(null, navigate: opened.add);
    openEngagementAction('', navigate: opened.add);
    expect(opened, ['new_sale', 'goal']);
  });
}
