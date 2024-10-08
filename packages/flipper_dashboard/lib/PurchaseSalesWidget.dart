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
  final List<SaleList> finalSaleList;

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
    required this.finalSaleList,
  });

  @override
  _PurchaseSaleWidgetState createState() => _PurchaseSaleWidgetState();
}

class _PurchaseSaleWidgetState extends State<PurchaseSaleWidget> {
  ItemList? selectedItemList;

  @override
  void initState() {
    selectedItemList = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: FutureBuilder<RwApiResponse>(
        future: widget.futureResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
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
                        DataTable(
                          border: TableBorder.all(color: Colors.black),
                          columnSpacing: 24.0,
                          headingRowHeight: 48.0,
                          dataRowMinHeight: 48.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Supplier Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Supplier Tin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Taxable amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                          rows: List.generate(
                            salesList.length,
                            (index) {
                              final item = salesList[index];
                              return DataRow(
                                onLongPress: () {
                                  showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) => OptionModal(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 16, 16, 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    controller:
                                                        widget.nameController,
                                                    decoration: InputDecoration(
                                                      hintText: 'Enter a name',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade200,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 12.0),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: widget
                                                        .supplyPriceController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Supply price is required';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter supply price',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade200,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 12.0),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    controller: widget
                                                        .retailPriceController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Retail price is required';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter retail Price',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey.shade200,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 16.0,
                                                              vertical: 12.0),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16.0),
                                                ElevatedButton(
                                                  onPressed:
                                                      widget.saveItemName,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.0,
                                                            vertical: 12.0),
                                                    child: Text(
                                                      'Confirm Edit(s)',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(16),
                                            child: DataTable(
                                              border: TableBorder.all(
                                                  color: Colors.black),
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'Item name',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Qty',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Price',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Total tax',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              rows: salesList[index]
                                                  .itemList!
                                                  .map(
                                                (item) {
                                                  // Add item to finalSalesList
                                                  widget.finalSalesList
                                                      .add(item);
                                                  return DataRow(
                                                    selected:
                                                        selectedItemList ==
                                                            item,
                                                    onSelectChanged:
                                                        (bool? selected) {
                                                      if (selected == true) {
                                                        setState(() {
                                                          selectedItemList =
                                                              item;
                                                        });

                                                        /// pass down the selected item
                                                        widget.selectSale(
                                                            selected == true
                                                                ? item
                                                                : null,
                                                            salesList[index]);
                                                      } else {
                                                        setState(() {
                                                          selectedItemList =
                                                              null;
                                                        });
                                                      }
                                                    },
                                                    cells: [
                                                      DataCell(
                                                          Text(item.itemNm)),
                                                      DataCell(Text(
                                                          item.qty.toString())),
                                                      DataCell(Text(
                                                          item.prc.toString())),
                                                      DataCell(
                                                        Text(
                                                          item.totAmt
                                                              .toString(),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                cells: [
                                  DataCell(
                                    Text(
                                      item.spplrNm,
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.spplrTin,
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      '${item.totTaxAmt}',
                                      style: const TextStyle(fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
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
