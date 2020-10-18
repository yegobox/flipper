import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'build_supplier_body.dart';

class SupplyPriceWidget extends StatefulWidget {
  const SupplyPriceWidget({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  _SupplyPriceWidgetState createState() => _SupplyPriceWidgetState();
}

class _SupplyPriceWidgetState extends State<SupplyPriceWidget> {
  //show input field to add supply price when variant id in stock is 0 i.e it is still in temp or has not been updated
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return BuildSupplierBody(vm:vm);
      },
    );
  }
}
