import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/apps.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

import 'receipt_ui.dart';

class AppLayoutDrawer extends StatefulHookConsumerWidget {
  const AppLayoutDrawer(
      {Key? key,
      required this.controller,
      required this.tabSelected,
      required this.focusNode})
      : super(key: key);

  final TextEditingController controller;
  final int tabSelected;
  final FocusNode focusNode;

  @override
  AppLayoutDrawerState createState() => AppLayoutDrawerState();
}

class AppLayoutDrawerState extends ConsumerState<AppLayoutDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isScanningMode = ref.watch(scanningModeProvider);
    final currentTransaction = ref.watch(pendingTransactionProvider);
    return ViewModelBuilder<CoreViewModel>.reactive(
        viewModelBuilder: () =>
            CoreViewModel(transaction: currentTransaction.value),
        builder: (a, model, child) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth < 600) {
                return Apps(
                  isBigScreen: false,
                  controller: widget.controller,
                  model: model,
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      child: const SizedBox.shrink(),
                    ),
                    Expanded(
                      flex: 2,
                      child: ProductView.normalMode(),
                    ),
                    isScanningMode
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 400,
                                // height: 300,
                                child: ReceiptUI(),
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 1,
                            child: CheckOut(isBigScreen: true),
                          ),
                  ],
                );
              }
            },
          );
        });
  }
}
