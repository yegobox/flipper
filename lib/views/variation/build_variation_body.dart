import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'variation_viewmodel.dart';

class BuildVariationBody extends StatelessWidget {
  const BuildVariationBody({Key key, this.productId}) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder:
            (BuildContext context, VariationViewModel model, Widget child) {
          return model.busy || model.variations == null
              ? const Text('Variation:)')
              : Text(model.product.name);
        },
        onModelReady: (VariationViewModel model) =>
            model.getProductById(productId: productId, context: context),
        viewModelBuilder: () => VariationViewModel());
  }
}
