import 'dart:io';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

/// Utility class for file operations related to export functionality
class FileUtils {
  /// MIME type mapping for common file extensions
  static final _mimeTypes = {
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'pdf': 'application/pdf',
  };

  /// Saves an Excel workbook to a file and returns the file path
  static Future<String> saveExcelFile(excel.Workbook workbook) async {
    final List<int> bytes = workbook.saveAsStream();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${formattedDate}-Report.xlsx';

    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);

      await file.create(recursive: true);

      // Chunk the data if it's large
      final chunkSize = 1024 * 1024; // 1MB chunk size (adjust as needed)
      if (bytes.length > chunkSize) {
        final fileStream = file.openWrite(mode: FileMode.writeOnly);
        for (int i = 0; i < bytes.length; i += chunkSize) {
          final end =
              (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
          final chunk = bytes.sublist(i, end);
          fileStream.add(chunk);
        }
        await fileStream.flush(); // Ensure all data is written to disk
        await fileStream.close(); // Close the stream
      } else {
        await file.writeAsBytes(bytes, flush: true);
      }

      return filePath;
    } catch (e) {
      talker.error('Error saving Excel file: $e');
      rethrow;
    }
  }

  /// Saves a PDF document to a file and returns the file path
  static Future<String> savePdfFile(PdfDocument document) async {
    final List<int> bytes = await document.save();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${formattedDate}-Report.pdf';

    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);

      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      return filePath;
    } catch (e) {
      talker.error('Error saving PDF file: $e');
      rethrow;
    }
  }

  /// Opens or shares a file based on the platform
  static Future<void> openOrShareFile(String filePath) async {
    if (Platform.isWindows || Platform.isMacOS) {
      try {
        final response = await OpenFilex.open(filePath);
        talker.warning(response);
      } catch (e) {
        talker.error(e);
      }
    } else {
      await shareFileAsAttachment(filePath);
    }
  }

  /// Shares a file as an attachment
  static Future<void> shareFileAsAttachment(String filePath) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final file = File(filePath);
    final fileName = p.basename(file.path);

    if (Platform.isWindows || Platform.isLinux) {
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(filePath);
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: mimeType, name: fileName)],
        subject: 'Report Download - $formattedDate',
      );
    } else {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Report Download - $formattedDate',
      );
    }
  }

  /// Looks up the MIME type for a file based on its extension
  static String lookupMimeType(String filePath) {
    final mimeType = _mimeTypes[filePath.split('.').last];
    return mimeType ?? 'application/octet-stream';
  }

  /// Requests necessary permissions for file operations
  static Future<void> requestPermissions() async {
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }
}
