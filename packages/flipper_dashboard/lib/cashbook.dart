import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_models/db_model_export.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulHookConsumerWidget {
  const Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
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
      builder: (context, model, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(model),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [datePicker()],
      title: const Text('Cash Book'),
    );
  }

  Widget _buildBody(CoreViewModel model) {
    return Column(
      children: [
        Expanded(
          child: _buildMainContent(model),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMainContent(CoreViewModel model) {
    return model.newTransactionPressed
        ? _buildTransactionEntry(model)
        : _buildTransactionList(model);
  }

  Widget _buildTransactionList(CoreViewModel model) {
    final transactionData = ref.watch(dashboardTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return Column(
      children: [
        const SizedBox(height: 5),
        Expanded(
          child: BuildGaugeOrList(
            startDate: dateRange.startDate,
            endDate: dateRange.endDate,
            context: context,
            model: model,
            widgetType: 'list',
            data: transactionData,
          ),
        ),
        _buildActionButtons(model),
      ],
    );
  }

  Widget _buildActionButtons(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildTransactionButton(
            text: TransactionType.cashIn,
            color: Colors.green,
            onPressed: () =>
                _startNewTransaction(model, TransactionType.cashIn),
          ),
          _buildTransactionButton(
            text: TransactionType.cashOut,
            color: const Color(0xFFFF0331),
            onPressed: () =>
                _startNewTransaction(model, TransactionType.cashOut),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FlipperButton(
          text: text,
          color: color,
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _startNewTransaction(CoreViewModel model, String transactionType) {
    model.newTransactionPressed = true;
    model.newTransactionType = transactionType;
    model.notifyListeners();
  }

  Widget _buildTransactionEntry(CoreViewModel model) {
    return KeyPadView.cashBookMode(
      onConfirm: () => _finishTransaction(model),
      model: model,
      isBigScreen: widget.isBigScreen,
      accountingMode: true,
      transactionType: model.newTransactionType,
    );
  }

  void _finishTransaction(CoreViewModel model) {
    Navigator.of(context).pop();
    model.newTransactionPressed = false;
    model.notifyListeners();
  }
}
