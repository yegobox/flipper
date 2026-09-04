import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The Pay spinner must be released by the button itself.
///
/// Every `stopLoading()` on the completion path is guarded by the *host*
/// widget's `mounted` / `context.mounted` (QuickSellingView, the checkout
/// shell). When the host is torn down mid-sale those guards never fire, while
/// this button stays mounted rendering a dead spinner with `onPressed: null` —
/// the till could not even retry.
void main() {
  Widget buildButton({
    required ProviderContainer container,
    required CompleteTransactionStub onComplete,
  }) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: Scaffold(
          body: PreviewSaleButton(
            mode: SellingMode.forSelling,
            digitalPaymentEnabled: false,
            transactionId: 'txn-1',
            // Passing wording keeps the test off the l10n delegates.
            wording: 'Pay',
            completeTransaction: onComplete,
          ),
        ),
      ),
    );
  }

  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  testWidgets('releases the spinner when the sale is not waiting on payment',
      (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      buildButton(
        container: container,
        onComplete: (immediateCompletion, [onConfirmed, onFailed]) async {
          calls++;
          // A completed / aborted sale: the host may already be gone, so it
          // never stops the spinner itself.
          return false;
        },
      ),
    );

    await tester.tap(find.byKey(const Key('PaymentButton')));
    await tester.pumpAndSettle();

    expect(calls, 1);
    expect(container.read(payButtonStateProvider)[ButtonType.pay], false);
  });

  testWidgets('keeps the spinner while an out-of-band payment is pending',
      (tester) async {
    await tester.pumpWidget(
      buildButton(
        container: container,
        onComplete: (immediateCompletion, [onConfirmed, onFailed]) async {
          // Digital/MoMo: returns before the customer has confirmed.
          return true;
        },
      ),
    );

    await tester.tap(find.byKey(const Key('PaymentButton')));
    // Not pumpAndSettle: the spinner animates forever while loading, so the
    // tree never settles — which is exactly the state under test.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(container.read(payButtonStateProvider)[ButtonType.pay], true);
  });

  testWidgets('a pending payment that times out releases the spinner',
      (tester) async {
    // The shared error snackbar needs room to lay out; the default 800x600 test
    // surface squeezes its Row and reports an overflow that has nothing to do
    // with the behaviour under test.
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    void Function(String)? capturedOnFailed;

    await tester.pumpWidget(
      buildButton(
        container: container,
        onComplete: (immediateCompletion, [onConfirmed, onFailed]) async {
          capturedOnFailed = onFailed;
          return true;
        },
      ),
    );

    await tester.tap(find.byKey(const Key('PaymentButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(payButtonStateProvider)[ButtonType.pay], true);

    // What the 60s confirmation timeout in PreviewCartMixin invokes. Before the
    // button passed a callback this was null, so nothing ever fired.
    expect(capturedOnFailed, isNotNull);
    capturedOnFailed!('Payment confirmation timeout. Please try again.');
    await tester.pumpAndSettle();

    expect(container.read(payButtonStateProvider)[ButtonType.pay], false);
  });

  testWidgets('releases the spinner when completion throws', (tester) async {
    await tester.pumpWidget(
      buildButton(
        container: container,
        onComplete: (immediateCompletion, [onConfirmed, onFailed]) async {
          throw Exception('tax server unreachable');
        },
      ),
    );

    await tester.tap(find.byKey(const Key('PaymentButton')));
    await tester.pumpAndSettle();

    expect(container.read(payButtonStateProvider)[ButtonType.pay], false);
  });
}

typedef CompleteTransactionStub = Future<bool> Function(
  bool immediateCompletion, [
  Function? onPaymentConfirmed,
  Function(String)? onPaymentFailed,
]);
