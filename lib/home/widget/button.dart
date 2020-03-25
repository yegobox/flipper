import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/model/key_pad.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class KeyPadButtons extends StatefulWidget {
  KeyPadButtons({Key key}) : super(key: key);

  @override
  _KeyPadButtonsState createState() => _KeyPadButtonsState();
}

class _KeyPadButtonsState extends State<KeyPadButtons> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Container(
          child: Container(
              child: Wrap(
            children: _buildButtons(vm),
          )),
        );
      },
    );
  }

  List<Widget> _buildButtons(CommonViewModel vm) {
    List<int> list = new List<int>();
    list.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
    List<Widget> widget = new List<Widget>();

    for (var i = 1; i < list.length; i++) {
      widget.add(
        SingleKey(
          keypadValue: i.toString(),
          vm: vm,
        ),
      );
    }
    widget.add(SingleKey(
      keypadValue: "0",
      vm: vm,
    ));
    widget.add(SingleKey(
      keypadValue: "C",
      vm: vm,
    ));
    widget.add(SingleKey(
      keypadValue: "+",
      vm: vm,
    ));
    return widget;
  }
}

class SingleKey extends StatelessWidget {
  const SingleKey({
    Key key,
    @required this.keypadValue,
    this.vm,
  }) : super(key: key);

  final String keypadValue;
  final CommonViewModel vm;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136.99,
      child: InkWell(
        enableFeedback: false,
        onTap: () async {
          HapticFeedback.vibrate();
          if (keypadValue == "C") {
            StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
            return;
          }
          if (keypadValue == "+") {
            final store = StoreProvider.of<AppState>(context);
            List<VariationTableData> variants = await store
                .state.database.variationDao
                .getVariantByProductId(productId: vm.tmpItem.id);

            StoreProvider.of<AppState>(context).dispatch(
              IncrementAction(
                increment: 1,
              ),
            );
            Product cartItem = Product(
              (b) => b
                ..id = variants[0]
                    .id //we expect that this product should have 1 default variant to use while selling.
                ..name = vm.tmpItem.name
                ..categoryId = vm.tmpItem.categoryId
                ..unit = 'custom',
            );
            StoreProvider.of<AppState>(context).dispatch(
              AddItemToCartAction(cartItem: cartItem),
            );

            String branchId =
                StoreProvider.of<AppState>(context).state.branch.id;
            List<StockTableData> stocks = await store.state.database.stockDao
                .getStockByProductId(
                    branchId: branchId, productId: vm.tmpItem.id);

            for (var i = 0; i < stocks.length; i++) {
              await store.state.database.stockDao.updateStock(stocks[i]
                  .copyWith(
                      retailPrice: vm.keypad.amount.toDouble(),
                      branchId: branchId));
            }

            StoreProvider.of<AppState>(context).dispatch(SaveCart());
            StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
          } else {
            StoreProvider.of<AppState>(context).dispatch(
              KayPadAction(
                keyPad: KeyPad((k) => k
                  ..amount = vm.keypad == null
                      ? int.parse(keypadValue)
                      : int.parse(vm.keypad.amount.toString() + keypadValue)
                  ..note = "note"),
              ),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              width: 0.5,
            ),
          ),
          padding: EdgeInsets.fromLTRB(55, 21, 20, 20),
          child: Text(keypadValue.toString(),
              style: TextStyle(fontSize: 40, fontFamily: "Heebo-Thin")),
        ),
      ),
    );
  }
}
