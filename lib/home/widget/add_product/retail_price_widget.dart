import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/add_product/retail_price.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RetailPriceWidget extends StatefulWidget {
  RetailPriceWidget({Key key, this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  _RetailPriceWidgetState createState() => _RetailPriceWidgetState();
}

class _RetailPriceWidgetState extends State<RetailPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return StreamBuilder(
          stream: vm.database.variationDao.getItemVariationsByItemId(
              vm.tmpItem.productId), //do we have regular variant on this item?
          builder: (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
            //if we have more than one variant do not show regular widget for changing supply price
            if (snapshot.data != null && snapshot.data.length < 2) {
              return RetailPrice(
                vm: widget.vm,
              );
            }
            return Text("");
          },
        );
      },
    );
  }
}
