import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flipper_models/helperModels/extensions.dart';

class BottomSheets {
  static void edit(
      {required BuildContext context,
      required WidgetRef ref,
      required TransactionItem transactionItem}) {
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
                      ])
                    ],
                  ),
                ))
          ];
        });
  }

  static void showBottom(
      {required BuildContext context, required WidgetRef ref}) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    final transactionItemsAsyncValue =
        ref.watch(transactionItemsProvider((isExpense: isOrdering)));
    double calculateTotal(List<TransactionItem> items) {
      double total = 0;
      for (var item in items) {
        total += item.price;
      }
      return total;
    }

    Widget _buildTransactionItem(TransactionItem transactionItem) {
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
                        context: context,
                        ref: ref,
                        transactionItem: transactionItem);
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
                  if (transactionItemsAsyncValue.hasValue)
                    ...transactionItemsAsyncValue.value!
                        .map((transactionItem) =>
                            _buildTransactionItem(transactionItem))
                        .toList(),
                  SizedBox(height: 16),

                  // Calculate and display the total price
                  if (transactionItemsAsyncValue.hasValue)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${calculateTotal(transactionItemsAsyncValue.value!)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle "Clear All" button press here
                          // This might involve clearing the transactionItemsAsyncValue
                          print('Clear All button pressed!');
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  FlipperButton(
                    color: Colors.blue,
                    width: double.infinity,
                    text: 'Charge ' +
                        calculateTotal(transactionItemsAsyncValue.value!)
                            .toRwf(),
                    onPressed: () => Navigator.of(context).pop(),
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
