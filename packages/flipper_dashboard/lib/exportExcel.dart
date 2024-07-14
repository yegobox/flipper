import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'package:permission_handler/permission_handler.dart' as permission;

mixin BaseCoreWidgetMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  Future<void> exportDataGridToExcel({
    DateTime? startDate,
    DateTime? endDate,
    double? grossProfit,
    double? netProfit,
  }) async {
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();

      final business = await ProxyService.local.getBusiness();
      final tinNumber = business.tinNumber ?? 0;
      final bhfId = ProxyService.box.bhfId() ?? "00";
      final drawer = await ProxyService.realm
          .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

      final excel.Workbook workbook =
          workBookKey.currentState!.exportToExcelWorkbook();
      final excel.Worksheet sheet = workbook.worksheets[0];

      // Define styles
      final excel.Style balanceStyle =
          _createStyle(workbook, fontColor: '#FFFFFF', backColor: '#008000');
      final excel.Style infoStyle =
          _createStyle(workbook, fontColor: '#000000', backColor: '#FFFF00');

      // Add information rows at the top
      _addInfoRows(sheet, infoStyle, tinNumber, bhfId, startDate, endDate,
          drawer?.openingBalance, grossProfit, netProfit);

      // Add closing balance row at the bottom
      _addClosingBalanceRow(sheet, balanceStyle);

      // Save and share the file
      final String filePath = await _saveExcelFile(workbook);
      workbook.dispose();

      ref.read(isProcessingProvider.notifier).stopProcessing();
      shareFileAsAttachment(filePath);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error(e);
      talker.error(s);
    }
  }

  excel.Style _createStyle(excel.Workbook workbook,
      {required String fontColor, required String backColor}) {
    final style = workbook.styles.add('customStyle');
    style.fontName = 'Arial';
    style.bold = true;
    style.fontSize = 12;
    style.fontColor = fontColor;
    style.backColor = backColor;
    return style;
  }

  void _addInfoRows(
      excel.Worksheet sheet,
      excel.Style style,
      int tinNumber,
      String bhfId,
      DateTime? startDate,
      DateTime? endDate,
      double? openingBalance,
      double? grossProfit,
      double? netProfit) {
    final infoData = [
      ['TIN Number', tinNumber],
      ['BHF ID', bhfId],
      ['Start Date', startDate?.toIso8601String() ?? "-"],
      ['End Date', endDate?.toIso8601String() ?? "-"],
      ['Opening Balance', openingBalance ?? 0],
      ['Gross Profit', grossProfit ?? 0],
      ['Net Profit', netProfit ?? 0],
    ];

    for (var i = 0; i < infoData.length; i++) {
      sheet.insertRow(i + 1);
      sheet.getRangeByName('A${i + 1}').setText(infoData[i][0].toString());
      sheet.getRangeByName('E${i + 1}').setValue(infoData[i][1]);
      for (var col = 1; col <= 5; col++) {
        sheet.getRangeByIndex(i + 1, col).cellStyle = style;
      }
    }
  }

  void _addClosingBalanceRow(excel.Worksheet sheet, excel.Style style) {
    final lastRow = sheet.getLastRow() + 1;
    sheet.insertRow(lastRow);
    sheet.getRangeByName('A$lastRow').setText('Closing Balance');
    sheet.getRangeByName('E$lastRow').setFormula('=SUM(C6:C${lastRow - 1})');
    for (var col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(lastRow, col).cellStyle = style;
    }
  }

  Future<String> _saveExcelFile(excel.Workbook workbook) async {
    final List<int> bytes = workbook.saveAsStream();
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final String filePath = '${tempDir.path}/${formattedDate}-Report.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<void> shareFileAsAttachment(String filePath) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final file = File(filePath);
    final fileName = p.basename(file.path);

    if (Platform.isWindows || Platform.isLinux) {
      final bytes = await file.readAsBytes();
      final mimeType = _lookupMimeType(filePath);
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

  String _lookupMimeType(String filePath) {
    final mimeType = _mimeTypes[filePath.split('.').last];
    return mimeType ?? 'application/octet-stream';
  }

  Future<void> requestPermissions() async {
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }

  final _mimeTypes = {
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
}
