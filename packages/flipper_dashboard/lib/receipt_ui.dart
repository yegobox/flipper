// import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'preview_sale_bottom_sheet.dart';

class ReceiptUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelBuilder.reactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (a, model, b) {
          return PreviewSaleBottomSheet(
            reverse: false,
          );
        },
      ),
    );
  }
}
