import 'package:flipper_dashboard/export/utils/plu_excel_formula_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('excelLiteralNumForFormula', () {
    test('zero and integers', () {
      expect(PluExcelFormulaBuilder.excelLiteralNumForFormula(0), '0');
      expect(PluExcelFormulaBuilder.excelLiteralNumForFormula(18), '18');
    });

    test('fractions use toString', () {
      expect(
        PluExcelFormulaBuilder.excelLiteralNumForFormula(1.5),
        '1.5',
      );
    });
  });

  group('formulaSheetPrefix', () {
    test('simple names unquoted', () {
      expect(PluExcelFormulaBuilder.formulaSheetPrefix('Report'), 'Report!');
      expect(PluExcelFormulaBuilder.formulaSheetPrefix('Expenses'), 'Expenses!');
    });

    test('names with spaces are quoted', () {
      expect(
        PluExcelFormulaBuilder.formulaSheetPrefix('Stock Recount'),
        "'Stock Recount'!",
      );
    });

    test('apostrophe doubled inside quotes', () {
      expect(
        PluExcelFormulaBuilder.formulaSheetPrefix("Joe's Shop"),
        "'Joe''s Shop'!",
      );
    });

    test('trim and empty', () {
      expect(PluExcelFormulaBuilder.formulaSheetPrefix('  Report  '), 'Report!');
      expect(PluExcelFormulaBuilder.formulaSheetPrefix(''), '');
    });
  });

  group('pluTaxPayableExcelFormula', () {
    Map<String, dynamic> baseRow({
      String ty = 'B',
      double discount = 0,
      num? taxAmt,
      num? tot,
      num? taxbl,
    }) {
      return {
        PluExcelRowKeys.taxTyCd: ty,
        PluExcelRowKeys.discount: discount,
        if (taxAmt != null) PluExcelRowKeys.taxAmt: taxAmt,
        if (tot != null) PluExcelRowKeys.totAmt: tot,
        if (taxbl != null) PluExcelRowKeys.taxblAmt: taxbl,
      };
    }

    test('returns null when taxAmt is positive', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(taxAmt: 12.5),
          excelRow: 2,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        isNull,
      );
    });

    test('returns null when tot exceeds taxbl (tax from tot−taxbl)', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(tot: 120, taxbl: 100),
          excelRow: 3,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        isNull,
      );
    });

    test('type D is zero', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(ty: 'D'),
          excelRow: 2,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        '=0',
      );
    });

    test('type B tax-inclusive', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(ty: 'B'),
          excelRow: 5,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        '=IF(D5*F5-0<=0,0,ROUND((D5*F5-0)*H5/(100+H5),2))',
      );
    });

    test('tax column J row 9 keeps J9 and D9 separate (no glued J9D9 token)', () {
      final f = PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
        rowData: baseRow(ty: 'B'),
        excelRow: 9,
        priceLetter: 'D',
        qtyLetter: 'F',
        taxRateLetter: 'J',
      );
      expect(
        f,
        '=IF(D9*F9-0<=0,0,ROUND((D9*F9-0)*J9/(100+J9),2))',
      );
      expect(f, isNot(contains('J9D')));
    });

    test('type C same inclusive pattern as B', () {
      final f = PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
        rowData: baseRow(ty: 'c'),
        excelRow: 10,
        priceLetter: 'D',
        qtyLetter: 'F',
        taxRateLetter: 'H',
      );
      expect(f, contains('(100+H10)'));
    });

    test('tax-exclusive for other tax types', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(ty: 'A'),
          excelRow: 4,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        '=IF(D4*F4-0<=0,0,ROUND((D4*F4-0)*H4/100,2))',
      );
    });

    test('embeds discount literal', () {
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: baseRow(ty: 'B', discount: 50),
          excelRow: 2,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        '=IF(D2*F2-50<=0,0,ROUND((D2*F2-50)*H2/(100+H2),2))',
      );
    });

    test('defaults empty tax type to B', () {
      final row = <String, dynamic>{PluExcelRowKeys.discount: 0.0};
      expect(
        PluExcelFormulaBuilder.pluTaxPayableExcelFormula(
          rowData: row,
          excelRow: 2,
          priceLetter: 'D',
          qtyLetter: 'F',
          taxRateLetter: 'H',
        ),
        contains('(100+H2)'),
      );
    });
  });

  group('pluNetProfitExcelFormula', () {
    test('with supply column', () {
      expect(
        PluExcelFormulaBuilder.pluNetProfitExcelFormula(
          excelRow: 7,
          totalSalesLetter: 'G',
          taxPayableLetter: 'J',
          supplyLetter: 'H',
        ),
        '=ROUND((G7-H7)-J7,2)',
      );
    });

    test('with literal supply amount', () {
      expect(
        PluExcelFormulaBuilder.pluNetProfitExcelFormula(
          excelRow: 3,
          totalSalesLetter: 'G',
          taxPayableLetter: 'J',
          splyAmtLiteral: 1000,
        ),
        '=ROUND((G3-1000)-J3,2)',
      );
    });

    test('null literal treated as zero', () {
      expect(
        PluExcelFormulaBuilder.pluNetProfitExcelFormula(
          excelRow: 2,
          totalSalesLetter: 'G',
          taxPayableLetter: 'J',
        ),
        '=ROUND((G2-0)-J2,2)',
      );
    });
  });

  group('final net profit cross-sheet', () {
    test('finalNetProfitAfterExpensesFormula', () {
      expect(
        PluExcelFormulaBuilder.finalNetProfitAfterExpensesFormula(
          reportSheetName: 'Report',
          expensesSheetName: 'Expenses',
          netProfitColumnLetter: 'K',
          netProfitBeforeExpensesRow: 12,
          totalExpensesRow: 8,
        ),
        '=Report!K12-Expenses!B8',
      );
    });

    test('quoted report sheet when name has space', () {
      expect(
        PluExcelFormulaBuilder.finalNetProfitAfterExpensesFormula(
          reportSheetName: 'Stock Recount',
          expensesSheetName: 'Expenses',
          netProfitColumnLetter: 'K',
          netProfitBeforeExpensesRow: 20,
          totalExpensesRow: 5,
        ),
        "='Stock Recount'!K20-Expenses!B5",
      );
    });

    test('netProfitBeforeExpensesOnlyFormula', () {
      expect(
        PluExcelFormulaBuilder.netProfitBeforeExpensesOnlyFormula(
          reportSheetName: 'Report',
          netProfitColumnLetter: 'K',
          netProfitBeforeExpensesRow: 11,
        ),
        '=Report!K11',
      );
    });
  });

  group('PluExcelRowKeys', () {
    test('stable string values for row maps', () {
      expect(PluExcelRowKeys.taxTyCd, '__excelRowTaxTyCd');
      expect(PluExcelRowKeys.discount, '__excelRowDiscount');
      expect(PluExcelRowKeys.splyAmt, '__excelRowSplyAmt');
      expect(PluExcelRowKeys.taxAmt, '__excelRowTaxAmt');
      expect(PluExcelRowKeys.totAmt, '__excelRowTotAmt');
      expect(PluExcelRowKeys.taxblAmt, '__excelRowTaxblAmt');
    });
  });
}
