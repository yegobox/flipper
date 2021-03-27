import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_models/view_models/sku_viewmodel.dart';

class SkuView extends StatefulWidget {
  const SkuView({Key key, this.productId}) : super(key: key);
  final String productId;
  @override
  _SkuViewState createState() => _SkuViewState();
}

class _SkuViewState extends State<SkuView> {
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, SkuViewModel model, Widget child) {
          return model.data == null || model.busy
              ? const SizedBox.shrink()
              : Center(
                  child: Container(
                    width: 300,
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black),
                      controller:model.skuController,
                      decoration: const InputDecoration(
                          hintText: 'SKU', focusColor: Colors.blue),
                    ),
                  ),
                );
        },
        onModelReady: (SkuViewModel model) => model.getVariations(
            context: context,
            productId: widget.productId), //should load regular variation
        viewModelBuilder: () => SkuViewModel());
  }
}
