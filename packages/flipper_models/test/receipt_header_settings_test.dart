import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helpers/rra_top_message.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/services/branch_document_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_models/brick/repository/storage.dart';

final getIt = GetIt.instance;

class _FakeBox implements LocalStorage {
  final Map<String, Object?> values = {};
  String? branchId;

  @override
  String? getBranchId() => branchId;

  @override
  String? readString({required String key}) => values[key] as String?;

  @override
  Future<void> writeString({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  bool? readBool({required String key}) => values[key] as bool?;

  @override
  Future<void> writeBool({required String key, required bool value}) async {
    values[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Only the Ditto calls the receipt header makes. Stores raw JSON and merges
/// on upsert, like Ditto's ON ID CONFLICT DO UPDATE.
class _FakeDb implements DatabaseSyncInterface {
  final Map<String, Map<String, dynamic>> raw = {};
  final List<Map<String, dynamic>> writes = [];
  bool failReads = false;
  bool failWrites = false;

  void seed(BranchDocumentSettings settings) =>
      raw[settings.branchId] = settings.toJson();

  BranchDocumentSettings? doc(String branchId) => raw[branchId] == null
      ? null
      : BranchDocumentSettings.fromJson(raw[branchId]!);

  @override
  Future<BranchDocumentSettings?> branchDocumentSettings({
    required String branchId,
  }) async {
    if (failReads) throw StateError('Ditto not initialized');
    return doc(branchId);
  }

  @override
  Future<void> saveBranchReceiptHeader(BranchDocumentSettings settings) async {
    if (failWrites) throw StateError('Ditto not initialized');
    final json = settings.receiptHeaderJson();
    writes.add(json);
    raw[settings.branchId] = {...?raw[settings.branchId], ...json};
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('BranchDocumentSettings receipt header', () {
    test('falls back to the business when the branch has nothing', () {
      const settings = BranchDocumentSettings(branchId: 'b1');
      expect(settings.receiptPhoneOr(' 0788000000 '), '0788000000');
      expect(settings.receiptEmailOr('shop@example.com'), 'shop@example.com');
      expect(settings.receiptPhoneOr(null), '');
      expect(settings.receiptEmailOr(null), '');
      expect(settings.receiptWelcomeLine, 'WELCOME TO OUR SHOP');
    });

    test("the branch's own values win over the business", () {
      const settings = BranchDocumentSettings(
        branchId: 'b1',
        receiptPhone: '0722111222',
        receiptEmail: 'branch@example.com',
        receiptMessage: 'Murakaza neza',
      );
      expect(settings.receiptPhoneOr('0788000000'), '0722111222');
      expect(settings.receiptEmailOr('shop@example.com'), 'branch@example.com');
      expect(settings.receiptWelcomeLine, 'Murakaza neza');
    });

    test('a blank welcome line prints the default', () {
      const settings = BranchDocumentSettings(
        branchId: 'b1',
        receiptMessage: '   ',
      );
      expect(settings.receiptWelcomeLine, 'WELCOME TO OUR SHOP');
    });

    test('copyWith trims, and an empty string clears back to null', () {
      const base = BranchDocumentSettings(
        branchId: 'b1',
        receiptPhone: '0722111222',
        receiptMessage: 'Hello',
      );
      final edited = base.copyWith(
        receiptEmail: '  a@b.co ',
        receiptMessage: '',
      );
      expect(edited.receiptPhone, '0722111222');
      expect(edited.receiptEmail, 'a@b.co');
      expect(edited.receiptMessage, isNull);
    });

    test('round-trips through Ditto JSON, writing cleared fields as null', () {
      const settings = BranchDocumentSettings(
        branchId: 'b1',
        receiptPhone: '0722111222',
        receiptEmail: 'branch@example.com',
      );
      final json = settings.receiptHeaderJson();
      // Written even when null so a cleared line clears on every device.
      expect(json.containsKey('receiptMessage'), isTrue);
      expect(json['receiptMessage'], isNull);
      // A header save never carries the stamp...
      expect(json.keys.where((k) => k.startsWith('stamp')), isEmpty);
      // ...and a stamp save never carries the header.
      expect(
        settings.toJson().keys.where((k) => k.startsWith('receipt')),
        isEmpty,
      );

      final back = BranchDocumentSettings.fromJson(json);
      expect(back.receiptPhone, '0722111222');
      expect(back.receiptEmail, 'branch@example.com');
      expect(back.receiptMessage, isNull);

      final blank = BranchDocumentSettings.fromJson({
        'branchId': 'b1',
        'receiptPhone': '',
        'receiptEmail': '  ',
      });
      expect(blank.receiptPhone, isNull);
      expect(blank.receiptEmail, isNull);
    });

    test('a document from a build before these fields still reads', () {
      final old = BranchDocumentSettings.fromJson({
        'branchId': 'b1',
        'stampEnabled': true,
        'stampImageBase64': 'AAAA',
      });
      expect(old.hasStamp, isTrue);
      expect(old.receiptPhone, isNull);
      expect(old.receiptWelcomeLine, 'WELCOME TO OUR SHOP');
    });
  });

  group('rraReceiptTopMessage', () {
    test('sends the branch header and its welcome line', () {
      final message = rraReceiptTopMessage(
        header: const BranchDocumentSettings(
          branchId: 'b1',
          receiptPhone: '+250722111222',
          receiptEmail: 'branch@example.com',
          receiptMessage: 'Thank you for visiting',
        ),
        businessName: 'Kigali Shop',
        address: 'KN 3 Rd',
        businessPhone: '0788000000',
        businessEmail: 'shop@example.com',
        tin: '123456789',
      );
      expect(
        message,
        'Kigali Shop\nKN 3 Rd\nTEL: 250722111222\n'
        'Email: branch@example.com\nTIN: 123456789\nThank you for visiting',
      );
    });

    test('keeps the old placeholders when nothing is set anywhere', () {
      final message = rraReceiptTopMessage(
        header: const BranchDocumentSettings(branchId: 'b1'),
      );
      expect(
        message,
        'Our Business\n\nTEL: 0780000000\nEmail: info@yegobox.com\n'
        'TIN: 999909695\nWELCOME TO OUR SHOP',
      );
    });
  });

  group('BranchDocumentSettingsService receipt header', () {
    late _FakeBox box;
    late _FakeDb db;

    setUp(() {
      box = _FakeBox()..branchId = 'branch-a';
      db = _FakeDb();
      getIt.registerSingleton<LocalStorage>(box);
      getIt.registerSingleton<SyncStrategy>(
        SyncStrategy(capella: db, cloudSync: db),
        instanceName: 'strategy',
      );
    });

    tearDown(() async => getIt.reset());

    test('the print cache carries the header, and clears it', () {
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0722111222',
          receiptEmail: 'branch@example.com',
          receiptMessage: 'Hello',
        ),
      );
      var current = BranchDocumentSettingsService.current();
      expect(current.receiptPhone, '0722111222');
      expect(current.receiptEmail, 'branch@example.com');
      expect(current.receiptMessage, 'Hello');

      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(branchId: 'branch-a'),
      );
      current = BranchDocumentSettingsService.current();
      expect(current.receiptPhone, isNull);
      expect(current.receiptEmail, isNull);
      expect(current.receiptMessage, isNull);
    });

    test('loadForBranch reads the header from Ditto', () async {
      await db.saveBranchReceiptHeader(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptEmail: 'branch@example.com',
        ),
      );
      final loaded = await BranchDocumentSettingsService.loadForBranch(
        'branch-a',
      );
      expect(loaded.receiptEmail, 'branch@example.com');
    });

    test('loadForBranch falls back to the cache, then to defaults', () async {
      db.failReads = true;
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0722111222',
        ),
      );
      final cached = await BranchDocumentSettingsService.loadForBranch(
        'branch-a',
      );
      expect(cached.receiptPhone, '0722111222');

      final other = await BranchDocumentSettingsService.loadForBranch(
        'branch-b',
      );
      expect(other.branchId, 'branch-b');
      expect(other.receiptPhone, isNull);
    });

    test('saving writes only the header and keeps a newer stamp', () async {
      // The dialog read the doc before another till added a stamp; its save
      // must not revert that stamp.
      final opened = await BranchDocumentSettingsService.loadForBranch(
        'branch-a',
      );
      db.seed(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'NEW',
        ),
      );
      BranchDocumentSettingsService.applyToLocalCache(db.doc('branch-a')!);

      final ok = await BranchDocumentSettingsService.saveReceiptHeader(
        opened.copyWith(receiptPhone: '0722111222'),
      );

      expect(ok, isTrue);
      expect(
        db.writes.single.keys.where((k) => k.startsWith('stamp')),
        isEmpty,
      );
      final stored = db.doc('branch-a')!;
      expect(stored.stampImageBase64, 'NEW');
      expect(stored.receiptPhone, '0722111222');
      final cached = BranchDocumentSettingsService.current();
      expect(cached.receiptPhone, '0722111222');
      expect(cached.stampImageBase64, 'NEW');
    });

    test('a failed read never turns into a stamp-clearing save', () async {
      db.seed(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          stampEnabled: true,
          stampImageBase64: 'AAAA',
        ),
      );
      db.failReads = true;
      final opened = await BranchDocumentSettingsService.loadForBranch(
        'branch-a',
      );
      expect(opened.hasStamp, isFalse); // defaults: the cache was empty

      await BranchDocumentSettingsService.saveReceiptHeader(
        opened.copyWith(receiptPhone: '0722111222'),
      );

      expect(db.doc('branch-a')!.hasStamp, isTrue);
      expect(db.doc('branch-a')!.receiptPhone, '0722111222');
    });

