import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/common/common_app_bar.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ReceiveStockScreen extends StatefulWidget {
  ReceiveStockScreen({
    Key key,
    @required this.variationId,
  }) : super(key: key);
  final int variationId;
  @override
  _ReceiveStockScreenState createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends State<ReceiveStockScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: CommonAppBar(
            disableButton: false,
            title: "Receive stock",
            onPressedCallback: () {
              Router.navigator.pop();
            },
            showActionButton: true,
            actionButtonName: S.of(context).save,
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 52,
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                      stream: vm.database.stockDao.getStockByVariantStream(
                          branchId: vm.branch.id,
                          variationId: widget.variationId),
                      builder: (context,
                          AsyncSnapshot<List<StockTableData>> snapshot) {
                        if (snapshot.data == null) {
                          return InputWidget(
                            variantId: widget.variationId,
                            vm: vm,
                          );
                        } else {
                          return InputWidget(
                            variantId: widget.variationId,
                            vm: vm,
                            currentStock: snapshot.data[0].currentStock,
                          );
                        }
                      }),
                  Container(
                    height: 20,
                  ),
                  Text(
                      "Inventory tracking will be enabled by\n default for items with stock count. To turn \n tracking off, visit your flipper Dashboard")
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InputWidget extends StatefulWidget {
  const InputWidget({
    Key key,
    @required this.vm,
    @required this.variantId,
    this.currentStock,
  }) : super(key: key);
  final CommonViewModel vm;
  final variantId;
  final int currentStock;
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  Future receiveStock(CommonViewModel vm, double count) async {
    StockTableData stock = await vm.database.stockDao.getStockByVariantId(
        variantId: widget.variantId, branchId: vm.branch.id);

    vm.database.stockDao.updateStock(
      stock.copyWith(updatedAt: DateTime.now(), currentStock: count.toInt()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue:
          widget.currentStock == null ? '0' : widget.currentStock.toString(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.rtl,
      autofocus: true,
      style: TextStyle(color: Colors.black),
      onChanged: (count) async {
        if (count != '') {
          await receiveStock(widget.vm, double.parse(count));
        }
      },
      decoration: InputDecoration(
        hintText: "Add Stock",
        focusColor: Colors.blue,
      ),
    );
  }
}
