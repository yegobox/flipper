import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/payment/payment_support.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records what the payment screen sends to support.
class _Support implements FloSupportRepository {
  final sent = <(String, String, Map<String, String>?)>[];

  @override
  Future<FloSupportConversation> conversation({String? since}) async =>
      const FloSupportConversation();

  @override
  Future<FloSupportPost> send(
    String body, {
    String topic = 'general',
    Map<String, String>? context,
  }) async {
    sent.add((body, topic, context));
    return FloSupportPost(
      id: 'p1',
      body: body,
      fromSupport: false,
      authorName: 'Me',
      mine: true,
    );
  }
}

Future<BuildContext> _app(WidgetTester tester, _Support support) async {
  late BuildContext context;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        floSupportRepositoryProvider.overrideWithValue(support),
        floSupportPollIntervalProvider.overrideWithValue(
          const Duration(hours: 1),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (c) {
            context = c;
            return const Scaffold();
          },
        ),
      ),
    ),
  );
  return context;
}

void main() {
  testWidgets('the context carries what the screen shows, blanks left out', (
    tester,
  ) async {
    await _app(tester, _Support());
    final plan = Plan(
      id: 'p1',
      businessId: 'biz',
      selectedPlan: 'Mobile',
      rule: 'monthly',
      paymentStatus: 'failed',
      lastError: '  ',
    );
    expect(paymentSupportContext(plan, amount: 'RWF 2,194.00'), {
      'planId': 'p1',
      'plan': 'Mobile',
      'amount': 'RWF 2,194.00',
      'billing': 'Monthly',
      'paymentStatus': 'failed',
    });
    expect(paymentSupportContext(Plan(id: 'p2')), {'planId': 'p2'});
    expect(paymentSupportContext(null), isEmpty);
  });

  test('WhatsApp support names the business', () {
    expect(
      paymentSupportWhatsAppUri(Plan(businessId: 'biz')).toString(),
      'https://wa.me/250788360058?text='
      'I%20need%20help%20with%20my%20Flipper%20payment.%20Business%3A%20biz',
    );
    expect(
      paymentSupportWhatsAppUri(null).queryParameters['text'],
      'I need help with my Flipper payment. Business: ',
    );
  });

  testWidgets('Need Help opens the support chat about this payment', (
    tester,
  ) async {
    final support = _Support();
    final context = await _app(tester, support);
    openPaymentSupport(
      context,
      plan: Plan(id: 'p1', selectedPlan: 'Mobile'),
      amount: 'RWF 5,000.00',
    );
    await tester.pumpAndSettle();
    expect(find.byType(FloSupportChat), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('flo-support-message')),
      'It failed',
    );
    await tester.tap(find.byKey(const Key('flo-support-send')));
    await tester.pumpAndSettle();
    final (body, topic, sentContext) = support.sent.single;
    expect([body, topic], ['It failed', 'payment']);
    expect(sentContext, {
      'planId': 'p1',
      'plan': 'Mobile',
      'amount': 'RWF 5,000.00',
    });
  });
}
