import 'package:customappbar/commonappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/cart.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartDetailsScreen extends StatefulWidget {
  final List<Cart> carts;
  CartDetailsScreen({Key key, this.carts}) : super(key: key);

  @override
  _CartDetailsScreenState createState() => _CartDetailsScreenState();
}

class _CartDetailsScreenState extends State<CartDetailsScreen> {
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    _getTotal(widget.carts, context);
    return StoreConnector(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            onPop: () {
              Router.navigator.pop();
            },
            title: "Total RWF " + _total.toString(),
            disableButton: false,
            showActionButton: true,
            actionButtonName: S.of(context).add,
            onPressedCallback: () {},
          ),
          body: ListView(
            children: renderCart(widget.carts, vm),
          ),
        );
      },
    );
  }

  List<Widget> renderCart(List<Cart> carts, CommonViewModel vm) {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < carts.length; i++) {
      list.add(ListTile(
        title: Text(
          carts[i].parentName + " × " + carts[i].count.toString(),
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Text(carts[i].variationName),
        ),
        trailing: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: StreamBuilder(
              stream: vm.database.stockDao.getStockByVariantIdStream(
                  branchId: vm.branch.id, variantId: carts[i].variationId),
              builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
                if (snapshot.data == null) {
                  return Text("");
                }
                return Text(
                    (snapshot.data[0].retailPrice * carts[i].count).toString() +
                        " RWF");
              }),
        ),
      ));
    }
    list.add(ListTile(
      title: Text(
        'Total',
        style: TextStyle(color: Colors.black),
      ),
      trailing: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Text("RWF " + _total.toString()),
      ),
    ));
    return list;
  }

  void _getTotal(List<Cart> carts, BuildContext context) async {
    final store = StoreProvider.of<AppState>(context);
    var total = 0;
    for (var i = 0; i < carts.length; i++) {
      final data = await store.state.database.stockDao.getStockByVariantId(
          variantId: carts[i].variationId, branchId: store.state.branch.id);
      total += (data.retailPrice.toInt() * carts[i].count).toInt();
    }
    setState(() {
      _total = total;
    });
  }
}
