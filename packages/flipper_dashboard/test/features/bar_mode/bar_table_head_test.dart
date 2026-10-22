import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

// flutter test test/features/bar_mode/bar_table_head_test.dart
TransactionItem _line({String? loggedByName}) => TransactionItem(
  name: 'Chips',
  qty: 1,
  price: 2500,
  discount: 0,
  prc: 2500,
  ttCatCd: 'B',
  loggedByTenantId: 't1',
  loggedByName: loggedByName,
);

Future<void> _pumpHead(WidgetTester tester, {String? openedBy}) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          // The desktop tab panel is 460 px wide.
          child: SizedBox(
            width: 460,
            child: BarTableHead(
              tableName: 'Umunyinya 2(Etage)',
              zoneName: 'Main Bar',
              seats: 2,
              openedAt: DateTime(2026, 10, 22, 8, 4),
              openedBy: openedBy,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('barTableBadgeLabel', () {
    test('keeps short table codes', () {
      expect(barTableBadgeLabel('T4'), 'T4');
      expect(barTableBadgeLabel('b12'), 'B12');
    });

    test('collapses long names to the first letter of two words', () {
      expect(barTableBadgeLabel('Umunyinya 2(Etage)'), 'U2');
      expect(barTableBadgeLabel('Main Bar 4'), 'MB');
      expect(barTableBadgeLabel('Terrace'), 'T');
    });

    test('falls back to ? for a blank name', () {
      expect(barTableBadgeLabel(''), '?');
      expect(barTableBadgeLabel('   '), '?');
    });
  });

  group('barOpenerName', () {
    test('is empty before any line is logged', () {
      expect(barOpenerName(const []), '');
    });

    test('is the first name of whoever logged the first line', () {
      expect(barOpenerName([_line(loggedByName: 'Aline Uwase')]), 'Aline');
    });
  });

  group('BarTableHead', () {
    testWidgets('fits a long table name and titles the head with it', (
      tester,
    ) async {
      await _pumpHead(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('U2'), findsOneWidget);
      expect(find.text('Umunyinya 2(Etage)'), findsOneWidget);
      expect(find.text('Main Bar'), findsOneWidget);
    });

    testWidgets('says who opened the tab only when someone did', (
      tester,
    ) async {
      await _pumpHead(tester);
      expect(find.textContaining(' by '), findsNothing);

      await _pumpHead(tester, openedBy: 'Aline');
      expect(find.textContaining(' by Aline'), findsOneWidget);
    });
  });
}
