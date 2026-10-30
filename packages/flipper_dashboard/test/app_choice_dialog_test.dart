import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/app_choice_dialog.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/widgets/app_launch_overlay.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/locator.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// LocalStorage that records `defaultApp` writes the way the dialog expects.
class _AppChoiceBox extends MockBox {
  String? defaultApp;

  @override
  String? getDefaultApp() => defaultApp;

  @override
  Future<void> writeString({required String key, required String value}) async {
    if (key == 'defaultApp') defaultApp = value;
  }
}

/// The selected tile swaps its shortcut badge for a [CircularProgressIndicator],
/// which spins forever — so settle by pumping fixed frames instead.
Future<void> _pumpSelection(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

void main() {
  late _AppChoiceBox box;
  late List<DialogResponse> responses;

  Future<void> pumpChooser(
    WidgetTester tester, {
    AppChoiceDialogRequest request = const AppChoiceDialogRequest(
      businessName: 'Yegobox Ltd',
      branchName: 'Kigali Heights',
    ),
  }) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: AppChoiceDialog(
            request: DialogRequest<AppChoiceDialogRequest>(data: request),
            completer: responses.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    responses = [];
    box = _AppChoiceBox();
    // The launch curtain loops an animation and arms a safety timer, so leave it
    // out of these tests; it is covered by app_launch_overlay_test.dart.
    AppLaunchOverlay.suppressForTests = true;
    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
    getIt.registerSingleton<LocalStorage>(box);
  });

  tearDown(() {
    AppLaunchOverlay.suppressForTests = false;
    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
  });

  testWidgets('offers only POS and Books, with the branch and business', (
    tester,
  ) async {
    await pumpChooser(tester);

    expect(find.text('Choose your app'), findsOneWidget);
    expect(find.text('Yegobox Ltd'), findsOneWidget);
    expect(find.text('Kigali Heights'), findsOneWidget);

    expect(find.text('POS'), findsOneWidget);
    expect(find.text('Books'), findsOneWidget);
    // Everything else lives inside POS, so it is not an app of its own.
    for (final title in [
      'Inventory',
      'Reports',
      'Orders',
      'Customers',
      'Settings',
    ]) {
      expect(find.text(title), findsNothing, reason: '$title is not an app');
    }
  });

  testWidgets('marks the stored default app', (tester) async {
    box.defaultApp = 'Books';
    await pumpChooser(tester);

    expect(find.text('DEFAULT'), findsOneWidget);
    expect(find.text('Default · Books'), findsOneWidget);
  });

  testWidgets('a default from an older build reads as POS', (tester) async {
    box.defaultApp = 'Reports';
    await pumpChooser(tester);

    expect(find.text('DEFAULT'), findsOneWidget);
    expect(find.text('Default · POS'), findsOneWidget);

    // The cursor starts on that default, so Enter opens POS.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'POS');
  });

  testWidgets('tapping a tile stores the choice and confirms the dialog', (
    tester,
  ) async {
    await pumpChooser(tester);

    await tester.tap(find.text('POS'));
    await _pumpSelection(tester);

    expect(box.defaultApp, 'POS');
    expect(responses, hasLength(1));
    expect(responses.single.confirmed, isTrue);
    expect(responses.single.data, {'defaultApp': 'POS'});
  });

  testWidgets('number keys launch the matching app', (tester) async {
    await pumpChooser(tester);

    // Tiles are ordered POS, Books, so "2" is Books.
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'Books');
    expect(responses.single.data, {'defaultApp': 'Books'});
  });

  testWidgets('number keys past the last app do nothing', (tester) async {
    await pumpChooser(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
    await _pumpSelection(tester);

    expect(box.defaultApp, isNull);
    expect(responses, isEmpty);
  });

  testWidgets('arrow keys move the cursor and Enter opens it', (tester) async {
    await pumpChooser(tester);

    // Cursor starts on POS; one step right lands on Books.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpSelection(tester);

    expect(box.defaultApp, 'Books');
  });

  testWidgets('Escape cancels without storing a default', (tester) async {
    await pumpChooser(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(box.defaultApp, isNull);
    expect(responses.single.confirmed, isFalse);
  });

  testWidgets(
    'falls back to the active branch when the caller passes no context',
    (tester) async {
      // The side-menu switcher supplies no request payload, so the branch label
      // comes from activeBranchProvider — and selecting must not read it again
      // after the pop, where `ref` is no longer usable.
      await tester.binding.setSurfaceSize(const Size(1280, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeBranchProvider.overrideWith(
              (ref) => Stream.value(
                Branch(
                  id: 'b1',
                  name: 'Nyabugogo',
                  businessId: 'biz1',
                  isDefault: true,
                ),
              ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: FlipperLocalizationDelegates.delegates,
            supportedLocales: FlipperLocalizationDelegates.supportedLocales,
            home: AppChoiceDialog(
              request: DialogRequest<AppChoiceDialogRequest>(),
              completer: responses.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nyabugogo'), findsOneWidget);

      await tester.tap(find.text('POS'));
      await _pumpSelection(tester);

      expect(box.defaultApp, 'POS');
      expect(responses.single.confirmed, isTrue);
    },
  );

  testWidgets('choosing POS preselects its dashboard page', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    // Start elsewhere so the assertion cannot pass on the provider's default.
    container.read(selectedPageProvider.notifier).state = DashboardPage.reports;

    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: AppChoiceDialog(
            request: DialogRequest<AppChoiceDialogRequest>(
              // branchName supplied so the chooser does not fall back to
              // activeBranchProvider, which arms a retry timer.
              data: const AppChoiceDialogRequest(
                awaitsExternalNavigation: true,
                branchName: 'Kigali Heights',
              ),
            ),
            completer: responses.add,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('POS'));
    await _pumpSelection(tester);

    expect(container.read(selectedPageProvider), DashboardPage.inventory);
  });
}
