import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flutter/material.dart';

class ImportSalesWidget extends StatefulWidget {
  final Future<RwApiResponse>? futureResponse;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController supplyPriceController;
  final TextEditingController retailPriceController;
  final void Function() saveItemName;
  final void Function() acceptAllImport;
  final void Function(Item? selectedItem) selectItem;
  final Item? selectedItem;
  final List<Item> finalItemList;

  ImportSalesWidget({
    required this.futureResponse,
    required this.formKey,
    required this.nameController,
    required this.supplyPriceController,
    required this.retailPriceController,
    required this.saveItemName,
    required this.acceptAllImport,
    required this.selectItem,
    required this.selectedItem,
    required this.finalItemList,
  });

  @override
  _ImportSalesWidgetState createState() => _ImportSalesWidgetState();
}

class _ImportSalesWidgetState extends State<ImportSalesWidget> {
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
            final itemList = snapshot.data!.data!.itemList ?? [];
            widget.finalItemList.clear();
            widget.finalItemList.addAll(itemList);

            return Form(
              key: widget.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: widget.nameController,
                            decoration: InputDecoration(
                              hintText: 'Enter a name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: widget.supplyPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Supply price is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter supply price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: widget.retailPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Retail price is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter retail Price',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: widget.saveItemName,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text(
                              'Save Name',
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
                        SizedBox(
                          width: 4,
                        ),
                        ElevatedButton(
                          onPressed: widget.acceptAllImport,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Text(
                              'Accept All import',
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
                                'Item Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'HS Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                          rows: itemList
                              .map(
                                (item) => DataRow(
                                  selected: item == widget.selectedItem,
                                  onSelectChanged: (bool? selected) {
                                    widget.selectItem(
                                        selected == true ? item : null);
                                  },
                                  cells: [
                                    DataCell(
                                      Text(
                                        item.itemNm,
                                        style:
                                            const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        item.hsCd,
                                        style:
                                            const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        '${item.qty} ${item.qtyUnitCd}',
                                        style:
                                            const TextStyle(fontSize: 14.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
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

