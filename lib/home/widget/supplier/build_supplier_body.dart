
import 'package:flipper/home/widget/supplier/supply_price.dart';
import 'package:flipper/home/widget/supplier/supplier_viewmodel.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BuildSupplierBody extends StatelessWidget {
  const BuildSupplierBody({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,SupplierViewmodel model, Widget child){
        return model.data==null?const SizedBox.shrink():SupplyPrice(vm: vm,);
    }, viewModelBuilder:()=> SupplierViewmodel());
  }
}