    test('an unhydrated cache is left for hydrate to fill', () async {
      final ok = await BranchDocumentSettingsService.saveReceiptHeader(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0722111222',
        ),
      );
      expect(ok, isTrue);
      expect(box.values.containsKey('docReceiptPhone'), isFalse);
    });

    test("saving another branch leaves this branch's cache alone", () async {
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0722111222',
        ),
      );
      final ok = await BranchDocumentSettingsService.saveReceiptHeader(
        const BranchDocumentSettings(
          branchId: 'branch-b',
          receiptPhone: '0733000000',
        ),
      );
      expect(ok, isTrue);
      expect(db.doc('branch-b')!.receiptPhone, '0733000000');
      expect(
        BranchDocumentSettingsService.current().receiptPhone,
        '0722111222',
      );
    });

    test('a failed save reports false and leaves the cache alone', () async {
      BranchDocumentSettingsService.applyToLocalCache(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0722111222',
        ),
      );
      db.failWrites = true;
      final ok = await BranchDocumentSettingsService.saveReceiptHeader(
        const BranchDocumentSettings(
          branchId: 'branch-a',
          receiptPhone: '0799999999',
        ),
      );
      expect(ok, isFalse);
      expect(
        BranchDocumentSettingsService.current().receiptPhone,
        '0722111222',
      );
    });
  });
}
