import 'dart:developer';

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/DynamicDataSource.dart';
import 'package:flipper_dashboard/HeaderTransactionItem.dart';
import 'package:flipper_dashboard/Refund.dart';
import 'package:flipper_dashboard/RowsPerPageInput.dart';
import 'package:flipper_dashboard/TransactionDataSource.dart';
import 'package:flipper_dashboard/TransactionItemDataSource.dart';
import 'package:flipper_dashboard/exportExcel.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_socials/ui/views/home/home_viewmodel.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:talker_flutter/talker_flutter.dart';

class DataView extends StatefulHookConsumerWidget {
  const DataView({
    super.key,
    this.transactions,
    required this.startDate,
    required this.endDate,
    required this.showPluReport,
    required this.rowsPerPage,
    this.transactionItems,
  });

  final List<ITransaction>? transactions;
  final DateTime startDate;
  final DateTime endDate;
  final bool showPluReport;
  final int rowsPerPage;
  final List<TransactionItem>? transactionItems;

  @override
  DataViewState createState() => DataViewState();
}

class DataViewState extends ConsumerState<DataView>
    with BaseCoreWidgetMixin, DateCoreWidget, Headers {
  static const double dataPagerHeight = 60;
  DataGridSource? _dataGridSource;
  int pageIndex = 0;

  final rowsPerPageController = TextEditingController(text: 1000.toString());

  @override
  void initState() {
    super.initState();
    _dataGridSource = _buildDataGridSource(widget.showPluReport,
        widget.transactionItems, widget.transactions, widget.rowsPerPage);
  }

  @override
  void didUpdateWidget(covariant DataView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transactionItems != oldWidget.transactionItems ||
        widget.transactions != oldWidget.transactions ||
        widget.rowsPerPage != oldWidget.rowsPerPage) {
      _dataGridSource = _buildDataGridSource(widget.showPluReport,
          widget.transactionItems, widget.transactions, widget.rowsPerPage);
    }
  }

  @override
  void dispose() {
    rowsPerPageController.dispose();
    super.dispose();
  }

  final talker = TalkerFlutter.init();

  void handleCellTap(DataGridCellTapDetails details) {
    final rowIndex = details.rowColumnIndex.rowIndex;
    if (rowIndex < 1) return;

    final dataSource = _dataGridSource as DynamicDataSource;
    final data = dataSource.data[pageIndex * widget.rowsPerPage + rowIndex - 1];

    talker.warning('Tapped row: ID = ${data.id}, Name = ${data.subTotal}');
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: Refund(
          refundAmount: data.subTotal,
          transactionId: data.id.toString(),
          currency: "RWF",
          transaction: data is ITransaction ? data : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const EdgeInsets headerPadding =
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

    // talker.info("Given data size: ${widget.transactionItems?.length}");

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {},
      builder: (context, model, child) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraint) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            widget.showPluReport
                                ? // Toggle Button for PluReport/ZReport
                                Switch(
                                    value: ref.watch(showAiReport),
                                    onChanged: (value) {
                                      ref
                                          .read(showAiReport.notifier)
                                          .toggleReport();
                                      if (ref.read(showAiReport)) {
                                        ref
                                            .read(rowsPerPageProvider.notifier)
                                            .state = 1000;
                                      }
                                    })
                                : const SizedBox.shrink(),
                            widget.showPluReport
                                ? Text(ref.read(showAiReport)
                                    ? 'PLU Report'
                                    : 'ZReport')
                                : SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: RowsPerPageInput(
                                  rowsPerPageProvider: rowsPerPageProvider),
                            ),
                            widget.showPluReport
                                ? datePicker()
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                        width: 150.0,
                        child: BoxButton(
                          onTap: () async {
                            if (workBookKey.currentState == null) {
                              toast("Error: Workbook is null");
                            } else {
                              ///
                              final expenses = ProxyService.realm.transactions(
                                  startDate: widget.startDate,
                                  endDate: widget.endDate,
                                  isExpense: true,
                                  branchId: ProxyService.box.getBranchId());
                              talker.info("Exporting data to Excel");
                              exportDataGridToExcel(
                                  endDate: widget.endDate,
                                  startDate: widget.startDate,
                                  grossProfit: widget.transactionItems!.fold<double>(
                                      0.0,
                                      (sum, item) =>
                                          sum +
                                          (((item.qty * item.price) -
                                                  (item.qty * item.splyAmt)) -
                                              (((item.qty * item.price) - (item.qty * item.splyAmt)) *
                                                  18 /
                                                  118))),
                                  netProfit: (
                                      // Gross profit calculation
                                      widget.transactionItems!.fold<double>(
                                              0.0,
                                              (sum, item) =>
                                                  sum +
                                                  ((item.qty * item.price) -
                                                      (item.qty *
                                                          item.splyAmt)))
                                          // Subtract tax amount
                                          -
                                          widget.transactionItems!.fold<double>(
                                              0.0,
                                              (sum, item) =>
                                                  sum +
                                                  (((item.qty * item.price) -
                                                          (item.qty *
                                                              item.splyAmt)) *
                                                      18 /
                                                      118))),
                                  expenses: expenses);
                            }
                          },
                          borderRadius: 1,
                          title: 'Export to Excel',
                          busy: ref.watch(isProcessingProvider),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerHoverColor: Colors.yellow,
                        gridLineColor: Colors.amber,
                        gridLineStrokeWidth: 1.0,
                        rowHoverColor: Colors.yellow,
                        selectionColor: Colors.yellow,
                        rowHoverTextStyle: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                      child: SizedBox(
                        height: constraint.maxHeight - dataPagerHeight,
                        width: constraint.maxWidth,
                        child: SfDataGrid(
                          rowsPerPage: widget.rowsPerPage,
                          allowFiltering: true,
                          highlightRowOnHover: true,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          key: workBookKey,
                          source: _dataGridSource!,
                          columnWidthMode: ColumnWidthMode.fill,
                          onCellTap: handleCellTap,
                          columns: widget.showPluReport
                              ? pluReportTableHeader(headerPadding)
                              : zReportTableHeader(headerPadding),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: dataPagerHeight,
                    child: SfDataPager(
                      lastPageItemVisible: false,
                      nextPageItemVisible: false,
                      delegate: _dataGridSource!,
                      pageCount:
                          (_dataGridSource!.rows.length / widget.rowsPerPage)
                              .ceilToDouble(),
                      direction: Axis.horizontal,
                      onPageNavigationEnd: (index) {
                        log("Page Index ${index}");
                        setState(() {
                          pageIndex = index;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  DataGridSource _buildDataGridSource(
      bool showPluReport,
      List<TransactionItem>? transactionItems,
      List<ITransaction>? transactions,
      int rowsPerPage) {
    if (showPluReport) {
      return TransactionItemDataSource(
          transactionItems!, rowsPerPage, showPluReport);
    } else {
      return TransactionDataSource(transactions!, rowsPerPage, showPluReport);
    }
  }
}
