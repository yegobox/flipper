import 'dart:async';

import 'package:flipper_dashboard/TaxSettingsModal.dart';
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/features/receipt_header/receipt_header_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _Box implements LocalStorage {
  _Box({this.branchId = 'br'});

  final String? branchId;

  @override
  String? getBusinessId() => 'biz';

  @override
  String? getBranchId() => branchId;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Db implements DatabaseSyncInterface {
  _Db({this.business, this.businessThrows = false});

  final Business? business;
  final bool businessThrows;
  bool saveThrows = false;
  Future<void>? saveGate;
  bool taxesThrow = false;
  final saved = <({String configId, double taxPercentage})>[];
  final taxRows = [
    Configurations(id: 'cfg-b', taxType: 'B', taxPercentage: 18),
  ];

  @override
  Future<Business?> getBusiness({String? businessId}) async {
    if (businessThrows) throw StateError('offline');
    return business;
  }

  @override
  Future<List<Configurations>> taxes({required String branchId}) async {
    if (taxesThrow) throw StateError('offline');
    return taxRows;
  }

  @override
  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  }) async {
    if (saveThrows) throw StateError('offline');
    saved.add((configId: configId, taxPercentage: taxPercentage));
    if (saveGate != null) await saveGate;
    return taxRows.first;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Services extends BranchServices {
  _Services(this.db, {String? branchId = 'br'})
    : _box = _Box(branchId: branchId);

  final _Db db;
  final _Box _box;

  @override
  LocalStorage get box => _box;

  @override
  DatabaseSyncInterface get strategy => db;
}

class _Store implements ReceiptHeaderStore {
  _Store([BranchDocumentSettings? initial])
    : settings = initial ?? const BranchDocumentSettings(branchId: 'br');

  BranchDocumentSettings settings;
  final saved = <BranchDocumentSettings>[];
  final loaded = <String>[];
  bool fail = false;

  @override
  Future<BranchDocumentSettings> load(String branchId) async {
    loaded.add(branchId);
    return settings;
  }

  @override
  Future<bool> save(BranchDocumentSettings next) async {
    if (fail) return false;
    saved.add(next);
    settings = next;
    return true;
  }
}

List<Override> _overrides(_Store store, _Db db) => [
  branchServicesProvider.overrideWithValue(_Services(db)),
  receiptHeaderStoreProvider.overrideWithValue(store),
];

Future<void> _pump(
  WidgetTester tester,
  _Store store,
  _Db db, {
  Size size = const Size(900, 1600),
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(store, db),
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const TaxSettingsModal(branchId: 'br'),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

String _field(WidgetTester tester, String key) =>
    tester.widget<TextFormField>(find.byKey(ValueKey(key))).controller!.text;

void main() {
  group('receipt phone/email validation', () {
    test('phones need at least 9 digits and dialable characters', () {
      expect(isValidReceiptPhone('0788 123 456'), isTrue);
      expect(isValidReceiptPhone('+250 (788) 123-456'), isTrue);
      expect(isValidReceiptPhone('12345'), isFalse);
      expect(isValidReceiptPhone('call me'), isFalse);
    });

    test('emails need a user, a domain and a dot', () {
      expect(isValidReceiptEmail('shop@example.com'), isTrue);
      expect(isValidReceiptEmail(' shop@example.rw '), isTrue);
      expect(isValidReceiptEmail('shop@example'), isFalse);
      expect(isValidReceiptEmail('shop.example.com'), isFalse);
    });
  });

  group('Tax Settings → Receipt header', () {
    testWidgets('starts from the business details when the branch has none', (
      tester,
    ) async {
      final db = _Db(
        business: Business(
          serverId: 1,
          phoneNumber: '+250788123456',
          email: 'shop@example.com',
        ),
      );
      await _pump(tester, _Store(), db);

      expect(_field(tester, 'receiptHeaderPhone'), '+250788123456');
      expect(_field(tester, 'receiptHeaderEmail'), 'shop@example.com');
      expect(_field(tester, 'receiptHeaderMessage'), '');
      expect(find.byKey(const ValueKey('receiptHeaderMissing')), findsNothing);
      // The tax rates are still there underneath.
      expect(find.text('18.0%'), findsOneWidget);
    });

    testWidgets('warns, and refuses to save, while phone or email is empty', (
      tester,
    ) async {
      final store = _Store();
      await _pump(tester, store, _Db(businessThrows: true));

      expect(
        find.byKey(const ValueKey('receiptHeaderMissing')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('receiptHeaderSave')));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsNWidgets(2));
      expect(store.saved, isEmpty);
    });

    testWidgets('rejects a malformed phone or email', (tester) async {
      final store = _Store();
      await _pump(tester, store, _Db());

      await tester.enterText(
        find.byKey(const ValueKey('receiptHeaderPhone')),
        '123',
      );
      await tester.enterText(
        find.byKey(const ValueKey('receiptHeaderEmail')),
        'not-an-email',
      );
      await tester.tap(find.byKey(const ValueKey('receiptHeaderSave')));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid phone number'), findsOneWidget);
      expect(find.text('Enter a valid email address'), findsOneWidget);
      expect(store.saved, isEmpty);
    });

    testWidgets('saves phone, email and the welcome line, keeping the stamp', (
      tester,
    ) async {
      final store = _Store(
        const BranchDocumentSettings(
          branchId: 'br',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
        ),
      );
      await _pump(tester, store, _Db());

      await tester.enterText(
        find.byKey(const ValueKey('receiptHeaderPhone')),
        ' 0788 123 456 ',
      );
      await tester.enterText(
        find.byKey(const ValueKey('receiptHeaderEmail')),
        'branch@example.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('receiptHeaderMessage')),
        'Murakaza neza',
      );
      await tester.tap(find.byKey(const ValueKey('receiptHeaderSave')));
      await tester.pumpAndSettle();

      final saved = store.saved.single;
      expect(saved.receiptPhone, '0788 123 456');
      expect(saved.receiptEmail, 'branch@example.com');
      expect(saved.receiptMessage, 'Murakaza neza');
      expect(saved.hasStamp, isTrue);
      expect(find.text('Receipt header saved'), findsOneWidget);
      expect(find.byKey(const ValueKey('receiptHeaderMissing')), findsNothing);
    });

    testWidgets("the branch's saved header wins over the business", (
      tester,
    ) async {
      final store = _Store(
        const BranchDocumentSettings(
          branchId: 'br',
          receiptPhone: '0722111222',
          receiptEmail: 'branch@example.com',
          receiptMessage: 'Hello',
        ),
      );
      final db = _Db(
        business: Business(
          serverId: 1,
          phoneNumber: '0788000000',
          email: 'shop@example.com',
        ),
      );
      await _pump(tester, store, db);

      expect(_field(tester, 'receiptHeaderPhone'), '0722111222');
      expect(_field(tester, 'receiptHeaderEmail'), 'branch@example.com');
      expect(_field(tester, 'receiptHeaderMessage'), 'Hello');
    });

    testWidgets('says so when the save fails', (tester) async {
      final store = _Store(
        const BranchDocumentSettings(
          branchId: 'br',
          receiptPhone: '0722111222',
          receiptEmail: 'branch@example.com',
        ),
      )..fail = true;
      await _pump(tester, store, _Db());

      await tester.tap(find.byKey(const ValueKey('receiptHeaderSave')));
      await tester.pumpAndSettle();

      expect(
        find.text('Could not save the receipt header. Try again.'),
        findsOneWidget,
      );
    });

    testWidgets('tax rates still save through the injected strategy', (
      tester,
    ) async {
      final db = _Db();
      await _pump(tester, _Store(), db);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, '18.0'), '16');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(db.saved.single, (configId: 'cfg-b', taxPercentage: 16.0));
      expect(find.text('Tax settings updated successfully'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Tax settings updated successfully'), findsNothing);
    });

    testWidgets('a rate out of range is refused; undo puts the old one back', (
      tester,
    ) async {
      final db = _Db();
      await _pump(tester, _Store(), db);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      final rate = find.byKey(const ValueKey('taxRate-cfg-b'));
      await tester.enterText(rate, '150');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(find.text('Must be 0-100'), findsOneWidget);

      await tester.enterText(rate, '');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('Required'), findsOneWidget);
      expect(db.saved, isEmpty);

      await tester.tap(find.byIcon(Icons.undo));
      await tester.pumpAndSettle();
      expect(rate, findsNothing);
      expect(find.text('18.0%'), findsOneWidget);
    });

    testWidgets('a failed rate save says so and can be dismissed', (
      tester,
    ) async {
      final db = _Db()..saveThrows = true;
      await _pump(tester, _Store(), db);

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, '18.0'), '16');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      final status = find.byKey(const ValueKey('taxSettingsStatus'));
      expect(find.text('Error updating tax settings'), findsOneWidget);
      await tester.tap(
        find.descendant(of: status, matching: find.byIcon(Icons.close)),
      );
      await tester.pumpAndSettle();
      expect(status, findsNothing);
    });

    testWidgets('says so when the branch has no tax rates', (tester) async {
      await _pump(tester, _Store(), _Db()..taxRows.clear());
      expect(find.text('No tax configurations found'), findsOneWidget);
    });

    testWidgets('a failed rate lookup is shown, not a spinner', (tester) async {
      await _pump(tester, _Store(), _Db()..taxesThrow = true);
      expect(find.textContaining('offline'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('the close button dismisses the dialog', (tester) async {
      await _pump(tester, _Store(), _Db());

      expect(find.byType(TaxSettingsModal), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('configClose')));
      await tester.pumpAndSettle();
      expect(find.byType(TaxSettingsModal), findsNothing);
    });

    testWidgets('phone and email stack on a phone, sit side by side in a '
        'wide dialog', (tester) async {
      double dy(String key) => tester.getTopLeft(find.byKey(ValueKey(key))).dy;

      await _pump(tester, _Store(), _Db(), size: const Size(420, 1600));
      expect(dy('receiptHeaderEmail'), greaterThan(dy('receiptHeaderPhone')));

      await _pump(tester, _Store(), _Db());
      expect(dy('receiptHeaderEmail'), dy('receiptHeaderPhone'));
    });
  });

  group('narrow screens and no branch', () {
    testWidgets('a rate being edited on a phone drops below its label', (
      tester,
    ) async {
      await _pump(tester, _Store(), _Db(), size: const Size(360, 1600));

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final field = find.byKey(const ValueKey('taxRate-cfg-b'));
      expect(
        tester.getTopLeft(field).dy,
        greaterThan(tester.getBottomLeft(find.text('B Tax')).dy),
      );
      expect(find.byIcon(Icons.undo), findsOneWidget);
    });

    testWidgets('with no branch the header says so instead of dead fields', (
      tester,
    ) async {
      final store = _Store();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            branchServicesProvider.overrideWithValue(
              _Services(_Db(), branchId: null),
            ),
            receiptHeaderStoreProvider.overrideWithValue(store),
          ],
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates:
                FlipperAppLocalizations.localizationsDelegates,
            supportedLocales: FlipperAppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(child: ReceiptHeaderSection()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('receiptHeaderNoBranch')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('receiptHeaderPhone')), findsNothing);
      expect(find.byKey(const ValueKey('receiptHeaderSave')), findsNothing);
      expect(store.loaded, isEmpty);
    });

    testWidgets('with no branch id passed, it loads the active branch', (
      tester,
    ) async {
      final store = _Store();
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(store, _Db()),
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates:
                FlipperAppLocalizations.localizationsDelegates,
            supportedLocales: FlipperAppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(child: ReceiptHeaderSection()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(store.loaded, ['br']);
      expect(find.byKey(const ValueKey('receiptHeaderPhone')), findsOneWidget);
    });
  });

  testWidgets('Enter while a rate save is pending does not save twice', (
    tester,
  ) async {
    final gate = Completer<void>();
    final db = _Db()..saveGate = gate.future;
    await _pump(tester, _Store(), db);

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    final rate = find.byKey(const ValueKey('taxRate-cfg-b'));
    await tester.enterText(rate, '16');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.enterText(rate, '17');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(db.saved, [(configId: 'cfg-b', taxPercentage: 16.0)]);
    gate.complete();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
  });
}
