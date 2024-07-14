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
      // await requestPermissions();
      ref.read(isProcessingProvider.notifier).startProcessing();

      Business business = await ProxyService.local.getBusiness();
      int tinNumber = business.tinNumber ?? 0;
      String bhfId = ProxyService.box.bhfId() ?? "00";
      Drawers? drawer = await ProxyService.realm
          .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

      final excel.Workbook workbook =
          workBookKey.currentState!.exportToExcelWorkbook();
      final excel.Worksheet sheet = workbook.worksheets[0];

      final excel.Style balanceStyle = workbook.styles.add('balanceStyle');
      balanceStyle.fontName = 'Arial';
      balanceStyle.bold = true;
      balanceStyle.fontSize = 12;
      balanceStyle.fontColor = '#FFFFFF'; // White font color
      balanceStyle.backColor = '#008000'; // Dark green background color

      final excel.Style infoStyle = workbook.styles.add('infoStyle');
      infoStyle.fontName = 'Arial';
      infoStyle.bold = true;
      infoStyle.fontSize = 12;
      infoStyle.fontColor = '#000000'; // Black font color
      infoStyle.backColor = '#FFFF00'; // Yellow background color

      // Add information rows at the top
      for (int i = 0; i < 5; i++) {
        sheet.insertRow(1);
        for (int col = 1; col <= 5; col++) {
          sheet.getRangeByIndex(i + 1, col).cellStyle = infoStyle;
        }
      }

      sheet.getRangeByName('A1').setText('TIN Number');
      sheet.getRangeByName('E1').setNumber(tinNumber.toDouble());
      sheet.getRangeByName('A2').setText('BHF ID');
      sheet.getRangeByName('E2').setText(bhfId);
      sheet.getRangeByName('A3').setText('Start Date');
      sheet.getRangeByName('E3').setText(
          startDate?.toIso8601String() ?? "-"); // Format date as needed
      sheet.getRangeByName('A4').setText('End Date');
      sheet
          .getRangeByName('E4')
          .setText(endDate?.toIso8601String() ?? "-"); // Format date as needed
      sheet.getRangeByName('A5').setText('Opening Balance');
      sheet.getRangeByName('E5').setNumber(drawer?.openingBalance ?? 0);
      sheet.getRangeByName('A6').setText('Gross Profit');
      sheet.getRangeByName('E6').setNumber(grossProfit ?? 0);
      sheet.getRangeByName('A7').setText('Net Profit');
      sheet.getRangeByName('E7').setNumber(netProfit ?? 0);

      // Add closing balance row at the bottom
      final int lastRow = sheet.getLastRow() + 1;
      sheet.insertRow(lastRow);
      for (int col = 1; col <= 5; col++) {
        sheet.getRangeByIndex(lastRow, col).cellStyle = balanceStyle;
      }
      sheet.getRangeByName('A$lastRow').setText('Closing Balance');
      sheet.getRangeByName('E$lastRow').setFormula('=SUM(C6:C${lastRow - 1})');

      final List<int> bytes = workbook.saveAsStream();

      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final Directory tempDir = await getApplicationDocumentsDirectory();
      final File file = File('${tempDir.path}/${formattedDate}-Report.xlsx');
      await file.writeAsBytes(bytes);

      workbook.dispose();
      ref.read(isProcessingProvider.notifier).stopProcessing();
      shareFileAsAttachment(file.path);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error(e);
      talker.error(s);
    }
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
