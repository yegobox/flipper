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

    testWidgets('a retry that fails stays paid, and the next Pay retries', (
      tester,
    ) async {
      final host = await pumpHost(tester);
      var attempts = 0;

      // Mirrors the payment callback: a failure before the sale is marked
      // complete goes through endPaidSaleAfterError, then rethrows.
      Future<void> issueReceipt() async {
        attempts++;
        if (attempts == 1) {
          host.endPaidSaleAfterError(
            transactionId: 'tx-1',
            paymentAttempt: 0,
            saleMarkedComplete: false,
            retryReceipt: issueReceipt,
          );
          throw StateError('tax server down');
        }
      }

      host.holdPaidSaleForReceipt(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        issueReceipt: issueReceipt,
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(attempts, 1);
      // Still paid and locked: the failure did not turn it into an unpaid
      // sale that could be edited or charged again.
      verifyNever(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      );

      expect(await tester.runAsync(() => pay(host)), isTrue);
      await tester.runAsync(pumpEventQueue);
      expect(attempts, 2);

      await tester.pump(const Duration(seconds: 11));
    });

    testWidgets('a failure after the sale is complete releases the lock', (
      tester,
    ) async {
      final host = await pumpHost(tester);

      host.endPaidSaleAfterError(
        transactionId: 'tx-1',
        paymentAttempt: 0,
        saleMarkedComplete: true,
        retryReceipt: () async => fail('a completed sale is not retried'),
      );

      verify(
        () => box.writeBool(key: 'transactionCompleting', value: false),
      ).called(1);
      // Nothing is held for Pay to resume.
      expect(
        find.text(FlipperL10n.current.cartPaymentReceivedReceiptPending),
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
