import 'package:flipper_dashboard/DataRow.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flutter/material.dart';

class PurchaseSaleWidget extends StatefulWidget {
  final Future<RwApiResponse>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final void Function() acceptPurchases;
  final void Function(ItemList? selectedItem, SaleList saleList) selectSale;
  final List<ItemList> finalSalesList;

  PurchaseSaleWidget(
      {required this.futureResponse,
      required this.formKey,
      required this.nameController,
      required this.supplyPriceController,
      required this.retailPriceController,
      required this.saveItemName,
      required this.acceptPurchases,
      required this.selectSale,
      required this.finalSalesList});

  @override
  _PurchaseSaleWidgetState createState() => _PurchaseSaleWidgetState();
}

class _PurchaseSaleWidgetState extends State<PurchaseSaleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: FutureBuilder<RwApiResponse>(
        future: widget.futureResponse,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return const Center(child: Text('No Data Found'));
          } else {
            final salesList = snapshot.data!.data!.saleList ?? [];
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
                        ElevatedButton(
                          onPressed: widget.acceptPurchases,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text(
                              'Accept All Purchases',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
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
                          salesList: salesList,
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
