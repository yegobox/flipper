import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flipper_models/helperModels/talker.dart';

class ExcelUtility {
  /// Converts an Excel file to a Markdown representation (one table per sheet)
  static Future<String> excelToMarkdown(String filePath) async {
    try {
      final file = File(filePath);
      if (!(await file.exists())) {
        return 'Error: File does not exist at $filePath';
      }
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        return 'Error: File is empty.';
      }

      talker
          .info('Decoding Excel file: $filePath (Size: ${bytes.length} bytes)');
      final excel = Excel.decodeBytes(bytes);
      final StringBuffer sb = StringBuffer();

      if (excel.tables.isEmpty) {
        return 'No sheets found in the Excel file.';
      }

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        sb.writeln('### Sheet: $table');

        // Use a safer way to access rows
        final rows = sheet.rows;
        if (rows.isEmpty) {
          sb.writeln('Empty sheet.');
          continue;
        }

        talker.info('Summary for sheet $table: ${rows.length} rows found.');

        // Extract headers safely
        final firstRow = rows.first;
        if (firstRow.isEmpty) {
          sb.writeln('No columns found in first row.');
          continue;
        }

        final headers = firstRow.map((cell) {
          try {
            return cell?.value?.toString() ?? '';
          } catch (e) {
            return '';
          }
        }).toList();

        sb.writeln('| ${headers.join(' | ')} |');
        sb.writeln('| ${headers.map((_) => '---').join(' | ')} |');

        // Extract data (subsequent rows)
        for (var i = 1; i < rows.length; i++) {
          final rowData = rows[i].map((cell) {
            try {
              return cell?.value?.toString() ?? '';
            } catch (e) {
              return '';
            }
          }).toList();
          sb.writeln('| ${rowData.join(' | ')} |');
        }
        sb.writeln();
      }

      return sb.toString();
    } catch (e, stackTrace) {
      talker.error('Error parsing Excel: $e');
      talker.error(stackTrace);
      return 'Error: Could not parse Excel file: $e';
    }
  }

  /// Extracts structured data (headers and rows) for all sheets in an Excel file
  static Future<Map<String, Map<String, dynamic>>> excelToData(
      String filePath) async {
    try {
      final file = File(filePath);
      if (!(await file.exists())) {
        throw Exception('File does not exist');
      }
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      final Map<String, Map<String, dynamic>> results = {};

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null || sheet.maxRows == 0) continue;

        final rows = sheet.rows;
        if (rows.isEmpty) continue;

        final List<String> headers =
            rows.first.map((cell) => cell?.value?.toString() ?? '').toList();

        final List<List<dynamic>> rowData = [];
        for (var i = 1; i < rows.length; i++) {
          rowData.add(rows[i].map((cell) => cell?.value).toList());
        }

        results[table] = {
          'headers': headers,
          'rows': rowData,
        };
      }
      return results;
    } catch (e) {
      talker.error('Error extracting data from Excel: $e');
      rethrow;
    }
  }

  /// Extracts monthly financial data specifically for the financial_report visualization
  /// returns a Map structure that can be easily converted to JSON for the AI
  static Future<Map<String, dynamic>> extractFinancialData(
      String filePath) async {
    // For now, we rely on the AI to parse the Markdown table we provide.
    // This utility can be expanded if we need more structured extraction before sending to AI.
    return {};
  }
}
