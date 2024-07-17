import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'customappbar.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulHookConsumerWidget {
  const Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
  final bool isBigScreen;

  @override
  CashbookState createState() => CashbookState();
}

class CashbookState extends ConsumerState<Cashbook> {
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) async {
        // You can fetch transactions here
        // model.updateTransactionsList(
        //   newTransactions: await ProxyService.realm.completedTransactions(
        //     branchId: ProxyService.box.getBranchId()!,
        //   ),
        // );
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: buildCustomAppBar(model),
          body: buildBody(context, model),
        );
      },
    );
  }

  PreferredSizeWidget buildCustomAppBar(CoreViewModel model) {
    return CustomAppBar(
      isDividerVisible: false,
      title: 'Cash Book',
      icon: Icons.close,
      onPop: () async {
        _routerService.back();
      },
    );
  }

  Widget buildBody(BuildContext context, CoreViewModel model) {
    return Column(
      children: [
        // Filters
        buildDropdowns(model),
        const SizedBox(height: 20),

        // Transaction List or Gauge
        // You can use a StreamBuilder to watch transactionData
        Expanded(
          child: BuildGaugeOrList(
            context: context,
            model: model,
            widgetType: 'list',
            data:
                ref.watch(transactionsStreamProvider), // Use StreamBuilder here
          ),
        ),

        // Transaction Buttons
        buildTransactionButtons(model),

        const SizedBox(height: 31),
      ],
    );
  }

  Widget buildDropdowns(CoreViewModel model) {
    return Row(
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
    );
  }

  Widget buildTransactionButtons(CoreViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTransactionButton(
          label: TransactionType.cashIn,
          color: Colors.green,
          onPressed: () {
            model.newTransactionPressed = true;
            model.newTransactionType = TransactionType.cashIn;
            model.notifyListeners();
          },
        ),
        buildTransactionButton(
          label: TransactionType.cashOut,
          color: const Color(0xFFFF0331),
          onPressed: () {
            model.newTransactionPressed = true;
            model.newTransactionType = TransactionType.cashOut;
            model.notifyListeners();
          },
        ),
      ],
    );
  }

  Widget buildTransactionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        height: 41,
        width: 150,
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: WidgetStateProperty.all<BorderSide>(
              BorderSide(color: color),
            ),
            shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(color),
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return color; // Defer to the widget's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                  label == TransactionType.cashIn
                      ? Icons.add
                      : FluentIcons.subtract_24_regular,
                  color: Colors.white),
              const Spacer(),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNewTransactionContent(BuildContext context, CoreViewModel model) {
    return Column(
      children: [
        buildNewTransactionTypeLabel(model.newTransactionType, model),
        Expanded(
          child: KeyPadView.cashBookMode(
            model: model,
            isBigScreen: widget.isBigScreen,
            accountingMode: true,
            transactionType: model.newTransactionType,
          ),
        ),
      ],
    );
  }

  Widget buildNewTransactionTypeLabel(String transactionType, model) {
    String label = '';
    if (transactionType == TransactionType.cashIn) {
      label = ' Cash In';
    } else if (transactionType == TransactionType.cashOut) {
      label = TransactionType.cashOut;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            model.newTransactionPressed = false;
            model.notifyListeners();
          },
        ),
      ],
    );
  }
}
