import 'package:flipper_dashboard/features/online_shop/online_shop_items_section.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_page.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart' show Variant;
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _FakeClient extends OnlineShopClient {
  _FakeClient(this.state) : super(baseUrl: () async => 'https://unused.test/');

  OnlineShopState state;
  OnlineShopSettings? saved;
  bool slugTaken = false;
  final hiddenCalls = <(List<String>, bool)>[];

  @override
  Future<OnlineShopState> load(String branchId) async => state;

  @override
  Future<OnlineShopState> save(
    String branchId,
    OnlineShopSettings settings,
  ) async {
    if (slugTaken) {
      throw const OnlineShopException(
        'slug_taken',
        statusCode: 409,
        code: 'slug_taken',
      );
    }
    saved = settings;
    return state = OnlineShopState(
      shop: OnlineShopSettings(
        id: 'shop1',
        slug: 'kigali-mart',
        enabled: settings.enabled,
        displayName: settings.displayName,
        momoPayCode: settings.momoPayCode,
      ),
      url: 'https://useflipper.com/shop/kigali-mart',
    );
  }

  @override
  Future<Set<String>> setHidden({
    required String branchId,
    required List<String> variantIds,
    required bool hidden,
  }) async {
    hiddenCalls.add((variantIds, hidden));
    return hidden ? {...variantIds} : <String>{};
  }
}

Future<void> _pump(
  WidgetTester tester,
  _FakeClient client, {
  bool canEdit = true,
}) async {
  tester.view.physicalSize = const Size(1080, 7000);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        onlineShopClientProvider.overrideWithValue(client),
        onlineShopBranchIdProvider.overrideWithValue('br1'),
        onlineShopVariantsProvider.overrideWith(
          (ref, search) async => [
            Variant(id: 'v1', name: 'Milk 1L', branchId: 'br1'),
            Variant(id: 'v2', name: 'Bread', branchId: 'br1'),
          ],
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: OnlineShopPage(canEdit: canEdit),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first save sends the form and then shows the link', (
    tester,
  ) async {
    final client = _FakeClient(const OnlineShopState());
    await _pump(tester, client);

    expect(find.byKey(const Key('online_shop_url')), findsNothing);
    await tester.enterText(
      find.byKey(const Key('online_shop_name')),
      'Kigali Mart',
    );
    await tester.pump();
    // Live preview of the derived address.
    expect(find.text('https://useflipper.com/shop/kigali-mart'), findsOne);

    await tester.tap(find.byKey(const Key('online_shop_save')));
    await tester.pumpAndSettle();

    expect(client.saved!.displayName, 'Kigali Mart');
    expect(client.saved!.enabled, isTrue);
    expect(find.byKey(const Key('online_shop_url')), findsOneWidget);
    expect(find.byKey(const Key('online_shop_qr')), findsOneWidget);
    // Saved shop: the items list appears.
    expect(find.byKey(const ValueKey('online_shop_item_v1')), findsOneWidget);
  });

  testWidgets('saving keeps the shop logo this page cannot edit', (
    tester,
  ) async {
    final client = _FakeClient(
      const OnlineShopState(
        shop: OnlineShopSettings(
          id: 's',
          displayName: 'Shop',
          slug: 'shop',
          logoUrl: 'https://cdn.test/logo.png',
        ),
      ),
    );
    await _pump(tester, client);
    await tester.tap(find.byKey(const Key('online_shop_save')));
    await tester.pumpAndSettle();
    expect(client.saved!.logoUrl, 'https://cdn.test/logo.png');
  });

  testWidgets('a MoMo field without SMS Bridge shows the manual notice', (
    tester,
  ) async {
    final client = _FakeClient(
      const OnlineShopState(
        shop: OnlineShopSettings(id: 's', displayName: 'Shop', slug: 'shop'),
        url: 'https://useflipper.com/shop/shop',
      ),
    );
    await _pump(tester, client);
    final notice = find.byKey(const Key('online_shop_sms_bridge_notice'));
    expect(notice, findsNothing);
    await tester.enterText(
      find.byKey(const Key('online_shop_paycode')),
      '12345',
    );
    await tester.pump();
    expect(notice, findsOneWidget);
  });

  testWidgets('a taken slug is shown on the field', (tester) async {
    final client = _FakeClient(const OnlineShopState())..slugTaken = true;
    await _pump(tester, client);
    await tester.enterText(find.byKey(const Key('online_shop_name')), 'X');
    await tester.enterText(find.byKey(const Key('online_shop_slug')), 'taken');
    await tester.tap(find.byKey(const Key('online_shop_save')));
    await tester.pumpAndSettle();
    expect(find.text('That address is taken. Try another one.'), findsOne);
  });

  testWidgets('an invalid slug never reaches the server', (tester) async {
    final client = _FakeClient(const OnlineShopState());
    await _pump(tester, client);
    await tester.enterText(find.byKey(const Key('online_shop_name')), 'X');
    await tester.enterText(find.byKey(const Key('online_shop_slug')), 'Bad!');
    await tester.tap(find.byKey(const Key('online_shop_save')));
    await tester.pumpAndSettle();
    expect(client.saved, isNull);
    expect(
      find.text('Use 3 to 48 lowercase letters, numbers or dashes'),
      findsOne,
    );
  });

  testWidgets('hiding an item calls the connector', (tester) async {
    final client = _FakeClient(
      const OnlineShopState(
        shop: OnlineShopSettings(id: 's', displayName: 'Shop', slug: 'shop'),
      ),
    );
    await _pump(tester, client);
    await tester.tap(find.byKey(const ValueKey('online_shop_item_v2')));
    await tester.pumpAndSettle();
    expect(client.hiddenCalls.single.$1, ['v2']);
    expect(client.hiddenCalls.single.$2, isTrue);
    expect(find.text('1 hidden'), findsOneWidget);
  });

  testWidgets('read-only users get no save button', (tester) async {
    await _pump(tester, _FakeClient(const OnlineShopState()), canEdit: false);
    expect(find.byKey(const Key('online_shop_save')), findsNothing);
    expect(
      find.text('You can view these settings but not change them.'),
      findsOne,
    );
  });
}
