import 'package:flipper_dashboard/DataRow.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/all_models.dart';

class PurchaseSaleWidget extends StatefulWidget {
  final Future<List<Purchase>>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final void Function() acceptPurchases;
  final void Function(Variant? selectedItem, Purchase saleList) selectSale;
  final List<Variant> finalSalesList;
  PurchaseSaleWidget({
    required this.futureResponse,
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
      child: FutureBuilder<List<Purchase>>(
        future: widget.futureResponse,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No Data Found'));
          } else {
            final salesList = snapshot.data;
            widget.finalSalesList.clear(); // Clear the list before populating
            return Form(
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
                          selectSale: widget.selectSale,
                          finalSalesList: widget.finalSalesList,
                          salesList: salesList!,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
