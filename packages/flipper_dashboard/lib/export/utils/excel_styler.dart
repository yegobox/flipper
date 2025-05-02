import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

/// Utility class for creating and managing Excel styles
class ExcelStyler {
  final excel.Workbook workbook;
  int _styleCounter = 0;

  ExcelStyler(this.workbook);

  /// Creates a custom Excel style with the specified properties
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
