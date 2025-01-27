import 'package:flipper_dashboard/DataRow.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class PurchaseSaleWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final void Function() acceptPurchases;
  final void Function(Variant? selectedItem) selectSale;
  final List<Variant> finalSalesList;

  PurchaseSaleWidget({
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptPurchases,
    required this.selectSale,
    required this.finalSalesList,
  });

  @override
  _PurchaseSaleWidgetState createState() => _PurchaseSaleWidgetState();
}

class _PurchaseSaleWidgetState extends State<PurchaseSaleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlipperButton(
                    onPressed: widget.acceptPurchases,
                    text: 'Accept All Purchases',
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  DataRowWidget(
                    nameController: widget.nameController,
                    supplyPriceController: widget.supplyPriceController,
                    retailPriceController: widget.retailPriceController,
                    saveItemName: widget.saveItemName,
                    acceptPurchases: widget.acceptPurchases,
                    selectSale: (variant) => widget.selectSale(variant),
                    finalSalesList: widget.finalSalesList,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
