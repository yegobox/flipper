import 'package:flipper_models/variation.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/flipperNavigation_service.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';

class VariationWidget extends StatefulWidget {
  const VariationWidget(
      {Key key,
      @required this.variation,
      @required this.context,
      @required this.vm})
      : super(key: key);

  final Variation variation;
  final BuildContext context;
  final CommonViewModel vm;

  @override
  _VariationWidgetState createState() => _VariationWidgetState();
}

class _VariationWidgetState extends State<VariationWidget> {
  final FlipperNavigationService _navigationService = ProxyService.nav;
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      GestureDetector(
          onTap: () {
            _navigationService.navigateTo(
              Routing.editVariationScreen,
              //TODO(richard): work on this.
              // arguments: EditVariationScreenArguments(
              //   variationId: widget.variation.id,
              //     itemId: widget.variation.productId
              // ),
            );
          },
          child: SizedBox.shrink()
          // child: StreamBuilder(
          //     stream: widget.vm.database.stockDao.getStockByProductIdStream(
          //         branchId: widget.vm.branch.id, productId: '001'),
          //     builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
          //       if (snapshot.data == null) {
          //         return Text('');
          //       }
          //       return Column(
          //         children:
          //             buildVariantRow(snapshot, context, widget.variation.name),
          //       );
          //     }),
          )
    ]);
  }

  // List<Widget> buildVariantRow(AsyncSnapshot<List<StockTableData>> snapshot,
  //     BuildContext context, String name) {
  //   List<Widget> list = [];
  //   for (var i = 0; i < snapshot.data.length; i++) {
  //     list.add(ListTile(
  //       leading: Icon(
  //         Icons.dehaze,
  //       ),
  //       subtitle: Text('${name}\nRWF${snapshot.data[i].retailPrice}'),
  //       trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //         FlatButton(
  //           child: Text(
  //             snapshot.data == null
  //                 ? 'Receive Stock'
  //                 : '${snapshot.data[i].currentStock}' + 'in Stock',
  //           ),
  //           onPressed: () {
  //             _navigationService.navigateTo(Routing.receiveStock);
  //           },
  //         )
  //       ]),
  //       dense: true,
  //     ));
  //   }
  //   return list;
  // }
}
