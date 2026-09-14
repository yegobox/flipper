import 'package:flipper_web/features/billing/application/books_billing_providers.dart';
import 'package:flipper_web/features/billing/data/books_return_url.dart';
import 'package:flipper_web/features/billing/presentation/books_billing_gate.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/books_billing_fixtures.dart';
import '../helpers/fake_books_payment_rails.dart';
import '../helpers/fake_books_plan_repository.dart';

const _child = Text('BOOKS CONTENT', key: Key('books-content'));
const _subscribeStub = Text('SUBSCRIBE PAGE', key: Key('subscribe-stub'));

Future<ProviderContainer> _pumpGate(
  WidgetTester tester, {
  required FakeBooksPlanRepository repo,
  int businessTypeId = 1,
  bool isDefault = false,
}) async {
  final container = ProviderContainer(
    overrides: [
      booksPlanRepositoryProvider.overrideWithValue(repo),
      booksPaymentRailsProvider.overrideWithValue(FakeBooksPaymentRails()),
      // The real restore reads SharedPreferences and the profile; the gate
      // only needs it to have finished.
      selectedBusinessRestoreProvider.overrideWith((ref) async {}),
    ],
  );
  addTearDown(container.dispose);
  addTearDown(repo.dispose);
  container.read(selectedBusinessProvider.notifier).set(
        testBusiness(businessTypeId: businessTypeId, isDefault: isDefault),
      );

  final router = GoRouter(
    initialLocation: '/accounting',
    routes: [
      GoRoute(
        path: '/accounting',
        builder: (_, __) => const BooksBillingGate(child: _child),
      ),
      GoRoute(path: '/subscribe', builder: (_, __) => _subscribeStub),
      GoRoute(
        path: '/business-selection',
        builder: (_, __) => const Text('SELECT'),
      ),
    ],
  );

  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('BooksBillingGate', () {
    testWidgets('a paid business sees Books', (tester) async {
      await _pumpGate(
        tester,
        repo: FakeBooksPlanRepository(plans: {'biz-1': paidPlan()}),
      );

      expect(find.byKey(const Key('books-content')), findsOneWidget);
      expect(find.byKey(const Key('books-paywall-panel')), findsNothing);
    });

    testWidgets('a fresh signup with no plan is locked', (tester) async {
      await _pumpGate(tester, repo: FakeBooksPlanRepository());

      expect(find.byKey(const Key('books-content')), findsNothing);
      expect(find.byKey(const Key('books-paywall-panel')), findsOneWidget);
      expect(find.text('Flipper Books needs a subscription'), findsOneWidget);
      expect(find.text('Choose a plan'), findsOneWidget);
    });

    testWidgets('an expired plan reads as lapsed, with a renew action',
        (tester) async {
      await _pumpGate(
        tester,
        repo: FakeBooksPlanRepository(
          plans: {
            'biz-1': paidPlan(
              nextBillingDate:
                  DateTime.now().subtract(const Duration(days: 2)),
            ),
          },
        ),
      );

      expect(find.text('Your subscription has ended'), findsOneWidget);
      expect(find.text('Renew now'), findsOneWidget);
    });

    testWidgets('a charge in flight says so on the lock', (tester) async {
      await _pumpGate(
        tester,
        repo: FakeBooksPlanRepository(
          plans: {'biz-1': unpaidPlan(paymentStatus: 'PENDING')},
        ),
      );

      expect(find.byKey(const Key('books-paywall-panel')), findsOneWidget);
      expect(find.textContaining('already on its way'), findsOneWidget);
    });

    testWidgets('the lock leads to the paywall', (tester) async {
      await _pumpGate(tester, repo: FakeBooksPlanRepository());

      await tester.tap(find.byKey(const Key('books-paywall-subscribe')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('subscribe-stub')), findsOneWidget);
    });

    testWidgets('a payment settled elsewhere unlocks the open tab',
        (tester) async {
      final repo = FakeBooksPlanRepository(plans: {'biz-1': unpaidPlan()});
      await _pumpGate(tester, repo: repo);
      expect(find.byKey(const Key('books-paywall-panel')), findsOneWidget);

      // data-connector settles the row; Supabase realtime delivers it.
      repo.emit('biz-1', paidPlan());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('books-content')), findsOneWidget);
      expect(find.byKey(const Key('books-paywall-panel')), findsNothing);
    });

    testWidgets('a default Individual business is waived', (tester) async {
      await _pumpGate(
        tester,
        repo: FakeBooksPlanRepository(),
        businessTypeId: 2,
        isDefault: true,
      );

      expect(find.byKey(const Key('books-content')), findsOneWidget);
    });

    testWidgets('a failed read fails open', (tester) async {
      await _pumpGate(
        tester,
        repo: FakeBooksPlanRepository()..fetchError = Exception('offline'),
      );

      expect(find.byKey(const Key('books-content')), findsOneWidget);
      expect(find.byKey(const Key('books-paywall-panel')), findsNothing);
    });
  });

  group('booksSubscribeReturnUrl', () {
    test('puts the route after the hash, on the loaded page', () {
      final url = booksSubscribeReturnUrl(
        'plan-1',
        base: Uri.parse('https://books.flipper.rw/index.html#/accounting'),
      );
      expect(
        url,
        'https://books.flipper.rw/index.html#/subscribe?planId=plan-1&rail=card',
      );
    });

    test('a root page keeps a single slash', () {
      final url = booksSubscribeReturnUrl(
        'plan-1',
        base: Uri.parse('http://localhost:8080'),
      );
      expect(url, 'http://localhost:8080/#/subscribe?planId=plan-1&rail=card');
    });

    test('a page with no origin still yields a usable route', () {
      final url = booksSubscribeReturnUrl(
        'plan-1',
        base: Uri.parse('file:///tmp/test.html'),
      );
      expect(url, '/tmp/test.html#/subscribe?planId=plan-1&rail=card');
    });
  });
}
