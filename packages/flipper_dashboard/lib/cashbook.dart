import 'package:flipper_dashboard/keypad_view.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_dashboard/BuildGaugeOrList.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'customappbar.dart';
import 'widgets/dropdown.dart';

class Cashbook extends StatefulHookConsumerWidget {
  Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
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
        // List<ITransaction> _transactions = await ProxyService.realm
        //     .completedTransactions(branchId: ProxyService.box.getBranchId()!);
        // model.updateTransactionsList(newTransactions: _transactions);
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          buildDropdowns(model),
          buildGaugeOrList(context, model),
          buildTransactionSection(context, model),
          SizedBox(height: 31),
        ],
      ),
    );
  }

  Widget buildDropdowns(CoreViewModel model) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 30, right: 0),
      leading: ReusableDropdown(
        options: model.transactionPeriodOptions,
        selectedOption: model.transactionPeriod,
        onChanged: (String? newPeriod) {
          model.transactionPeriod = newPeriod!;
        },
      ),
      trailing: ReusableDropdown(
        options: model.profitTypeOptions,
        selectedOption: model.profitType,
        onChanged: (String? newProfitType) {
          model.profitType = newProfitType!;
          model.notifyListeners();
        },
      ),
    );
  }

  Widget buildGaugeOrList(BuildContext context, CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: BuildGaugeOrList(
        context: context,
        model: model,
        widgetType: 'gauge',
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
    return Column(
      children: [
        Text(
          model.transactionPeriod,
          style: GoogleFonts.poppins(
            fontSize: 17,
            color: Colors.lightBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: BuildGaugeOrList(
            context: context,
            model: model,
            widgetType: 'list',
          ),
        ),
        buildTransactionButtons(model),
      ],
    );
  }

  Widget buildTransactionButtons(CoreViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildTransactionButton(
          label: 'Cash In',
          color: Colors.green,
          onPressed: () {
            model.newTransactionPressed = true;
            model.newTransactionType = TransactionType.cashIn;
            model.notifyListeners();
          },
        ),
        buildTransactionButton(
          label: 'Cash Out',
          color: Color(0xFFFF0331),
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
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(color: color),
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(color),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return color; // Defer to the widget's default.
              },
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.add, color: Colors.white),
              Spacer(),
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
        KeyPadView.cashBookMode(
          model: model,
          isBigScreen: widget.isBigScreen,
          transactionMode: true,
          transactionType: model.newTransactionType,
        ),
      ],
    );
  }

  Widget buildNewTransactionTypeLabel(String transactionType, model) {
    String label = '';
    if (transactionType == TransactionType.cashIn) {
      label = ' Cash In';
    } else if (transactionType == TransactionType.cashOut) {
      label = ' Cash Out';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            model.newTransactionPressed = false;
            model.notifyListeners();
          },
        ),
      ],
    );
  }
}
