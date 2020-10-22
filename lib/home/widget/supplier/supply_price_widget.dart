import 'package:flipper/home/product/add/add_product_viewmodel.dart';
import 'package:flipper/home/widget/supplier/supplier_viewmodel.dart';

import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SupplyPriceWidget extends StatelessWidget {
  const SupplyPriceWidget({Key key, this.vm, this.addModel}) : super(key: key);
  final CommonViewModel vm;
  final AddProductViewmodel addModel;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, SupplierViewmodel model, Widget child) {
          return model.busy == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  child: Container(
                    width: double.infinity,
                    child: TextFormField(
                      controller: addModel.supplierPriceController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Supplier Price',
                        fillColor: Theme.of(context)
                            .copyWith(canvasColor: Colors.white)
                            .canvasColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor('#D0D7E3')),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: const Icon(Icons.book),
                      ),
                    ),
                  ),
                );
        },
        viewModelBuilder: () => SupplierViewmodel());
  }
}
