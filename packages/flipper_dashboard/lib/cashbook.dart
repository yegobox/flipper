import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_dashboard/CashBookCashOutPressed.dart';
import 'package:flipper_dashboard/CashBookCashInPressed.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';
import 'customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulHookConsumerWidget {
  Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
  final bool isBigScreen;
  @override
  CashbookState createState() => CashbookState();
}

class CashbookState extends ConsumerState<Cashbook> {
  List<String> transactionPeriodOptions = [
    "Today",
    "This Week",
    "This Month",
    "This Year",
  ];

  List<String> profitTypeOptions = ["Net Profit", "Gross Profit"];

  List<double> cashInAndOut = [1, 1];
  List<int> transactionIds = [];

  final _routerService = locator<RouterService>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () =>
          CoreViewModel(transaction: currentTransaction.value!),
      onViewModelReady: (model) async {
        List<ITransaction> _transactions = await ProxyService.isar
            .completedTransactions(branchId: ProxyService.box.getBranchId()!);
        model.updateTransactionsList(newTransactions: _transactions);
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(
            isDividerVisible: false,
            title: 'Cash Book',
            icon: Icons.close,
            onPop: () async {
              _routerService.back();
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 30, right: 0),
                  leading: ReusableDropdown(
                    options: transactionPeriodOptions,
                    selectedOption: model.transactionPeriod,
                    onChanged: (String? newPeriod) {
                      model.transactionPeriod = newPeriod!;
                    },
                  ),
                  trailing: ReusableDropdown(
                    options: profitTypeOptions,
                    selectedOption: model.profitType,
                    onChanged: (String? newProfitType) {
                      model.profitType = newProfitType!;
                      model.notifyListeners();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: BuildGaugeOrList(
                    context: context,
                    model: model,
                    widgetType: 'gauge',
                  ),
                ),
                Expanded(
                  child: model.newTransactionPressed == false
                      ? CashBookCashInPressed(
                          model: model,
                        )
                      : CashBookCashOutPressed(
                          isBigScreen: widget.isBigScreen,
                          model: model,
                        ),
                ),
                SizedBox(height: 31),
              ],
            ),
          ),
        );
      },
    );
  }
}
