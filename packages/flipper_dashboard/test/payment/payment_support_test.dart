import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_dashboard/payment/payment_support.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records what the payment screen sends to support.
class _Support implements FloSupportRepository {
  final sent = <(String, String, Map<String, String>?)>[];
  var reads = 0;

  @override
  Future<FloSupportConversation> conversation({String? since}) async {
    reads++;
    return const FloSupportConversation();
  }

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

  test('the error on screen is what support hears about', () {
    final plan = Plan(id: 'p1', lastError: 'server said no');
    expect(
      paymentSupportContext(plan, error: ' Payment timed out ')['lastError'],
      'Payment timed out',
    );
    expect(paymentSupportContext(plan)['lastError'], 'server said no');
    expect(
      paymentSupportContext(plan, error: '  ')['lastError'],
      'server said no',
    );
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

  group('WhatsApp fallback', () {
    late List<Uri> opened;

    setUp(() => opened = []);
    tearDown(() {
      paymentSupportLaunch = (uri) async => false;
      LocalMode.debugSet(false);
    });

    for (final (name, launch) in <(String, Future<bool> Function(Uri))>[
      ('cannot open', (uri) async => false),
      ('throws', (uri) async => throw StateError('no app')),
    ]) {
      testWidgets('a launch that $name shows the support number', (
        tester,
      ) async {
        paymentSupportLaunch = (uri) {
          opened.add(uri);
          return launch(uri);
        };
        final context = await _app(tester, _Support());
        openPaymentSupportWhatsApp(context, Plan(businessId: 'biz'));
        await tester.pumpAndSettle();
        expect(opened.single.host, 'wa.me');
        expect(
          find.byKey(const Key('payment-support-whatsapp-failed')),
          findsOneWidget,
        );
        expect(find.textContaining('+250788360058'), findsOneWidget);
      });
    }

    testWidgets('an opened WhatsApp needs nothing more', (tester) async {
      paymentSupportLaunch = (uri) async {
        opened.add(uri);
        return true;
      };
      final context = await _app(tester, _Support());
      openPaymentSupportWhatsApp(context, null);
      await tester.pumpAndSettle();
      expect(opened, hasLength(1));
      expect(
        find.byKey(const Key('payment-support-whatsapp-failed')),
        findsNothing,
      );
    });

    testWidgets('in Local Mode the chat never reaches the connector', (
      tester,
    ) async {
      LocalMode.debugSet(true);
      paymentSupportLaunch = (uri) async {
        opened.add(uri);
        return true;
      };
      final support = _Support();
      final context = await _app(tester, support);
      openPaymentSupport(
        context,
        plan: Plan(id: 'p1', businessId: 'biz'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FloSupportChat), findsNothing);
      expect(support.reads, 0);
      expect(opened.single.host, 'wa.me');
    });
  });
}
