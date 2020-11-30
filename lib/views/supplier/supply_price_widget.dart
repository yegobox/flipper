

import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/views/product/add/add_product_viewmodel.dart';
import 'package:flipper/views/supplier/supplier_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SupplyPrice extends StatelessWidget {
  const SupplyPrice({Key key, this.addModel}) : super(key: key);
 // final CommonViewModel vm;
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
                      // controller: addModel.supplierPriceController,
                      onChanged: (value){
                        addModel.setRetailPriceController(price:double.parse(value));
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.black),
                      keyboardType: TextInputType.number,
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
