import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/widgets/checkout_mode_bar.dart';
import 'package:flipper_dashboard/widgets/checkout_transfer_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('CheckoutModeBar switches Sale and Transfer', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final mode = ref.watch(checkoutCartModeProvider);
                return Column(
                  children: [
                    Text('mode:${mode.name}'),
                    const CheckoutModeBar(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('mode:sale'), findsOneWidget);
    await tester.tap(find.text('Transfer'));
    await tester.pump();
    expect(find.text('mode:transfer'), findsOneWidget);
    await tester.tap(find.text('Sale'));
    await tester.pump();
    expect(find.text('mode:sale'), findsOneWidget);
  });

  testWidgets('CheckoutTransferFooter disables Transfer with empty cart', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CheckoutTransferFooter(
              itemCount: 0,
              onClear: _noop,
              onTransfer: _noop,
            ),
          ),
        ),
      ),
    );

    final transfer = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Transfer'),
    );
    expect(transfer.onPressed, isNull);
  });
}

void _noop() {}
