import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';

import 'package:flipper/model/key_pad.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/presentation/home/common_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class KeyPadButtons extends StatefulWidget {
  const KeyPadButtons({Key key}) : super(key: key);

  @override
  _KeyPadButtonsState createState() => _KeyPadButtonsState();
}

class _KeyPadButtonsState extends State<KeyPadButtons> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Wrap(
          // alignment: Alignment.center,
          children: _buildButtons(vm),
        );
      },
    );
  }

  List<Widget> _buildButtons(CommonViewModel vm) {
    final List<int> list = <int>[];
    // ignore: always_specify_types
    list.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]);
    final List<Widget> widget = <Widget>[];

    for (int i = 1; i < list.length; i++) {
      widget.add(
        SingleKey(
          buttonKeyName: i.toString(),
          vm: vm,
        ),
      );
    }
    widget.add(SingleKey(
      buttonKeyName: '0',
      vm: vm,
    ));
    widget.add(SingleKey(
      buttonKeyName: 'C',
      vm: vm,
    ));
    widget.add(SingleKey(
      buttonKeyName: '+',
      vm: vm,
    ));
    return widget;
  }
}

class SingleKey extends StatefulWidget {
  const SingleKey({
    Key key,
    @required this.buttonKeyName,
    this.vm,
  }) : super(key: key);

  final String buttonKeyName;
  final CommonViewModel vm;

  @override
  _SingleKeyState createState() => _SingleKeyState();
}

class _SingleKeyState extends State<SingleKey> {
  double sum = 0.00;

  bool flag = false;

  int count = 0;

  String sumString = '0.00';

  double temp;

  double permanentSum = 0.00;

  String permanentSumString = '0.00';

  double temp1 = 0;

  double temp2 = 0;

  void btnClicked(
      {String buttonKeyName, BuildContext context, CommonViewModel vm}) async {
    HapticFeedback.vibrate();
    if (buttonKeyName == 'C') {
      StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
      return;
    }
    if (buttonKeyName == '+') {
      final Store<AppState> store = StoreProvider.of<AppState>(context);
      final List<VariationTableData> variants = await store
          .state.database.variationDao
          .getVariantByProductId(productId: vm.tmpItem.id);

      StoreProvider.of<AppState>(context).dispatch(
        IncrementAction(
          increment: 1,
        ),
      );
      final Product cartItem = Product(
        (ProductBuilder b) => b
          ..id = variants[0]
              .id //done intentionally so we can use it while saving cart or orderDetail.
          ..name = vm.tmpItem.name
          ..categoryId = vm.tmpItem.categoryId
          ..unit = 'custom',
      );

      StoreProvider.of<AppState>(context).dispatch(
        AddItemToCartAction(cartItem: cartItem),
      );

      final String branchId =
          StoreProvider.of<AppState>(context).state.branch.id;
      final List<StockTableData> stocks = await store.state.database.stockDao
          .getStockByProductId(branchId: branchId, productId: vm.tmpItem.id);

      for (int i = 0; i < stocks.length; i++) {
        await store.state.database.stockDao.updateStock(stocks[i].copyWith(
            retailPrice: vm.keypad.amount.toDouble(), branchId: branchId));
      }
      StoreProvider.of<AppState>(context).dispatch(SaveCart());
      StoreProvider.of<AppState>(context).dispatch(CleanKeyPad());
    } else {
     
      StoreProvider.of<AppState>(context).dispatch(
        KayPadAction(
          keyPad: KeyPad(
            (KeyPadBuilder k) => k
              ..amount = vm.keypad == null
                  ? int.parse(buttonKeyName)
                 
                  : int.parse(vm.keypad.amount.toString() + buttonKeyName)
              ..note = 'note',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 136.99,
      height: 110,
      child: InkWell(
        enableFeedback: false,
        onTap: () =>
            btnClicked(buttonKeyName: widget.buttonKeyName, context: context, vm: widget.vm),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              width: 0.5,
            ),
          ),
          // padding: const EdgeInsets.fromLTRB(55, 21, 20, 20),
          child: Center(
            
            child: Text(
              widget.buttonKeyName.toString(),
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 40,fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ),
    );
  }
}
