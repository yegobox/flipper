// ignore_for_file: unused_result

import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension StringExtensions on String {
  /// Extracts the part of the string before the first '(' and the number after the first '(' and before the first ')'.
  ///
  /// For example:
  ///   'Product Name (123)' -> 'Product Name, 123'
  ///   'Product Name' -> 'Product Name, '
  ///
  /// Returns a string with the name and number separated by a comma and a space.
  String extractNameAndNumber() {
    String name = split('(')[0];
    String number = '';

    if (contains('(')) {
      number = split('(')[1].split(')')[0];
    }

    return '$name $number'; // Concatenate name and number with a comma and space
  }
}

class QuickSellingView extends StatefulHookConsumerWidget {
  @override
  _QuickSellingViewState createState() => _QuickSellingViewState();
}

class _QuickSellingViewState extends ConsumerState<QuickSellingView> {
  final TextEditingController discountController = TextEditingController();
  final TextEditingController shippingController = TextEditingController();
  List<TransactionItem> transactionItems = [];

  double get grandTotal {
    return transactionItems.fold(
        0.0, (sum, product) => sum + (product.price * product.qty));
  }

  double get totalAfterDiscountAndShipping {
    double discount = double.tryParse(discountController.text) ?? 0.0;
    double shipping = double.tryParse(shippingController.text) ?? 0.0;
    return grandTotal - discount + shipping;
  }

  @override
  Widget build(BuildContext context) {
    final transaction =
        ref.watch(pendingTransactionProvider(TransactionType.sale));
    final transactionItemsNotifier = ref.watch(
        transactionItemsProvider(transaction.value?.value?.id!).notifier);
    transactionItemsNotifier.updatePendingTransaction();

    transactionItems = (ref
            .watch(
              transactionItemsProvider(transaction.value?.value?.id),
            )
            .value ??
        []);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Product',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                if (transactionItems.isEmpty)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No data available',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(''),
                      ),
                    ],
                  )
                else
                  for (var item in transactionItems)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                item.name?.extractNameAndNumber() != null &&
                                        item.name!
                                                .extractNameAndNumber()
                                                .length >=
                                            5
                                    ? item.name!
                                        .extractNameAndNumber()
                                        .substring(0, 5)
                                    : item.name?.extractNameAndNumber() ?? "",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.price.toStringAsFixed(0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.red,
                                child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  onPressed: () {
                                    ProxyService.realm.realm!.write(() {
                                      if (item.qty > 0) item.qty--;
                                    });
                                    ref.refresh(transactionItemsProvider(
                                        transaction.value?.value?.id));
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1.0),
                                child: Text(item.qty.toString()),
                              ),
                              Container(
                                color: Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    ProxyService.realm.realm!.write(() {
                                      if (item.qty > 0) item.qty++;
                                    });
                                    ref.refresh(transactionItemsProvider(
                                        transaction.value?.value?.id));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Text((item.price * item.qty).toStringAsFixed(0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // transactionItems.remove(item);
                              ProxyService.realm.realm!.write(() {
                                ProxyService.realm.realm!.delete(item);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Grand Total: \RWF${grandTotal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: discountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Discount',
                      suffixIcon: Icon(Icons.discount),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => null,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: shippingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Shipping',
                      suffixIcon: Icon(Icons.local_shipping),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \RWF${totalAfterDiscountAndShipping.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
