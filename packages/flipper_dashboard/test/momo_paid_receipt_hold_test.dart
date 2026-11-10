import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/utils/momo_paid_receipt_hold.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockCapella extends Mock implements DatabaseSyncInterface {}

class _MockBox extends Mock implements LocalStorage {}

class _MockSyncStrategy extends Mock implements SyncStrategy {}

class _Host extends ConsumerStatefulWidget {
  const _Host({super.key});

  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host>
    with TextEditingControllersMixin, TransactionMixinOld, PreviewCartMixin {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// A MoMo sale whose money arrived but whose purchase-code dialog was
/// cancelled. Releasing it as unpaid let the cashier edit the cart or charge
/// the customer a second time; it must stay paid until Pay issues the receipt.
void main() {
  group('MomoPaidReceiptHold', () {
    test('holds one ticket until it is resumed', () async {
      final hold = MomoPaidReceiptHold();
      var issued = 0;
      expect(hold.transactionId, isNull);
      expect(hold.resume('tx-1', onError: (_, __) {}), isFalse);

      hold.hold(transactionId: 'tx-1', issueReceipt: () async => issued++);
      expect(hold.transactionId, 'tx-1');
      expect(hold.holds('tx-1'), isTrue);
      expect(hold.holds('tx-2'), isFalse);
      expect(hold.resume('tx-2', onError: (_, __) {}), isFalse);

      expect(hold.resume('tx-1', onError: (_, __) {}), isTrue);
      await pumpEventQueue();
      expect(issued, 1);
      // Released before the receipt step runs, so it can hold again.
      expect(hold.holds('tx-1'), isFalse);
      expect(hold.resume('tx-1', onError: (_, __) {}), isFalse);
    });

    test('a failed receipt step is reported, not thrown', () async {
      final hold = MomoPaidReceiptHold()
        ..hold(
          transactionId: 'tx-1',
          issueReceipt: () async => throw StateError('printer'),
        );
      Object? reported;

      expect(hold.resume('tx-1', onError: (e, _) => reported = e), isTrue);
      await pumpEventQueue();
      expect(reported, isA<StateError>());
    });

    test('clear drops the held ticket', () {
      final hold = MomoPaidReceiptHold()
        ..hold(transactionId: 'tx-1', issueReceipt: () async {});
      hold.clear();
      expect(hold.holds('tx-1'), isFalse);
    });
  });

  group('PreviewCartMixin.holdPaidSaleForReceipt', () {
    late _MockBox box;
    late ProviderContainer container;
    final hostKey = GlobalKey<_HostState>();

    setUpAll(() => registerFallbackValue(Strategy.capella));

    setUp(() async {
      await getIt.reset();
      box = _MockBox();
      final strategy = _MockSyncStrategy();
      getIt.registerSingleton<LocalStorage>(box);
      getIt.registerSingleton<KeyPadService>(KeyPadService());
      getIt.registerSingleton<Crash>(CrashlitycsTalkerObserverUnsupported());
      getIt.registerSingleton<SyncStrategy>(strategy, instanceName: 'strategy');
      when(() => strategy.getStrategy(any())).thenReturn(_MockCapella());
      when(
        () => box.writeBool(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          canCollectPosPaymentProvider.overrideWithValue(true),
          effectiveSettlingTillTicketProvider.overrideWithValue(null),
        ],
      );
    });

    tearDown(() => container.dispose());

    Future<_HostState> pumpHost(WidgetTester tester) async {
      // A till-sized window: the snackbar's side margins leave a default
      // 800px test surface too narrow for its text.
      tester.view.physicalSize = const Size(1600, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: Scaffold(body: _Host(key: hostKey)),
          ),
        ),
      );
      return hostKey.currentState!;
    }

    Future<bool> pay(_HostState host) => host.startCompleteTransactionFlow(
      transactionId: 'tx-1',
      completeTransaction: () {},
      paymentMethods: const [],
    );

    testWidgets('keeps the sale paid and lets Pay issue the receipt', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      container
          .read(payButtonStateProvider.notifier)
          .startLoading(ButtonType.pay);
      var issued = 0;

      host.holdPaidSaleForReceipt(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        issueReceipt: () async => issued++,
      );
      await tester.pump();

      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedReceiptPending),
        findsOneWidget,
      );
      expect(container.read(payButtonStateProvider)[ButtonType.pay], isFalse);
      // Still locked: grid taps cannot change what the customer paid for.
      verifyNever(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      );

      // Pay issues the receipt instead of sending a second MoMo request.
      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(issued, 1);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('a hold from an older attempt still waits for Pay', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      var issued = 0;

      host.holdPaidSaleForReceipt(
        transactionId: 'tx-1',
        paymentAttempt: 7,
        issueReceipt: () async => issued++,
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(issued, 1);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('a receipt step that fails does not break Pay', (tester) async {
      final host = await pumpHost(tester);

      host.holdPaidSaleForReceipt(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        issueReceipt: () async => throw StateError('printer'),
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);

      await tester.pump(const Duration(seconds: 11));
    });

    /// Runs [PreviewCartMixin.completePaidSale] the way the payment callback
    /// does, with each step counted. `retry` (what Pay runs for a held sale)
    /// comes back with the same progress, as `onPaymentRow` does.
    ({
      Future<void> Function() run,
      List<String> calls,
      MomoPaidSaleProgress progress,
    })
    paidSale(
      _HostState host, {
      Future<bool> Function(int attempt)? receipt,
      Future<int> Function(int attempt)? mark,
      Future<void> Function(int mark)? finish,
      bool hostCompleteThrows = false,
    }) {
      final calls = <String>[];
      final progress = MomoPaidSaleProgress();
      var receipts = 0;
      var marks = 0;
      late Future<void> Function() run;
      run = () => host.completePaidSale<int>(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        progress: progress,
        issueReceipt: () async {
          calls.add('receipt');
          return receipt == null ? true : receipt(++receipts);
        },
        markComplete: () async {
          calls.add('mark');
          return mark == null ? 42 : mark(++marks);
        },
        finishSale: (m) async {
          calls.add('finish $m');
          if (finish != null) await finish(m);
        },
        completeTransaction: () {
          calls.add('complete');
          if (hostCompleteThrows) throw StateError('sheet already closed');
        },
        retry: () => run(),
        onPaymentFailed: (message) => calls.add('failed: $message'),
      );
      return (run: run, calls: calls, progress: progress);
    }

    testWidgets('a paid sale completes in order', (tester) async {
      final host = await pumpHost(tester);
      final sale = paidSale(host);

      await tester.runAsync(sale.run);

      expect(sale.calls, ['receipt', 'mark', 'finish 42', 'complete']);
      expect(sale.progress.saleMarkedComplete, isTrue);
    });

    testWidgets('a host that fails to close does not fail a completed sale', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      final sale = paidSale(host, hostCompleteThrows: true);

      await tester.runAsync(sale.run);

      expect(sale.calls, ['receipt', 'mark', 'finish 42', 'complete']);
      verifyNever(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      );
    });

    testWidgets('a cancelled receipt is held, and Pay issues it', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      final sale = paidSale(host, receipt: (attempt) async => attempt > 1);

      await tester.runAsync(sale.run);
      await tester.pump();
      expect(sale.calls, ['receipt']);
      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedReceiptPending),
        findsOneWidget,
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(sale.calls, [
        'receipt',
        'receipt',
        'mark',
        'finish 42',
        'complete',
      ]);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('a receipt that fails stays paid, and the next Pay retries', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      final sale = paidSale(
        host,
        receipt: (attempt) async =>
            attempt == 1 ? throw StateError('tax server down') : true,
      );

      await tester.runAsync(
        () => expectLater(sale.run(), throwsA(isA<StateError>())),
      );
      // Still paid and locked: the failure did not turn it into an unpaid
      // sale that could be edited or charged again.
      verifyNever(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(sale.calls, [
        'receipt',
        'failed: Bad state: tax server down',
        'receipt',
        'mark',
        'finish 42',
        'complete',
      ]);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('receipt issued but sale not saved: Pay finishes it without '
        'a second receipt', (tester) async {
      final host = await pumpHost(tester);
      final sale = paidSale(
        host,
        mark: (attempt) async =>
            attempt == 1 ? throw StateError('database busy') : 42,
      );

      await tester.runAsync(
        () => expectLater(sale.run(), throwsA(isA<StateError>())),
      );
      await tester.pump();
      expect(sale.calls, [
        'receipt',
        'mark',
        'failed: Bad state: database busy',
      ]);
      expect(sale.progress.receiptIssued, isTrue);
      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedSaleNotSaved),
        findsOneWidget,
      );
      verifyNever(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      // One receipt only: the fiscal receipt is not issued again.
      expect(sale.calls, [
        'receipt',
        'mark',
        'failed: Bad state: database busy',
        'mark',
        'finish 42',
        'complete',
      ]);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('a failure after the sale is complete releases the lock', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      final sale = paidSale(
        host,
        finish: (_) async => throw StateError('stock write failed'),
      );

      await tester.runAsync(
        () => expectLater(sale.run(), throwsA(isA<StateError>())),
      );
      await tester.pump();

      verify(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      ).called(1);
      // Nothing is held for Pay to resume.
      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedReceiptPending),
        findsNothing,
      );
      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedSaleNotSaved),
        findsNothing,
      );
    });

    testWidgets('a disposed till releases the lock instead', (tester) async {
      final host = await pumpHost(tester);
      await tester.pumpWidget(const SizedBox.shrink());

      host.holdPaidSaleForReceipt(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        issueReceipt: () async {},
      );

      verify(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      ).called(1);
      verify(
        () => box.writeBool(key: 'transactionInProgress', value: false),
      ).called(1);
    });
  });
}
