import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulHookConsumerWidget {
  Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
  final bool isBigScreen;

  @override
  CashbookState createState() => CashbookState();
}

class CashbookState extends ConsumerState<Cashbook> with DateCoreWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {},
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildCustomAppBar(model),
          body: buildBody(context, model),
        );
      },
    );
  }

  PreferredSizeWidget buildCustomAppBar(CoreViewModel model) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [datePicker()],
      title: Text('Cash Book'),
    );
  }

  Widget buildBody(BuildContext context, CoreViewModel model) {
    return Column(
      children: [
        buildTransactionSection(context, model),
        const SizedBox(height: 31), // Use const for static widgets
      ],
    );
  }

  Widget buildDropdowns(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReusableDropdown(
            options: model.transactionPeriodOptions,
            selectedOption: model.transactionPeriod,
            onChanged: (String? newPeriod) {
              model.transactionPeriod = newPeriod!;
            },
          ),
          ReusableDropdown(
            options: model.profitTypeOptions,
            selectedOption: model.profitType,
            onChanged: (String? newProfitType) {
              model.profitType = newProfitType!;
              model.notifyListeners();
            },
          ),
        ],
      ),
    );
  }

  Widget buildTransactionSection(BuildContext context, CoreViewModel model) {
    return Expanded(
      child: model.newTransactionPressed
          ? buildNewTransactionContent(context, model)
          : buildTransactionListContent(model),
    );
  }

  Widget buildTransactionListContent(CoreViewModel model) {
    final transactionData = ref.watch(transactionsStreamProvider);
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    return Column(
      children: [
        const SizedBox(height: 5), // Use const for static widgets
        Expanded(
          child: BuildGaugeOrList(
            startDate: startDate,
            endDate: endDate,
            context: context,
            model: model,
            widgetType: 'list',
            data: transactionData,
          ),
        ),
        buildTransactionButtons(model),
      ],
    );
  }

  Widget buildTransactionButtons(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FlipperButton(
                text: TransactionType.cashIn,
                color: Colors.green,
                onPressed: () {
                  model.newTransactionPressed = true;
                  model.newTransactionType = TransactionType.cashIn;
                  model.notifyListeners();
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FlipperButton(
                text: TransactionType.cashOut,
                color: const Color(0xFFFF0331),
                onPressed: () {
                  model.newTransactionPressed = true;
                  model.newTransactionType = TransactionType.cashOut;
                  model.notifyListeners();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNewTransactionContent(BuildContext context, CoreViewModel model) {
    return Column(
      children: [
        Expanded(
          child: KeyPadView.cashBookMode(
            onConfirm: () {
              // Handle the pop action here
              Navigator.of(context).pop();
              model.newTransactionPressed = false;
              model.notifyListeners();
            },
            model: model,
            isBigScreen: widget.isBigScreen,
            accountingMode: true,
            transactionType: model.newTransactionType,
          ),
        ),
      ],
    );
  }
}
