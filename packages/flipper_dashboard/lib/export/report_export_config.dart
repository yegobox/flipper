import 'package:flipper_dashboard/features/config/widgets/currency_options.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

class ExcelStyler {
  final excel.Workbook workbook;
  int _styleCounter = 0;

  ExcelStyler(this.workbook);

  excel.Style createStyle({
    required String fontColor,
    required String backColor,
    required double fontSize,
  }) {
    final styleName = 'customStyle${_styleCounter++}';
    final style = workbook.styles.add(styleName);
    style.fontName = 'Calibri';
    style.bold = true;
    style.fontSize = fontSize;
    style.fontColor = fontColor;
    style.backColor = backColor;
    style.hAlign = excel.HAlignType.center;
    style.vAlign = excel.VAlignType.center;
    return style;
  }
}

class ExportConfig {
  DateTime? startDate;
  DateTime? endDate;
  double? grossProfit;
  double? netProfit;
  double? cogs;
  String currencyCode;
  String currencySymbol;
  String currencyFormat;
  final List<ITransaction> transactions;
  ExportConfig({
    this.startDate,
    this.endDate,
    this.grossProfit,
    this.netProfit,
    this.cogs,
    this.currencyCode = 'RWF',
    required this.transactions,
  }) : currencySymbol = CurrencyOptions.getSymbolForCurrency(currencyCode),
       currencyFormat =
           '${CurrencyOptions.getSymbolForCurrency(currencyCode)}#,##0.00_);${CurrencyOptions.getSymbolForCurrency(currencyCode)}#,##0.00;${CurrencyOptions.getSymbolForCurrency(currencyCode)} 0.00';
}
