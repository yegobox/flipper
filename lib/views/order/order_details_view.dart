import 'package:customappbar/customappbar.dart';
import 'package:flipper_models/order_detail.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:flipper_services/proxy.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({Key key}) : super(key: key);

  @override
  _OrderDetailsViewState createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  final int _total = 0;

  @override
  Widget build(BuildContext context) {
    _getTotal(null, context);
    // ignore: always_specify_types
    return StoreConnector(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              ProxyService.nav.pop();
            },
            title: 'Total RWF ' + _total.toString(),
            disableButton: false,
            showActionButton: true,
            actionButtonName: 'Add',
            onPressedCallback: () {},
          ),
          body: ListView(
            children: renderOrder(null, vm),
          ),
        );
      },
    );
  }

  List<Widget> renderOrder(List<OrderDetail> orders, CommonViewModel vm) {
    final List<Widget> list = <Widget>[];
    for (int i = 0; i < orders.length; i++) {
      list.add(ListTile(
        title: Text(
          orders[i].productName + ' × ' + orders[i].quantity.toString(),
          style: const TextStyle(color: Colors.black),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(orders[i].productName),
        ),
        trailing: const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text('FIXME')
            // FIXME:
            // child: StreamBuilder(
            //     stream: vm.database.stockDao.getStockByProductIdStream(
            //         branchId: vm.branch.id, productId: orders[i].variationId),
            //     builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
            //       if (snapshot.data == null) {
            //         return Text('');
            //       }
            //       return Text((snapshot.data[0].retailPrice * orders[i].quantity)
            //               .toString() +
            //           ' RWF');
            //     }),
            ),
      ));
    }
    list.add(ListTile(
      title: const Text(
        'Total',
        style: TextStyle(color: Colors.black),
      ),
      trailing: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text('RWF ' + _total.toString()),
      ),
    ));
    return list;
  }

  void _getTotal(List<OrderDetail> orders, BuildContext context) async {
    // FIXME:
    // final store = StoreProvider.of<AppState>(context);
    // var total = 0;
    // for (var i = 0; i < orders.length; i++) {
    //   final data = await store.state.database.stockDao.getStockByVariantId(
    //       variantId: orders[i].variationId, branchId: store.state.branch.id);
    //   total += (data.retailPrice.toInt() * orders[i].quantity).toInt();
    // }
    // setState(() {
    //   _total = total;
    // });
  }
}
