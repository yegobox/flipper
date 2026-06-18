import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_desktop_shell.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

bool _isLayoutOverflow(Object exception) {
  return exception.toString().contains('RenderFlex overflowed');
}

void main() {
  testWidgets('AccountingModuleScreen shows desktop shell at wide width', (tester) async {
    final previousHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (_isLayoutOverflow(details.exception)) return;
      previousHandler?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousHandler);

    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountingModuleScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AccountingDesktopShell), findsOneWidget);
    expect(find.byType(AccountingMobileShell), findsNothing);
  });

  testWidgets('AccountingModuleScreen desktop shell has no horizontal overflow at breakpoint', (tester) async {
    final overflows = <FlutterErrorDetails>[];
    final previousHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (_isLayoutOverflow(details.exception)) {
        overflows.add(details);
        return;
      }
      previousHandler?.call(details);
    };

    tester.view.physicalSize = Size(SITokens.desktopBreakpoint, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountingModuleScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    FlutterError.onError = previousHandler;

    expect(find.byType(AccountingDesktopShell), findsOneWidget);
    expect(overflows, isEmpty, reason: overflows.map((e) => e.exception).join('\n'));
  });

  testWidgets('AccountingModuleScreen shows mobile shell below breakpoint', (tester) async {
    tester.view.physicalSize = Size(SITokens.desktopBreakpoint - 1, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AccountingModuleScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AccountingMobileShell), findsOneWidget);
    expect(find.byType(AccountingDesktopShell), findsNothing);
  });
}
