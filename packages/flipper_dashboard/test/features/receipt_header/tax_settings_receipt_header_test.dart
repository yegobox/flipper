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
  @override
  String? getBusinessId() => 'biz';

  @override
  String? getBranchId() => 'br';

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _Db implements DatabaseSyncInterface {
  _Db({this.business, this.businessThrows = false});

  final Business? business;
  final bool businessThrows;
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
  Future<List<Configurations>> taxes({required String branchId}) async =>
      taxRows;

  @override
  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  }) async {
    saved.add((configId: configId, taxPercentage: taxPercentage));
    return taxRows.first;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Services extends BranchServices {
  _Services(this.db);

  final _Db db;
  final _box = _Box();

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
  bool fail = false;

  @override
  Future<BranchDocumentSettings> load(String branchId) async => settings;

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

Future<void> _pump(WidgetTester tester, _Store store, _Db db) async {
  tester.view.physicalSize = const Size(900, 1600) * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(store, db),
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: const Scaffold(body: TaxSettingsModal(branchId: 'br')),
      ),
    ),
  );
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

      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextFormField, '18.0'), '16');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(db.saved.single, (configId: 'cfg-b', taxPercentage: 16.0));
      expect(find.text('Tax settings updated successfully'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
