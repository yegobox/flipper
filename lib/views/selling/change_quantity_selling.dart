
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChangeQuantityForSelling extends StatefulWidget {
  const ChangeQuantityForSelling({Key key, @required this.productId})
      : super(key: key);
  final String productId;

  @override
  _ChangeQuantityForSellingState createState() =>
      _ChangeQuantityForSellingState();
}

class _ChangeQuantityForSellingState extends State<ChangeQuantityForSelling> {
  final incrementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
        distinct: true,
        converter: CommonViewModel.fromStore,
        builder: (context, vm) {
          return const SizedBox.shrink();
          // FIXME(richard)
          // return StreamBuilder(
          //     stream: vm.database.stockDao.getStockByProductIdStream(
          //         branchId: vm.branch.id, productId: widget.productId),
          //     builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
          //       if (snapshot.data == null) {
          //         return Text('');
          //       }
          //       return MultipleVariantViewWidget(
          //         stocks: snapshot.data,
          //         vm: vm,
          //       );
          //     });
        });
  }
}




