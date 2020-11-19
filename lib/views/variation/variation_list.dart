import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flipper/services/proxy.dart';

class VariationList extends StatefulWidget {
  const VariationList({Key key, this.productId}) : super(key: key);

  @override
  _VariationListState createState() => _VariationListState();
  final String productId;
}

class _VariationListState extends State<VariationList> {
  final FlipperNavigationService _navigationService = ProxyService.nav;

  // _buildVariationsList(
  //     List<VariationTableData> variations, CommonViewModel vm) {
  //   List<Widget> list = new List<Widget>();
  //   for (var i = 0; i < variations.length; i++) {
  //     if (variations[i].name != 'tmp') {
  //       list.add(
  //         Center(
  //           child: SizedBox(
  //             height: 90,
  //             width: 350,
  //             child: ListView(children: <Widget>[
  //               StreamBuilder(
  //                   stream: vm.database.stockDao.getStockByVariantStream(
  //                       branchId: vm.branch.id, variationId: variations[i].id),
  //                   builder: (context,
  //                       AsyncSnapshot<List<StockTableData>> snapshot) {
  //                     if (snapshot.data == null) {
  //                       return Text('');
  //                     }
  //                     return ListTile(
  //                       leading: Icon(
  //                         Icons.dehaze,
  //                       ),
  //                       subtitle: Text(
  //                           '${variations[i].name} \nRWF ${snapshot.data[0].retailPrice}'),
  //                       trailing: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: <Widget>[
  //                             FlatButton(
  //                               child: Text(
  //                                 snapshot.data[0].currentStock == 0
  //                                     ? 'Receive Stock'
  //                                     : snapshot.data[0].currentStock
  //                                             .toString() +
  //                                         ' ' +
  //                                         'in Stock',
  //                               ),
  //                               onPressed: () {
  //                                 _navigationService.navigateTo(
  //                                   Routing.receiveStock,
  //                                   arguments: ReceiveStockScreenArguments(
  //                                     variationId: variations[i].id,
  //                                   ),
  //                                 );
  //                               },
  //                             ),
  //                           ]),
  //                       dense: true,
  //                     );
  //                   })
  //             ]),
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //   if (list.length == 0) {
  //     return Container();
  //   }
  //   return Column(children: list);
  // }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return const SizedBox.shrink();
        // FIXME:
        // return StreamBuilder(
        //   stream: vm.database.variationDao
        //       .getItemVariationsByItemId(widget.productId),
        //   builder: (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
        //     if (snapshot.data == null) {
        //       return Text('');
        //     }
        //     return snapshot.data.length > 1
        //         ? _buildVariationsList(snapshot.data, vm)
        //         : Text('');
        //   },
        // );
      },
    );
  }
}
