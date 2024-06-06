import 'dart:io';

import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;

final pluReportToggleProvider =
    StateNotifierProvider<PluReportToggleNotifier, bool>(
  (ref) => PluReportToggleNotifier(),
);

class PluReportToggleNotifier extends StateNotifier<bool> {
  PluReportToggleNotifier() : super(false); // Default to ZReport

  void toggleReport() {
    state = !state;
  }
}

final isProcessingProvider = StateNotifierProvider<IsProcessingNotifier, bool>(
  (ref) => IsProcessingNotifier(),
);

class IsProcessingNotifier extends StateNotifier<bool> {
  IsProcessingNotifier() : super(false); // Default to not processing

  void startProcessing() {
    state = true;
  }

  void stopProcessing() {
    state = false;
  }

  void toggleProcessing() {
    state = !state;
  }
}

class TransactionList extends ConsumerWidget {
  const TransactionList({Key? key}) : super(key: key);
  Future<void> requestPermissions() async {
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }

  Future<void> exportDataGridToExcel(
      {required DateTime startDate,
      required DateTime endDate,
      required WidgetRef ref,
      required GlobalKey<SfDataGridState> workBookKey}) async {
    await requestPermissions();
    ref.read(isProcessingProvider.notifier).startProcessing();

    Business business = await ProxyService.local.getBusiness();
    // Get the drawer to get the opening balance
    int tinNumber = business.tinNumber!;
    String bhfId = business.bhfId ?? "00";
    Drawers? drawer = await ProxyService.realm
        .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

    // Generate the Excel workbook from the DataGrid
    final excel.Workbook workbook =
        workBookKey.currentState!.exportToExcelWorkbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    // Define a style for the opening and closing balance rows
    final excel.Style balanceStyle = workbook.styles.add('balanceStyle');
    balanceStyle.fontName = 'Arial';
    balanceStyle.bold = true;
    balanceStyle.fontSize = 12;
    balanceStyle.fontColor = '#FFFFFF'; // White font color
    balanceStyle.backColor = '#008000'; // Dark green background color

    // Define a style for the TIN and BHF ID rows
    final excel.Style infoStyle = workbook.styles.add('infoStyle');
    infoStyle.fontName = 'Arial';
    infoStyle.bold = true;
    infoStyle.fontSize = 12;
    infoStyle.fontColor = '#000000'; // Black font color
    infoStyle.backColor = '#FFFF00'; // Yellow background color

    // Add the TIN and BHF ID rows at the top
    sheet.insertRow(1); // For TIN
    sheet.insertRow(2); // For BHF ID
    sheet.insertRow(3); // For Start Date
    sheet.insertRow(4); // For End Date

    // Ensure the style covers all cells in the TIN row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(1, col).cellStyle = infoStyle;
    }
    sheet.getRangeByName('A1').setText('TIN Number');
    sheet.getRangeByName('E1').setNumber(tinNumber.toDouble());

    // Ensure the style covers all cells in the BHF ID row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(2, col).cellStyle = infoStyle;
    }
    sheet.getRangeByName('A2').setText('BHF ID');
    sheet.getRangeByName('E2').setText(bhfId);

    // Ensure the style covers all cells in the Start Date row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(3, col).cellStyle = infoStyle;
    }
    sheet.getRangeByName('A3').setText('Start Date');
    sheet
        .getRangeByName('E3')
        .setText(startDate.toIso8601String()); // Format date as needed

    // Ensure the style covers all cells in the End Date row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(4, col).cellStyle = infoStyle;
    }
    sheet.getRangeByName('A4').setText('End Date');
    sheet
        .getRangeByName('E4')
        .setText(endDate.toIso8601String()); // Format date as needed

    // Add the opening balance row below TIN and BHF ID
    sheet.insertRow(5);

    // Ensure the style covers all cells in the opening balance row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(5, col).cellStyle = balanceStyle;
    }
    sheet.getRangeByName('A5').setText('Opening Balance');
    sheet.getRangeByName('E5').setNumber(drawer?.openingBalance ?? 0);

    // Add the closing balance row at the bottom and apply the style to the entire row
    final int lastRow = sheet.getLastRow() + 1;
    sheet.insertRow(lastRow);

    // Ensure the style covers all cells in the closing balance row, up to column E
    for (int col = 1; col <= 5; col++) {
      sheet.getRangeByIndex(lastRow, col).cellStyle = balanceStyle;
    }
    sheet.getRangeByName('A$lastRow').setText('Closing Balance');
    sheet.getRangeByName('E$lastRow').setFormula('=SUM(C6:C${lastRow - 1})');

    // Save the workbook to a byte array
    final List<int> bytes = workbook.saveAsStream();

    // Save the byte array to a file
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final File file = File('${tempDir.path}/Report.xlsx');
    await file.writeAsBytes(bytes);

    // Dispose the workbook to free up resources
    workbook.dispose();

    ref.read(isProcessingProvider.notifier).stopProcessing();

    // Share the file
    var now = DateTime.now();
    var formattedDate = DateFormat('yyyy-MM-dd').format(now);
    await Share.shareXFiles([XFile(file.path)],
        subject: "Report Download - $formattedDate");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(transactionListProvider);
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];
    bool showPluReport = false;
    final GlobalKey<SfDataGridState> _workBookKey =
        GlobalKey<SfDataGridState>();

    return data.when(
      data: (transactionData) {
        return Container(
          width: 150,
          height: 800,
          child: transactionData.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Center(
                      child: Text("Please select a date to query reports")),
                )
              : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0.0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Toggle Button for PluReport/ZReport
                          Switch(
                            value: showPluReport,
                            onChanged: (value) {
                              ref
                                  .watch(pluReportToggleProvider.notifier)
                                  .toggleReport();
                            },
                          ),
                          Text(ref.read(pluReportToggleProvider)
                              ? 'PLU Report'
                              : 'ZReport'),
                          SizedBox(
                            height: 40.0,
                            width: 150.0,
                            child: BoxButton(
                              onTap: () {
                                exportDataGridToExcel(
                                    endDate: endDate!,
                                    startDate: startDate!,
                                    ref: ref,
                                    workBookKey: _workBookKey);
                              },
                              borderRadius: 1,
                              title: 'Export to Excel',
                              busy: ref.watch(isProcessingProvider),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: DataView(
                        transactions: transactionData,
                        startDate: startDate!,
                        endDate: endDate!,
                        workBookKey: _workBookKey,
                        showPluReport: ref.watch(pluReportToggleProvider),
                      ),
                    ),
                  ],
                ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child:
            const Center(child: Text("Please select a date to query reports")),
      ),
      error: (error, stackTrace) => Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(child: Text('Errors: $error'))
        ],
      ),
    );
  }
}
