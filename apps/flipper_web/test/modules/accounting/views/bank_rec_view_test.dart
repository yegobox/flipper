import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_statement_service.dart';
import 'package:flipper_web/modules/accounting/views/desktop/other_desktop_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/accounting_unit_test_overrides.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

/// Hands the import a one-page "PDF" without a native file dialog.
class _FakePicker extends FilePicker {
  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async => FilePickerResult([
    PlatformFile(
      name: 'momo.pdf',
      size: 3,
      bytes: Uint8List.fromList([1, 2, 3]),
    ),
  ]);
}

class _FakeStatements extends BankStatementService {
  _FakeStatements(this.statement);

  final ParsedStatement statement;

  @override
  Future<ParsedStatement> parse(Uint8List pdfBytes) async => statement;
}

typedef _Upsert = ({
  String? id,
  String account,
  BankLine line,
  String? matchedEntry,
});

/// Bank lines per ledger account, delivered a beat late like a real stream.
class _Ledger extends FakeAccountingLedgerRepository {
  _Ledger(this.linesByAccount, {super.entries});

  final Map<String, List<BankLine>> linesByAccount;
  final upserts = <_Upsert>[];

  @override
  Stream<List<BankLine>> watchBankLines({
    required String businessId,
    String bankAccountCode = '1020',
  }) => Stream.fromFuture(
    Future.delayed(
      const Duration(milliseconds: 10),
      () => linesByAccount[bankAccountCode] ?? const <BankLine>[],
    ),
  );

  @override
  Future<void> upsertBankLine({
    required String businessId,
    required BankLine line,
    String bankAccountCode = '1020',
    String? id,
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) async => upserts.add((
    id: id,
    account: bankAccountCode,
    line: line,
    matchedEntry: matchedJournalEntryId,
  ));
}

const _bankSms = BankLine(
  date: 'Oct 14',
  desc: 'BK · to Jane',
  amt: -2000,
  matched: false,
  id: 'bank-sms',
  source: 'sms',
  isoDate: '2026-10-14',
);

const _momoSms = BankLine(
  date: 'Oct 14',
  desc: 'MoMo · from Eric',
  amt: 5000,
  matched: false,
  id: 'momo-sms',
  source: 'sms',
  isoDate: '2026-10-14',
);

Future<void> _pump(
  WidgetTester tester,
  _Ledger ledger, {
  ParsedStatement statement = const ParsedStatement(),
}) async {
  tester.view.physicalSize = const Size(1400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...accountingUnitTestOverrides(),
        accountingLedgerRepositoryProvider.overrideWithValue(ledger),
        accountingBusinessIdProvider.overrideWithValue('biz'),
        accountingAccountsProvider.overrideWithValue(
          defaultChartOfAccountsSeed,
        ),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingPeriodLabelProvider.overrideWithValue('Oct 2026'),
        bankStatementServiceProvider.overrideWithValue(
          _FakeStatements(statement),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: AccountingBankRecView()),
      ),
    ),
  );
  await _settle(tester);
}

/// Lets the ledger's late stream deliver, then settles the frames.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 20));
  await tester.pumpAndSettle();
}

Future<void> _pickMomo(WidgetTester tester) =>
    tester.tap(find.text('Mobile money (1030)'));

void main() {
  setUp(() => FilePicker.platform = _FakePicker());

  testWidgets('a statement imported on MoMo reuses that account\'s SMS line', (
    tester,
  ) async {
    final ledger = _Ledger({
      '1020': [_bankSms],
      '1030': [_momoSms],
    });
    await _pump(
      tester,
      ledger,
      statement: const ParsedStatement(
        bankName: 'MTN MoMo',
        lines: [
          ParsedStatementLine(
            date: '2026-10-14',
            description: 'MOMO RECEIVED ERIC',
            credit: 5000,
          ),
          ParsedStatementLine(
            date: '2026-10-14',
            description: 'TRANSFER JANE',
            debit: 2000,
          ),
        ],
      ),
    );
    expect(find.text('BK · to Jane'), findsOneWidget);

    // Import straight after switching, before MoMo's lines have arrived: the
    // Bank account's SMS lines must not stand in for the MoMo statement.
    await _pickMomo(tester);
    await tester.tap(find.text('Import statement'));
    await _settle(tester);

    expect(find.text('MoMo · from Eric'), findsOneWidget);
    expect(find.text('TRANSFER JANE'), findsOneWidget);
    expect(find.text('MOMO RECEIVED ERIC'), findsNothing);
    expect(find.text('BK · to Jane'), findsNothing);
    // Only the statement line with no SMS twin is written, on MoMo.
    expect(ledger.upserts, hasLength(1));
    expect(ledger.upserts.single.account, '1030');
    expect(ledger.upserts.single.line.desc, 'TRANSFER JANE');
    expect(ledger.upserts.single.line.isoDate, '2026-10-14');
    expect(find.text('Statement imported'), findsOneWidget);
  });

  testWidgets('matching an SMS line keeps its stored id and account', (
    tester,
  ) async {
    final ledger = _Ledger(
      {
        '1030': [_momoSms],
      },
      entries: const [
        JournalEntry(
          id: 'JE-7',
          date: 'Oct 14',
          memo: 'MoMo sale',
          ref: 'JE-7',
          status: JournalStatus.posted,
          src: 'POS',
          lines: [
            JournalLine(ac: '1030', dr: 5000),
            JournalLine(ac: '4010', cr: 5000),
          ],
          uuid: 'je-uuid-7',
        ),
      ],
    );
    await _pump(tester, ledger);
    await _pickMomo(tester);
    await _settle(tester);

    await tester.tap(find.text('Match'));
    await _settle(tester);

    expect(find.text('Bank line matched'), findsOneWidget);
    expect(find.text('JE-7'), findsOneWidget);
    final upsert = ledger.upserts.single;
    expect(upsert.id, 'momo-sms');
    expect(upsert.account, '1030');
    expect(upsert.matchedEntry, 'je-uuid-7');
    expect(upsert.line.matched, isTrue);
    expect(upsert.line.source, 'sms');
  });

  testWidgets('a categorised MoMo charge posts against Mobile money', (
    tester,
  ) async {
    const charge = BankLine(
      date: 'Oct 14',
      desc: 'Withdrawal fee',
      amt: -300,
      matched: false,
    );
    final ledger = _Ledger({
      '1030': [charge],
    });
    await _pump(tester, ledger);
    await _pickMomo(tester);
    await _settle(tester);

    await tester.tap(find.text('Match'));
    await _settle(tester);
    await tester.tap(find.text('Bank fee / charge'));
    await _settle(tester);

    final entry = ledger.entries.single;
    expect(
      [for (final l in entry.lines) (l.ac, l.dr, l.cr)],
      [('6000', 300, 0), ('1030', 0, 300)],
    );
    final upsert = ledger.upserts.single;
    expect(upsert.account, '1030');
    // A line without a stored id is keyed the way the import keys it.
    expect(upsert.id, isNotNull);
    expect(upsert.matchedEntry, entry.uuid);
  });
}
