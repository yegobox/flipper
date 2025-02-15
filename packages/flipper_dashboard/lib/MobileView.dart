import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/search_field.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MobileView extends StatefulHookConsumerWidget {
  const MobileView({
    required this.widget,
    required this.tabController,
    required this.textEditController,
    required this.model,
    Key? key,
  }) : super(key: key);
  final CoreViewModel model;
  final CheckOut widget;
  final TabController tabController;
  final TextEditingController textEditController;

  @override
  _MobileViewState createState() => _MobileViewState();
}

class _MobileViewState extends ConsumerState<MobileView> {
  final TextEditingController textEditController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController receivedAmountController =
      TextEditingController();
  final TextEditingController customerPhoneNumberController =
      TextEditingController();
  final TextEditingController paymentTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchField(
                  controller: searchController,
                  showAddButton: true,
                  showDatePicker: false,
                  showIncomingButton: true,
                  showOrderButton: true,
                ),
              ),
              ProductView.normalMode(),
            ],
          ),
        ),
      ),
    );
  }
}
