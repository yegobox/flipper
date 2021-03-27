import 'package:flipper_models/view_models/variation_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BuildRetailWidget extends StatelessWidget {
  const BuildRetailWidget({Key key, this.productId}) : super(key: key);
  final String productId;
  static final GlobalKey<FormState> _textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      // ignore: always_specify_types
      child: ViewModelBuilder.reactive(
          builder:
              (BuildContext context, VariationViewModel model, Widget child) {
            return model.busy || model.variations == null
                ? TextFormField(
                    key: _textKey,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    validator: Validators.isValid,
                    controller: model.retailController,
                    decoration: const InputDecoration(
                        hintText: 'Retail Price', focusColor: Colors.blue),
                  )
                : Container(
                    width: 300,
                    child: TextFormField(
                      key: _textKey,
                      initialValue: model.stock.retailPrice.toString(),
                      style: TextStyle(color: HexColor('#2d3436')),
                      validator: Validators.isValid,
                      controller: model.retailController,
                      decoration: InputDecoration(
                          hintText: 'SKU', focusColor: HexColor('#0984e3')),
                    ),
                  );
          },
          onModelReady: (VariationViewModel model) =>
              model.getStockByProductId(productId: productId, context: context),
          viewModelBuilder: () => VariationViewModel()),
    );
  }
}
