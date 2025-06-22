import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ReportActionsRow extends ConsumerWidget {
  const ReportActionsRow({
    super.key,
    required this.showDetailed,
    required this.isExporting,
    this.isXReportLoading = false,
    this.isZReportLoading = false,
    this.isSaleReportLoading = false,
    this.isPLUReportLoading = false,
    required this.onExportPressed,
    required this.workBookKey,
    required this.onPrintPressed,
    required this.onToggleReport,
    required this.onXReportPressed,
    required this.onZReportPressed,
    required this.onSaleReportPressed,
    required this.onPluReportPressed,
  });

  final bool showDetailed;
  final bool isExporting;
  final bool isXReportLoading;
  final bool isZReportLoading;
  final bool isSaleReportLoading;
  final bool isPLUReportLoading;
  final VoidCallback onExportPressed;
  final GlobalKey<SfDataGridState> workBookKey;
  final VoidCallback onPrintPressed;
  final Future<void> Function() onToggleReport;
  final Future<void> Function() onXReportPressed;
  final Future<void> Function() onZReportPressed;
  final Future<void> Function() onSaleReportPressed;
  final Future<void> Function() onPluReportPressed;

  Widget _buildReportTypeSwitch(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: showDetailed
                ? () async {
                    await onToggleReport();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: !showDetailed ? Colors.blue : Colors.transparent,
              foregroundColor: !showDetailed ? Colors.white : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Summarized'),
          ),
          TextButton(
            onPressed: !showDetailed
                ? () async {
                    await onToggleReport();
                  }
                : null,
            style: TextButton.styleFrom(
              backgroundColor: showDetailed ? Colors.blue : Colors.transparent,
              foregroundColor: showDetailed ? Colors.white : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text('Detailed'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _buildReportTypeSwitch(ref),
        const Spacer(),
        Tooltip(
          message: 'Export as CSV',
          child: SizedBox(
            width: 40,
            height: 40,
            child: isExporting
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.download_rounded),
                    onPressed: onExportPressed,
                  ),
          ),
        ),
        Tooltip(
          message: 'X Report',
          child: SizedBox(
            width: 40,
            height: 40,
            child: isXReportLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.receipt_long_outlined),
                    onPressed: onXReportPressed,
                  ),
          ),
        ),
        Tooltip(
          message: 'Z Report',
          child: SizedBox(
            width: 40,
            height: 40,
            child: isZReportLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.assessment),
                    onPressed: onZReportPressed,
                  ),
          ),
        ),
        Tooltip(
          message: 'Sale Report',
          child: SizedBox(
            width: 40,
            height: 40,
            child: isSaleReportLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.analytics_outlined),
                    onPressed: onSaleReportPressed,
                  ),
          ),
        ),
        Tooltip(
          message: 'PLU Report',
          child: SizedBox(
            width: 40,
            height: 40,
            child: isPLUReportLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.list_alt_rounded),
                    onPressed: onPluReportPressed,
                  ),
          ),
        ),
      ],
    );
  }
}
