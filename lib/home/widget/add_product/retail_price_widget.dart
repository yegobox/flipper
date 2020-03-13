import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/widget/add_product/retail_price.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RetailPriceWidget extends StatefulWidget {
  RetailPriceWidget({Key key}) : super(key: key);

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
          stream: vm.database.stockDao.getStockByProductIdStream(
              productId: vm.tmpItem.id,
              branchId:
                  vm.branch.id), //do we have regular variant on this item?
          builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
            //show nothing empty widget if a cost price is set

            if (snapshot.data == null || snapshot.data[0].retailPrice == 0) {
              return RetailPrice();
            }
            return Text("");
          },
        );
      },
    );
  }
}
