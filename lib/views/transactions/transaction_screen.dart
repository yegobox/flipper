import 'package:customappbar/customappbar.dart';

import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/order.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
            appBar: CommonAppBar(
              onPop: () {
                Routing.navigator.pop();
              },
              title: 'Transactions',
              showActionButton: false,
              onPressedCallback: () async {},
              icon: Icons.close,
              multi: 3,
              bottomSpacer: 52,
            ),
            body: SizedBox.fromSize()
            // FIXME:
            // body: StreamBuilder(
            //     stream: vm.database.orderDao.getOrdersStream(),
            //     builder: (context, AsyncSnapshot<List<OrderTableData>> snapshot) {
            //       if (snapshot.data == null) {
            //         return Text('');
            //       }

            //       return StreamBuilder(
            //           stream: null, //TODO: now load transactions here.
            //           builder: (context, transactions) {
            //             if (transactions.data == null) {
            //               return Center(child: Text('No Transaction'));
            //             }
            //             return ListView(
            //               children: ListTile.divideTiles(
            //                 context: context,
            //                 tiles: renderTransactions(
            //                     transactions.data, context, vm),
            //               ).toList(),
            //             );
            //           });
            //     }),
            );
      },
    );
  }

  List<Widget> renderTransactions(
      List<Order> data, BuildContext context, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < data.length; i++) {
      list.add(transactionRow(data[i]));
    }
    return list;
  }

  ListTile transactionRow(Order data) {
    return ListTile(
      leading: Container(
        width: 50,
        child: Text(data.amount.toString()),
      ),
      title: const Text('B'),
      trailing: const Text('C'),
      dense: true,
    );
  }
}
