// ignore_for_file: unused_result

import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomSheets {
  static void edit(
      {required BuildContext context,
      required WidgetRef ref,
      required TransactionItem transactionItem,
      required Function doneDelete,
      int? transactionId}) {
    WoltModalSheet.show<void>(
        context: context,
        pageListBuilder: (BuildContext context) {
          return [
            WoltModalSheetPage(
              hasSabGradient: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: transactionItem.qty.toString(),
                    ),
                    Row(children: [
                      Text(transactionItem.price.toString()),
                      Spacer(),
                      Text(0.toRwf())
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    FlipperButton(
                      color: Colors.blue,
                      width: double.infinity,
                      text: 'Done ',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlipperIconButton(
                      icon: Icons.delete,
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      text: 'Remove Product',
                      onPressed: () {
                        ProxyService.realm.deleteItemFromCart(
                            transactionItemId: transactionItem,
                            transactionId: transactionId);

                        Navigator.of(context).pop();
                        doneDelete();
                      },
                    )
                  ],
                ),
              ),
            )
          ];
        });
  }

  static void showBottom(
      {required BuildContext context,
      required WidgetRef ref,
      required Function doneDelete,
      required Function onCharge,
      required List<TransactionItem> items,
      int? transactionId}) {
    double calculateTotal(List<TransactionItem> items) {
      double total = 0;
      for (var item in items) {
        total += item.price;
      }
      return total;
    }

    Widget _buildTransactionItem(
        TransactionItem transactionItem, Function doneDelete) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              transactionItem.name!,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Row(
            children: [
              Text(
                transactionItem.price.toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 8),
              GestureDetector(
                  onTap: () {
                    edit(
                        doneDelete: doneDelete,
                        context: context,
                        ref: ref,
                        transactionItem: transactionItem,
                        transactionId: transactionId);
                  },
                  child: Icon(Icons.edit)),
            ],
          ),
        ],
      );
    }

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              /// I want to improve Ui so I show name on left, and price on right and edit icon next to it
              /// down on all item looped show total down on left
              /// and down clear all icon of bin
              /// and down show Charge button
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SearchInputWithDropdown(),
                  // Display the transaction items (if available)

                  ...items
                      .map((transactionItem) =>
                          _buildTransactionItem(transactionItem, doneDelete))
                      .toList(),
                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  // Display "Charge" button and "Clear All" icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlipperButtonFlat(
                        textColor: Colors.red,
                        onPressed: () {
                          // Handle "Charge" button press here
                          print('Charge button pressed!');
                        },
                        text: 'clear All',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          for (TransactionItem item in items) {
                            ProxyService.realm.deleteItemFromCart(
                                transactionItemId: item,
                                transactionId: transactionId);
                          }
                          doneDelete();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  FlipperButton(
                    color: Colors.blue,
                    width: double.infinity,
                    text: 'Charge ' + calculateTotal(items).toRwf(),
                    onPressed: () {
                      onCharge(transactionId, calculateTotal(items));
                    },
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}
