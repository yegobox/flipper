import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'customappbar.dart';
import 'widgets/transaction_status_widget.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulHookConsumerWidget {
  const TransactionDetail({Key? key, required this.transaction})
      : super(key: key);
  final ITransaction transaction;

  @override
  TransactionDetailState createState() => TransactionDetailState();
}

class TransactionDetailState extends ConsumerState<TransactionDetail> {
  bool transactionItemListIsExpanded = false;
  bool transactionStatusWidgetIsExpanded = false;
  bool moreActionsIsPressed = false;

  Widget _list(
      {required List<TransactionItem> items, required CoreViewModel model}) {
    double total = items.fold(0, (sum, item) => sum + (item.price * item.qty));
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: Text('Products (${items.length})',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            trailing: Icon(transactionItemListIsExpanded
                ? Icons.expand_less
                : Icons.expand_more),
            onTap: () => setState(() =>
                transactionItemListIsExpanded = !transactionItemListIsExpanded),
          ),
          if (transactionItemListIsExpanded)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length + 1,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return ListTile(
                    title: Text("Total",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    trailing: Text(total.toRwf(),
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  );
                }
                final item = items[index];
                return ListTile(
                  title: Text("${item.qty.toInt()} x ${item.name}",
                      style: GoogleFonts.poppins()),
                  trailing: Text((item.qty * item.price).toRwf(),
                      style: GoogleFonts.poppins()),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget transactionStatusHeader() {
    String status = widget.transaction.status!.capitalize();
    Color statusColor = _getStatusColor(status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
                const SizedBox(width: 8),
                Text(status,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat('#,###').format(widget.transaction.subTotal) +
                  " RWF",
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusWidget() {
    List<TransactionStatus> statuses = _getTransactionStatuses();
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: Text('Transaction Details',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            trailing: Icon(transactionStatusWidgetIsExpanded
                ? Icons.expand_less
                : Icons.expand_more),
            onTap: () => setState(() => transactionStatusWidgetIsExpanded =
                !transactionStatusWidgetIsExpanded),
          ),
          if (transactionStatusWidgetIsExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TransactionStatusWidget(statuses: statuses),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {
        List<TransactionItem> items = await ProxyService.realm.transactionItems(
          transactionId: widget.transaction.id!,
          doneWithTransaction: true,
          active: true,
        );
        model.completedTransactionItemsList = items;
      },
      builder: (context, model, child) {
        String transactionType =
            widget.transaction.transactionType == 'Cash Out'
                ? 'Expense'
                : 'Income';
        return Scaffold(
          appBar: CustomAppBar(
            isDividerVisible: false,
            title:
                '$transactionType: ${NumberFormat('#,###').format(widget.transaction.subTotal)} RWF',
            icon: Icons.close,
            onPop: () async => locator<RouterService>().back(),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                transactionStatusHeader(),
                _list(items: model.completedTransactionItemsList, model: model),
                _statusWidget(),
                const SizedBox(height: 16),
                _buildActionButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: !moreActionsIsPressed
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.more_horiz),
                    label: const Text('More Actions'),
                    onPressed: () =>
                        setState(() => moreActionsIsPressed = true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.receipt),
                    label: const Text('Invoice'),
                    onPressed: () => locator<RouterService>().navigateTo(
                        PaymentConfirmationRoute(
                            transaction: widget.transaction)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF66AAFF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                _buildActionTile(Icons.edit_note, "Edit Note", onTap: () {}),
                _buildActionTile(Icons.check_circle, "Approve Transaction",
                    color: Colors.greenAccent, onTap: () {}),
                _buildActionTile(Icons.cancel_outlined, "Cancel",
                    color: Colors.red,
                    onTap: () => setState(() => moreActionsIsPressed = false)),
              ],
            ),
    );
  }

  Widget _buildActionTile(IconData icon, String text,
      {Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: onTap,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "parked":
        return Colors.blue;
      default:
        return Colors.lightGreen;
    }
  }

  List<TransactionStatus> _getTransactionStatuses() {
    List<TransactionStatus> statuses = [];
    statuses.add(TransactionStatus(
        status: PENDING,
        dateTime: DateTime.parse(widget.transaction.createdAt!)));

    String currentStatus = widget.transaction.status!;
    if (currentStatus != PENDING) {
      statuses.add(TransactionStatus(
        status:
            "${currentStatus.toUpperCase()}: ${widget.transaction.paymentType!.toUpperCase()}",
        dateTime: DateTime.parse(widget.transaction.updatedAt!),
      ));
    }
    return statuses;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
