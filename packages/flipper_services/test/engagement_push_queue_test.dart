import 'package:flipper_services/notifications/engagement_push.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DateTime now;

  setUp(() {
    resetEngagementActions();
    now = DateTime(2026, 10, 22, 8);
    engagementClock = () => now;
    // Run "after the frame" at once: these are plain unit tests.
    engagementAfterFrame = (run) => run();
  });

  test('a tap before the handler exists opens it once it registers', () {
    var opened = 0;
    openEngagementAction(kSmsReviewEngagementAction);
    expect(opened, 0);
    registerEngagementActionHandler(kSmsReviewEngagementAction, () => opened++);
    expect(opened, 1);
    // Consumed: registering again (another screen) does not reopen it.
    registerEngagementActionHandler(kSmsReviewEngagementAction, () => opened++);
    expect(opened, 1);
  });

  test('an old tap is dropped', () {
    var opened = 0;
    openEngagementAction(kSmsReviewEngagementAction);
    now = now.add(kPendingEngagementTtl + const Duration(seconds: 1));
    registerEngagementActionHandler(kSmsReviewEngagementAction, () => opened++);
    expect(opened, 0);
  });

  test('a registered handler runs at once', () {
    var opened = 0;
    registerEngagementActionHandler(kSmsReviewEngagementAction, () => opened++);
    openEngagementAction(kSmsReviewEngagementAction);
    expect(opened, 1);
  });

  test('a waiting tap only opens its own action', () {
    var opened = 0;
    openEngagementAction(kSmsReviewEngagementAction);
    registerEngagementActionHandler('goal', () => opened++);
    expect(opened, 0);
  });

  test('a new-sale tap waits for the business home', () {
    var opened = 0;
    // Cold start: no home yet, so nothing is pushed onto the splash screen.
    openEngagementAction(kNewSaleEngagementAction);
    expect(opened, 0);
    registerEngagementActionHandler(kNewSaleEngagementAction, () => opened++);
    expect(opened, 1);
  });

  test('a gone home stops answering, a newer one keeps its handler', () {
    var first = 0;
    var second = 0;
    void a() => first++;
    void b() => second++;
    registerEngagementActionHandler(kNewSaleEngagementAction, a);
    registerEngagementActionHandler(kNewSaleEngagementAction, b);
    // The first home is disposed after the second registered.
    unregisterEngagementActionHandler(kNewSaleEngagementAction, a);
    openEngagementAction(kNewSaleEngagementAction);
    expect((first, second), (0, 1));

    unregisterEngagementActionHandler(kNewSaleEngagementAction, b);
    openEngagementAction(kNewSaleEngagementAction);
    expect((first, second), (0, 1));
  });

  test('the launch tap is claimed once per process', () {
    // NotificationManager.create runs at boot and again lazily; only the
    // first may route the notification that launched the app.
    expect(claimLaunchEngagementTap(), isTrue);
    expect(claimLaunchEngagementTap(), isFalse);
    expect(claimLaunchEngagementTap(), isFalse);
  });

  test('reads the action from a local notification payload', () {
    expect(
      engagementActionFromPayload(
        engagementNotificationPayload(kSmsReviewEngagementAction),
      ),
      kSmsReviewEngagementAction,
    );
    expect(engagementActionFromPayload('{"type":"delegation"}'), isNull);
    expect(engagementActionFromPayload('not json'), isNull);
    expect(engagementActionFromPayload(null), isNull);
  });
}
