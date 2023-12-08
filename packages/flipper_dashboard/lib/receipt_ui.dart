// import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

import 'preview_sale_bottom_sheet.dart';

class ReceiptUI extends StatefulHookConsumerWidget {
  @override
  ReceiptUIState createState() => ReceiptUIState();
}

class ReceiptUIState extends ConsumerState<ReceiptUI> {
  @override
  Widget build(BuildContext context) {
    final currentTransaction =
        ref.watch(pendingTransactionProvider(ProxyService.box.getBranchId()));
    return Scaffold(
      body: ViewModelBuilder.reactive(
        viewModelBuilder: () =>
            CoreViewModel(transaction: currentTransaction.value?.value),
        builder: (a, model, b) {
          return PreviewSaleBottomSheet(
            reverse: false,
          );
        },
      ),
    );
  }
}
