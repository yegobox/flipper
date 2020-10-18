import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/add_product/supply_price.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
        return const Text('supply widget');
        // FIXME(richard): 
        // return StreamBuilder(
        //   stream: vm.database.variationDao.getItemVariationsByItemId(
        //       vm.tmpItem.id), //do we have regular variant on this item?
        //   builder: (BuildContext context, AsyncSnapshot<List<VariationTableData>> snapshot) {
        //     //if we have more than one variant do not show regular widget for changing supply price
        //     if (snapshot.data != null && snapshot.data.length < 2) {
        //       return SupplyPrice(
        //         vm: widget.vm,
        //       );
        //     }
        //     return const SizedBox.shrink();
        //   },
        // );
      },
    );
  }
}
