import 'package:flipper/views/variation/variation_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BuildCostWidget extends StatelessWidget {
  const BuildCostWidget({Key key, this.productId}) : super(key: key);
  final String productId;
  static final GlobalKey<FormState> _textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      // ignore: always_specify_types
      child: ViewModelBuilder.reactive(
          builder:
              (BuildContext context, VariationViewModel model, Widget child) {
            return model.busy || model.variation == null
                ? TextFormField(
                    key: _textKey,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    validator: Validators.isValid,
                    controller: model.costController,
                    decoration: const InputDecoration(
                        hintText: 'Cost Price', focusColor: Colors.blue),
                  )
                : Container(
                    width: 300,
                    child: TextFormField(
                      key: _textKey,
                      initialValue: '0.0',
                      style: TextStyle(color: HexColor('#2d3436')),
                      validator: Validators.isValid,
                      controller: model.costController,
                      decoration: InputDecoration(
                          hintText: 'Cost Price',
                          focusColor: HexColor('#0984e3')),
                    ),
                  );
          },
          onModelReady: (VariationViewModel model) =>
              model.getStockByProductId(productId: productId, context: context),
          viewModelBuilder: () => VariationViewModel()),
    );
  }
}
