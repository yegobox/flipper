import 'package:flipper_accounting/shift_history_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:flipper_services/proxy.dart';

class ShiftHistoryView extends StackedView<ShiftHistoryViewModel> {
  const ShiftHistoryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ShiftHistoryViewModel viewModel,
    Widget? child,
  ) {
    final currencySymbol = ProxyService.box.defaultCurrency();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift History'),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.data == null || viewModel.data!.isEmpty
              ? const Center(child: Text('No shifts found.'))
              : ListView.builder(
                  itemCount: viewModel.data!.length,
                  itemBuilder: (context, index) {
                    final shift = viewModel.data![index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User ID: ${shift.userId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(shift.startAt.toLocal())}'),
                            Text(
                                'End: ${shift.endAt != null ? DateFormat('yyyy-MM-dd HH:mm').format(shift.endAt!.toLocal()) : 'N/A'}'),
                            Text(
                                'Opening Balance: ${currencySymbol} ${shift.openingBalance.toStringAsFixed(2)}'),
                            Text(
                                'Cash Sales: ${currencySymbol} ${(shift.cashSales ?? 0.0).toStringAsFixed(2)}'),
                            Text(
                                'Expected Cash: ${currencySymbol} ${(shift.expectedCash ?? 0.0).toStringAsFixed(2)}'),
                            Text(
                                'Closing Balance: ${currencySymbol} ${(shift.closingBalance ?? 0.0).toStringAsFixed(2)}'),
                            Text(
                                'Cash Difference: ${currencySymbol} ${(shift.cashDifference ?? 0.0).toStringAsFixed(2)}'),
                            Text('Status: ${shift.status.name}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  ShiftHistoryViewModel viewModelBuilder(BuildContext context) =>
      ShiftHistoryViewModel(businessId: ProxyService.box.getBusinessId()!);
}