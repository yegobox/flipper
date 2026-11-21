import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/sync/capella/mixins/hotel_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

class _Sync with CapellaHotelMixin {
  _Sync(this.fake);

  final FakeDitto? fake;

  @override
  dynamic get dittoHandle => fake;

  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();
}

void main() {
  late FakeDitto ditto;
  late _Sync sync;

  setUp(() {
    ditto = FakeDitto();
    sync = _Sync(ditto);
  });

  test('a header save leaves the stored stamp alone', () async {
    await sync.saveBranchDocumentSettings(
      const BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: 'AAAA',
        stampWidthMm: 44,
      ),
    );

    // Built from defaults, as after a failed read: no stamp in it at all.
    await sync.saveBranchReceiptHeader(
      const BranchDocumentSettings(
        branchId: 'b1',
        receiptPhone: '0722111222',
        receiptEmail: 'branch@example.com',
        receiptMessage: 'Murakaza neza',
      ),
    );

    final stored = (await sync.branchDocumentSettings(branchId: 'b1'))!;
    expect(stored.hasStamp, isTrue);
    expect(stored.stampWidthMm, 44);
    expect(stored.receiptPhone, '0722111222');
    expect(stored.receiptEmail, 'branch@example.com');
    expect(stored.receiptMessage, 'Murakaza neza');
    expect(stored.updatedAt, isNotNull);
  });

  test('a stamp save leaves the stored header alone', () async {
    await sync.saveBranchReceiptHeader(
      const BranchDocumentSettings(
        branchId: 'b1',
        receiptPhone: '0722111222',
        receiptMessage: 'Hello',
      ),
    );
    // A device whose cache never saw the header saves its stamp.
    await sync.saveBranchDocumentSettings(
      const BranchDocumentSettings(
        branchId: 'b1',
        stampEnabled: true,
        stampImageBase64: 'AAAA',
      ),
    );

    final stored = (await sync.branchDocumentSettings(branchId: 'b1'))!;
    expect(stored.hasStamp, isTrue);
    expect(stored.receiptPhone, '0722111222');
    expect(stored.receiptMessage, 'Hello');
  });

  test('a cleared welcome line clears in Ditto', () async {
    await sync.saveBranchReceiptHeader(
      const BranchDocumentSettings(branchId: 'b1', receiptMessage: 'Hello'),
    );
    await sync.saveBranchReceiptHeader(
      const BranchDocumentSettings(branchId: 'b1'),
    );
    final stored = (await sync.branchDocumentSettings(branchId: 'b1'))!;
    expect(stored.receiptMessage, isNull);
    expect(stored.receiptWelcomeLine, 'WELCOME TO OUR SHOP');
  });

  test('without Ditto the save throws, so the editor reports it', () async {
    expect(
      () => _Sync(
        null,
      ).saveBranchReceiptHeader(const BranchDocumentSettings(branchId: 'b1')),
      throwsStateError,
    );
  });
}
